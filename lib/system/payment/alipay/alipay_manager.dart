
import 'dart:async';
import 'dart:convert';

import 'package:alipay_kit/alipay_kit.dart';
import 'package:flutter/material.dart';
import 'package:frechat/system/app_config/app_config.dart';
import 'package:frechat/system/base_view_model.dart';
import 'package:frechat/system/payment/alipay/alipay_response_code.dart';
import 'package:frechat/widgets/shared/dialog/comm_dialog.dart';


class AlipayManager  {

  // static const bool _ALIPAY_USE_RSA2 = true;
  // static const String _ALIPAY_APPID = '2021004121650267'; // 支付/登录
  // static const String _ALIPAY_PID = 'your alipay pid'; // 登录
  // static const String _ALIPAY_TARGETID = 'your alipay targetId'; // 登录
  // static const String _ALIPAY_PRIVATEKEY = 'your alipay rsa private key(pkcs1/pkcs8)'; // 支付/登录

  static StreamSubscription<AlipayResp>? _paySubs;
  static StreamSubscription<AlipayResp>? _authSubs;
  static final _alipay = AlipayKitPlatform.instance;

  /// callback
  static Function? onPayment;
  static Function? onSuccess;
  static Function(String msg)? onFail;


  static Future<void> init({
    required Function onPayment,
    required Function onSuccess,
    required Function(String msg) onFail,
  }) async {

    if (_paySubs != null) return;
    if (_authSubs != null) return;

    _paySubs ??= _alipay.payResp().listen(_listenPay);
    _authSubs ??= _alipay.authResp().listen(_listenAuth);
    AlipayManager.onPayment = onPayment;
    AlipayManager.onSuccess = onSuccess;
    AlipayManager.onFail= onFail;
  }

  static void dispose() {
    if (_paySubs != null) {
      _paySubs?.cancel();
      _paySubs = null;
    }
    if(_authSubs != null) {
      _authSubs?.cancel();
      _authSubs = null;
    }
  }

  static Future<void> setEnv() async {
    final AlipayEnv env = AppConfig.alipayEnv;
    _alipay.setEnv(env: env);
  }


  static Future<bool> isInstalled() async {
    return _alipay.isInstalled();
  }

  /// 9000——订单支付成功
  /// 8000——正在处理中
  /// 4000——订单支付失败
  /// 5000——重复请求
  /// 6001——用户中途取消
  /// 6002——网络连接出错
  static void _listenPay(AlipayResp resp) {
    if(resp.resultStatus == AliPayResponseCode.CODE_PAY_SUCCESS) {
      print('支付成功');
      onPayment?.call();
      onSuccess?.call();
    }else{
      final String content = 'listen Pay: ${resp.resultStatus} - ${resp.result}';
      onFail?.call(content);
    }
  }

  static void _listenAuth(AlipayResp resp) {
    final String content = 'listen Auth: ${resp.resultStatus} - ${resp.result}';
    _showTips('授权登录', content);
  }

  static void pay(String orderInfo) {
    _alipay.pay(orderInfo: orderInfo);
  }

  static void auth(String authInfo) {
    _alipay.auth(authInfo: authInfo);
  }

  static void _showTips(String title, String content) {
    final currentContext = BaseViewModel.getGlobalContext();

    showDialog<void>(
      context: currentContext,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
        );
      },
    );
  }
}