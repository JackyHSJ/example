import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frechat/models/ws_req/notification/ws_notification_search_info_with_type_req.dart';
import 'package:frechat/models/ws_req/notification/ws_notification_search_intimacy_level_info_req.dart';
import 'package:frechat/models/ws_req/notification/ws_notification_search_online_status_req.dart';
import 'package:frechat/models/ws_res/notification/ws_notification_search_info_with_type_res.dart';
import 'package:frechat/models/ws_res/notification/ws_notification_search_intimacy_level_info_res.dart';
import 'package:frechat/models/ws_res/notification/ws_notification_search_online_status_res.dart';
import 'package:frechat/system/base_view_model.dart';
import 'package:frechat/system/constant/enum.dart';
import 'package:frechat/system/provider/new_user_behavior_model_provider.dart';
import 'package:frechat/system/providers.dart';
import 'package:frechat/system/repository/response_code.dart';
import 'package:frechat/system/websocket/websocket_handler.dart';
import 'package:frechat/system/ws_comm/ws_params_req.dart';

import '../../models/ws_req/notification/ws_notification_block_group_req.dart';
import '../../models/ws_req/notification/ws_notification_leave_group_block_req.dart';
import '../../models/ws_req/notification/ws_notification_press_btn_and_remove_black_account_req.dart';
import '../../models/ws_req/notification/ws_notification_search_list_req.dart';
import '../../models/ws_req/notification/ws_notification_strike_up_req.dart';
import '../../models/ws_req/ws_base_req.dart';
import '../../models/ws_res/notification/ws_notification_block_group_res.dart';
import '../../models/ws_res/notification/ws_notification_leave_group_block_res.dart';
import '../../models/ws_res/notification/ws_notification_press_btn_and_remove_black_account_res.dart';
import '../../models/ws_res/notification/ws_notification_search_list_res.dart';
import '../../models/ws_res/notification/ws_notification_strike_up_res.dart';
import 'package:uuid/uuid.dart';

class NotificationWs {
  NotificationWs({required this.ref});
  final ProviderRef ref;

  /// 查詢消息清單
  Future<WsNotificationSearchListRes> wsNotificationSearchList(
    WsNotificationSearchListReq wsNotificationSearchListReq, {
    required Function(String) onConnectSuccess,
    required Function(String) onConnectFail,
  }) async {
    final userInfo = ref.read(userInfoProvider);
    final WsBaseReq msg = WsParamsReq.notificationSearchList
      ..tId = userInfo.commToken ?? "emptyToken"
      ..msg = wsNotificationSearchListReq;

    /// 傳送ws send
    final res = await WebSocketHandler.sendData(msg,
        funcCode: WsParamsReq.notificationSearchList.f,
        onConnectSuccess: (msg) => onConnectSuccess(msg),
        onConnectFail: (errMsg) => onConnectFail(errMsg));

    return WsNotificationSearchListRes.fromJson(res.resultMap);
  }

  /// 搭訕
  Future<WsNotificationStrikeUpRes> wsNotificationStrikeUp(
    WsNotificationStrikeUpReq wsNotificationStrikeUpReq, {
    required Function(String) onConnectSuccess,
    required Function(String) onConnectFail,
  }) async {
    final userInfo = ref.read(userInfoProvider);
    final String uuid = const Uuid().v4();
    final WsBaseReq msg = WsParamsReq.notificationStrikeUp
      ..tId = userInfo.commToken ?? "emptyToken"
      // ..rId = uuid
      ..msg = wsNotificationStrikeUpReq;

    /// 傳送ws send
    final res = await WebSocketHandler.sendData(msg,
        funcCode: WsParamsReq.notificationStrikeUp.f,
        onConnectSuccess: (msg) {
          onConnectSuccess(msg);
          ref.read(newUserBehaviorManagerProvider).stateController.add(NewUserBehaviorState.strike);
        },
        onConnectFail: (errMsg) => onConnectFail(errMsg));

    return (res.resultMap == null)
        ? WsNotificationStrikeUpRes()
        : WsNotificationStrikeUpRes.fromJson(res.resultMap);
  }

  /// 退出群組、拉黑
  /// 需要先搭訕過後取得roomId, 再把roomId帶入 退出群組、拉黑
  Future<WsNotificationLeaveGroupBlockRes> wsNotificationLeaveGroupBlock(
    WsNotificationLeaveGroupBlockReq wsNotificationLeaveGroupBlockReq, {
    required Function(String) onConnectSuccess,
    required Function(String) onConnectFail,
  }) async {
    final userInfo = ref.read(userInfoProvider);
    final WsBaseReq msg = WsParamsReq.notificationLeaveGroupBlock
      ..tId = userInfo.commToken ?? "emptyToken"
      ..msg = wsNotificationLeaveGroupBlockReq;

    /// 傳送ws send
    final res = await WebSocketHandler.sendData(msg,
        funcCode: WsParamsReq.notificationLeaveGroupBlock.f,
        onConnectSuccess: (msg) => onConnectSuccess(msg),
        onConnectFail: (errMsg) => onConnectFail(errMsg));

    return (res.resultMap == null)
        ? WsNotificationLeaveGroupBlockRes()
        : WsNotificationLeaveGroupBlockRes.fromJson(res.resultMap);
  }

