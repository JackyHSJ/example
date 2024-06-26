


import 'dart:convert';
import 'dart:core';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:frechat/models/ws_req/benefit/ws_benefit_info_req.dart';
import 'package:frechat/models/ws_req/member/ws_member_point_coin_req.dart';
import 'package:frechat/models/ws_req/withdraw/ws_withdraw_cloud_agreement_req.dart';
import 'package:frechat/models/ws_req/withdraw/ws_withdraw_member_income_req.dart';
import 'package:frechat/models/ws_req/withdraw/ws_withdraw_member_point_to_coin_req.dart';
import 'package:frechat/models/ws_req/withdraw/ws_withdraw_money_req.dart';
import 'package:frechat/models/ws_req/withdraw/ws_withdraw_search_payment_req.dart';
import 'package:frechat/models/ws_res/benefit/ws_benefit_info_res.dart';
import 'package:frechat/models/ws_res/member/ws_member_point_coin_res.dart';
import 'package:frechat/models/ws_res/withdraw/ws_withdraw_cloud_agreement_res.dart';
import 'package:frechat/models/ws_res/withdraw/ws_withdraw_member_income_res.dart';
import 'package:frechat/models/ws_res/withdraw/ws_withdraw_member_point_to_coin_res.dart';
import 'package:frechat/models/ws_res/withdraw/ws_withdraw_money_res.dart';
import 'package:frechat/models/ws_res/withdraw/ws_withdraw_search_payment_res.dart';
import 'package:frechat/system/base_view_model.dart';
import 'package:frechat/system/call_back_function.dart';
import 'package:frechat/system/constant/enum.dart';
import 'package:frechat/system/provider/user_info_provider.dart';
import 'package:frechat/system/providers.dart';
import 'package:frechat/system/repository/response_code.dart';
import 'package:frechat/system/util/convert_util.dart';
import 'package:frechat/widgets/loading_dialog/loading_widget.dart';
import 'package:frechat/widgets/shared/dialog/check_dialog.dart';
import 'package:frechat/widgets/shared/dialog/comm_dialog.dart';
import 'package:frechat/widgets/theme/app_theme.dart';

class PersonalBenefitViewModel {

  WidgetRef ref;
  ViewChange setState;
  BuildContext context;

  PersonalBenefitViewModel({
    required this.ref,
    required this.setState,
    required this.context
  });

  bool isLoading = true;
  List<String> explanationList = [];
  int tabIndex = 1;
  int withdrawIncomeIndex = 0;
  List<WithdrawIncomeListInfo> withdrawIncomeList = [];
  String tip = ''; // 服務費(用 % 來算)
  String withdrawAmountPerDay = ''; // 每日可提現金額
  String dailyWithdrawPerDay = ''; // 每日可提現次數
  num points = 0; // 個人積分
  num todayIncome = 0; // 今日收益
  num withdrawalAmount = 0; // 審核中收益
  num pointsToRMB = 0;
  bool showWithdrawType = false; // 審核開關 6. 提現
  bool checkCloudAgreement = false;
  String cloudWithdrawalAgreementUrl = ''; // 雲服務協議書 Url
  String firstWithdrawal = '0'; // 0:非首次提款 1:首次提款
  WithdrawPaymentListInfo? defaultWithdrawAccount; // 預設提領帳戶
  bool isRealNameAuth = false;
  final TextEditingController exchangeTextEditController = TextEditingController();


  void init() async {
    await getMemberInfo();
    await _getPersonalBenefit();
    await getWithdrawMemberIncome();
    await _getExplanation();
    await getWithdrawSearchPayment();
    await _getCloudWithdrawAgreement();
    _configInit();
    isLoading = false;
    setState((){});
  }

  void dispose() {}

  void tabHandler(int index) {
    tabIndex = index;
    setState((){});
  }

  void withdrawIncomeHandler(int index) {
    withdrawIncomeIndex = index;
    setState((){});
  }

  void cloudAgreementHandler() {
    checkCloudAgreement = !checkCloudAgreement;
  }

  // 審核開關
  void _configInit() {
    showWithdrawType = ref.read(userInfoProvider).buttonConfigList?.withdrawType == 1 ? true : false;
    isRealNameAuth = ref.read(userInfoProvider).memberInfo?.realNameAuth == 1 ? true : false;
  }

