

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frechat/system/constant/law.dart';
import 'package:frechat/system/zego_call/zego_login.dart';

import '../../../../models/ws_req/member/ws_member_apply_cancel_req.dart';
import '../../../../system/provider/user_info_provider.dart';
import '../../../../system/providers.dart';

class PersonalSettingDeleteViewModel{
  PersonalSettingDeleteViewModel({
    required this.ref
  });

  WidgetRef ref;
  bool isVerify = false;
  String law = Law.deleteLaw;

  void toggleVerify() {
    isVerify = !isVerify;
  }
}