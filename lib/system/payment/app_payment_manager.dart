
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frechat/models/ws_req/deposit/ws_deposit_apple_reply_receipt_req.dart';
import 'package:frechat/models/ws_req/deposit/ws_deposit_money_req.dart';
import 'package:frechat/models/ws_req/deposit/ws_deposit_number_option_req.dart';
import 'package:frechat/models/ws_req/deposit/ws_deposit_wechat_pay_sign_req.dart';
import 'package:frechat/models/ws_req/member/ws_member_info_req.dart';
import 'package:frechat/models/ws_req/member/ws_member_point_coin_req.dart';
import 'package:frechat/models/ws_res/deposit/ws_deposit_money_res.dart';
import 'package:frechat/models/ws_res/deposit/ws_deposit_number_option_res.dart';
import 'package:frechat/models/ws_res/deposit/ws_deposit_wechat_pay_sign_res.dart';
import 'package:frechat/models/ws_res/member/ws_member_info_res.dart';
import 'package:frechat/models/ws_res/member/ws_member_point_coin_res.dart';
import 'package:frechat/system/base_view_model.dart';
import 'package:frechat/system/constant/enum.dart';
import 'package:frechat/system/payment/alipay/alipay_manager.dart';
import 'package:frechat/system/payment/apple_payment/apple_payment_manager.dart';
import 'package:frechat/system/payment/wechat/wechat_manager.dart';
import 'package:frechat/system/provider/user_info_provider.dart';
import 'package:frechat/system/repository/response_code.dart';
import 'package:frechat/widgets/shared/dialog/comm_dialog.dart';
import 'package:frechat/widgets/shared/loading_animation.dart';
import 'package:frechat/widgets/theme/app_theme.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:uuid/uuid.dart';
import '../providers.dart';

class AppPaymentManager {
  AppPaymentManager({required this.ref});

  ProviderRef ref;
  String? _transactionId;
  num? _rechargeType;
  DepositOptionListInfo? _phraseOption;
  AppPaymentStatus? appPaymentStatus;

  /// 先發送API 8-1做創建訂單, 並拿取微信渠道資料
  Future<void> memberRecharge(BuildContext context, {
    required num rechargeType,
    DepositOptionListInfo? selectPhraseOption
  }) async {
    final AppTheme theme = ref.read(userInfoProvider).theme ?? AppTheme(themeType: AppThemeType.original);
    LoadingAnimation.showOverlayDotsLoading(context, appTheme: theme);
    String resultCodeCheck = '';

    /// 檢查是否有選擇商品
    if(selectPhraseOption == null) {
      BaseViewModel.showToast(context, '亲～您尚未选择商品呦');
      LoadingAnimation.cancelOverlayLoading();
      return ;
    }

    final num activeCoinsAmount = selectPhraseOption.amount ?? 0;
    final WsDepositMoneyReq reqBody = WsDepositMoneyReq.create(type: rechargeType, amount: activeCoinsAmount);
    final WsDepositMoneyRes res = await ref.read(depositWsProvider).wsDepositMoney(reqBody,
        onConnectSuccess: (succMsg) => resultCodeCheck = succMsg,
        onConnectFail: (errMsg) => BaseViewModel.showToast(context, ResponseCode.map[errMsg]!)
    );

    if (resultCodeCheck == ResponseCode.CODE_SUCCESS) {
      await _initPayListener(
          phraseOption: selectPhraseOption,
          rechargeType: rechargeType,
          wechatAppId: res.weChatAppId,
          transactionId: res.transactionId ?? ''
      );

      /// 狀態為微信支付檢查, 未安裝微信App則跳出錯誤
      if(rechargeType == 0) {
        final bool isInstalled = await WeChatManager.isInstalled();
        if(isInstalled == false) {
          BaseViewModel.showToast(context, '亲～您尚未安装微信呦');
          _disposePayListener();
          return ;
        }
      }

      /// 狀態為支付寶做檢查, 未安裝支付寶App則跳出錯誤
      if(rechargeType == 1) {
        final bool isInstalled = await AlipayManager.isInstalled();
        if(isInstalled == false) {
          BaseViewModel.showToast(context, '亲～您尚未安装支付宝呦');
          _disposePayListener();
          return ;
        }
      }

      _pay(depositMoneyRes: res, rechargeType: rechargeType);

    /// error
    } else {
      _disposePayListener();
    }
  }

  Future<void> _initPayListener({
    required num rechargeType,
    required String transactionId,
    String? wechatAppId,
    DepositOptionListInfo? phraseOption
  }) async {
    _transactionId = transactionId;
    _rechargeType = rechargeType;
    _phraseOption = phraseOption;
    appPaymentStatus = AppPaymentStatus.init;

    if (Platform.isIOS) {
      await _initApplePayment();
    } else {
      await _initAndroidPayment(phraseOption: phraseOption, wechatAppId: wechatAppId);
    }
  }

