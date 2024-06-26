

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frechat/models/ws_req/agent/ws_agent_member_list_req.dart';
import 'package:frechat/models/ws_res/agent/ws_agent_member_list_res.dart';
import 'package:frechat/system/base_view_model.dart';
import 'package:frechat/system/call_back_function.dart';
import 'package:frechat/system/constant/enum.dart';
import 'package:frechat/system/extension/ws_agent_member_list_res.dart';
import 'package:frechat/system/provider/user_info_provider.dart';
import 'package:frechat/system/providers.dart';
import 'package:frechat/system/repository/response_code.dart';
import 'package:frechat/system/util/date_format_util.dart';

class AgentUtil {
  AgentUtil({
    required this.ref,
    required this.setState,
    this.mode,
    required this.onMessageAndSetDataToProviderFunction,
  });
  final WidgetRef ref;
  ViewChange setState;
  final AgentMemberListMode? mode;
  final Function(WsAgentMemberListRes) onMessageAndSetDataToProviderFunction;
  static DateTime startTime = DateTime.now().subtract(const Duration(days: 1));
  static DateTime endTime = DateTime.now();


  // 上面那段
  num totalAmount = 0; // 總收益
  num messageAmount = 0; // 文字
  num giftAmount = 0; // 禮物
  num voiceAmount = 0; // 語音
  num videoAmount = 0; // 視頻
  num pickupAmount = 0; // 搭訕
  num feedDonateAmount = 0; // 动态打赏

  WsAgentMemberListRes? filterMemberList;
  String page = '1';

  Future<void> initLoadData(BuildContext context) async {
    // 初始化取得參數
    resetToInitState();
    await getAgentMemberList(context);
    setState(() {});
  }

  /// 16-1 成員列表用
  Future<void> getAgentMemberList(BuildContext context) async {
    String resultCodeCheck = '';

    final startTimeFormat = DateFormatUtil.getDateWith24HourFormat(startTime);
    final endTimeFormat = DateFormatUtil.getDateWith24HourFormat(endTime);

    final WsAgentMemberListReq reqBody = WsAgentMemberListReq.create(
      startDate: startTimeFormat,
      endDate: endTimeFormat,
      page: page,
      agentMemberListMode: mode
    );

    final WsAgentMemberListRes res = await ref.read(agentWsProvider).wsAgentMemberList(reqBody,
      onConnectSuccess: (succMsg) => resultCodeCheck = succMsg,
      onConnectFail: (errMsg) => resultCodeCheck = errMsg,
    );

    if (resultCodeCheck == ResponseCode.CODE_SUCCESS) {
      if(res.list?.length == 0) {
        return ;
      }

      onMessageAndSetDataToProviderFunction(res);
      /// 判斷頁數來判斷要覆蓋還是添加資料
      if(page == '1') {
        filterMemberList = res;
      } else {
        filterMemberList?.list?.addAll(res.list ?? []);
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
    // 刷新自己的收益
    getTotalBenefit();

    setState((){});
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

  getTotalBenefit() {
    _initTotalBenefit();
    if(filterMemberList == null) {
      return ;
    }
    totalAmount = filterMemberList!.getSumTotalAmount((info) => info.totalAmount ?? 0);
    messageAmount = filterMemberList!.getSumTotalAmount((info) => info.messageAmount ?? 0);
    giftAmount = filterMemberList!.getSumTotalAmount((info) => info.giftAmount ?? 0);
    voiceAmount = filterMemberList!.getSumTotalAmount((info) => info.voiceAmount ?? 0);
    videoAmount = filterMemberList!.getSumTotalAmount((info) => info.videoAmount ?? 0);
    pickupAmount = filterMemberList!.getSumTotalAmount((info) => info.pickupAmount ?? 0);
    feedDonateAmount = filterMemberList!.getSumTotalAmount((info) => info.feedDonateAmount ?? 0);

  }

  _initTotalBenefit() {
    totalAmount = 0;
    messageAmount = 0;
    giftAmount = 0;
    voiceAmount = 0;
    videoAmount = 0;
    pickupAmount = 0;
    feedDonateAmount = 0;
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