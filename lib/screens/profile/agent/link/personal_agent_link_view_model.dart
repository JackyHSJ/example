
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frechat/models/deep_link_model.dart';
import 'package:frechat/models/user_info_model.dart';
import 'package:frechat/system/call_back_function.dart';
import 'package:frechat/system/payment/wechat/wechat_manager.dart';
import 'package:frechat/system/provider/user_info_provider.dart';
import 'package:frechat/system/providers.dart';
import 'package:frechat/system/repository/http_setting.dart';
import 'package:frechat/system/util/share_util.dart';
import 'package:wechat_kit/wechat_kit.dart';

class PersonalAgentLinkViewModel {

  ViewChange setState;
  WidgetRef ref;

  PersonalAgentLinkViewModel({
    required this.setState,
    required this.ref
  });

  DateTime startTime = DateTime.now().subtract(const Duration(days: 1));
  DateTime endTime = DateTime.now();

  init() {
  }

  dispose() {
  }
}