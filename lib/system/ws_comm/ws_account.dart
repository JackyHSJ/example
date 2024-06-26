
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frechat/models/ws_req/account/ws_account_call_package_req.dart';
import 'package:frechat/models/ws_req/account/ws_account_end_call_req.dart';
import 'package:frechat/models/ws_req/account/ws_account_get_gift_detail_req.dart';
import 'package:frechat/models/ws_req/account/ws_account_get_gift_type_req.dart';
import 'package:frechat/models/ws_req/account/ws_account_get_rtm_token_req.dart';
import 'package:frechat/models/ws_req/account/ws_account_on_tv_req.dart';
import 'package:frechat/models/ws_req/account/ws_account_quick_match_list_req.dart';
import 'package:frechat/models/ws_req/account/ws_account_shumei_violate_req.dart';
import 'package:frechat/models/ws_req/account/ws_account_update_package_gift_req.dart';
import 'package:frechat/models/ws_res/account/ws_account_call_package_res.dart';
import 'package:frechat/models/ws_res/account/ws_account_get_gift_detail_res.dart';
import 'package:frechat/models/ws_res/account/ws_account_get_gift_type_res.dart';
import 'package:frechat/models/ws_res/account/ws_account_on_tv_res.dart';
import 'package:frechat/models/ws_res/account/ws_account_quick_match_list_res.dart';
import 'package:frechat/models/ws_res/account/ws_account_shumei_violate_res.dart';
import 'package:frechat/models/ws_res/account/ws_account_update_package_gift_res.dart';
import 'package:frechat/system/ws_comm/ws_params_req.dart';
import 'package:frechat/models/ws_res/account/ws_account_end_call_res.dart';
import 'package:frechat/models/ws_res/account/ws_account_get_rtm_token_res.dart';
import 'package:frechat/models/ws_res/account/ws_account_speak_res.dart';
import 'package:frechat/system/providers.dart';
import 'package:frechat/system/websocket/websocket_handler.dart';

import '../../models/ws_req/account/ws_account_call_charge_req.dart';
import '../../models/ws_req/account/ws_account_call_verification_req.dart';
import '../../models/ws_req/account/ws_account_follow_and_fans_list_req.dart';
import '../../models/ws_req/account/ws_account_follow_req.dart';
import '../../models/ws_req/account/ws_account_get_rtc_token_req.dart';
import '../../models/ws_req/account/ws_account_remark_req.dart';
import '../../models/ws_req/account/ws_account_speak_req.dart';
import '../../models/ws_req/ws_base_req.dart';
import '../../models/ws_res/account/ws_account_call_charge_res.dart';
import '../../models/ws_res/account/ws_account_call_verification_res.dart';
import '../../models/ws_res/account/ws_account_follow_and_fans_list_res.dart';
import '../../models/ws_res/account/ws_account_follow_res.dart';
import '../../models/ws_res/account/ws_account_get_rtc_token_res.dart';
import '../../models/ws_res/account/ws_account_remark_res.dart';
import 'package:uuid/uuid.dart';

class AccountWs {
  AccountWs({required this.ref});
  final ProviderRef ref;

  /// 3-1 發話
  Future<WsAccountSpeakRes> wsAccountSpeak(WsAccountSpeakReq wsAccountSpeakReq, {
    required Function(String) onConnectSuccess,
    required Function(String) onConnectFail,
  }) async {
    final userInfo = ref.read(userInfoProvider);
    final String uuid = const Uuid().v4();
    final WsBaseReq msg = WsParamsReq.accountSpeak
      ..rId = uuid
      ..tId = userInfo.commToken ?? "emptyToken"
      ..msg = wsAccountSpeakReq;

      /// 傳送ws send
      final res = await WebSocketHandler.sendData(msg,
        funcCode: WsParamsReq.accountSpeak.f,
        onConnectSuccess: (msg) => onConnectSuccess(msg),
        onConnectFail: (errMsg) => onConnectFail(errMsg));

      return WsAccountSpeakRes.fromJson(res.resultMap);
  }

  /// 上電視
  Future<WsAccountOnTVRes> wsAccountOnTV(WsAccountOnTVReq wsAccountOnTVReq, {
    required Function(String) onConnectSuccess,
    required Function(String) onConnectFail,
  }) async {
    final userInfo = ref.read(userInfoProvider);
    final WsBaseReq msg = WsParamsReq.accountOnTV
      ..tId = userInfo.commToken ?? "emptyToken"
      ..msg = wsAccountOnTVReq;

    /// 傳送ws send
    final res = await WebSocketHandler.sendData(msg,
        funcCode: WsParamsReq.accountOnTV.f,
        onConnectSuccess: (msg) => onConnectSuccess(msg),
        onConnectFail: (errMsg) => onConnectFail(errMsg));

    return WsAccountOnTVRes.fromJson(res.resultMap);
  }

