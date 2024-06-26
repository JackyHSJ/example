
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frechat/models/ws_req/withdraw/ws_withdraw_cloud_agreement_req.dart';
import 'package:frechat/models/ws_req/withdraw/ws_withdraw_member_income_req.dart';
import 'package:frechat/models/ws_req/withdraw/ws_withdraw_member_point_to_coin_req.dart';
import 'package:frechat/models/ws_req/withdraw/ws_withdraw_recharge_reward_req.dart';
import 'package:frechat/models/ws_req/withdraw/ws_withdraw_save_aipay_req.dart';
import 'package:frechat/models/ws_req/withdraw/ws_withdraw_search_payment_req.dart';
import 'package:frechat/models/ws_res/withdraw/ws_withdraw_cloud_agreement_res.dart';
import 'package:frechat/models/ws_res/withdraw/ws_withdraw_member_point_to_coin_res.dart';
import 'package:frechat/models/ws_res/withdraw/ws_withdraw_recharge_reward_res.dart';
import 'package:frechat/models/ws_res/withdraw/ws_withdraw_save_aipay_res.dart';
import 'package:frechat/models/ws_res/withdraw/ws_withdraw_search_payment_res.dart';
import 'package:frechat/system/ws_comm/ws_params_req.dart';

import '../../models/ws_req/deposit/ws_deposit_money_req.dart';
import '../../models/ws_req/withdraw/ws_withdraw_money_req.dart';
import '../../models/ws_req/withdraw/ws_withdraw_search_record_req.dart';
import '../../models/ws_req/ws_base_req.dart';
import '../../models/ws_res/deposit/ws_deposit_money_res.dart';
import '../../models/ws_res/withdraw/ws_withdraw_member_income_res.dart';
import '../../models/ws_res/withdraw/ws_withdraw_money_res.dart';
import '../../models/ws_res/withdraw/ws_withdraw_search_record_res.dart';
import '../providers.dart';
import '../websocket/websocket_handler.dart';

class WithdrawWs {
  WithdrawWs({required this.ref});
  final ProviderRef ref;

  /// 會員提現
  /// 結果代碼:
  /// 000:成功;001:參數格式錯誤;002:系統維護;004:查無帳號;035:餘額不足
  Future<WsWithdrawMoneyRes> wsWithdrawMoney(WsWithdrawMoneyReq wsWithdrawMoneyReq, {
    required Function(String) onConnectSuccess,
    required Function(String) onConnectFail,
  }) async {
    final userInfo = ref.read(userInfoProvider);
    final WsBaseReq msg = WsParamsReq.withdrawMoney
      ..tId = userInfo.commToken ?? "emptyToken"
      ..msg = wsWithdrawMoneyReq;

    /// 傳送ws send
    final res = await WebSocketHandler.sendData(msg,
        funcCode: WsParamsReq.withdrawMoney.f,
        onConnectSuccess: (msg) => onConnectSuccess(msg),
        onConnectFail: (errMsg) => onConnectFail(errMsg));
    return (res.resultMap == null) ? WsWithdrawMoneyRes() : WsWithdrawMoneyRes.fromJson(res.resultMap);
  }

  /// 提現紀錄
  Future<WsWithdrawSearchRecordRes> wsWithdrawSearchRecord(WsWithdrawSearchRecordReq wsWithdrawSearchRecordReq, {
    required Function(String) onConnectSuccess,
    required Function(String) onConnectFail,
  }) async {
    final userInfo = ref.read(userInfoProvider);
    final WsBaseReq msg = WsParamsReq.withdrawSearchRecord
      ..tId = userInfo.commToken ?? "emptyToken"
      ..msg = wsWithdrawSearchRecordReq;

    /// 傳送ws send
    final res = await WebSocketHandler.sendData(msg,
        funcCode: WsParamsReq.withdrawSearchRecord.f,
        onConnectSuccess: (msg) => onConnectSuccess(msg),
        onConnectFail: (errMsg) => onConnectFail(errMsg));
    return WsWithdrawSearchRecordRes.fromJson(res.resultMap);
  }

  /// 會員收益提現
  Future<WsWithdrawMemberIncomeRes> wsWithdrawMemberIncome(WsWithdrawMemberIncomeReq wsWithdrawMemberIncomeReq, {
    required Function(String) onConnectSuccess,
    required Function(String) onConnectFail,
  }) async {
    final userInfo = ref.read(userInfoProvider);
    final WsBaseReq msg = WsParamsReq.withdrawMemberIncome
      ..tId = userInfo.commToken ?? "emptyToken"
      ..msg = wsWithdrawMemberIncomeReq;

    /// 傳送ws send
    final res = await WebSocketHandler.sendData(msg,
        funcCode: WsParamsReq.withdrawMemberIncome.f,
        onConnectSuccess: (msg) => onConnectSuccess(msg),
        onConnectFail: (errMsg) => onConnectFail(errMsg));
    return WsWithdrawMemberIncomeRes.fromJson(res.resultMap);
  }

