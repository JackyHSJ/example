
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frechat/models/ws_req/agent/ws_agent_member_list_req.dart';
import 'package:frechat/models/ws_req/agent/ws_agent_promoter_info_req.dart';
import 'package:frechat/models/ws_res/agent/ws_agent_member_list_res.dart';
import 'package:frechat/models/ws_res/agent/ws_agent_promoter_info_res.dart';
import 'package:frechat/system/base_view_model.dart';
import 'package:frechat/system/call_back_function.dart';
import 'package:frechat/system/providers.dart';
import 'package:frechat/system/repository/response_code.dart';
import 'package:frechat/system/ws_comm/ws_account.dart';

class PersonalAgentViewModel {
  PersonalAgentViewModel({
    required this.tickerProvider,
    required this.ref,
    required this.setState,
  });

  ViewChange setState;
  WidgetRef ref;
  late TabController tabController;
  TickerProvider tickerProvider;
  List<Tab> tabList = [];

  WsAgentMemberListRes? memberList;
  WsAgentPromoterInfoRes? promoterInfo;

  _fitTab({required String text}) {
    return Tab(
      child: FittedBox(
        child: Text(text),
      ),
    );
  }

  init(BuildContext context) {
    tabList = [
      _fitTab(text: '推广中心'),
      _fitTab(text: '成员列表'),
      // _fitTab(text: '收益汇总'),
      _fitTab(text: '渠道链接')
    ];
    tabController = TabController(length: tabList.length, vsync: tickerProvider);
  }

  dispose() {
    tabController.dispose();
  }


}