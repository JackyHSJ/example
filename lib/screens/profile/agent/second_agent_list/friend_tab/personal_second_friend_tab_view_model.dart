

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frechat/models/ws_res/agent/ws_agent_member_list_res.dart';
import 'package:frechat/screens/profile/agent/second_agent_list/second_agent_list_util.dart';
import 'package:frechat/system/call_back_function.dart';
import 'package:frechat/system/constant/enum.dart';
import 'package:frechat/system/provider/user_info_provider.dart';

class PersonalSecondFriendTabViewModel {
  PersonalSecondFriendTabViewModel({required this.ref, required this.setState, required this.agentMember});

  WidgetRef ref;
  ViewChange setState;
  AgentMemberInfo agentMember;

  late TextEditingController searchMemberTextController;
  late SecondAgentListUtil secondAgentListUtil;

  init(BuildContext context) {
    searchMemberTextController = TextEditingController();
    secondAgentListUtil = SecondAgentListUtil(ref: ref, setState: setState, agentMember: agentMember, mode: AgentSecondAgentListMode.friend, onMessageAndSetDataToProviderFunction: (res){
      ref.read(userUtilProvider.notifier).loadAgentSecondFriendList(res);
    });
    secondAgentListUtil.initLoadData(context);
  }

  dispose() {
    searchMemberTextController.dispose();
  }
}