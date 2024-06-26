
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frechat/models/ws_req/member/ws_member_delete_album_photo_req.dart';
import 'package:frechat/models/ws_req/member/ws_member_disable_teen_req.dart';
import 'package:frechat/models/ws_req/member/ws_member_enable_teen_req.dart';
import 'package:frechat/models/ws_req/member/ws_member_move_album_photo_req.dart';
import 'package:frechat/models/ws_req/member/ws_member_new_user_to_top_list_req.dart';
import 'package:frechat/models/ws_req/member/ws_member_point_coin_req.dart';
import 'package:frechat/models/ws_req/member/ws_member_real_name_auth_req.dart';
import 'package:frechat/models/ws_req/member/ws_member_real_person_veri_req.dart';
import 'package:frechat/models/ws_req/member/ws_member_teen_forget_password_req.dart';
import 'package:frechat/models/ws_req/member/ws_member_teen_status_req.dart';
import 'package:frechat/models/ws_res/member/ws_member_delete_album_photo_res.dart';
import 'package:frechat/models/ws_res/member/ws_member_disable_teen_res.dart';
import 'package:frechat/models/ws_res/member/ws_member_enable_teen_res.dart';
import 'package:frechat/models/ws_res/member/ws_member_move_album_photo_res.dart';
import 'package:frechat/models/ws_res/member/ws_member_new_user_to_top_list_res.dart';
import 'package:frechat/models/ws_res/member/ws_member_point_coin_res.dart';
import 'package:frechat/models/ws_res/member/ws_member_real_name_auth_res.dart';
import 'package:frechat/models/ws_res/member/ws_member_real_person_veri_res.dart';
import 'package:frechat/models/ws_res/member/ws_member_teen_forget_password_res.dart';
import 'package:frechat/models/ws_res/member/ws_member_teen_status_res.dart';
import 'package:frechat/system/ws_comm/ws_params_req.dart';

import '../../models/ws_req/member/ws_member_apply_cancel_req.dart';
import '../../models/ws_req/member/ws_member_fate_online_req.dart';
import '../../models/ws_req/member/ws_member_fate_recommend_req.dart';
import '../../models/ws_req/member/ws_member_info_req.dart';
import '../../models/ws_req/ws_base_req.dart';
import '../../models/ws_res/member/ws_member_apply_cancel_res.dart';
import '../../models/ws_res/member/ws_member_fate_online_res.dart';
import '../../models/ws_res/member/ws_member_fate_recommend_res.dart';
import '../../models/ws_res/member/ws_member_info_res.dart';
import '../providers.dart';
import '../websocket/websocket_handler.dart';
import 'package:uuid/uuid.dart';

class MemberWs {
  MemberWs({required this.ref});
  final ProviderRef ref;

  /// 用戶信息
  Future<WsMemberInfoRes> wsMemberInfo(WsMemberInfoReq wsMemberInfoReq, {
    required Function(String) onConnectSuccess,
    required Function(String) onConnectFail,
  }) async {
    final userInfo = ref.read(userInfoProvider);
    final String uuid = const Uuid().v4();
    if (wsMemberInfoReq.id == null && wsMemberInfoReq.userName == null) {
      wsMemberInfoReq = WsMemberInfoReq.create(id: userInfo.userId);
    }
    final WsBaseReq msg = WsParamsReq.memberInfo
      ..rId = uuid
      ..tId = userInfo.commToken ?? "emptyToken"
      ..msg = wsMemberInfoReq.toBody();

    /// 傳送ws send
    final res = await WebSocketHandler.sendData(msg,
        funcCode: WsParamsReq.memberInfo.f,
        onConnectSuccess: (msg) => onConnectSuccess(msg),
        onConnectFail: (errMsg) => onConnectFail(errMsg));

    return res.resultMap == null ? WsMemberInfoRes() : WsMemberInfoRes.fromJson(res.resultMap);
  }

