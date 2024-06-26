
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frechat/models/ws_req/agent/ws_agent_member_list_req.dart';
import 'package:frechat/models/ws_req/agent/ws_agent_second_member_list_req.dart';
import 'package:frechat/models/ws_res/agent/ws_agent_member_list_res.dart';

import 'package:frechat/system/base_view_model.dart';
import 'package:frechat/system/call_back_function.dart';
import 'package:frechat/system/constant/enum.dart';
import 'package:frechat/system/provider/user_info_provider.dart';
import 'package:frechat/system/providers.dart';
import 'package:frechat/system/repository/response_code.dart';
import 'package:frechat/system/util/date_format_util.dart';

class PersonalAgentMemberViewModel {

  WidgetRef ref;
  ViewChange setState;
  BuildContext context;

  PersonalAgentMemberViewModel({
    required this.ref,
    required this.context,
    required this.setState
  });

  WsAgentMemberListRes? filterMemberList;
  num? vm_totalAmount;
  num? vm_totalAmountWithReward;
  num? vm_onlineDuration;
  num? vm_pickup;
  num? vm_messageAmount;
  num? vm_voiceAmount;
  num? vm_videoAmount;
  num? vm_giftAmount;
  num? vm_pickUpAmount;
  num? vm_feedDonateAmount;

  DateTime vm_startTime = DateTime.now();
  DateTime vm_endTime = DateTime.now();
  String? vm_userName;
  num? vm_parentId;

  init({required num totalAmount,required num totalAmountWithReward,required num onlineDuration,required num pickup, required num messageAmount, required num voiceAmount,required num videoAmount, required num giftAmount, required num pickUpAmount, required num feedDonateAmount ,required DateTime startTime, required DateTime endTime, required String userName, required num parentId, required AgentMemberListMode? mode}) {

    vm_startTime = startTime;
    vm_endTime = endTime;
    vm_userName = userName;
    vm_parentId = parentId;

    // 一級推廣員看底下二級推廣進去要換 mode
    // agent -> secondaryAgent
    // http://redmine.zyg.com.tw/issues/1953
    if (mode == AgentMemberListMode.agent) {
      resetToInitState();
      getAgentMemberList(mode: AgentMemberListMode.secondaryAgent);
      setState(() {});
      return;
    }

    vm_totalAmount = totalAmount;
    vm_totalAmountWithReward = totalAmountWithReward;
    vm_onlineDuration = onlineDuration;
    vm_pickup = pickup;
    vm_messageAmount = messageAmount;
    vm_voiceAmount = voiceAmount;
    vm_videoAmount = videoAmount;
    vm_giftAmount = giftAmount;
    vm_pickUpAmount = pickUpAmount;
    vm_feedDonateAmount = feedDonateAmount;
  }

  // 查詢列表先回到預設狀態
  void resetToInitState(){
    vm_totalAmount = 0;
    vm_totalAmountWithReward = 0;
    vm_onlineDuration = 0;
    vm_pickup = 0;
    vm_messageAmount = 0;
    vm_voiceAmount = 0;
    vm_videoAmount = 0;
    vm_giftAmount = 0;
    vm_pickUpAmount = 0;
    vm_feedDonateAmount = 0;
  }

  Future<WsAgentMemberListRes> _getPrimaryAgent({
    required AgentMemberListMode mode,
    required String startTimeFormat,
    required String endTimeFormat,
    required Function(String) onResultCodeCheck
  }) async {
    final WsAgentMemberListReq reqBody = WsAgentMemberListReq.create(
      agentMemberListMode: mode,
      startDate: startTimeFormat,
      endDate: endTimeFormat,
      userName: vm_userName,
    );
    final res = await ref.read(agentWsProvider).wsAgentMemberList(reqBody,
      onConnectSuccess: (succMsg) => onResultCodeCheck(succMsg),
      onConnectFail: (errMsg) => onResultCodeCheck(errMsg),
    );
    return res;
  }
  Future<WsAgentMemberListRes> _getSecondAgent({
    required AgentMemberListMode mode,
    required String startTimeFormat,
    required String endTimeFormat,
    required Function(String) onResultCodeCheck
  }) async {
    final String userId = vm_parentId == 0 ? 'null' : '$vm_parentId';
    final WsAgentSecondMemberListReq reqBody = WsAgentSecondMemberListReq.create(
      userId: userId,
      userName: '$vm_userName',
      startDate: startTimeFormat,
      endDate: endTimeFormat,
    );
    final res = await ref.read(agentWsProvider).wsAgentSecondMemberList(reqBody,
      onConnectSuccess: (succMsg) => onResultCodeCheck(succMsg),
      onConnectFail: (errMsg) => onResultCodeCheck(errMsg),
    );
    return res;
  }

