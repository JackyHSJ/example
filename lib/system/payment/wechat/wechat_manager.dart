

import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:frechat/models/deep_link_model.dart';
import 'package:frechat/models/user_info_model.dart';
import 'package:frechat/models/ws_res/deposit/ws_deposit_money_res.dart';
import 'package:frechat/system/app_config/app_config.dart';
import 'package:frechat/system/base_view_model.dart';
import 'package:frechat/system/constant/enum.dart';
import 'package:frechat/system/payment/wechat/wechat_setting.dart';
import 'package:frechat/system/provider/user_info_provider.dart';
import 'package:frechat/system/repository/http_setting.dart';
import 'package:frechat/system/util/share_util.dart';
import 'package:wechat_kit/wechat_kit_platform_interface.dart';
import 'package:wechat_kit_extension/wechat_kit_extension.dart';

import '../../providers.dart';

class WeChatManager {
  static StreamSubscription<WechatResp>? _respSubs;
  static WechatAuthResp? _authResp;
  static final WechatKitPlatform _wechatPay = WechatKitPlatform.instance;

  /// callback
  static Function? onPayment;
  static Function? onSuccess;
  static Function(String msg)? onFail;

  static Future<void> init({
    required String wechatAppId,
    required Function onPayment,
    required Function onSuccess,
    required Function(String msg) onFail,
  }) async {
    if(_respSubs != null) {
      return;
    }
    _respSubs = _wechatPay.respStream().listen(_listenResp);
    await _registerApp(wechatAppId);
    WeChatManager.onPayment = onPayment;
    WeChatManager.onSuccess = onSuccess;
    WeChatManager.onFail= onFail;
  }

  static Future<void> dispose() async {
    if(_respSubs == null) {
      return;
    }
    _respSubs?.cancel();
    _respSubs = null;
  }

  static void _listenResp(WechatResp resp) {
    if (resp is WechatAuthResp) {
      _authResp = resp;
      final String content = 'auth: ${resp.errorCode} ${resp.errorMsg}';
      _showTips('登录', content);
    } else if (resp is WechatShareMsgResp) {
      final String content = 'share: ${resp.errorCode} ${resp.errorMsg}';
      _showTips('分享', content);
    } else if (resp is WechatPayResp) {
      final String content = 'pay: ${resp.errorCode} ${resp.errorMsg}';
      if(resp.isSuccessful) {
        onPayment?.call();
        onSuccess?.call();
      }else{
        onFail?.call(content);
      }
    } else if (resp is WechatLaunchMiniProgramResp) {
      final String content = 'mini program: ${resp.errorCode} ${resp.errorMsg}';
      _showTips('拉起小程序', content);
    }
  }

  static Future<void> _registerApp(String wechatAppId) async {
    await _wechatPay.registerApp(
      appId: wechatAppId,
      universalLink: WeChatSetting.universalLink,
    );
  }

  static Future<bool> isInstalled () async {
    final bool isInstalled = await _wechatPay.isInstalled();
    final bool isSupportApi = await _wechatPay.isSupportApi();
    return isInstalled && isSupportApi;
  }

  @Deprecated('未使用到')
  static Future<void> getAccessTokenUnionID() async {
    final String code = _authResp?.code ?? '';
    final WechatAccessTokenResp accessTokenResp = await WechatExtension.getAccessTokenUnionID(
      appId: 'WeChatSetting.appId',
      appSecret: WeChatSetting.appSecret,
      code: code,
    );

    if (accessTokenResp.isSuccessful) {
      final String openId = accessTokenResp.openid ?? '';
      final String accessToken = accessTokenResp.accessToken ?? '';
      final WechatUserInfoResp userInfoResp = await WechatExtension.getUserInfoUnionID(
        openId: openId, accessToken: accessToken,
      );
      if (userInfoResp.isSuccessful) {
        _showTips('用户信息', '${userInfoResp.nickname} - ${userInfoResp.sex}');
      }
    }
  }

  /// partnerid: 微信商戶號平台取得
  ///
  /// prepayid: 這個ID是在您的伺服器後端呼叫微信的統一下單一介面（unified order API）後獲得的。
  /// 呼叫該介面需要您的伺服器後端發送支付訂單的相關資訊給微信支付伺服器，微信支付伺服器回應後會傳回一個 prepayid。
  ///
  /// sign: 這是一個透過簽章演算法計算得出的字串。
  /// 您需要依照微信支付的簽章演算法，在伺服器端將支付請求的參數（包括 appid、partnerid、prepayid、noncestr、timestamp 等）進行簽署。
  /// 微信支付的簽名演算法詳見微信支付官方文件中的簽名產生演算法。
  /// !!!!! 確保您使用的簽章方式（MD5 或 SHA256）與您在統一下單一介面中所使用的一致。 !!!!!
  static Future<void> pay({
    required String timeStamp,
    required String sign,
    required String nonceStr,
    required WsDepositMoneyRes depositMoneyRes,
  }) async {
    _wechatPay.pay(
      appId: depositMoneyRes.weChatAppId ?? '',
      partnerId: depositMoneyRes.weChatPartnerId ?? '',
      prepayId: depositMoneyRes.weChatPayOrderInfo ?? '',
      package: WeChatSetting.package,
      nonceStr: nonceStr,
      timeStamp: timeStamp,
      sign: sign,
    );
  }

  static Future<void> auth() async {
    await init(wechatAppId: WeChatSetting.appId, onPayment: (){}, onSuccess: (){}, onFail: (_){});
    _wechatPay.auth(
      scope: <String>[WechatScope.kSNSApiUserInfo],
      state: 'auth',
      type: WechatAuthType.kNormal
    );
    await dispose();
  }

  /// 還有分享 圖片、檔案、表情符號、網頁 etc...
  static Future<void> shareText({
    scene = WechatScene.kSession
  }) async {
    /// 聊天界面 kSession
    /// 朋友圈 kTimeline
    /// 收藏 kFavorite
    await init(wechatAppId: WeChatSetting.appId, onPayment: (){}, onSuccess: (){}, onFail: (_){});
    await _wechatPay.shareText(
      scene: scene,
      text: 'Share Text',
    );
    await dispose();
  }

  static Future<void> shareWebPage({
    int scene = WechatScene.kSession,
    required UserNotifier userUtil,
    required Uint8List appIcon,
    required InviteFriendType type,
  }) async {
    /// 朋友圈 kTimeline
    /// 收藏 kFavorite
    final String appName = AppConfig.appName;
    final String invitedUrl = userUtil.shareInvitedFriendUrl(type);
    await init(wechatAppId: WeChatSetting.appId, onPayment: (){}, onSuccess: (){}, onFail: (_){});
    await _wechatPay.shareWebpage(
      scene: scene,
      webpageUrl: invitedUrl,
      title: appName,
      description: '${AppConfig.getAppName()}交友，遇见甜甜的有缘人',
      thumbData: appIcon
    );
    await dispose();
  }

  /// 直接從App中拉起應用程序執行微信支付
  static void launchMiniProgram ({
    required String userName,
    required String path
}) {
    _wechatPay.launchMiniProgram(
      userName: userName,
      path: path,
      type: WechatMiniProgram.kPreview,
    );
  }

  static void _showTips(String title, String content) {
    final BuildContext currentContext = BaseViewModel.getGlobalContext();
    showDialog<void>(
      context: currentContext,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
        );
      },
    );
  }
}