  /// 用戶申請注銷
  Future<WsMemberApplyCancelRes> wsMemberApplyCancel(WsMemberApplyCancelReq wsMemberApplyCancelReq, {
    required Function(String) onConnectSuccess,
    required Function(String) onConnectFail,
  }) async {
    final userInfo = ref.read(userInfoProvider);
    final WsBaseReq msg = WsParamsReq.memberApplyCancel
      ..tId = userInfo.commToken ?? "emptyToken"
      ..msg = wsMemberApplyCancelReq;

    /// 傳送ws send
    final res = await WebSocketHandler.sendData(msg,
        funcCode: WsParamsReq.memberApplyCancel.f,
        onConnectSuccess: (msg) => onConnectSuccess(msg),
        onConnectFail: (errMsg) => onConnectFail(errMsg));

    return (res.resultMap == null) ? WsMemberApplyCancelRes() : WsMemberApplyCancelRes.fromJson(res.resultMap);
  }

  /// 缘分-推荐
  Future<WsMemberFateRecommendRes> wsMemberFateRecommend(WsMemberFateRecommendReq wsMemberFateRecommendReq, {
    required Function(String) onConnectSuccess,
    required Function(String) onConnectFail,
  }) async {
    final userInfo = ref.read(userInfoProvider);
    final WsBaseReq msg = WsParamsReq.memberFateRecommend
      ..tId = userInfo.commToken ?? "emptyToken"
      ..msg = wsMemberFateRecommendReq;

    /// 傳送ws send
    final res = await WebSocketHandler.sendData(msg,
        funcCode: WsParamsReq.memberFateRecommend.f,
        onConnectSuccess: (msg) => onConnectSuccess(msg),
        onConnectFail: (errMsg) => onConnectFail(errMsg));

    return (res.resultMap == null) ? WsMemberFateRecommendRes() : WsMemberFateRecommendRes.fromJson(res.resultMap);
  }

  /// 缘分-在線
  Future<WsMemberFateOnlineRes> wsMemberFateOnline(WsMemberFateOnlineReq wsMemberFateOnlineReq, {
    required Function(String) onConnectSuccess,
    required Function(String) onConnectFail,
  }) async {
    final userInfo = ref.read(userInfoProvider);
    final WsBaseReq msg = WsParamsReq.memberFateOnline
      ..tId = userInfo.commToken ?? "emptyToken"
      ..msg = wsMemberFateOnlineReq;

    /// 傳送ws send
    final res = await WebSocketHandler.sendData(msg,
        funcCode: WsParamsReq.memberFateOnline.f,
        onConnectSuccess: (msg) => onConnectSuccess(msg),
        onConnectFail: (errMsg) => onConnectFail(errMsg));

    return (res.resultMap == null) ? WsMemberFateOnlineRes() : WsMemberFateOnlineRes.fromJson(res.resultMap);
  }

  /// 真人认证檢驗
  Future<WsMemberRealPersonVeriRes> wsMemberRealPersonVeri(WsMemberRealPersonVeriReq wsMemberRealPersonVeriReq, {
    required Function(String) onConnectSuccess,
    required Function(String) onConnectFail,
  }) async {
    final userInfo = ref.read(userInfoProvider);
    final WsBaseReq msg = WsParamsReq.memberRealPersonVeri
      ..tId = userInfo.commToken ?? "emptyToken"
      ..msg = wsMemberRealPersonVeriReq;

    /// 傳送ws send
    final res = await WebSocketHandler.sendData(msg,
        funcCode: WsParamsReq.memberRealPersonVeri.f,
        onConnectSuccess: (msg) => onConnectSuccess(msg),
        onConnectFail: (errMsg) => onConnectFail(errMsg));

    return (res.resultMap == null) ? WsMemberRealPersonVeriRes() : WsMemberRealPersonVeriRes.fromJson(res.resultMap);
  }

  /// 删除相簿照片
  Future<WsMemberDeleteAlbumPhotoRes> wsMemberDeleteAlbumPhoto(WsMemberDeleteAlbumPhotoReq wsMemberDeleteAlbumPhotoReq, {
    required Function(String) onConnectSuccess,
    required Function(String) onConnectFail,
  }) async {
    final userInfo = ref.read(userInfoProvider);
    final WsBaseReq msg = WsParamsReq.memberDeleteAlbumPhoto
      ..tId = userInfo.commToken ?? "emptyToken"
      ..msg = wsMemberDeleteAlbumPhotoReq;

    /// 傳送ws send
    final res = await WebSocketHandler.sendData(msg,
        funcCode: WsParamsReq.memberDeleteAlbumPhoto.f,
        onConnectSuccess: (msg) => onConnectSuccess(msg),
        onConnectFail: (errMsg) => onConnectFail(errMsg));

    return (res.resultMap == null) ? WsMemberDeleteAlbumPhotoRes() : WsMemberDeleteAlbumPhotoRes.fromJson(res.resultMap);
  }

