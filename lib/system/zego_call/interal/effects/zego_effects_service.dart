
import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frechat/system/app_config/app_config.dart';
import 'package:frechat/system/database/model/zego_beauty_model.dart';
import 'package:frechat/system/zego_call/interal/effects/beauty_ability/zego_beauty_ability.dart';
import 'package:frechat/system/zego_call/interal/effects/beauty_ability/zego_beauty_type.dart';
import 'package:frechat/system/zego_call/interal/effects/extension/zego_effects_service_extension.dart';
import 'package:frechat/system/zego_call/interal/effects/helper/zego_effects_helper.dart';
import 'package:frechat/system/zego_call/zyg_zego_setting.dart';
import 'package:zego_effects_plugin/zego_effects_plugin.dart';

class ZegoEffectsService {
  ZegoEffectsService._internal();
  factory ZegoEffectsService() => instance;
  static final ZegoEffectsService instance = ZegoEffectsService._internal();

  final methodChannel = const MethodChannel('zego_beauty_effects');

  final backendApiUrl = 'https://aieffects-api.zego.im/?Action=DescribeEffectsLicense';

  String resourcesFolder = '';

  final beautyAbilities = <ZegoBeautyType, ZegoBeautyAbility>{};

  Future<void> init(int appID, {String? appSign}) async {
    final authInfo = await ZegoEffectsPlugin.instance.getAuthInfo(AppConfig.zegoAppSign);
    final license = await EffectsHelper.getLicence(backendApiUrl, appID, authInfo);
    await initEffects(license);
  }

  Future<void> unInit() async {
    await ZegoEffectsPlugin.instance.destroy();
  }

  Future<void> initEffects(String license) async {
    await EffectsHelper.setResources();
    resourcesFolder = EffectsHelper.resourcesFolder;

    final ret = await ZegoEffectsPlugin.instance.create(license);
    debugPrint('ZegoEffectsPlugin init result: $ret');

    await ZegoEffectsPlugin.instance.initEnv(const Size(720, 1280));

    await enableCustomVideoProcessing();

    // callback of effects sdk.
    ZegoEffectsPlugin.registerEventCallback(
      onEffectsError: onEffectsError,
      onEffectsFaceDetected: onEffectsFaceDetected,
    );

    initBeautyAbilities();

    ZegoEffectsPlugin.instance.enableFaceDetection(true);
  }

  void onEffectsError(int errorCode, String desc) {
    debugPrint('effects errorCode: $errorCode, desc: $desc');
    if (errorCode == 5000002) {
      EffectsHelper.inValidLicense();
      init(AppConfig.zegoAppID, appSign: AppConfig.zegoAppSign);
    }
  }

  void onEffectsFaceDetected(double score, Point point, Size size) {
    debugPrint(
        'onEffectsFaceDetected, score: $score, point: $point, size: $size');
  }

  Future<void> enableCustomVideoProcessing() async {
    await methodChannel.invokeMethod('enableCustomVideoProcessing');
  }

  Future<String?> getResourcesFolder() async {
    final folder =
    await methodChannel.invokeMethod<String>('getResourcesFolder');
    return folder;
  }
}