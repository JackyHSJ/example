

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frechat/models/agent_tag_model.dart';
import 'package:frechat/models/ws_req/agent/ws_agent_member_list_req.dart';
import 'package:frechat/models/ws_req/agent/ws_agent_second_member_list_req.dart';
import 'package:frechat/models/ws_res/agent/ws_agent_member_list_res.dart';

import 'package:frechat/system/base_view_model.dart';
import 'package:frechat/system/call_back_function.dart';
import 'package:frechat/system/constant/enum.dart';
import 'package:frechat/system/providers.dart';
import 'package:frechat/system/repository/response_code.dart';
import 'package:frechat/system/util/date_format_util.dart';

import '../../../../system/provider/user_info_provider.dart';

class PersonalSecondAgentListViewModel {

  TickerProvider tickerProvider;

  PersonalSecondAgentListViewModel({
    required this.tickerProvider
  });

  // Tab
  // List<Tab> tabTitles = ['推广人脉', '好友人脉']; // 底下的 Tab
  List<Tab> tabTitles = [const Tab(
    child: Align(
      alignment: Alignment.center,
      child: Text("推广人脉"),
    ),
  ),
    const Tab(
      child: Align(
        alignment: Alignment.center,
        child: Text("好友人脉"),
      ),
    ),
  ]; // 底下的 Tab

  late TabController tabController; // 底下的 tab controller

  init(BuildContext context) {
    tabController = TabController(initialIndex: 0, length: 2, vsync: tickerProvider);
  }

  dispose() {
  }
}