  /// 移動相簿照片
  Future<WsMemberMoveAlbumPhotoRes> wsMemberMoveAlbumPhoto(WsMemberMoveAlbumPhotoReq wsMemberMoveAlbumPhotoReq, {
    required Function(String) onConnectSuccess,
    required Function(String) onConnectFail,
  }) async {
    final userInfo = ref.read(userInfoProvider);
    final WsBaseReq msg = WsParamsReq.memberMoveAlbumPhoto
      ..tId = userInfo.commToken ?? "emptyToken"
      ..msg = wsMemberMoveAlbumPhotoReq;

    /// 傳送ws send
    final res = await WebSocketHandler.sendData(msg,
        funcCode: WsParamsReq.memberMoveAlbumPhoto.f,
        onConnectSuccess: (msg) => onConnectSuccess(msg),
        onConnectFail: (errMsg) => onConnectFail(errMsg));

    return (res.resultMap == null) ? WsMemberMoveAlbumPhotoRes() : WsMemberMoveAlbumPhotoRes.fromJson(res.resultMap);
  }

  /// 給出用戶的 積分, 金币（金币+活動金币
  Future<WsMemberPointCoinRes> wsMemberPointCoin(WsMemberPointCoinReq wsMemberPointCoinReq, {
    required Function(String) onConnectSuccess,
    required Function(String) onConnectFail,
  }) async {
    final userInfo = ref.read(userInfoProvider);
    final WsBaseReq msg = WsParamsReq.memberPointCoinInfo
      ..tId = userInfo.commToken ?? "emptyToken"
      ..msg = wsMemberPointCoinReq;

    /// 傳送ws send
    final res = await WebSocketHandler.sendData(msg,
        funcCode: WsParamsReq.memberPointCoinInfo.f,
        onConnectSuccess: (msg) => onConnectSuccess(msg),
        onConnectFail: (errMsg) => onConnectFail(errMsg));

    return (res.resultMap == null) ? WsMemberPointCoinRes() : WsMemberPointCoinRes.fromJson(res.resultMap);
  }

  /// 青少年模式狀態
  Future<WsMemberTeenStatusRes> wsMemberTeenStatus(WsMemberTeenStatusReq wsMemberTeenStatusReq, {
    required Function(String) onConnectSuccess,
    required Function(String) onConnectFail,
  }) async {
    final userInfo = ref.read(userInfoProvider);
    final WsBaseReq msg = WsParamsReq.memberTeenStatus
      ..tId = userInfo.commToken ?? "emptyToken"
      ..msg = wsMemberTeenStatusReq;

    /// 傳送ws send
    final res = await WebSocketHandler.sendData(msg,
        funcCode: WsParamsReq.memberTeenStatus.f,
        onConnectSuccess: (msg) => onConnectSuccess(msg),
        onConnectFail: (errMsg) => onConnectFail(errMsg));

    return (res.resultMap == null) ? WsMemberTeenStatusRes() : WsMemberTeenStatusRes.fromJson(res.resultMap);
  }

  /// 開啟青少年模式
  Future<WsMemberEnableTeenRes> wsMemberEnableTeen(WsMemberEnableTeenReq wsMemberEnableTeenReq, {
    required Function(String) onConnectSuccess,
    required Function(String) onConnectFail,
  }) async {
    final userInfo = ref.read(userInfoProvider);
    final WsBaseReq msg = WsParamsReq.memberEnableTeen
      ..tId = userInfo.commToken ?? "emptyToken"
      ..msg = wsMemberEnableTeenReq;

    /// 傳送ws send
    final res = await WebSocketHandler.sendData(msg,
        funcCode: WsParamsReq.memberEnableTeen.f,
        onConnectSuccess: (msg) => onConnectSuccess(msg),
        onConnectFail: (errMsg) => onConnectFail(errMsg));

    return (res.resultMap == null) ? WsMemberEnableTeenRes() : WsMemberEnableTeenRes.fromJson(res.resultMap);
  }

