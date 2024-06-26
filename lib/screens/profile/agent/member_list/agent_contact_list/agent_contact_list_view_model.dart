import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frechat/models/ws_req/agent/ws_agent_member_list_req.dart';
import 'package:frechat/models/ws_res/agent/ws_agent_member_list_res.dart';
import 'package:frechat/screens/profile/agent/agent_util.dart';
import 'package:frechat/system/base_view_model.dart';
import 'package:frechat/system/call_back_function.dart';
import 'package:frechat/system/constant/enum.dart';
import 'package:frechat/system/provider/user_info_provider.dart';
import 'package:frechat/system/providers.dart';
import 'package:frechat/system/repository/response_code.dart';
import 'package:frechat/system/util/date_format_util.dart';

class AgentContactListViewModel {
  AgentContactListViewModel({
    required this.ref,
    required this.setState,
    required this.context
  });

  WidgetRef ref;
  ViewChange setState;
  BuildContext context;

  late TextEditingController searchMemberTextController; // 搜尋

  void init(BuildContext context, {required DateTime startTime, required DateTime endTime}) {
    searchMemberTextController = TextEditingController();
  }

  void dispose() {
    searchMemberTextController.dispose();
  }
}