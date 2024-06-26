

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frechat/models/agent_tag_model.dart';
import 'package:frechat/models/ws_req/agent/ws_agent_second_member_list_req.dart';
import 'package:frechat/models/ws_res/agent/ws_agent_member_list_res.dart';

import 'package:frechat/system/base_view_model.dart';
import 'package:frechat/system/call_back_function.dart';
import 'package:frechat/system/constant/enum.dart';
import 'package:frechat/system/providers.dart';
import 'package:frechat/system/repository/response_code.dart';
import 'package:frechat/system/util/date_format_util.dart';

class SecondAgentListUtil {
  SecondAgentListUtil({
    required this.ref,
    required this.setState,
    required this.mode,
    required this.agentMember,
    required this.onMessageAndSetDataToProviderFunction,
  });

  final WidgetRef ref;
  final ViewChange setState;
  final AgentSecondAgentListMode mode;
  final AgentMemberInfo agentMember;
  final Function(WsAgentMemberListRes) onMessageAndSetDataToProviderFunction;

  WsAgentMemberListRes? filterMemberList;

  DateTime startTime = DateTime.now().subtract(const Duration(days: 1));
  DateTime endTime = DateTime.now();
  String page = '1';

  void initLoadData(BuildContext context) {
    // 初始化取得參數
    resetToInitState();
    getAgentMemberList(context);
    setState(() {});
  }

  /// 取得成員列表
  getAgentMemberList(BuildContext context) async {
    WsAgentMemberListRes? res;
    String resultCodeCheck = '';
    res = await _getMemberListRes(onResultCodeCheck: (resCode) => resultCodeCheck = resCode);
    if (resultCodeCheck == ResponseCode.CODE_SUCCESS) {
      onMessageAndSetDataToProviderFunction(res ?? WsAgentMemberListRes());
      filterMemberList = res;
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

  Future<WsAgentMemberListRes?> _getMemberListRes({ required Function(String) onResultCodeCheck }) async {
    WsAgentMemberListRes? res;
    final String startTimeFormat = DateFormatUtil.getDateWith24HourFormat(startTime);
    final String endTimeFormat = DateFormatUtil.getDateWith24HourFormat(endTime);
    // final AgentTagType type = _getAgentType();
    if(mode == AgentSecondAgentListMode.friend) {
      res = await _loadAgentSecondFriendList(
          startTimeFormat: startTimeFormat, endTimeFormat: endTimeFormat,
          onResponseCode: (resCode) => onResultCodeCheck(resCode)
      );
      return res;
    }

    res = await _loadAgentSecondMemberList(
        startTimeFormat: startTimeFormat, endTimeFormat: endTimeFormat,
        onResponseCode: (resCode) => onResultCodeCheck(resCode)
    );

    // if(type == AgentTagType.level2Agent) {
    //   res = await _loadAgentSecondMemberList(
    //       startTimeFormat: startTimeFormat, endTimeFormat: endTimeFormat,
    //       onResponseCode: (resCode) => onResultCodeCheck(resCode)
    //   );
    // } else {
    //   res = await _loadAgentThirdMemberList(
    //       startTimeFormat: startTimeFormat, endTimeFormat: endTimeFormat,
    //       onResponseCode: (resCode) => onResultCodeCheck(resCode)
    //   );
    // }

    return res;
  }

  Future<WsAgentMemberListRes> _loadAgentSecondMemberList({
    required String startTimeFormat,
    required String endTimeFormat,
    required Function(String) onResponseCode
  }) async {
    /// 16-3 二級成員列表
    final WsAgentSecondMemberListReq reqBody = WsAgentSecondMemberListReq.create(
      userId: '${agentMember.id}',
      startDate: startTimeFormat,
      endDate: endTimeFormat,
      page: page,
    );
    final WsAgentMemberListRes res = await ref.read(agentWsProvider).wsAgentSecondMemberList(reqBody,
      onConnectSuccess: (succMsg) => onResponseCode(succMsg),
      onConnectFail: (errMsg) => onResponseCode(errMsg),
    );
    return res;
  }

  Future<WsAgentMemberListRes> _loadAgentThirdMemberList({
    required String startTimeFormat,
    required String endTimeFormat,
    required Function(String) onResponseCode
  }) async {
    /// 16-4 三級成員列表
    final WsAgentSecondMemberListReq reqBody = WsAgentSecondMemberListReq.create(
      userId: '${agentMember.id}',
      startDate: startTimeFormat,
      endDate: endTimeFormat,
      page: page,
    );

    final WsAgentMemberListRes res = await ref.read(agentWsProvider).wsAgentThirdMemberList(reqBody,
      onConnectSuccess: (succMsg) => onResponseCode(succMsg),
      onConnectFail: (errMsg) => onResponseCode(errMsg),
    );

    return res;
  }

  Future<WsAgentMemberListRes> _loadAgentSecondFriendList({
    required String startTimeFormat,
    required String endTimeFormat,
    required Function(String) onResponseCode
  }) async {
    /// 16-5 三級成員列表 - 好友人脈
    final WsAgentSecondMemberListReq reqBody = WsAgentSecondMemberListReq.create(
      userId: '${agentMember.id}',
      startDate: startTimeFormat,
      endDate: endTimeFormat,
      page: page,
    );

    final WsAgentMemberListRes res = await ref.read(agentWsProvider).wsAgentSecondFriendList(reqBody,
      onConnectSuccess: (succMsg) => onResponseCode(succMsg),
      onConnectFail: (errMsg) => onResponseCode(errMsg),
    );

    return res;
  }

  void filter({required String userName, WsAgentMemberListRes? memberList}) {
    final List<AgentMemberInfo>? list = memberList?.list?.where((memberInfo) {
      if(userName == '') {
        return true;
      }
      final isContain = memberInfo.userName?.contains(userName);
      return isContain ?? false;
    }).toList();
    filterMemberList = WsAgentMemberListRes(list: list);
    setState((){});
  }

  // 查詢列表先回到預設狀態
  void resetToInitState(){
    page = '1';
    filterMemberList = null;
  }

  AgentTagType _getAgentType() {
    final num myUserId = ref.read(userInfoProvider).userId ?? 0;
    final AgentTagType type = AgentTagModel.getType(myUserId: myUserId, info: agentMember);
    return type;
  }

  onRefresh() {

  }

  onFetchMore(BuildContext context) {
    num pageNum = num.tryParse(page) ?? 1;
    pageNum++;
    page = '$pageNum';
    getAgentMemberList(context);
  }
}