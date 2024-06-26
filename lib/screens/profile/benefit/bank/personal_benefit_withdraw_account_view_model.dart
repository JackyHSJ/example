


import 'dart:convert';
import 'dart:core';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frechat/models/ws_req/benefit/ws_benefit_info_req.dart';
import 'package:frechat/models/ws_req/member/ws_member_point_coin_req.dart';
import 'package:frechat/models/ws_req/withdraw/ws_withdraw_cloud_agreement_req.dart';
import 'package:frechat/models/ws_req/withdraw/ws_withdraw_member_income_req.dart';
import 'package:frechat/models/ws_req/withdraw/ws_withdraw_money_req.dart';
import 'package:frechat/models/ws_req/withdraw/ws_withdraw_search_payment_req.dart';
import 'package:frechat/models/ws_res/benefit/ws_benefit_info_res.dart';
import 'package:frechat/models/ws_res/member/ws_member_point_coin_res.dart';
import 'package:frechat/models/ws_res/withdraw/ws_withdraw_cloud_agreement_res.dart';
import 'package:frechat/models/ws_res/withdraw/ws_withdraw_member_income_res.dart';
import 'package:frechat/models/ws_res/withdraw/ws_withdraw_money_res.dart';
import 'package:frechat/models/ws_res/withdraw/ws_withdraw_search_payment_res.dart';
import 'package:frechat/system/base_view_model.dart';
import 'package:frechat/system/call_back_function.dart';
import 'package:frechat/system/constant/enum.dart';
import 'package:frechat/system/providers.dart';
import 'package:frechat/system/repository/response_code.dart';
import 'package:frechat/system/util/convert_util.dart';
import 'package:frechat/widgets/loading_dialog/loading_widget.dart';
import 'package:frechat/widgets/shared/dialog/comm_dialog.dart';
import 'package:frechat/widgets/theme/app_theme.dart';

class PersonalBenefitWithdrawAccountViewModel {

  WidgetRef ref;
  ViewChange setState;
  BuildContext context;

  PersonalBenefitWithdrawAccountViewModel({
    required this.ref,
    required this.setState,
    required this.context
  });

  // 當前帳號綁定設定資料
  WsWithdrawSearchPaymentRes? wsWithdrawSearchPaymentRes;
  bool isInitializing = true;


  void init () async {
    getWithdrawSearchPayment();
  }

  void dispose () {

  }

  // 9-6 查詢支付帳號
  Future<void> getWithdrawSearchPayment() async {

    String resultCodeCheck = '';
    final WsWithdrawSearchPaymentReq reqBody = WsWithdrawSearchPaymentReq.create();

    final WsWithdrawSearchPaymentRes res = await ref.read(withdrawWsProvider).wsWithdrawSearchPayment(reqBody,
        onConnectSuccess: (succMsg) => resultCodeCheck = succMsg,
        onConnectFail: (errMsg) => resultCodeCheck = errMsg
    );

    if (resultCodeCheck == ResponseCode.CODE_SUCCESS) {
      setState(() {
        wsWithdrawSearchPaymentRes = res;
        isInitializing = false;
      });
    }
  }
}
