
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frechat/models/ws_req/deposit/ws_deposit_alipay_reply_error_req.dart';
import 'package:frechat/models/ws_req/deposit/ws_deposit_apple_reply_receipt_req.dart';
import 'package:frechat/models/ws_req/deposit/ws_deposit_number_option_req.dart';
import 'package:frechat/models/ws_req/deposit/ws_deposit_wechat_pay_sign_req.dart';
import 'package:frechat/models/ws_res/deposit/ws_deposit_alipay_reply_error_res.dart';
import 'package:frechat/models/ws_res/deposit/ws_deposit_apple_reply_receipt_res.dart';
import 'package:frechat/models/ws_res/deposit/ws_deposit_number_option_res.dart';
import 'package:frechat/models/ws_res/deposit/ws_deposit_wechat_pay_sign_res.dart';
import 'package:frechat/system/ws_comm/ws_params_req.dart';

import '../../models/ws_req/deposit/ws_deposit_money_req.dart';
import '../../models/ws_req/ws_base_req.dart';
import '../../models/ws_res/deposit/ws_deposit_money_res.dart';
import '../providers.dart';
import '../websocket/websocket_handler.dart';

class DepositWs {
  DepositWs({required this.ref});
  final ProviderRef ref;

  /// 會員充值
  Future<WsDepositMoneyRes> wsDepositMoney(WsDepositMoneyReq wsDepositMoneyReq, {
    required Function(String) onConnectSuccess,
    required Function(String) onConnectFail,
  }) async {
    final userInfo = ref.read(userInfoProvider);
    final WsBaseReq msg = WsParamsReq.depositMoney
      ..tId = userInfo.commToken ?? "emptyToken"
      ..msg = wsDepositMoneyReq;

    /// 傳送ws send
    final res = await WebSocketHandler.sendData(msg,
        funcCode: WsParamsReq.depositMoney.f,
        onConnectSuccess: (msg) => onConnectSuccess(msg),
        onConnectFail: (errMsg) => onConnectFail(errMsg));
    return (res.resultMap == null) ? WsDepositMoneyRes() : WsDepositMoneyRes.fromJson(res.resultMap);
  }

  /// 顯示充值金額選項
  Future<WsDepositNumberOptionRes> wsDepositNumberOption(WsDepositNumberOptionReq wsDepositNumberOptionReq, {
    required Function(String) onConnectSuccess,
    required Function(String) onConnectFail,
  }) async {
    final userInfo = ref.read(userInfoProvider);
    final WsBaseReq msg = WsParamsReq.depositNumberOption
      ..tId = userInfo.commToken ?? "emptyToken"
      ..msg = wsDepositNumberOptionReq;

    /// 傳送ws send
    final res = await WebSocketHandler.sendData(msg,
        funcCode: WsParamsReq.depositNumberOption.f,
        onConnectSuccess: (msg) => onConnectSuccess(msg),
        onConnectFail: (errMsg) => onConnectFail(errMsg));
    return (res.resultMap == null) ? WsDepositNumberOptionRes() : WsDepositNumberOptionRes.fromJson(res.resultMap);
  }

  /// 支付寶APP回复異常
  Future<WsDepositAlipayReplyErrorRes> wsDepositAliPayReplyError(WsDepositAlipayReplyErrorReq wsDepositAliPayReplyErrorReq, {
    required Function(String) onConnectSuccess,
    required Function(String) onConnectFail,
  }) async {
    final userInfo = ref.read(userInfoProvider);
    final WsBaseReq msg = WsParamsReq.depositAliPayReplyError
      ..tId = userInfo.commToken ?? "emptyToken"
      ..msg = wsDepositAliPayReplyErrorReq;

    /// 傳送ws send
    final res = await WebSocketHandler.sendData(msg,
        funcCode: WsParamsReq.depositAliPayReplyError.f,
        onConnectSuccess: (msg) => onConnectSuccess(msg),
        onConnectFail: (errMsg) => onConnectFail(errMsg));
    return (res.resultMap == null) ? WsDepositAlipayReplyErrorRes() : WsDepositAlipayReplyErrorRes.fromJson(res.resultMap);
  }

  /// 頻果檢核
  Future<WsDepositAppleReplyReceiptRes> wsDepositAppleReplyReceipt(WsDepositAppleReplyReceiptReq wsDepositAppleReplyReceiptReq, {
    required Function(String) onConnectSuccess,
    required Function(String) onConnectFail,
  }) async {
    final userInfo = ref.read(userInfoProvider);
    final WsBaseReq msg = WsParamsReq.depositAppleReplyReceipt
      ..tId = userInfo.commToken ?? "emptyToken"
      ..msg = wsDepositAppleReplyReceiptReq;

    /// 傳送ws send
    final res = await WebSocketHandler.sendData(msg,
        funcCode: WsParamsReq.depositAppleReplyReceipt.f,
        onConnectSuccess: (msg) => onConnectSuccess(msg),
        onConnectFail: (errMsg) => onConnectFail(errMsg));
    return (res.resultMap == null) ? WsDepositAppleReplyReceiptRes() : WsDepositAppleReplyReceiptRes.fromJson(res.resultMap);
  }

  /// 微信支付簽名
  Future<WsDepositWeChatPaySignRes> wsDepositWeChatPaySign(WsDepositWeChatPaySignReq wsDepositWeChatPaySignReq, {
    required Function(String) onConnectSuccess,
    required Function(String) onConnectFail,
  }) async {
    final userInfo = ref.read(userInfoProvider);
    final WsBaseReq msg = WsParamsReq.depositWeChatPaySign
      ..tId = userInfo.commToken ?? "emptyToken"
      ..msg = wsDepositWeChatPaySignReq;

    /// 傳送ws send
    final res = await WebSocketHandler.sendData(msg,
        funcCode: WsParamsReq.depositWeChatPaySign.f,
        onConnectSuccess: (msg) => onConnectSuccess(msg),
        onConnectFail: (errMsg) => onConnectFail(errMsg));
    return (res.resultMap == null) ? WsDepositWeChatPaySignRes() : WsDepositWeChatPaySignRes.fromJson(res.resultMap);
  }
}