  // 取得說明
  Future<void> _getExplanation() async {
    String helpText = await rootBundle.loadString('assets/txt/personal_benefit_help.txt');
    helpText = helpText.replaceFirst('{#X}', dailyWithdrawPerDay);
    helpText = helpText.replaceFirst('{#Y}', withdrawAmountPerDay);
    helpText = helpText.replaceFirst('{#Z}', tip);
    explanationList = helpText.split('\n');
  }

  // 2-8 用戶資訊
  Future<void> getMemberInfo() async {
    String resultCodeCheck = '';
    final WsMemberPointCoinReq reqBody = WsMemberPointCoinReq.create();
    final WsMemberPointCoinRes res = await ref.read(memberWsProvider).wsMemberPointCoin(reqBody,
        onConnectSuccess: (succMsg) => resultCodeCheck = succMsg,
        onConnectFail: (errMsg) => resultCodeCheck = errMsg
    );

    if (resultCodeCheck == ResponseCode.CODE_SUCCESS) {
      ref.read(userUtilProvider.notifier).loadMemberPointCoin(res);
      points = res.points ?? 0;
      pointsToRMB = num.parse(ConvertUtil.toRMB(points));
    } else {
      if (context.mounted) {
        BaseViewModel.showToast(context, ResponseCode.map[resultCodeCheck]!);
      }
    }

    setState(() {});
  }

  // 17-1 我的收益
  Future<void> _getPersonalBenefit() async {
    String resultCodeCheck = '';
    final WsBenefitInfoReq reqBody = WsBenefitInfoReq.create();
    final WsBenefitInfoRes res = await ref.read(benefitWsProvider).wsBenefitInfo(reqBody,
        onConnectSuccess: (succMsg) => resultCodeCheck = succMsg,
        onConnectFail: (errMsg) => resultCodeCheck = errMsg
    );

    if (resultCodeCheck == ResponseCode.CODE_SUCCESS) {
      todayIncome = res.todayIncome ?? 0;
      withdrawalAmount = res.withdrawalAmount ?? 0;
    } else {
      if (context.mounted) {
        BaseViewModel.showToast(context, ResponseCode.map[resultCodeCheck]!);
      }
    }
  }

  // 9-3 會員提現金額樣板
  Future<void> getWithdrawMemberIncome() async {
    String resultCodeCheck = '';
    final WsWithdrawMemberIncomeReq reqBody = WsWithdrawMemberIncomeReq.create();
    final WsWithdrawMemberIncomeRes res = await ref.read(withdrawWsProvider).wsWithdrawMemberIncome(reqBody,
        onConnectSuccess: (succMsg) => resultCodeCheck = succMsg,
        onConnectFail: (errMsg) => resultCodeCheck = errMsg
    );

    if (resultCodeCheck == ResponseCode.CODE_SUCCESS) {
      res.list?.sort((a, b) => double.parse(a.moneyRange!).compareTo(double.parse(b.moneyRange!)));
      withdrawIncomeList = res.list ?? [];
      firstWithdrawal = res.firstWithdrawal ?? '1';
      tip = res.tip ?? '';
      withdrawAmountPerDay = res.withdrawAmountPerDay ?? '';
      dailyWithdrawPerDay = res.dailyWithdrawPerDay ?? '';
    } else {
      if (context.mounted) {
        BaseViewModel.showToast(context, ResponseCode.map[resultCodeCheck]!);
      }
    }

    setState((){});
  }

  // 9-1 會員提現
  // 填入提現帳號類型及金額
  Future<void> memberWithdrawal(num type, num amount) async {
    String resultCodeCheck = '';
    Loading.show(context, '提现中...');
    // 這邊填要提多少錢
    final WsWithdrawMoneyReq reqBody = WsWithdrawMoneyReq.create(type: type, amount: amount);
    final WsWithdrawMoneyRes res = await ref.read(withdrawWsProvider).wsWithdrawMoney(reqBody,
        onConnectSuccess: (succMsg) => resultCodeCheck = succMsg,
        onConnectFail: (errMsg) => resultCodeCheck = errMsg
    );
    if (resultCodeCheck == ResponseCode.CODE_SUCCESS) {
      if (context.mounted)  {
        Loading.hide(context);
        _showDialog(context, '提现成功');
      }

    } else {
      if (context.mounted) {
        Loading.hide(context);
        _showDialog(context, '提现失败，请再试一次');
      }
    }
  }

