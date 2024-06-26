
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frechat/models/ws_req/agent/ws_agent_member_list_req.dart';
import 'package:frechat/models/ws_res/agent/ws_agent_member_list_res.dart';
import 'package:frechat/system/base_view_model.dart';
import 'package:frechat/system/call_back_function.dart';
import 'package:frechat/system/provider/user_info_provider.dart';
import 'package:frechat/system/providers.dart';
import 'package:frechat/system/repository/response_code.dart';
import 'package:frechat/system/util/date_format_util.dart';
import 'package:frechat/widgets/shared/loading_animation.dart';

class PersonalAgentBenefitViewModel {

  WidgetRef ref;
  ViewChange setState;
  BuildContext context;

  PersonalAgentBenefitViewModel({
    required this.ref,
    required this.setState,
    required this.context
  });

  late TextEditingController searchMemberTextController;
  WsAgentMemberListRes? filterMemberList;
  DateTime startTime = DateTime.now().subtract(const Duration(days: 1));
  DateTime endTime = DateTime.now();
  num totalAmount = 0; // 總收益
  num messageAmount = 0; // 文字
  num giftAmount = 0; // 禮物
  num voiceAmount = 0; // 語音
  num videoAmount = 0; // 視頻
  num pickupAmount = 0; // 搭訕

  String page = '1';
  bool isNoMoreData = false;

  ScrollController? scrollController;
  bool isLoading = false;

  init(BuildContext context) async {
    searchMemberTextController = TextEditingController();
    scrollController = ScrollController();
    scrollController?.addListener(_scrollListener);
    getAgentMemberList(context);
  }

  dispose() {
    searchMemberTextController.dispose();
    if(scrollController != null) {
      scrollController?.dispose();
      scrollController = null;
    }
  }

  Future<void> _scrollListener() async {
    if (scrollController!.offset >= scrollController!.position.maxScrollExtent && !scrollController!.position.outOfRange) {
      LoadingAnimation.showOverlayLoading(context);
      await onFetchMore();
      LoadingAnimation.cancelOverlayLoading();
    }
  }

  void resetToInitStatus(){
    totalAmount = 0;
    messageAmount = 0;
    giftAmount = 0;
    voiceAmount = 0;
    videoAmount = 0;
    pickupAmount = 0;
  }

  /// 16-1
  Future<void> getAgentMemberList(BuildContext context) async {
    String resultCodeCheck = '';

    final startTimeFormat = DateFormatUtil.getDateWith24HourFormat(startTime);
    final endTimeFormat = DateFormatUtil.getDateWith24HourFormat(endTime);

    final WsAgentMemberListReq reqBody = WsAgentMemberListReq.create(
      startDate: startTimeFormat,
      endDate: endTimeFormat,
      page: page,
      profit: 'T'
    );

    final WsAgentMemberListRes res = await ref.read(agentWsProvider).wsAgentMemberList(reqBody,
        onConnectSuccess: (succMsg) => resultCodeCheck = succMsg,
        onConnectFail: (errMsg) => resultCodeCheck = errMsg,
    );

    if (resultCodeCheck == ResponseCode.CODE_SUCCESS) {
      ref.read(userUtilProvider.notifier).loadAgentMemberListSearchAll(res);
      /// 判斷頁數來判斷要覆蓋還是添加資料
      if(page == '1') {
        filterMemberList = res;
      } else {
        filterMemberList?.list?.addAll(res.list ?? []);
      }

    } else if (resultCodeCheck == '123'){
      if (context.mounted) BaseViewModel.showToast(context, '查询区间上限为1个月，请重新选择');
    } else if (resultCodeCheck == '160') {
      if (context.mounted) BaseViewModel.showToast(context, '查询区间上限为1个月，请重新选择');
    } else if (resultCodeCheck == '161') {
      if (context.mounted) BaseViewModel.showToast(context, '查询区间上限为1个月，请重新选择');
    } else {
      if (context.mounted) BaseViewModel.showToast(context, resultCodeCheck);
    }

    /// 刷新自己的收益
    getTotalBenefit();

    setState((){});
  }

  filter(String userName) {
    final WsAgentMemberListRes? memberList = ref.read(userInfoProvider).agentMemberListSearchAll;
    final list = memberList?.list?.where((memberInfo) {
      if(userName == '') {
        return true;
      }
      final isContain = memberInfo.userName?.contains(userName);
      return isContain ?? false;
    }).toList();
    filterMemberList = WsAgentMemberListRes(list: list);
    setState((){});
  }

  getTotalBenefit() {
    totalAmount = 0;
    messageAmount = 0;
    giftAmount = 0;
    voiceAmount = 0;
    videoAmount = 0;
    pickupAmount = 0;
    
    filterMemberList?.list?.forEach((info) {
      totalAmount += info.totalAmount ?? 0;
      messageAmount += info.messageAmount ?? 0;
      giftAmount += info.giftAmount ?? 0;
      voiceAmount += info.voiceAmount ?? 0;
      videoAmount += info.videoAmount ?? 0;
      pickupAmount += info.pickupAmount ?? 0;
    });
  }

  onFetchMore() async {
    num pageNum = num.tryParse(page) ?? 1;
    pageNum++;
    page = '$pageNum';
    getAgentMemberList(context);
  }
}