  /// 關閉青少年模式
  Future<WsMemberDisableTeenRes> wsMemberDisableTeen(WsMemberDisableTeenReq wsMemberDisableTeenReq, {
    required Function(String) onConnectSuccess,
    required Function(String) onConnectFail,
  }) async {
    final userInfo = ref.read(userInfoProvider);
    final WsBaseReq msg = WsParamsReq.memberDisableTeen
      ..tId = userInfo.commToken ?? "emptyToken"
      ..msg = wsMemberDisableTeenReq;

    /// 傳送ws send
    final res = await WebSocketHandler.sendData(msg,
        funcCode: WsParamsReq.memberDisableTeen.f,
        onConnectSuccess: (msg) => onConnectSuccess(msg),
        onConnectFail: (errMsg) => onConnectFail(errMsg));

    return (res.resultMap == null) ? WsMemberDisableTeenRes() : WsMemberDisableTeenRes.fromJson(res.resultMap);
  }

  /// 青少年模式-忘記密碼
  Future<WsMemberTeenForgetPasswordRes> wsMemberTeenForgetPassword(WsMemberTeenForgetPasswordReq wsMemberTeenForgetPasswordReq, {
    required Function(String) onConnectSuccess,
    required Function(String) onConnectFail,
  }) async {
    final userInfo = ref.read(userInfoProvider);
    final WsBaseReq msg = WsParamsReq.memberTeenForgetPassword
      ..tId = userInfo.commToken ?? "emptyToken"
      ..msg = wsMemberTeenForgetPasswordReq;

    /// 傳送ws send
    final res = await WebSocketHandler.sendData(msg,
        funcCode: WsParamsReq.memberTeenForgetPassword.f,
        onConnectSuccess: (msg) => onConnectSuccess(msg),
        onConnectFail: (errMsg) => onConnectFail(errMsg));

    return (res.resultMap == null) ? WsMemberTeenForgetPasswordRes() : WsMemberTeenForgetPasswordRes.fromJson(res.resultMap);
  }

  /// 实名认证
  Future<WsMemberRealNameAuthRes> wsMemberRealNameAuth(WsMemberRealNameAuthReq wsMemberRealNameAuthReq, {
    required Function(String) onConnectSuccess,
    required Function(String) onConnectFail,
  }) async {
    final userInfo = ref.read(userInfoProvider);
    final WsBaseReq msg = WsParamsReq.memberRealNameAuth
      ..tId = userInfo.commToken ?? "emptyToken"
      ..msg = wsMemberRealNameAuthReq;

    /// 傳送ws send
    final res = await WebSocketHandler.sendData(msg,
        funcCode: WsParamsReq.memberRealNameAuth.f,
        onConnectSuccess: (resultCode) => onConnectSuccess(resultCode),
        onConnectFail: (resultCode) => onConnectFail(resultCode));

    return (res.resultMap == null) ? WsMemberRealNameAuthRes() : WsMemberRealNameAuthRes.fromJson(res.resultMap);
  }

  /// 新用戶至頂新增
  Future<WsMemberNewUserToTopListRes> wsMemberNewUserToTopList(WsMemberNewUserToTopListReq wsMemberNewUserToTopListReq, {
    required Function(String) onConnectSuccess,
    required Function(String) onConnectFail,
  }) async {
    final userInfo = ref.read(userInfoProvider);
    final WsBaseReq msg = WsParamsReq.memberNewUserToTopList
      ..tId = userInfo.commToken ?? "emptyToken"
      ..msg = wsMemberNewUserToTopListReq;

    /// 傳送ws send
    final res = await WebSocketHandler.sendData(msg,
        funcCode: WsParamsReq.memberNewUserToTopList.f,
        onConnectSuccess: (resultCode) => onConnectSuccess(resultCode),
        onConnectFail: (resultCode) => onConnectFail(resultCode));

    return (res.resultMap == null) ? WsMemberNewUserToTopListRes() : WsMemberNewUserToTopListRes.fromJson(res.resultMap);
  }
}