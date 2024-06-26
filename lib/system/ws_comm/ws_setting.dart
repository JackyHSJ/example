
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frechat/models/ws_req/setting/ws_setting_charge_req.dart';
import 'package:frechat/models/ws_req/setting/ws_setting_charm_achievement_req.dart';
import 'package:frechat/models/ws_res/setting/ws_setting_charge_res.dart';
import 'package:frechat/models/ws_res/setting/ws_setting_charm_achievement_res.dart';
import 'package:frechat/system/ws_comm/ws_params_req.dart';

import '../../models/ws_req/ws_base_req.dart';
import '../providers.dart';
import '../websocket/websocket_handler.dart';

class SettingWs {
  SettingWs({required this.ref});
  final ProviderRef ref;

  /// 收費設定
  Future<WsSettingChargeRes> wsSettingCharge(WsSettingChargeReq wsSettingChargeReq, {
    required Function(String) onConnectSuccess,
    required Function(String) onConnectFail,
  }) async {
    final userInfo = ref.read(userInfoProvider);
    final WsBaseReq msg = WsParamsReq.settingCharge
      ..tId = userInfo.commToken ?? "emptyToken"
      ..msg = wsSettingChargeReq;

    /// 傳送ws send
    final res = await WebSocketHandler.sendData(msg,
        funcCode: WsParamsReq.settingCharge.f,
        onConnectSuccess: (msg) => onConnectSuccess(msg),
        onConnectFail: (errMsg) => onConnectFail(errMsg));

    return (res.resultMap == null) ? WsSettingChargeRes() : WsSettingChargeRes.fromJson(res.resultMap);
  }

  /// 魅力值達標設定
  Future<WsSettingCharmAchievementRes> wsSettingCharmAchievement(WsSettingChargeAchievementReq wsChargeAchievementReq, {
    required Function(String) onConnectSuccess,
    required Function(String) onConnectFail,
  }) async {
    final userInfo = ref.read(userInfoProvider);
    final WsBaseReq msg = WsParamsReq.settingCharmAchievement
      ..tId = userInfo.commToken ?? "emptyToken"
      ..msg = wsChargeAchievementReq.toBody();

    /// 傳送ws send
    final res = await WebSocketHandler.sendData(msg,
        funcCode: WsParamsReq.settingCharmAchievement.f,
        onConnectSuccess: (msg) => onConnectSuccess(msg),
        onConnectFail: (errMsg) => onConnectFail(errMsg));

    return (res.resultMap == null) ? WsSettingCharmAchievementRes() : WsSettingCharmAchievementRes.fromJson(res.resultMap);
  }
}