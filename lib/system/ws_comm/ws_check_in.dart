
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frechat/models/ws_req/check_in/ws_check_in_req.dart';
import 'package:frechat/models/ws_req/check_in/ws_check_in_search_list_req.dart';
import 'package:frechat/models/ws_req/ws_base_req.dart';
import 'package:frechat/models/ws_res/check_in/ws_check_in_res.dart';
import 'package:frechat/models/ws_res/check_in/ws_check_in_search_list_res.dart';
import 'package:frechat/system/providers.dart';
import 'package:frechat/system/websocket/websocket_handler.dart';

import 'ws_params_req.dart';

class CheckInWs {
  CheckInWs({required this.ref});
  final ProviderRef ref;

  /// 签到
  Future<WsCheckInRes> wsCheckIn(WsCheckInReq wsCheckInReq, {
    required Function(String) onConnectSuccess,
    required Function(String) onConnectFail,
  }) async {
    final userInfo = ref.read(userInfoProvider);
    final WsBaseReq msg = WsParamsReq.checkIn
      ..tId = userInfo.commToken ?? "emptyToken"
      ..msg = wsCheckInReq;

    /// 傳送ws send
    final res = await WebSocketHandler.sendData(msg,
        funcCode: WsParamsReq.checkIn.f,
        onConnectSuccess: (msg) => onConnectSuccess(msg),
        onConnectFail: (errMsg) => onConnectFail(errMsg));

    return (res.resultMap == null) ? WsCheckInRes() : WsCheckInRes.fromJson(res.resultMap);
  }

  /// 签到紀錄
  Future<WsCheckInSearchListRes> wsCheckInSearchList(WsCheckInSearchListReq wsCheckInSearchListReq, {
    required Function(String) onConnectSuccess,
    required Function(String) onConnectFail,
  }) async {
    final userInfo = ref.read(userInfoProvider);
    final WsBaseReq msg = WsParamsReq.checkInSearchList
      ..tId = userInfo.commToken ?? "emptyToken"
      ..msg = wsCheckInSearchListReq;

    /// 傳送ws send
    final res = await WebSocketHandler.sendData(msg,
        funcCode: WsParamsReq.checkInSearchList.f,
        onConnectSuccess: (msg) => onConnectSuccess(msg),
        onConnectFail: (errMsg) => onConnectFail(errMsg));

    return WsCheckInSearchListRes.fromJson(res.resultMap);
  }
}