  Future<void> _initAndroidPayment({
    String? wechatAppId,
    DepositOptionListInfo? phraseOption
  }) async {
    final BuildContext currentContext = BaseViewModel.getGlobalContext();

    /// 微信支付
    if(_rechargeType == 0 && wechatAppId != null) {
      await WeChatManager.init(
          wechatAppId: wechatAppId,
          onPayment: () => _sendAnalyticsPayment(type: 0, paymentId: _transactionId ?? '', phraseOption: phraseOption),
          onSuccess: () {
            _showPaymentDialog(currentContext, '充值成功', true);
            _disposePayListener();
          },
          onFail: (msg) {
            _showPaymentDialog(currentContext, '充值失败请再一次', false);
            _disposePayListener();
          }
      );
      return ;
    }

    /// 支付寶支付
    if(_rechargeType == 1) {
      await AlipayManager.init(
          onPayment: () => _sendAnalyticsPayment(type: 1, paymentId: _transactionId ?? '', phraseOption: phraseOption),
          onSuccess: () {
            _showPaymentDialog(currentContext, '充值成功', true);
            _disposePayListener();
          },
          onFail: (msg) {
            _showPaymentDialog(currentContext, '充值失败请再一次', false);
            _disposePayListener();
          }
      );
      return ;
    }

    BaseViewModel.showToast(currentContext, '亲～您的支付发生错误啰');
  }

  _disposePayListener() {
    // 支付 dispose
    ApplePaymentManager.dispose();
    AlipayManager.dispose();
    WeChatManager.dispose();
    LoadingAnimation.cancelOverlayLoading();
    appPaymentStatus = AppPaymentStatus.dispose;

  }

  Future<void> _pay({
    required num rechargeType,
    required WsDepositMoneyRes depositMoneyRes,
  }) async {
    appPaymentStatus = AppPaymentStatus.paying;
    switch(rechargeType) {
    /// 微信支付
      case 0:
        final int timestamp = DateTime.now().millisecondsSinceEpoch;
        final String uuid = const Uuid().v4();
        final WsDepositWeChatPaySignRes? signRes = await _getWeChatPaySign(
          prepayId: depositMoneyRes.weChatPayOrderInfo ?? '',
          timestamp: timestamp,
          nonceStr: uuid
        );
        if(signRes == null) {
          _disposePayListener();
          return ;
        }
        final String sign = signRes.sign ?? '';
        WeChatManager.pay(
          timeStamp: '$timestamp',
          sign: sign,
          nonceStr: uuid,
          depositMoneyRes: depositMoneyRes
        );
        break;
    /// 支付寶
      case 1:
        AlipayManager.pay(depositMoneyRes.alipayOrderInfo ?? '');
        break;
    /// apple iap
      case 2:
        _buyAppleProduct();
        break;
      default:
        break;
    }
  }

  // init ApplePayment & callback
  Future<void> _initApplePayment() async {
    final BuildContext currentContext = BaseViewModel.getGlobalContext();
    final WsDepositNumberOptionRes? depositNumberOption = ref.read(userInfoProvider).depositNumberOption;
    final List<String> ids = depositNumberOption?.list?.map((info) => info.appleId ?? '').toList() ?? [];
    await ApplePaymentManager.init(
      ids: ids,
      onLoadingProduct: (){},
      onProductError: (){},
      onProductDone: (appleProductList) {
        // iapProductList = appleProductList;
      },
      onPurchasing: (){
        final AppTheme theme = ref.read(userInfoProvider).theme ?? AppTheme(themeType: AppThemeType.original);
        LoadingAnimation.showOverlayDotsLoading(currentContext, appTheme: theme);
      },
      onPurchaseDone: (){
        _sendAppleIapReceipt(currentContext, receiptId: ApplePaymentManager.consumables.last);
        _sendAnalyticsPayment(type: 2, paymentId: _transactionId ?? '', phraseOption: _phraseOption);
        _showPaymentDialog(currentContext, '充值成功', true);
        _disposePayListener();
      },
      onPurchaseError: (error){
        _showPaymentDialog(currentContext, '充值失败请再一次', false);
        _disposePayListener();
      },
    );
  }

  void _sendAppleIapReceipt(BuildContext context, { required String receiptId }) async {
    final WsDepositAppleReplyReceiptReq reqBody = WsDepositAppleReplyReceiptReq.create(
        transactionId: _transactionId,
        receiptId: receiptId
    );
    ref.read(depositWsProvider).wsDepositAppleReplyReceipt(reqBody,
        onConnectSuccess: (succMsg) => BaseViewModel.showToast(context, '亲～充值成功啰'),
        onConnectFail: (errMsg) => BaseViewModel.showToast(context, ResponseCode.map[errMsg]!));
  }