  /// 數美違規事項
  Future<WsAccountShumeiViolateRes> wsAccountShumeiViolate(WsAccountShumeiViolateReq wsAccountShumeiViolateReq, {
    required Function(String) onConnectSuccess,
    required Function(String) onConnectFail,
  }) async {
    final userInfo = ref.read(userInfoProvider);
    final WsBaseReq msg = WsParamsReq.accountShumeiViolate
      ..tId = userInfo.commToken ?? "emptyToken"
      ..msg = wsAccountShumeiViolateReq;

    /// 傳送ws send
    final res = await WebSocketHandler.sendData(msg,
        funcCode: WsParamsReq.accountShumeiViolate.f,
        onConnectSuccess: (msg) => onConnectSuccess(msg),
        onConnectFail: (errMsg) => onConnectFail(errMsg));

    return WsAccountShumeiViolateRes.fromJson(res.resultMap);
  }

  /// 速配名單
  Future<WsAccountQuickMatchListRes> wsAccountQuickMatchList(WsAccountQuickMatchListReq wsAccountQuickMatchListReq, {
    required Function(String) onConnectSuccess,
    required Function(String) onConnectFail,
  }) async {
    final userInfo = ref.read(userInfoProvider);
    final WsBaseReq msg = WsParamsReq.accountQuickMatchList
      ..tId = userInfo.commToken ?? "emptyToken"
      ..msg = wsAccountQuickMatchListReq;

    /// 傳送ws send
    final res = await WebSocketHandler.sendData(msg,
        funcCode: WsParamsReq.accountQuickMatchList.f,
        onConnectSuccess: (msg) => onConnectSuccess(msg),
        onConnectFail: (errMsg) => onConnectFail(errMsg));

    return WsAccountQuickMatchListRes.fromJson(res.resultMap);
  }

  /// 通話消費
  Future<WsAccountCallChargeRes> wsAccountCallCharge(WsAccountCallChargeReq wsAccountCallChargeReq, {
    required Function(String) onConnectSuccess,
    required Function(String) onConnectFail,
  }) async {
    final userInfo = ref.read(userInfoProvider);
    final WsBaseReq msg = WsParamsReq.accountCallCharge
      ..tId = userInfo.commToken ?? "emptyToken"
      ..msg = wsAccountCallChargeReq;

    /// 傳送ws send
    final res = await WebSocketHandler.sendData(msg,
      funcCode: WsParamsReq.accountCallCharge.f,
      onConnectSuccess: (msg) => onConnectSuccess(msg),
      onConnectFail: (errMsg) => onConnectFail(errMsg));

    return (res.resultMap == null) ? WsAccountCallChargeRes() : WsAccountCallChargeRes.fromJson(res.resultMap);
  }

  /// 通話查驗
  Future<WsAccountCallVerificationRes> wsAccountCallVerification(WsAccountCallVerificationReq wsAccountCallVerificationReq, {
    required Function(String) onConnectSuccess,
    required Function(String) onConnectFail,
  }) async {
    final userInfo = ref.read(userInfoProvider);
    final WsBaseReq msg = WsParamsReq.accountCallVerification
      ..tId = userInfo.commToken ?? "emptyToken"
      ..msg = wsAccountCallVerificationReq;

    /// 傳送ws send
    final res = await WebSocketHandler.sendData(msg,
        funcCode: WsParamsReq.accountCallVerification.f,
        onConnectSuccess: (msg) => onConnectSuccess(msg),
        onConnectFail: (errMsg) => onConnectFail(errMsg));
    return (res.resultMap == null) ? WsAccountCallVerificationRes() : WsAccountCallVerificationRes.fromJson(res.resultMap);
  }

  /// 通話結束
  Future<WsAccountEndCallRes> wsAccountEndCall(WsAccountEndCallReq wsAccountEndCallReq, {
    required Function(String) onConnectSuccess,
    required Function(String) onConnectFail,
  }) async {
    final userInfo = ref.read(userInfoProvider);
    final WsBaseReq msg = WsParamsReq.accountEndCall
      ..tId = userInfo.commToken ?? "emptyToken"
      ..msg = wsAccountEndCallReq;

    /// 傳送ws send
    final res = await WebSocketHandler.sendData(msg,
        funcCode: WsParamsReq.accountEndCall.f,
        onConnectSuccess: (msg) => onConnectSuccess(msg),
        onConnectFail: (errMsg) => onConnectFail(errMsg));
    return (res.resultMap == null) ? WsAccountEndCallRes() : WsAccountEndCallRes.fromJson(res.resultMap);
  }