  Future<WsAgentMemberListRes> _getSecondFriend({
    required AgentMemberListMode mode,
    required String startTimeFormat,
    required String endTimeFormat,
    required Function(String) onResultCodeCheck
  }) async {
    final String userId = vm_parentId == 0 ? 'null' : '$vm_parentId';
    final WsAgentSecondMemberListReq reqBody = WsAgentSecondMemberListReq.create(
      userId: userId,
      userName: '$vm_userName',
      startDate: startTimeFormat,
      endDate: endTimeFormat,
    );
    final res = await ref.read(agentWsProvider).wsAgentSecondFriendList(reqBody,
      onConnectSuccess: (succMsg) => onResultCodeCheck(succMsg),
      onConnectFail: (errMsg) => onResultCodeCheck(errMsg),
    );
    return res;
  }

  getAgentMemberList({AgentMemberListMode? mode}) async {
    WsAgentMemberListRes? res;
    String resultCodeCheck = '';
    final String startTimeFormat = DateFormatUtil.getDateWith24HourFormat(vm_startTime);
    final String endTimeFormat = DateFormatUtil.getDateWith24HourFormat(vm_endTime);

    if(mode == AgentMemberListMode.agent || mode == AgentMemberListMode.primaryPromotor || mode == AgentMemberListMode.friends || mode == AgentMemberListMode.secondaryAgent) {
      res = await _getPrimaryAgent(mode: mode!, startTimeFormat: startTimeFormat, endTimeFormat: endTimeFormat,
          onResultCodeCheck: (msg) => resultCodeCheck = msg
      );
    }

    if(mode == AgentMemberListMode.secondAgentContact) {
      res = await _getSecondAgent(mode: mode!, startTimeFormat: startTimeFormat, endTimeFormat: endTimeFormat,
          onResultCodeCheck: (msg) => resultCodeCheck = msg
      );
    }
    if(mode == AgentMemberListMode.secondFriendContact) {
      res =  await _getSecondFriend(mode: mode!, startTimeFormat: startTimeFormat, endTimeFormat: endTimeFormat,
          onResultCodeCheck: (msg) => resultCodeCheck = msg
      );
    }

    if (resultCodeCheck == ResponseCode.CODE_SUCCESS) {
      final bool isNotEmpty = res?.list?.isNotEmpty ?? false;
      if (isNotEmpty) {
        AgentMemberInfo agentMemberInfo = res!.list!.first;
        vm_totalAmount = agentMemberInfo.totalAmount;
        vm_totalAmountWithReward = agentMemberInfo.totalAmountWithReward;
        vm_onlineDuration = agentMemberInfo.onlineDuration;
        vm_pickup = agentMemberInfo.pickup;
        vm_messageAmount = agentMemberInfo.messageAmount;
        vm_voiceAmount = agentMemberInfo.voiceAmount;
        vm_videoAmount = agentMemberInfo.videoAmount;
        vm_giftAmount = agentMemberInfo.giftAmount;
        vm_pickUpAmount = agentMemberInfo.pickupAmount;
        vm_feedDonateAmount = agentMemberInfo.feedDonateAmount;

      }
    } else if (resultCodeCheck == ResponseCode.CODE_CAN_NOT_FOUND_DATA){
      resetToInitState();
    } else if (resultCodeCheck == ResponseCode.CODE_DATE_RANGE_NOT_EXCEED_62DAYS) {
      resetToInitState();
    } else if (resultCodeCheck == ResponseCode.CODE_SEARCH_RANGE_NOT_EXCEED_31DAYS) {
      resetToInitState();
    } else {
      if (context.mounted) BaseViewModel.showToast(context, resultCodeCheck);
      resetToInitState();
    }

    setState((){});
  }
}