  /// 拉黑群組列表
  Future<WsNotificationBlockGroupRes> wsNotificationBlockGroup(
    WsNotificationBlockGroupReq wsNotificationBlockGroupReq, {
    required Function(String) onConnectSuccess,
    required Function(String) onConnectFail,
  }) async {
    final userInfo = ref.read(userInfoProvider);
    final WsBaseReq msg = WsParamsReq.notificationBlockGroup
      ..tId = userInfo.commToken ?? "emptyToken"
      ..msg = wsNotificationBlockGroupReq;

    /// 傳送ws send
    final res = await WebSocketHandler.sendData(msg,
        funcCode: WsParamsReq.notificationBlockGroup.f,
        onConnectSuccess: (msg) => onConnectSuccess(msg),
        onConnectFail: (errMsg) => onConnectFail(errMsg));

    return WsNotificationBlockGroupRes.fromJson(res.resultMap);
  }

  /// 点击移出按钮后，将黑名单用户移出列表
  Future<WsNotificationPressBtnAndRemoveBlackAccountRes>
      wsNotificationPressBtnAndRemoveBlackAccount(
    WsNotificationPressBtnAndRemoveBlackAccountReq
        wsNotificationPressBtnAndRemoveBlackAccountReq, {
    required Function(String) onConnectSuccess,
    required Function(String) onConnectFail,
  }) async {
    final userInfo = ref.read(userInfoProvider);
    wsNotificationPressBtnAndRemoveBlackAccountReq.userId = userInfo.userId;
    final WsBaseReq msg = WsParamsReq.notificationPressBtnAndRemoveBlackAccount
      ..tId = userInfo.commToken ?? "emptyToken"
      ..msg = wsNotificationPressBtnAndRemoveBlackAccountReq.toBody();

    /// 傳送ws send
    final res = await WebSocketHandler.sendData(msg,
        funcCode: WsParamsReq.notificationPressBtnAndRemoveBlackAccount.f,
        onConnectSuccess: (msg) => onConnectSuccess(msg),
        onConnectFail: (errMsg) => onConnectFail(errMsg));

    return (res.resultMap == null)
        ? WsNotificationPressBtnAndRemoveBlackAccountRes()
        : WsNotificationPressBtnAndRemoveBlackAccountRes.fromJson(res.resultMap);
  }

  /// 查詢亲密度等级资讯
  Future<WsNotificationSearchIntimacyLevelInfoRes> wsNotificationSearchIntimacyLevelInfo(WsNotificationSearchIntimacyLevelInfoReq wsNotificationSearchIntimacyLevelInfoReq, {
    required Function(String) onConnectSuccess,
    required Function(String) onConnectFail,
  }) async {
    final userInfo = ref.read(userInfoProvider);
    final WsBaseReq msg = WsParamsReq.notificationSearchIntimacyLevelInfo
      ..tId = userInfo.commToken ?? "emptyToken"
      ..msg = wsNotificationSearchIntimacyLevelInfoReq;

    /// 傳送ws send
    final res = await WebSocketHandler.sendData(msg,
        funcCode: WsParamsReq.notificationSearchIntimacyLevelInfo.f,
        onConnectSuccess: (msg) => onConnectSuccess(msg),
        onConnectFail: (errMsg) => onConnectFail(errMsg));

    return (res.resultMap == null)
        ? WsNotificationSearchIntimacyLevelInfoRes()
        : WsNotificationSearchIntimacyLevelInfoRes.fromJson(res.resultMap);
  }

  /// 查詢房間User總比數跟明細
  Future<WsNotificationSearchInfoWithTypeRes> wsNotificationSearchInfoWithType(WsNotificationSearchInfoWithTypeReq wsNotificationSearchInfoWithTypeReq, {
    required Function(String) onConnectSuccess,
    required Function(String) onConnectFail,
  }) async {
    final userInfo = ref.read(userInfoProvider);
    final WsBaseReq msg = WsParamsReq.notificationSearchInfoWithType
      ..tId = userInfo.commToken ?? "emptyToken"
      ..msg = wsNotificationSearchInfoWithTypeReq.toBody();

    /// 傳送ws send
    final res = await WebSocketHandler.sendData(msg,
        funcCode: WsParamsReq.notificationSearchInfoWithType.f,
        onConnectSuccess: (msg) => onConnectSuccess(msg),
        onConnectFail: (errMsg) => onConnectFail(errMsg));

    return (res.resultMap == null)
        ? WsNotificationSearchInfoWithTypeRes()
        : WsNotificationSearchInfoWithTypeRes.fromJson(res.resultMap);
  }

  /// 查詢用戶上線狀態清單
  Future<WsNotificationSearchOnlineStatusRes> wsNotificationSearchOnlineStatus(WsNotificationSearchOnlineStatusReq wsNotificationSearchOnlineStatusReq, {
    required Function(String) onConnectSuccess,
    required Function(String) onConnectFail,
  }) async {
    final userInfo = ref.read(userInfoProvider);
    final WsBaseReq msg = WsParamsReq.notificationSearchOnlineStatus
      ..tId = userInfo.commToken ?? "emptyToken"
      ..msg = wsNotificationSearchOnlineStatusReq.toBody();

    /// 傳送ws send
    final res = await WebSocketHandler.sendData(msg,
        funcCode: WsParamsReq.notificationSearchOnlineStatus.f,
        onConnectSuccess: (msg) => onConnectSuccess(msg),
        onConnectFail: (errMsg) => onConnectFail(errMsg));

    return (res.resultMap == null)
        ? WsNotificationSearchOnlineStatusRes()
        : WsNotificationSearchOnlineStatusRes.fromJson(res.resultMap);
  }
}
