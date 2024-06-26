
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frechat/models/ws_req/deposit/ws_deposit_apple_reply_receipt_req.dart';
import 'package:frechat/models/ws_req/deposit/ws_deposit_money_req.dart';
import 'package:frechat/models/ws_req/deposit/ws_deposit_number_option_req.dart';
import 'package:frechat/models/ws_req/deposit/ws_deposit_wechat_pay_sign_req.dart';
import 'package:frechat/models/ws_req/member/ws_member_point_coin_req.dart';
import 'package:frechat/models/ws_res/deposit/ws_deposit_money_res.dart';
import 'package:frechat/models/ws_res/deposit/ws_deposit_number_option_res.dart';
import 'package:frechat/models/ws_res/deposit/ws_deposit_wechat_pay_sign_res.dart';
import 'package:frechat/screens/home/home_view_model.dart';
import 'package:frechat/screens/profile/deposit/personal_deposit.dart';
import 'package:frechat/system/base_view_model.dart';
import 'package:frechat/system/call_back_function.dart';
import 'package:frechat/system/payment/alipay/alipay_manager.dart';
import 'package:frechat/system/payment/apple_payment/apple_payment_manager.dart';
import 'package:frechat/system/payment/wechat/wechat_manager.dart';
import 'package:frechat/system/provider/user_info_provider.dart';
import 'package:frechat/system/providers.dart';
import 'package:frechat/system/repository/response_code.dart';
import 'package:frechat/widgets/shared/dialog/comm_dialog.dart';
import 'package:frechat/widgets/shared/loading_animation.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:uuid/uuid.dart';

class PersonalCallLimitViewModel {

  WidgetRef ref;
  ViewChange setState;
  BuildContext context;
  TickerProvider tickerProvider;

  PersonalCallLimitViewModel({
    required this.ref,
    required this.setState,
    required this.context,
    required this.tickerProvider
  });

  late TabController tabController;
  List<Tab> tabList = [Tab(text: 'VIP限定',), Tab(text: '不限对象'), Tab(text: '特定对象')];


  init(BuildContext context) async {
    tabController = TabController(length: tabList.length, vsync: tickerProvider);
  }

}