  // 9-5 云帳戶協議書, (回傳網址)
  Future<void> _getCloudWithdrawAgreement() async {
    String resultCodeCheck = '';
    final WsWithdrawCloudAgreementReq reqBody = WsWithdrawCloudAgreementReq.create();
    final WsWithdrawCloudAgreementRes res = await ref.read(withdrawWsProvider).wsWithdrawCloudAgreement(reqBody,
        onConnectSuccess: (succMsg) => resultCodeCheck = succMsg,
        onConnectFail: (errMsg) => resultCodeCheck = errMsg
    );

    if (resultCodeCheck == ResponseCode.CODE_SUCCESS) {
      cloudWithdrawalAgreementUrl = res.url ?? '';
    } else {
      if (context.mounted) {
        BaseViewModel.showToast(context, ResponseCode.map[resultCodeCheck]!);
      }
    }
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
      if (res.list!.isNotEmpty && res.list!.first.status == 1) {
        defaultWithdrawAccount = res.list!.first;
      }
    }
  }

  // 9-4 積分換金幣
  Future<void> withdrawMemberPointToCoin(int point) async {
    String resultCodeCheck = '';
    Loading.show(context, '兑换中...');
    final WsWithdrawMemberPointToCoinReq reqBody = WsWithdrawMemberPointToCoinReq.create(points: point);
    final WsWithdrawMemberPointToCoinRes res = await ref.read(withdrawWsProvider).wsWithdrawMemberPointToCoin(reqBody,
      onConnectSuccess: (succMsg) => resultCodeCheck = succMsg,
      onConnectFail: (errMsg) => resultCodeCheck = errMsg,
    );
    exchangeTextEditController.text = '';
    if (resultCodeCheck == ResponseCode.CODE_SUCCESS) {
      if (context.mounted) {
        Loading.hide(context);
        showToast('兑换成功: 現有積分: ${res.points}\n現有金幣: ${res.coins}');
      }
    } else {
      if (context.mounted) {
        Loading.hide(context);
        showToast(ResponseCode.map[resultCodeCheck]!);
      }
    }

    setState(() {});
  }

  // ----------------------------------------------------------------------- //
  // ----------------------------------------------------------------------- //
  // ----------------------------------------------------------------------- //

  void withdrawalFunction({
    required Function(String, double) onWithdrawDialog,
    required Function() onWithdrawWarningDialog,
  }) async {
    // 這邊檢查條件．並且計算手續費並顯示提問
    if (firstWithdrawal == '1' && !checkCloudAgreement) {
      await onWithdrawWarningDialog();
      return;
    }

    WithdrawIncomeListInfo selectedWithdrawIncomeInfo = withdrawIncomeList[withdrawIncomeIndex];
    double tipRate = double.parse(tip);
    double withdrawAmount = double.parse(selectedWithdrawIncomeInfo.moneyRange!);
    tipRate *= 0.01;
    double withdrawFee = withdrawAmount * tipRate;
    double withdrawIncome = withdrawAmount - withdrawFee;
    String withdrawCheckHint = '您的提领金额为 ${withdrawAmount.toStringAsFixed(2)} 元\n手续费为 ${withdrawFee.toStringAsFixed(2)} 元\n\n实际到账金额为 ${withdrawIncome.toStringAsFixed(2)} 元';
    await onWithdrawDialog(withdrawCheckHint, withdrawAmount);
  }

  void _showDialog(BuildContext context, String msg) {
    final AppTheme theme = ref.watch(userInfoProvider).theme ?? AppTheme(themeType: AppThemeType.original);
    CommDialog(context).build(
      theme: theme,
      title: '提现结果',
      contentDes: msg,
      rightBtnTitle: '确认',
      rightAction: () {
        BaseViewModel.popPage(context);
        setState(() {});
      }
    );
  }

  void showToast(String text) {
    Fluttertoast.showToast(
      msg: text,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: const Color.fromRGBO(0, 0, 0, 0.5),
      textColor: Colors.white,
      fontSize: 12.0,
    );
  }
}
