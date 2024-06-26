import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frechat/models/ws_req/mission/ws_mission_get_award_req.dart';
import 'package:frechat/models/ws_req/mission/ws_mission_search_status_req.dart';
import 'package:frechat/models/ws_req/ws_base_req.dart';
import 'package:frechat/models/ws_res/mission/ws_mission_get_award_res.dart';
import 'package:frechat/models/ws_res/mission/ws_mission_search_status_res.dart';
import 'package:frechat/system/providers.dart';
import 'package:frechat/system/websocket/websocket_handler.dart';
import 'package:frechat/system/ws_comm/ws_params_req.dart';

class MissionWs {
  MissionWs({required this.ref});
  final ProviderRef ref;

  /// 查詢新手.每日任務完成狀態
  Future<WsMissionSearchStatusRes> wsMissionSearchStatus(
    WsMissionSearchStatusReq wsMissionSearchStatusReq, {
    required Function(String) onConnectSuccess,
    required Function(String) onConnectFail,
  }) async {
    final userInfo = ref.read(userInfoProvider);
    final WsBaseReq msg = WsParamsReq.missionSearchStatus
      ..tId = userInfo.commToken ?? "emptyToken"
      ..msg = wsMissionSearchStatusReq;

    /// 傳送ws send
    final res = await WebSocketHandler.sendData(msg,
        funcCode: WsParamsReq.missionSearchStatus.f, onConnectSuccess: (msg) => onConnectSuccess(msg), onConnectFail: (errMsg) => onConnectFail(errMsg));
    return (res.resultMap == null) ? WsMissionSearchStatusRes() : WsMissionSearchStatusRes.fromJson(res.resultMap);
  }

  /// 任務完成領取獎勵
  Future<WsMissionGetAwardRes> wsMissionGetAward(
    WsMissionGetAwardReq wsMissionGetAwardReq, {
    required Function(String) onConnectSuccess,
    required Function(String) onConnectFail,
  }) async {
    final userInfo = ref.read(userInfoProvider);
    final WsBaseReq msg = WsParamsReq.missionGetAward
      ..tId = userInfo.commToken ?? "emptyToken"
      ..msg = wsMissionGetAwardReq;

    /// 傳送ws send
    final res = await WebSocketHandler.sendData(msg,
        funcCode: WsParamsReq.missionGetAward.f, onConnectSuccess: (msg) => onConnectSuccess(msg), onConnectFail: (errMsg) => onConnectFail(errMsg));
    return (res.resultMap == null) ? WsMissionGetAwardRes() : WsMissionGetAwardRes.fromJson(res.resultMap);
  }
}