  /// getRTMToken
  Future<WsAccountGetRTMTokenRes> wsAccountGetRTMToken(WsAccountGetRTMTokenReq wsAccountGetRTMTokenReq, {
    required Function(String) onConnectSuccess,
    required Function(String) onConnectFail,
  }) async {
    final userInfo = ref.read(userInfoProvider);
    final WsBaseReq msg = WsParamsReq.accountGetRTMToken
      ..tId = userInfo.commToken ?? "emptyToken"
      ..msg = wsAccountGetRTMTokenReq;

    /// 傳送ws send
    final res = await WebSocketHandler.sendData(msg,
        funcCode: WsParamsReq.accountGetRTMToken.f,
        onConnectSuccess: (msg) => onConnectSuccess(msg),
        onConnectFail: (errMsg) => onConnectFail(errMsg));
    return (res.resultMap == null) ? WsAccountGetRTMTokenRes() : WsAccountGetRTMTokenRes.fromJson(res.resultMap);
  }

  /// getRTCToken
  Future<WsAccountGetRTCTokenRes> wsAccountGetRTCToken(WsAccountGetRTCTokenReq wsAccountGetRTCTokenReq, {
    required Function(String) onConnectSuccess,
    required Function(String) onConnectFail,
  }) async {
    final userInfo = ref.read(userInfoProvider);
    final WsBaseReq msg = WsParamsReq.accountGetRTCToken
      ..tId = userInfo.commToken ?? "emptyToken"
      ..msg = wsAccountGetRTCTokenReq;

    /// 傳送ws send
    final res = await WebSocketHandler.sendData(msg,
        funcCode: WsParamsReq.accountGetRTCToken.f,
        onConnectSuccess: (msg) => onConnectSuccess(msg),
        onConnectFail: (errMsg) => onConnectFail(errMsg));
    return WsAccountGetRTCTokenRes.fromJson(res.resultMap);
  }

  /// 修改备注名
  Future<WsAccountRemarkRes> wsAccountRemark(WsAccountRemarkReq wsAccountRemarkReq, {
    required Function(String) onConnectSuccess,
    required Function(String) onConnectFail,
  }) async {
    final userInfo = ref.read(userInfoProvider);
    final WsBaseReq msg = WsParamsReq.accountRemark
      ..tId = userInfo.commToken ?? "emptyToken"
      ..msg = wsAccountRemarkReq;

    /// 傳送ws send
    final res = await WebSocketHandler.sendData(msg,
        funcCode: WsParamsReq.accountRemark.f,
        onConnectSuccess: (msg) => onConnectSuccess(msg),
        onConnectFail: (errMsg) => onConnectFail(errMsg));
    return (res.resultMap == null) ? WsAccountRemarkRes() : WsAccountRemarkRes.fromJson(res.resultMap);
  }

  /// 关注
  Future<WsAccountFollowRes> wsAccountFollow(WsAccountFollowReq wsAccountFollowReq, {
    required Function(String) onConnectSuccess,
    required Function(String) onConnectFail,
  }) async {
    final userInfo = ref.read(userInfoProvider);
    final WsBaseReq msg = WsParamsReq.accountFollow
      ..tId = userInfo.commToken ?? "emptyToken"
      ..msg = wsAccountFollowReq;

    /// 傳送ws send
    final res = await WebSocketHandler.sendData(msg,
        funcCode: WsParamsReq.accountFollow.f,
        onConnectSuccess: (msg) => onConnectSuccess(msg),
        onConnectFail: (errMsg) => onConnectFail(errMsg));
    return WsAccountFollowRes.fromJson(res.resultMap);
  }

