
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frechat/models/ws_req/contact/ws_contact_invite_friend_req.dart';
import 'package:frechat/models/ws_req/contact/ws_contact_search_form_req.dart';
import 'package:frechat/models/ws_req/contact/ws_contact_search_friend_benefit_req.dart';
import 'package:frechat/models/ws_res/contact/ws_contact_invite_friend_res.dart';
import 'package:frechat/models/ws_res/contact/ws_contact_search_form_res.dart';
import 'package:frechat/models/ws_res/contact/ws_contact_search_friend_benefit_res.dart';
import 'package:frechat/system/ws_comm/ws_params_req.dart';

import '../../models/ws_req/contact/ws_contact_search_list_req.dart';
import '../../models/ws_req/ws_base_req.dart';
import '../../models/ws_res/contact/ws_contact_search_list_res.dart';
import '../providers.dart';
import '../websocket/websocket_handler.dart';

class ContactWs {
  ContactWs({required this.ref});
  final ProviderRef ref;

  /// 查詢類型
  Future<WsContactSearchListRes> wsContactSearchList(WsContactSearchListReq wsContactSearchListReq, {
    required Function(String) onConnectSuccess,
    required Function(String) onConnectFail,
  }) async {
    final userInfo = ref.read(userInfoProvider);
    final WsBaseReq msg = WsParamsReq.contactSearchList
      ..tId = userInfo.commToken ?? "emptyToken"
      ..msg = wsContactSearchListReq;

    /// 傳送ws send
    final res = await WebSocketHandler.sendData(msg,
        funcCode: WsParamsReq.contactSearchList.f,
        onConnectSuccess: (msg) => onConnectSuccess(msg),
        onConnectFail: (errMsg) => onConnectFail(errMsg));

    return (res.resultMap == null) ? WsContactSearchListRes() : WsContactSearchListRes.fromJson(res.resultMap);
  }

  /// 查詢人脈貢獻報表
  Future<WsContactSearchFormRes> wsContactSearchForm(WsContactSearchFormReq wsContactSearchFormReq, {
    required Function(String) onConnectSuccess,
    required Function(String) onConnectFail,
  }) async {
    final userInfo = ref.read(userInfoProvider);
    final WsBaseReq msg = WsParamsReq.contactSearchForm
      ..tId = userInfo.commToken ?? "emptyToken"
      ..msg = wsContactSearchFormReq;

    /// 傳送ws send
    final res = await WebSocketHandler.sendData(msg,
        funcCode: WsParamsReq.contactSearchForm.f,
        onConnectSuccess: (msg) => onConnectSuccess(msg),
        onConnectFail: (errMsg) => onConnectFail(errMsg));

    return (res.resultMap == null) ? WsContactSearchFormRes() : WsContactSearchFormRes.fromJson(res.resultMap);
  }

  /// 查詢好友明細-收益
  Future<WsContactSearchFriendBenefitRes> wsContactSearchFriendBenefit(WsContactSearchFriendBenefitReq wsContactSearchFriendBenefitReq, {
    required Function(String) onConnectSuccess,
    required Function(String) onConnectFail,
  }) async {
    final userInfo = ref.read(userInfoProvider);
    final WsBaseReq msg = WsParamsReq.contactSearchFriendBenefit
      ..tId = userInfo.commToken ?? "emptyToken"
      ..msg = wsContactSearchFriendBenefitReq;

    /// 傳送ws send
    final res = await WebSocketHandler.sendData(msg,
        funcCode: WsParamsReq.contactSearchFriendBenefit.f,
        onConnectSuccess: (msg) => onConnectSuccess(msg),
        onConnectFail: (errMsg) => onConnectFail(errMsg));

    return (res.resultMap == null) ? WsContactSearchFriendBenefitRes() : WsContactSearchFriendBenefitRes.fromJson(res.resultMap);
  }

  /// 查詢人脈貢獻報表
  Future<WsContactInviteFriendRes> wsContactInviteFriend(WsContactInviteFriendReq wsContactInviteFriendReq, {
    required Function(String) onConnectSuccess,
    required Function(String) onConnectFail,
  }) async {
    final userInfo = ref.read(userInfoProvider);
    final WsBaseReq msg = WsParamsReq.contactInviteFriend
      ..tId = userInfo.commToken ?? "emptyToken"
      ..msg = wsContactInviteFriendReq;

    /// 傳送ws send
    final res = await WebSocketHandler.sendData(msg,
        funcCode: WsParamsReq.contactInviteFriend.f,
        onConnectSuccess: (msg) => onConnectSuccess(msg),
        onConnectFail: (errMsg) => onConnectFail(errMsg));

    return (res.resultMap == null) ? WsContactInviteFriendRes() : WsContactInviteFriendRes.fromJson(res.resultMap);
  }
}