  /// 會員積分轉金币
  Future<WsWithdrawMemberPointToCoinRes> wsWithdrawMemberPointToCoin(WsWithdrawMemberPointToCoinReq wsWithdrawMemberPointToCoinReq, {
    required Function(String) onConnectSuccess,
    required Function(String) onConnectFail,
  }) async {
    final userInfo = ref.read(userInfoProvider);
    final WsBaseReq msg = WsParamsReq.withdrawMemberPointToCoin
      ..tId = userInfo.commToken ?? "emptyToken"
      ..msg = wsWithdrawMemberPointToCoinReq;

    /// 傳送ws send
    final res = await WebSocketHandler.sendData(msg,
        funcCode: WsParamsReq.withdrawMemberPointToCoin.f,
        onConnectSuccess: (msg) => onConnectSuccess(msg),
        onConnectFail: (errMsg) => onConnectFail(errMsg));
    return (res.resultMap == null) ? WsWithdrawMemberPointToCoinRes() : WsWithdrawMemberPointToCoinRes.fromJson(res.resultMap);
  }

  /// 云帳戶協議書
  Future<WsWithdrawCloudAgreementRes> wsWithdrawCloudAgreement(WsWithdrawCloudAgreementReq wsWithdrawCloudAgreementReq, {
    required Function(String) onConnectSuccess,
    required Function(String) onConnectFail,
  }) async {
    final userInfo = ref.read(userInfoProvider);
    final WsBaseReq msg = WsParamsReq.withdrawCloudAgreement
      ..tId = userInfo.commToken ?? "emptyToken"
      ..msg = wsWithdrawCloudAgreementReq;

    /// 傳送ws send
    final res = await WebSocketHandler.sendData(msg,
        funcCode: WsParamsReq.withdrawCloudAgreement.f,
        onConnectSuccess: (msg) => onConnectSuccess(msg),
        onConnectFail: (errMsg) => onConnectFail(errMsg));
    return WsWithdrawCloudAgreementRes.fromJson(res.resultMap);
  }

  /// 查詢支付帳號
  Future<WsWithdrawSearchPaymentRes> wsWithdrawSearchPayment(WsWithdrawSearchPaymentReq wsWithdrawSearchPaymentReq, {
    required Function(String) onConnectSuccess,
    required Function(String) onConnectFail,
  }) async {
    final userInfo = ref.read(userInfoProvider);
    final WsBaseReq msg = WsParamsReq.withdrawSearchPayment
      ..tId = userInfo.commToken ?? "emptyToken"
      ..msg = wsWithdrawSearchPaymentReq;

    /// 傳送ws send
    final res = await WebSocketHandler.sendData(msg,
        funcCode: WsParamsReq.withdrawSearchPayment.f,
        onConnectSuccess: (msg) => onConnectSuccess(msg),
        onConnectFail: (errMsg) => onConnectFail(errMsg));
    return (res.resultMap == null) ? WsWithdrawSearchPaymentRes() : WsWithdrawSearchPaymentRes.fromJson(res.resultMap);
  }

  /// 儲存或是修改支付寶帳號
  Future<WsWithdrawSaveAiPayRes> wsWithdrawSaveAlipay(WsWithdrawSaveAiPayReq withdrawSaveAlipayReq, {
    required Function(String) onConnectSuccess,
    required Function(String) onConnectFail,
  }) async {
    final userInfo = ref.read(userInfoProvider);
    final WsBaseReq msg = WsParamsReq.withdrawSaveAlipay
      ..tId = userInfo.commToken ?? "emptyToken"
      ..msg = withdrawSaveAlipayReq.toBody();

    /// 傳送ws send
    final res = await WebSocketHandler.sendData(msg,
        funcCode: WsParamsReq.withdrawSaveAlipay.f,
        onConnectSuccess: (msg) => onConnectSuccess(msg),
        onConnectFail: (errMsg) => onConnectFail(errMsg));
    return res.resultMap != null ?  WsWithdrawSaveAiPayRes.fromJson(res.resultMap) : WsWithdrawSaveAiPayRes();
  }

  /// 查詢首充獎勵
  Future<WsWithdrawRechargeRewardRes> wsWithdrawRechargeReward(WsWithdrawRechargeRewardReq wsWithdrawRechargeRewardReq, {
    required Function(String) onConnectSuccess,
    required Function(String) onConnectFail,
  }) async {
    final userInfo = ref.read(userInfoProvider);
    final WsBaseReq msg = WsParamsReq.withdrawRechargeReward
      ..tId = userInfo.commToken ?? "emptyToken"
      ..msg = wsWithdrawRechargeRewardReq;

    /// 傳送ws send
    final res = await WebSocketHandler.sendData(msg,
        funcCode: WsParamsReq.withdrawRechargeReward.f,
        onConnectSuccess: (msg) => onConnectSuccess(msg),
        onConnectFail: (errMsg) => onConnectFail(errMsg));
    return  WsWithdrawRechargeRewardRes.fromJson(res.resultMap);
  }
}