  void _sendAnalyticsPayment({
    required String paymentId,
    required num type ,
    required DepositOptionListInfo? phraseOption
  }) {
    final num activeAmount = phraseOption?.amount ?? 0;
    // final num activeCurrency = phraseOption?.coins ?? 0;
    final String paymentMethod = _getTypeName(type.toDouble());

    ref.read(analyticsProvider).setPayment(
      paymentId,  // paymentId
      paymentMethod,  // paymentMethod
      'CNY',  // currencyType
      '$activeAmount',  // amount
      {},  // properties
    );
  }

  String _getTypeName(double type) {
    switch(type) {
      case 0:
        return 'WeChat Pay';
      case 1:
        return 'Ali Pay';
      case 2:
        return 'Apple Pay';
      default:
        return 'other Error';
    }
  }

  void _showPaymentDialog(BuildContext context, String msg, bool result){
    final AppTheme theme = ref.read(userInfoProvider).theme ?? AppTheme(themeType: AppThemeType.original);
    CommDialog(context).build(
        theme: theme,
        title: '充值结果',
        contentDes: msg,
        rightBtnTitle: '确认',
        rightAction: () async {
          await _getMemberInfoPointCoin();
          await _loadDepositNumberOption();


          if (result) {
            BaseViewModel.popupDialog();
          } else {
            BaseViewModel.popPage(context);
          }

        }
    );
  }

  // 刷新充值列表選項
  Future<void> _loadDepositNumberOption() async {
    String resultCodeCheck = '';
    final BuildContext currentContext = BaseViewModel.getGlobalContext();
    final WsDepositNumberOptionReq reqBody = WsDepositNumberOptionReq.create();
    final WsDepositNumberOptionRes res = await ref.read(depositWsProvider).wsDepositNumberOption(reqBody,
        onConnectSuccess: (succMsg) => resultCodeCheck = succMsg,
        onConnectFail: (errMsg) => BaseViewModel.showToast(currentContext, ResponseCode.map[errMsg]!)
    );
    if (resultCodeCheck == ResponseCode.CODE_SUCCESS) {
      ref.read(userUtilProvider.notifier).loadDepositNumberOption(res);
    }
  }

  // 取得會員資訊 (刷新金幣、充值次數)
  Future<void> _getMemberInfoPointCoin() async {
    String resultCodeCheck = '';
    final BuildContext currentContext = BaseViewModel.getGlobalContext();
    final WsMemberPointCoinReq reqBody = WsMemberPointCoinReq.create();
    final WsMemberPointCoinRes res = await ref.read(memberWsProvider).wsMemberPointCoin(reqBody,
        onConnectSuccess: (succMsg) => resultCodeCheck = succMsg,
        onConnectFail: (errMsg) => resultCodeCheck = errMsg
    );

    if (resultCodeCheck == ResponseCode.CODE_SUCCESS) {
      ref.read(userUtilProvider.notifier).loadMemberPointCoin(res);
    } else {
      if (currentContext.mounted) {
        BaseViewModel.showToast(currentContext, ResponseCode.map[resultCodeCheck]!);
      }
    }
  }

  Future<WsDepositWeChatPaySignRes?> _getWeChatPaySign({
    required String prepayId,
    required int timestamp,
    required String nonceStr,
  }) async {
    String? resultCodeCheck;
    final WsDepositWeChatPaySignReq reqBody = WsDepositWeChatPaySignReq.create(
        prepayId: prepayId,
        timestamp: '$timestamp',
        nonceStr: nonceStr,
        transactionId: _transactionId ?? ''
    );
    final BuildContext currentContext = BaseViewModel.getGlobalContext();
    final WsDepositWeChatPaySignRes res = await ref.read(depositWsProvider).wsDepositWeChatPaySign(reqBody,
        onConnectSuccess: (succMsg) => resultCodeCheck = succMsg,
        onConnectFail: (errMsg) => BaseViewModel.showToast(currentContext, ResponseCode.map[errMsg]!)
    );
    if(resultCodeCheck == ResponseCode.CODE_SUCCESS) {
      return res;
    }
    return null;
  }

  // ios 充值
  Future<void> _buyAppleProduct() async {
    final BuildContext currentContext = BaseViewModel.getGlobalContext();

    if(_phraseOption == null) {
      BaseViewModel.showToast(currentContext, '亲～您尚未选择商品呦');
      return;
    }
    ProductDetails? selectIAP;
    final String appleId = _phraseOption?.appleId ?? '';

    try {
      selectIAP = ApplePaymentManager.iapProductList.firstWhere((product) => product.id == appleId);
    } catch(e) {
      BaseViewModel.showToast(currentContext, '亲～您的商品目前无效呦');
      return ;
    }
    ApplePaymentManager.buyProduct(selectIAP);
  }
}