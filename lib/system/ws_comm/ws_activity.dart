
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frechat/system/app_config/app_config.dart';
import 'package:frechat/models/ws_req/activity/ws_activity_add_reply_req.dart';
import 'package:frechat/models/ws_req/activity/ws_activity_delete_reply_req.dart';
import 'package:frechat/models/ws_req/activity/ws_activity_delete_req.dart';
import 'package:frechat/models/ws_req/activity/ws_activity_donate_post_req.dart';
import 'package:frechat/models/ws_req/activity/ws_activity_hot_topic_list_req.dart';
import 'package:frechat/models/ws_req/activity/ws_activity_search_info_req.dart';
import 'package:frechat/models/ws_req/activity/ws_activity_search_reply_info_req.dart';
import 'package:frechat/models/ws_res/activity/ws_activity_add_reply_res.dart';
import 'package:frechat/models/ws_res/activity/ws_activity_delete_reply_res.dart';
import 'package:frechat/models/ws_res/activity/ws_activity_delete_res.dart';
import 'package:frechat/models/ws_res/activity/ws_activity_donate_post_res.dart';
import 'package:frechat/models/ws_res/activity/ws_activity_hot_topic_list_res.dart';
import 'package:frechat/models/ws_res/activity/ws_activity_search_info_res.dart';
import 'package:frechat/models/ws_res/activity/ws_activity_search_reply_info_res.dart';
import 'package:frechat/system/constant/enum.dart';
import 'package:frechat/system/ws_comm/ws_params_req.dart';
import 'package:frechat/system/providers.dart';
import 'package:frechat/system/websocket/websocket_handler.dart';

import '../../models/ws_req/ws_base_req.dart';

class ActivityWs {
  ActivityWs({required this.ref});
  final ProviderRef ref;

  /// 動態牆查詢(分頁)
  Future<WsActivitySearchInfoRes> wsActivitySearchInfo(WsActivitySearchInfoReq wsActivitySearchInfoReq, {
    required Function(String) onConnectSuccess,
    required Function(String) onConnectFail,
  }) async {
    final userInfo = ref.read(userInfoProvider);
    final WsBaseReq msg = WsParamsReq.activitySearchInfo
      ..tId = userInfo.commToken ?? "emptyToken"
      ..msg = wsActivitySearchInfoReq.toBody();

    /// 傳送ws send
    final res = await WebSocketHandler.sendData(msg,
        funcCode: WsParamsReq.activitySearchInfo.f,
        onConnectSuccess: (msg) => onConnectSuccess(msg),
        onConnectFail: (errMsg) => onConnectFail(errMsg));

    return res.resultMap == null ? WsActivitySearchInfoRes() : WsActivitySearchInfoRes.fromJson(res.resultMap);
  }

  /// 回復查詢
  Future<WsActivitySearchReplyInfoRes> wsActivitySearchReplyInfo(WsActivitySearchReplyInfoReq wsActivitySearchReplyInfoReq, {
    required Function(String) onConnectSuccess,
    required Function(String) onConnectFail,
  }) async {
    final userInfo = ref.read(userInfoProvider);
    final WsBaseReq msg = WsParamsReq.activitySearchReplyInfo
      ..tId = userInfo.commToken ?? "emptyToken"
      ..msg = wsActivitySearchReplyInfoReq;

    /// 傳送ws send
    final res = await WebSocketHandler.sendData(msg,
        funcCode: WsParamsReq.activitySearchReplyInfo.f,
        onConnectSuccess: (msg) => onConnectSuccess(msg),
        onConnectFail: (errMsg) => onConnectFail(errMsg));

    return res.resultMap == null ? WsActivitySearchReplyInfoRes() : WsActivitySearchReplyInfoRes.fromJson(res.resultMap);
  }

