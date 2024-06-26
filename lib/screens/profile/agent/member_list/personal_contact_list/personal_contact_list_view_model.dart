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

class PersonalContactListViewModel {

  WidgetRef ref;
  ViewChange setState;

  PersonalContactListViewModel({
    required this.ref,
    required this.setState,
  });

  late TextEditingController searchMemberTextController;

  void init(BuildContext context, {required DateTime startTime, required DateTime endTime}) {

    searchMemberTextController = TextEditingController();
  }

  void dispose() {
    searchMemberTextController.dispose();
  }
}