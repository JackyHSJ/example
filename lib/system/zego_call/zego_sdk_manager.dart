
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frechat/system/app_config/app_config.dart';
import 'package:frechat/system/database/model/zego_beauty_model.dart';
import 'package:frechat/system/notification/jpush/jpush_service.dart';
import 'package:frechat/system/notification/zpns/zpns_service.dart';
import 'package:frechat/system/provider/zego_beauty_model_provider.dart';
import 'package:frechat/system/zego_call/interal/effects/beauty_ability/zego_beauty_ability.dart';
import 'package:frechat/system/zego_call/interal/effects/beauty_ability/zego_beauty_type.dart';
import 'package:frechat/system/zego_call/interal/effects/zego_effects_service.dart';
import 'package:frechat/system/zego_call/interal/express/zego_express_service.dart';
import 'package:frechat/system/zego_call/model/zego_user_model.dart';
import 'package:frechat/system/zego_call/zego_provider.dart';
import 'package:frechat/system/zego_call/zyg_zego_setting.dart';

class ZEGOSDKManager {
  ZEGOSDKManager({required this.ref});
  ProviderRef ref;

  // ZEGOSDKManager._internal();
  // factory ZEGOSDKManager() => instance;
  // static final ZEGOSDKManager instance = ZEGOSDKManager._internal();

  // ZIMService zimService = ZIMService.instance;
  ZegoEffectsService zegoEffectService = ZegoEffectsService.instance;
  // JPushService jPushService = JPushService.instance;

  ZegoUserInfo get localUser => ref.read(expressServiceProvider).localUser;

  Future<void> init(int appID, String? appSign) async {
    await ref.read(expressServiceProvider).init(appID: appID, appSign: appSign);
    await ref.read(zimServiceProvider).init(appID: appID, appSign: appSign);
    // zegoEffectService.init(appID, appSign: appSign);
    // await zimService.init(appID: appID, appSign: appSign);
    await ref.read(zpnsServiceProvider).init();
    _checkAndResetBeautyDB();
    /// 測試用
    // await JPushService.initJPush();
  }

  Future<void> connectUser(String userID, String userName, {String? token}) async {
    await ref.read(expressServiceProvider).connectUser(userID, userName, token: token);
    await ref.read(zimServiceProvider).connectUser(userID, userName, token: token);
    // await zimService.connectUser(userID, userName, token: token);
  }

  Future<void> disconnectUser() async {
    await ref.read(expressServiceProvider).disconnectUser();
    // await ref.read(zimServiceProvider).disconnectUserAndZpns();
    // await zimService.disconnectUser(); //
    await ref.read(zpnsServiceProvider).disconnect();
  }

  Future<void> initZegoEffect() async {
    await zegoEffectService.init(AppConfig.zegoAppID, appSign: AppConfig.zegoAppSign);
    ref.read(expressServiceProvider).enableCustomVideoCapture(enable: true);
  }

  Future<void> disposeZegoEffect() async {
    zegoEffectService.unInit();
    ref.read(expressServiceProvider).enableCustomVideoCapture(enable: false);
  }

  ValueNotifier<Widget?> getVideoViewNotifier(String? userID) {
    final ExpressService expressService = ref.read(expressServiceProvider);
    if (userID == null || userID == expressService.localUser.userID) {
      return expressService.localVideoView;
    } else {
      return expressService.remoteVideoView;
    }
  }

  _checkAndResetBeautyDB() async {
    final ZegoBeautyModelNotifier notifier = ref.read(zegoBeautyModelNotifierProvider.notifier);
    final List<ZegoBeautyModel> data = await notifier.loadDataFromModel();
    final bool isEmpty = data == [] || data.isEmpty;
    if(isEmpty) {
      notifier.reset();
    }
  }

  /// other func
  loadDbDateToCurrentValue() {
    final List<ZegoBeautyModel> dbData = ref.read(zegoBeautyModelNotifierProvider);
    dbData.forEach((data) {
      final num index = data.beautyTypeIndex ?? 0;
      final ZegoBeautyType type = ZegoBeautyType.values[index.toInt()];
      final ZegoBeautyAbility? ability = getAbility(type);
      /// 檢查內容不等於預設值
      if(_checkCurrentValue(data) || _checkTypeIndex(ability)) {
        ability?.editor.enable(true);
        ability?.editor.apply(data.currentValue?.toInt() ?? 0);
        ability?.currentValue = data.currentValue?.toInt() ?? 0;
      }
    });
  }

  /// ZegoBeautyType index 1~18 直接執行馴染美顏功能
  bool _checkTypeIndex(ZegoBeautyAbility? ability) {
    return (ability?.type.index ?? 0) >= 1 && (ability?.type.index ?? 0) <= 18;
  }

  /// currentValue 50 or 0以外，才執行馴染美顏功能
  bool _checkCurrentValue(ZegoBeautyModel data) {
    return data.currentValue != 50 && data.currentValue != 0;
  }

  ZegoBeautyAbility? getAbility (ZegoBeautyType? type) {
    final ZegoBeautyAbility? ability = ZegoEffectsService.instance.beautyAbilities[type];
    return ability;
  }
}