  /// 新增留言
  Future<WsActivityAddReplyRes> wsActivityAddReply(WsActivityAddReplyReq wsActivityAddReplyReq, {
    required Function(String) onConnectSuccess,
    required Function(String) onConnectFail,
  }) async {
    final userInfo = ref.read(userInfoProvider);
    final WsBaseReq msg = WsParamsReq.activityAddReply
      ..tId = userInfo.commToken ?? "emptyToken"
      ..msg = wsActivityAddReplyReq;

    /// 傳送ws send
    final res = await WebSocketHandler.sendData(msg,
        funcCode: WsParamsReq.activityAddReply.f,
        onConnectSuccess: (msg) => onConnectSuccess(msg),
        onConnectFail: (errMsg) => onConnectFail(errMsg));

    return res.resultMap == null ? WsActivityAddReplyRes() : WsActivityAddReplyRes.fromJson(res.resultMap);
  }

  /// 動態删除
  Future<WsActivityDeleteRes> wsActivityDelete(WsActivityDeleteReq wsActivityDeleteReq, {
    required Function(String) onConnectSuccess,
    required Function(String) onConnectFail,
  }) async {
    final userInfo = ref.read(userInfoProvider);
    final WsBaseReq msg = WsParamsReq.activityDelete
      ..tId = userInfo.commToken ?? "emptyToken"
      ..msg = wsActivityDeleteReq;

    /// 傳送ws send
    final res = await WebSocketHandler.sendData(msg,
        funcCode: WsParamsReq.activityDelete.f,
        onConnectSuccess: (msg) => onConnectSuccess(msg),
        onConnectFail: (errMsg) => onConnectFail(errMsg));

    return WsActivityDeleteRes.fromJson(res.resultMap);
  }

  /// 熱門標題選單
  Future<WsActivityHotTopicListRes> wsActivityHotTopicList(WsActivityHotTopicListReq wsActivityHotTopicListReq, {
    required Function(String) onConnectSuccess,
    required Function(String) onConnectFail,
  }) async {
    final userInfo = ref.read(userInfoProvider);
    final WsBaseReq msg = WsParamsReq.activityHotTopicList
      ..tId = userInfo.commToken ?? "emptyToken"
      ..msg = wsActivityHotTopicListReq.toBody();

    /// 傳送ws send
    final res = await WebSocketHandler.sendData(msg,
        funcCode: WsParamsReq.activityHotTopicList.f,
        onConnectSuccess: (msg) => onConnectSuccess(msg),
        onConnectFail: (errMsg) => onConnectFail(errMsg));

    return WsActivityHotTopicListRes.fromJson(res.resultMap);
  }

  /// 删除留言
  Future<WsActivityDeleteReplyRes> wsActivityDeleteReply(WsActivityDeleteReplyReq wsActivityDeleteReplyReq, {
    required Function(String) onConnectSuccess,
    required Function(String) onConnectFail,
  }) async {
    final userInfo = ref.read(userInfoProvider);
    final WsBaseReq msg = WsParamsReq.activityDeleteReply
      ..tId = userInfo.commToken ?? "emptyToken"
      ..msg = wsActivityDeleteReplyReq.toBody();

    /// 傳送ws send
    final res = await WebSocketHandler.sendData(msg,
        funcCode: WsParamsReq.activityDeleteReply.f,
        onConnectSuccess: (msg) => onConnectSuccess(msg),
        onConnectFail: (errMsg) => onConnectFail(errMsg));

    return WsActivityDeleteReplyRes.fromJson(res.resultMap);
  }

  /// 打賞動態
  Future<WsActivityDonatePostRes> wsActivityDonatePost(WsActivityDonatePostReq wsActivityDonatePostReq, {
    required Function(String) onConnectSuccess,
    required Function(String) onConnectFail,
  }) async {
    final userInfo = ref.read(userInfoProvider);
    final WsBaseReq msg = WsParamsReq.activityDonatePost
      ..tId = userInfo.commToken ?? "emptyToken"
      ..msg = wsActivityDonatePostReq.toBody();

    /// 傳送ws send
    final res = await WebSocketHandler.sendData(msg,
        funcCode: WsParamsReq.activityDonatePost.f,
        onConnectSuccess: (msg) => onConnectSuccess(msg),
        onConnectFail: (errMsg) => onConnectFail(errMsg));

    return res.resultMap == null ? WsActivityDonatePostRes() : WsActivityDonatePostRes.fromJson(res.resultMap);
  }
}