
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frechat/models/ws_res/agent/ws_agent_member_list_res.dart';
import 'package:frechat/models/ws_res/member/ws_member_info_res.dart';
import 'package:frechat/screens/profile/agent/agent_util.dart';
import 'package:frechat/screens/profile/agent/member_list/agent_contact_list/agent_contact_list.dart';
import 'package:frechat/screens/profile/agent/member_list/personal_contact_list/personal_contact_list.dart';
import 'package:frechat/screens/profile/agent/member_list/second_agent_list/second_agent_list.dart';
import 'package:frechat/screens/profile/agent/second_agent_list/agent_tab/personal_second_agent_tab.dart';
import 'package:frechat/screens/profile/agent/second_agent_list/friend_tab/personal_second_friend_tab.dart';
import 'package:frechat/system/call_back_function.dart';
import 'package:frechat/system/constant/enum.dart';
import 'package:frechat/system/provider/user_info_provider.dart';
import 'package:frechat/system/providers.dart';

class PersonalAgentMemberListViewModel {
  PersonalAgentMemberListViewModel({
    required this.ref,
    required this.setState,
    required this.tickerProvider
  });

  WidgetRef ref;
  ViewChange setState;
  TickerProvider tickerProvider;

  late TextEditingController searchMemberTextController; // 搜尋

  // util
  late AgentUtil agentUtil;
  late AgentUtil agentContactListUtil;
  late AgentUtil personalContactListUtil;
  late AgentUtil secondAgentListUtil;

  // Tab // '推广人脉', '我的人脉', '二级推广'
  List<Tab> tabTitles = [];
  List<Widget> tabviews = [];
  late TabController tabController; // 底下的 tab controller
  int? type; // 0: 推广人脉,我的人脉 1: 二级推广: 推广人脉,我的人脉, 二级推广
  AgentMemberInfo? agentMember;
  //

  init(BuildContext context) async {
    AgentUtil.startTime = DateTime.now().subtract(const Duration(days: 1));
    AgentUtil.endTime = DateTime.now();

    _initAgentUtil();
    _getTabData();

    searchMemberTextController = TextEditingController();
    tabController = TabController(initialIndex: 0, length: tabTitles.length, vsync: tickerProvider);

    // 初始化取得參數
    await agentUtil.initLoadData(context);
    final bool isAgentLevel2 = ref.read(userInfoProvider).memberInfo?.agentLevel == 2;
    if(isAgentLevel2) {
      return ;
    }
    await agentContactListUtil.initLoadData(context);
    await personalContactListUtil.initLoadData(context);
    secondAgentListUtil.initLoadData(context);
  }

  _initAgentUtil() {
    agentUtil = AgentUtil(ref: ref, setState: setState,
        onMessageAndSetDataToProviderFunction: (res) => ref.read(userUtilProvider.notifier).loadAgentMemberListSearchAll(res));

    final bool isAgentLevel2 = ref.read(userInfoProvider).memberInfo?.agentLevel == 2;
    if(isAgentLevel2) {
      return ;
    }

    agentContactListUtil = AgentUtil(ref: ref, setState: setState, mode: AgentMemberListMode.primaryPromotor,
        onMessageAndSetDataToProviderFunction: (res) {ref.read(userUtilProvider.notifier).loadAgentMemberListFriend(res);});
    personalContactListUtil = AgentUtil(ref: ref, setState: setState, mode: AgentMemberListMode.friends,
        onMessageAndSetDataToProviderFunction: (res) {ref.read(userUtilProvider.notifier).loadAgentMemberListPrimaryPromotor(res);});
    secondAgentListUtil = AgentUtil(ref: ref, setState: setState, mode: AgentMemberListMode.agent,
        onMessageAndSetDataToProviderFunction: (res) {ref.read(userUtilProvider.notifier).loadAgentMemberListAgent(res);});
  }

  _getTabData() {
    final WsMemberInfoRes? memberInfo = ref.read(userInfoProvider).memberInfo;
    final bool isAgentLevel1 = memberInfo?.agentLevel == 1;
    final bool isAgentLevel2 = memberInfo?.agentLevel == 2;

    if(isAgentLevel1) {
      // tabTitles = [const Tab(text: '推广人脉',), const Tab(text: '我的人脉'), const Tab(text: '二级推广')];

      tabTitles = [
        const Tab(
          child: Align(
            alignment: Alignment.center,
            child: Text("推广人脉"),
          ),
        ),
        const Tab(
          child: Align(
            alignment: Alignment.center,
            child: Text("我的人脉"),
          ),
        ),
        const Tab(
          child: Align(
            alignment: Alignment.center,
            child: Text("二级推广"),
          ),
        ),
      ];
      type = 1;
      tabviews = [
        AgentContactList(startTime: AgentUtil.startTime, endTime: AgentUtil.endTime, agentUtil: agentContactListUtil),
        PersonalContactList(startTime: AgentUtil.startTime, endTime: AgentUtil.endTime, agentUtil: personalContactListUtil),
        SecondAgentList(startTime: AgentUtil.startTime, endTime: AgentUtil.endTime, agentUtil: secondAgentListUtil)
      ];
    }

    if(isAgentLevel2) {
      final num userId = ref.read(userInfoProvider).userId ?? 0;
      final num parent = ref.read(userInfoProvider).memberInfo?.parent ?? 0;
      agentMember = AgentMemberInfo(
        agentUserId: userId,
        parent: parent
      );
      // tabTitles = [const Tab(text: '推广人脉'), const Tab(text: '我的人脉')];
      tabTitles = [
        const Tab(
          child: Align(
            alignment: Alignment.center,
            child: Text("推广人脉"),
          ),
        ),
        const Tab(
          child: Align(
            alignment: Alignment.center,
            child: Text("我的人脉"),
          ),
        ),
      ];
      type =0;
      // tabviews = [
      //   PersonalSecondAgentTab(agentMember: agentMember),
      //   PersonalSecondFriendTab(agentMember: agentMember),
      // ];
    }
  }

  dispose() {
    searchMemberTextController.dispose();
    tabController.dispose();
  }

  setTimeAndGetAgentMemberList(BuildContext context) async {
    agentUtil.resetToInitState();
    await agentUtil.getAgentMemberList(context);

    final bool isAgentLevel2 = ref.read(userInfoProvider).memberInfo?.agentLevel == 2;
    if(isAgentLevel2) {
      return ;
    }
    agentContactListUtil.resetToInitState();
    await agentContactListUtil.getAgentMemberList(context);
    personalContactListUtil.resetToInitState();
    await personalContactListUtil.getAgentMemberList(context);
    secondAgentListUtil.resetToInitState();
    await secondAgentListUtil.getAgentMemberList(context);
  }
}