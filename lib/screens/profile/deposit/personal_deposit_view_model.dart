
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
import 'package:frechat/models/ws_res/member/ws_member_point_coin_res.dart';
import 'package:frechat/screens/home/home_view_model.dart';
import 'package:frechat/screens/profile/deposit/personal_deposit.dart';
import 'package:frechat/screens/profile/deposit/personal_deposit_dialog.dart';
import 'package:frechat/system/base_view_model.dart';
import 'package:frechat/system/call_back_function.dart';
import 'package:frechat/system/payment/alipay/alipay_manager.dart';
import 'package:frechat/system/payment/apple_payment/apple_payment_manager.dart';
import 'package:frechat/system/payment/wechat/wechat_manager.dart';
import 'package:frechat/system/provider/user_info_provider.dart';
import 'package:frechat/system/providers.dart';
import 'package:frechat/system/repository/response_code.dart';
import 'package:frechat/widgets/constant_value.dart';
import 'package:frechat/widgets/shared/dialog/comm_dialog.dart';
import 'package:frechat/widgets/shared/img_util.dart';
import 'package:frechat/widgets/shared/loading_animation.dart';
import 'package:frechat/widgets/theme/original/app_colors.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:uuid/uuid.dart';

class PersonalDepositViewModel {

  WidgetRef ref;
  ViewChange setState;
  BuildContext context;

  PersonalDepositViewModel({
    required this.ref,
    required this.setState,
    required this.context,
  });

  DepositOptionListInfo? selectPhraseOption;
  int? androidPlatformCode;

  init() async {
    _getMemberCoinsOrPointsData();
    _loadDepositNumberOption();
  }

  //
  dispose() {

  }

  void rechargeCoinsHandler(DepositOptionListInfo depositOptionListInfo){
    setState(() => selectPhraseOption = depositOptionListInfo);
  }

  // 取得個人金幣資訊
  Future<void> _getMemberCoinsOrPointsData() async {
    String? resultCodeCheck;
    final WsMemberPointCoinReq reqBody = WsMemberPointCoinReq.create();
    final WsMemberPointCoinRes res = await ref.read(memberWsProvider).wsMemberPointCoin(reqBody,
        onConnectSuccess: (succMsg) => resultCodeCheck = succMsg,
        onConnectFail: (errMsg) => BaseViewModel.showToast(context, ResponseCode.map[errMsg]!));

    if (resultCodeCheck == ResponseCode.CODE_SUCCESS) {
      ref.read(userUtilProvider.notifier).loadMemberPointCoin(res);
    }
  }

  // 刷新充值列表選項
  Future<void> _loadDepositNumberOption() async {
    String resultCodeCheck = '';
    final WsDepositNumberOptionReq reqBody = WsDepositNumberOptionReq.create();
    final WsDepositNumberOptionRes res = await ref.read(depositWsProvider).wsDepositNumberOption(reqBody,
        onConnectSuccess: (succMsg) => resultCodeCheck = succMsg,
        onConnectFail: (errMsg) => BaseViewModel.showToast(context, ResponseCode.map[errMsg]!)
    );
    if (resultCodeCheck == ResponseCode.CODE_SUCCESS) {
      ref.read(userUtilProvider.notifier).loadDepositNumberOption(res);
    }
  }
}