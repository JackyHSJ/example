
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frechat/models/ws_req/activity/ws_activity_add_reply_req.dart';
import 'package:frechat/models/ws_req/activity/ws_activity_delete_reply_req.dart';
import 'package:frechat/models/ws_req/activity/ws_activity_delete_req.dart';
import 'package:frechat/models/ws_req/activity/ws_activity_hot_topic_list_req.dart';
import 'package:frechat/models/ws_req/activity/ws_activity_search_info_req.dart';
import 'package:frechat/models/ws_req/activity/ws_activity_search_reply_info_req.dart';
import 'package:frechat/models/ws_req/visitor/ws_visitor_list_req.dart';
import 'package:frechat/models/ws_res/activity/ws_activity_add_reply_res.dart';
import 'package:frechat/models/ws_res/activity/ws_activity_delete_reply_res.dart';
import 'package:frechat/models/ws_res/activity/ws_activity_delete_res.dart';
import 'package:frechat/models/ws_res/activity/ws_activity_hot_topic_list_res.dart';
import 'package:frechat/models/ws_res/activity/ws_activity_search_info_res.dart';
import 'package:frechat/models/ws_res/activity/ws_activity_search_reply_info_res.dart';
import 'package:frechat/models/ws_res/visitor/ws_visitor_list_res.dart';
import 'package:frechat/system/ws_comm/ws_params_req.dart';
import 'package:frechat/system/providers.dart';
import 'package:frechat/system/websocket/websocket_handler.dart';

import '../../models/ws_req/ws_base_req.dart';

class VisitorWs {
  VisitorWs({required this.ref});
  final ProviderRef ref;

  /// 访客查詢
  Future<WsVisitorListRes> wsVisitorList(WsVisitorListReq wsVisitorListReq, {
    required Function(String) onConnectSuccess,
    required Function(String) onConnectFail,
  }) async {
    final userInfo = ref.read(userInfoProvider);
    final WsBaseReq msg = WsParamsReq.visitorList
      ..tId = userInfo.commToken ?? "emptyToken"
      ..msg = wsVisitorListReq;

    /// 傳送ws send
    final res = await WebSocketHandler.sendData(msg,
        funcCode: WsParamsReq.visitorList.f,
        onConnectSuccess: (msg) => onConnectSuccess(msg),
        onConnectFail: (errMsg) => onConnectFail(errMsg));

    return WsVisitorListRes.fromJson(res.resultMap);
  }

}