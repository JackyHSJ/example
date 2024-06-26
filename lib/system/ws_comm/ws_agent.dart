
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frechat/models/ws_req/agent/ws_agent_member_list_req.dart';
import 'package:frechat/models/ws_req/agent/ws_agent_promoter_info_req.dart';
import 'package:frechat/models/ws_req/agent/ws_agent_reward_ratio_list_req.dart';
import 'package:frechat/models/ws_req/agent/ws_agent_second_member_list_req.dart';
import 'package:frechat/models/ws_res/agent/ws_agent_member_list_res.dart';
import 'package:frechat/models/ws_res/agent/ws_agent_promoter_info_res.dart';
import 'package:frechat/models/ws_res/agent/ws_agent_reward_ratio_list_res.dart';

import 'package:frechat/system/ws_comm/ws_params_req.dart';
import 'package:frechat/system/providers.dart';
import 'package:frechat/system/websocket/websocket_handler.dart';

import '../../models/ws_req/ws_base_req.dart';

class AgentWs {
  AgentWs({required this.ref});
  final ProviderRef ref;

  /// 推廣中心/成員列表
  Future<WsAgentMemberListRes> wsAgentMemberList(WsAgentMemberListReq wsAgentMemberListReq, {
    required Function(String) onConnectSuccess,
    required Function(String) onConnectFail,
  }) async {
    final userInfo = ref.read(userInfoProvider);
    final WsBaseReq msg = WsParamsReq.agentMemberList
      ..tId = userInfo.commToken ?? "emptyToken"
      ..msg = wsAgentMemberListReq.toBody();

    /// 傳送ws send
    final res = await WebSocketHandler.sendData(msg,
        funcCode: WsParamsReq.agentMemberList.f,
        onConnectSuccess: (msg) => onConnectSuccess(msg),
        onConnectFail: (errMsg) => onConnectFail(errMsg));

    return res.resultMap == null ? WsAgentMemberListRes() : WsAgentMemberListRes.fromJson(res.resultMap);
  }

  /// 推廣中心-推廣者基本資料
  Future<WsAgentPromoterInfoRes> wsAgentPromoterInfo(WsAgentPromoterInfoReq wsAgentPromoterInfoReq, {
    required Function(String) onConnectSuccess,
    required Function(String) onConnectFail,
  }) async {
    final userInfo = ref.read(userInfoProvider);
    final WsBaseReq msg = WsParamsReq.agentPromoterInfo
      ..tId = userInfo.commToken ?? "emptyToken"
      ..msg = wsAgentPromoterInfoReq.toBody();

    /// 傳送ws send
    final res = await WebSocketHandler.sendData(msg,
        funcCode: WsParamsReq.agentPromoterInfo.f,
        onConnectSuccess: (msg) => onConnectSuccess(msg),
        onConnectFail: (errMsg) => onConnectFail(errMsg));

    return WsAgentPromoterInfoRes.fromJson(res.resultMap);
  }

  /// 推廣中心/二級成員列表
  Future<WsAgentMemberListRes> wsAgentSecondMemberList(WsAgentSecondMemberListReq wsAgentSecondMemberListReq, {
    required Function(String) onConnectSuccess,
    required Function(String) onConnectFail,
  }) async {
    final userInfo = ref.read(userInfoProvider);
    final WsBaseReq msg = WsParamsReq.agentSecondMemberList
      ..tId = userInfo.commToken ?? "emptyToken"
      ..msg = wsAgentSecondMemberListReq.toBody();

    /// 傳送ws send
    final res = await WebSocketHandler.sendData(msg,
        funcCode: WsParamsReq.agentSecondMemberList.f,
        onConnectSuccess: (msg) => onConnectSuccess(msg),
        onConnectFail: (errMsg) => onConnectFail(errMsg));

    return res.resultMap == null ? WsAgentMemberListRes() : WsAgentMemberListRes.fromJson(res.resultMap);
  }

  /// 推廣中心/三級成員列表 物件內容與16-3相同
  Future<WsAgentMemberListRes> wsAgentThirdMemberList(WsAgentSecondMemberListReq wsAgentSecondMemberListReq, {
    required Function(String) onConnectSuccess,
    required Function(String) onConnectFail,
  }) async {
    final userInfo = ref.read(userInfoProvider);
    final WsBaseReq msg = WsParamsReq.agentThirdMemberList
      ..tId = userInfo.commToken ?? "emptyToken"
      ..msg = wsAgentSecondMemberListReq.toBody();

    /// 傳送ws send
    final res = await WebSocketHandler.sendData(msg,
        funcCode: WsParamsReq.agentThirdMemberList.f,
        onConnectSuccess: (msg) => onConnectSuccess(msg),
        onConnectFail: (errMsg) => onConnectFail(errMsg));

    return res.resultMap == null ? WsAgentMemberListRes() : WsAgentMemberListRes.fromJson(res.resultMap);
  }

  /// 推廣中心/二級好友人脈成員列表
  Future<WsAgentMemberListRes> wsAgentSecondFriendList(WsAgentSecondMemberListReq wsAgentSecondMemberListReq, {
    required Function(String) onConnectSuccess,
    required Function(String) onConnectFail,
  }) async {
    final userInfo = ref.read(userInfoProvider);
    final WsBaseReq msg = WsParamsReq.agentSecondFriendList
      ..tId = userInfo.commToken ?? "emptyToken"
      ..msg = wsAgentSecondMemberListReq.toBody();

    /// 傳送ws send
    final res = await WebSocketHandler.sendData(msg,
        funcCode: WsParamsReq.agentSecondFriendList.f,
        onConnectSuccess: (msg) => onConnectSuccess(msg),
        onConnectFail: (errMsg) => onConnectFail(errMsg));

    return res.resultMap == null ? WsAgentMemberListRes() : WsAgentMemberListRes.fromJson(res.resultMap);
  }

  /// 推廣中心/推廣成數
  Future<WsAgentRewardRatioListRes> wsAgentRewardRatioList(WsAgentRewardRatioListReq wsAgentRewardRatioListReq, {
    required Function(String) onConnectSuccess,
    required Function(String) onConnectFail,
  }) async {
    final userInfo = ref.read(userInfoProvider);
    final WsBaseReq msg = WsParamsReq.agentRewardRatioList
      ..tId = userInfo.commToken ?? "emptyToken"
      ..msg = wsAgentRewardRatioListReq.toBody();

    /// 傳送ws send
    final res = await WebSocketHandler.sendData(msg,
        funcCode: WsParamsReq.agentRewardRatioList.f,
        onConnectSuccess: (msg) => onConnectSuccess(msg),
        onConnectFail: (errMsg) => onConnectFail(errMsg));

    return res.resultMap == null ? WsAgentRewardRatioListRes() : WsAgentRewardRatioListRes.fromJson(res.resultMap);
  }
}