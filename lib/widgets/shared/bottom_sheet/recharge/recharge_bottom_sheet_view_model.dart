import 'dart:async';
import 'dart:io' show Platform;
import 'package:flutter/cupertino.dart';
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

import 'package:frechat/system/base_view_model.dart';
import 'package:frechat/system/call_back_function.dart';
import 'package:frechat/system/constant/enum.dart';
import 'package:frechat/system/payment/alipay/alipay_manager.dart';
import 'package:frechat/system/payment/apple_payment/apple_payment_manager.dart';
import 'package:frechat/system/payment/wechat/wechat_manager.dart';
import 'package:frechat/system/provider/user_info_provider.dart';

import 'package:frechat/system/providers.dart';
import 'package:frechat/system/repository/response_code.dart';

import 'package:frechat/widgets/shared/dialog/check_dialog.dart';
import 'package:frechat/widgets/shared/dialog/comm_dialog.dart';
import 'package:frechat/widgets/shared/loading_animation.dart';
import 'package:frechat/widgets/theme/app_theme.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:uuid/uuid.dart';

class RechargeBottomSheetViewModel {

  WidgetRef ref;
  ViewChange setState;
  BuildContext context;

  RechargeBottomSheetViewModel({
    required this.ref,
    required this.setState,
    required this.context,
  });

  DepositOptionListInfo? selectPhraseOption;
  num? selectRechargeType;
  num myCoin = 0;

  void rechargeCoinsHandler(DepositOptionListInfo depositOptionListInfo){
    setState(() => selectPhraseOption = depositOptionListInfo);
  }

  void rechargePlatformHandler(type){
    setState(() => selectRechargeType = type);
  }

  init() async {
    _getMemberCoinsOrPointsData(context);
    _loadDepositNumberOption(context);
  }

  dispose() {
    //
  }

  // 取得個人金幣資訊
  Future<void> _getMemberCoinsOrPointsData(BuildContext context) async {
    String? resultCodeCheck;
    WsMemberPointCoinReq reqBody = WsMemberPointCoinReq.create();
    final res = await ref.read(memberWsProvider).wsMemberPointCoin(reqBody,
        onConnectSuccess: (succMsg) => resultCodeCheck = succMsg,
        onConnectFail: (errMsg) => BaseViewModel.showToast(context, ResponseCode.map[errMsg]!));

    if (resultCodeCheck == ResponseCode.CODE_SUCCESS) {
      ref.read(userUtilProvider.notifier).loadMemberPointCoin(res);
      myCoin = ref.read(userInfoProvider).memberPointCoin?.coins ?? 0;
      setState((){});
    }
  }

  // 刷新充值列表選項
  Future<void> _loadDepositNumberOption(BuildContext context) async {
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

  // 確認離開
  Future checkQuitDialog() async {
    final AppTheme theme = ref.read(userInfoProvider).theme ?? AppTheme(themeType: AppThemeType.original);

    CommDialog(context).build(
      theme: theme,
        title: '您确定要离开？',
        contentDes: '请充值金币以把握您的缘分吧！',
        leftBtnTitle: '离开',
        rightBtnTitle: '继续充值',
        leftAction: () {
          BaseViewModel.popPage(context);
          BaseViewModel.popPage(context);
        },
        rightAction: () => BaseViewModel.popPage(context)
    );
  }
}
