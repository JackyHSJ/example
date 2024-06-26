
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frechat/system/deeplink/openinstall/openinstall_model.dart';
import 'package:frechat/system/provider/user_info_provider.dart';
import 'package:openinstall_flutter_plugin/openinstall_flutter_plugin.dart';

class OpenInstallHandler {

  static OpeninstallFlutterPlugin _openinstallFlutterPlugin = OpeninstallFlutterPlugin();
  static String wakeUpLog = "";
  static String installLog = "";
  static late Function(String) onPushToRegisterPage;
  static late ProviderRef ref;

  /// 初始化
  static init (ProviderRef ref, {
    required Function(String) onPushToRegisterPage
  }) {
    OpenInstallHandler.ref = ref;
    OpenInstallHandler.onPushToRegisterPage = onPushToRegisterPage;
    _configIOS();
    _configAndroid();
    _openinstallFlutterPlugin.init(wakeupHandler, alwaysCallback: true);
  }

  static _configIOS() {
    final adConfig = <dynamic, dynamic>{}
    // ..["ASADebug"] = true //可选，ASA测试debug模式，注意：正式环境中请务必关闭(不配置或配置为false)
    ..["adEnabled"] = true
    ..["ASAEnable"] = true;
    _openinstallFlutterPlugin.configIos(adConfig);
  }

  static _configAndroid() {
    final adConfig = <dynamic, dynamic>{}
    ..["adEnabled"] = true;
    _openinstallFlutterPlugin.configAndroid(adConfig);

  }

  static dispose () {
  }

  /// 取得安裝參數
  static getInstall() {
    _openinstallFlutterPlugin.install(installHandler, 10);
  }

  /// 回報註冊
  @Deprecated('目前未有需求使用此方法')
  static reportRegister() {
    _openinstallFlutterPlugin.reportRegister();
  }

  /// 點擊效果统计
  @Deprecated('目前未有需求使用此方法')
  static reportEffectPoint() {
    _openinstallFlutterPlugin.reportEffectPoint("effect_test", 1);
  }

  /// 詳細點擊效果統計
  @Deprecated('目前未有需求使用此方法')
  static reportEffectDetail() {
    Map<String, String> extraMap = {
      "systemVersion": Platform.operatingSystemVersion,
      "flutterVersion": Platform.version
    };
    _openinstallFlutterPlugin.reportEffectPoint(
        "effect_detail", 1, extraMap);
  }

  /// 用戶分享連結統計
  @Deprecated('目前未有需求使用此方法')
  static reportShare() {
    _openinstallFlutterPlugin
        .reportShare("123456", "WechatSession")
        .then((data) =>
        print("reportShare : " + data.toString()));
  }

  @Deprecated('目前未有需求使用此方法')
  static void getInstallParams() {
    _openinstallFlutterPlugin.getInstallCanRetry((data) async {
    });
  }

  static Future<void> installHandler(Map<String, Object> data) async {
    _pushToRegisterPage(data);
  }

  static Future<void> wakeupHandler(Map<String, dynamic> data) async {
    _pushToRegisterPage(data);
  }

  static _pushToRegisterPage(Map<String, dynamic> data) {
    final OpenInstallModel openInstallModel = OpenInstallModel.decode(data);
    final bindData = openInstallModel.bindData;
    if(bindData.inviteCode?.isNotEmpty ?? false){
      final isLoginState = ref.read(userUtilProvider.notifier).isUserLoginState;
      if(isLoginState) {
        return ;
      }
      onPushToRegisterPage(bindData.inviteCode ?? '');
    }
  }
}