  /// 用户交互-关注列表or粉丝列表
  Future<WsAccountFollowAndFansListRes> wsAccountFollowAndFansList(WsAccountFollowAndFansListReq wsAccountFollowAndFansListReq, {
    required Function(String) onConnectSuccess,
    required Function(String) onConnectFail,
  }) async {
    final userInfo = ref.read(userInfoProvider);
    final String uuid = const Uuid().v4();
    final WsBaseReq msg = WsParamsReq.accountFollowAndFansList
      ..rId = uuid
      ..tId = userInfo.commToken ?? "emptyToken"
      ..msg = wsAccountFollowAndFansListReq;

    /// 傳送ws send
    final res = await WebSocketHandler.sendData(msg,
        funcCode: WsParamsReq.accountFollowAndFansList.f,
        onConnectSuccess: (msg) => onConnectSuccess(msg),
        onConnectFail: (errMsg) => onConnectFail(errMsg));
    return (res.resultMap == null) ? WsAccountFollowAndFansListRes() : WsAccountFollowAndFansListRes.fromJson(res.resultMap);
  }

  /// 取出禮物類別
  Future<WsAccountGetGiftTypeRes> wsAccountGetGiftType(WsAccountGetGiftTypeReq wsAccountGetGiftTypeReq, {
    required Function(String) onConnectSuccess,
    required Function(String) onConnectFail,
  }) async {
    final userInfo = ref.read(userInfoProvider);
    final WsBaseReq msg = WsParamsReq.accountGetGiftType
      ..tId = userInfo.commToken ?? "emptyToken"
      ..msg = wsAccountGetGiftTypeReq;

    /// 傳送ws send
    final res = await WebSocketHandler.sendData(msg,
        funcCode: WsParamsReq.accountGetGiftType.f,
        onConnectSuccess: (msg) => onConnectSuccess(msg),
        onConnectFail: (errMsg) => onConnectFail(errMsg));
    return (res.resultMap == null) ? WsAccountGetGiftTypeRes() : WsAccountGetGiftTypeRes.fromJson(res.resultMap);
  }

  /// 取得禮物明細
  Future<WsAccountGetGiftDetailRes> wsAccountGetGiftDetail(WsAccountGetGiftDetailReq wsAccountGetGiftDetailReq, {
    required Function(String) onConnectSuccess,
    required Function(String) onConnectFail,
  }) async {
    final userInfo = ref.read(userInfoProvider);
    final WsBaseReq msg = WsParamsReq.accountGetGiftDetail
      ..tId = userInfo.commToken ?? "emptyToken"
      ..msg = wsAccountGetGiftDetailReq;

    /// 傳送ws send
    final res = await WebSocketHandler.sendData(msg,
        funcCode: WsParamsReq.accountGetGiftDetail.f,
        onConnectSuccess: (msg) => onConnectSuccess(msg),
        onConnectFail: (errMsg) => onConnectFail(errMsg));
    return (res.resultMap == null) ? WsAccountGetGiftDetailRes() : WsAccountGetGiftDetailRes.fromJson(res.resultMap);
  }

  /// 修改背包禮物
  Future<WsAccountUpdatePackageGiftRes> wsAccountUpdatePackageGift(WsAccountUpdatePackageGiftReq wsAccountUpdatePackageGiftReq, {
    required Function(String) onConnectSuccess,
    required Function(String) onConnectFail,
  }) async {
    final userInfo = ref.read(userInfoProvider);
    final WsBaseReq msg = WsParamsReq.accountUpdatePackageGift
      ..tId = userInfo.commToken ?? "emptyToken"
      ..msg = wsAccountUpdatePackageGiftReq;

    /// 傳送ws send
    final res = await WebSocketHandler.sendData(msg,
        funcCode: WsParamsReq.accountUpdatePackageGift.f,
        onConnectSuccess: (msg) => onConnectSuccess(msg),
        onConnectFail: (errMsg) => onConnectFail(errMsg));
    return (res.resultMap == null) ? WsAccountUpdatePackageGiftRes() : WsAccountUpdatePackageGiftRes.fromJson(res.resultMap);
  }

  /// 呼叫背包
  Future<WsAccountCallPackageRes> wsAccountCallPackage(WsAccountCallPackageReq wsAccountCallPackageReq, {
    required Function(String) onConnectSuccess,
    required Function(String) onConnectFail,
  }) async {
    final userInfo = ref.read(userInfoProvider);
    final WsBaseReq msg = WsParamsReq.accountCallPackage
      ..tId = userInfo.commToken ?? "emptyToken"
      ..msg = wsAccountCallPackageReq;

    /// 傳送ws send
    final res = await WebSocketHandler.sendData(msg,
        funcCode: WsParamsReq.accountCallPackage.f,
        onConnectSuccess: (msg) => onConnectSuccess(msg),
        onConnectFail: (errMsg) => onConnectFail(errMsg));
    return (res.resultMap == null) ? WsAccountCallPackageRes() : WsAccountCallPackageRes.fromJson(res.resultMap);
  }
}