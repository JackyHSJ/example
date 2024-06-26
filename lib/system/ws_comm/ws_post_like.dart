
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frechat/models/ws_req/post_like/ws_post_add_like_req.dart';
import 'package:frechat/models/ws_req/post_like/ws_post_return_like_req.dart';
import 'package:frechat/models/ws_res/activity/ws_activity_search_info_res.dart';
import 'package:frechat/models/ws_res/post_like/ws_post_add_like_res.dart';
import 'package:frechat/models/ws_res/post_like/ws_post_return_like_res.dart';
import 'package:frechat/system/ws_comm/ws_params_req.dart';
import 'package:frechat/system/providers.dart';
import 'package:frechat/system/websocket/websocket_handler.dart';

import '../../models/ws_req/ws_base_req.dart';

class PostLikeWs {
  PostLikeWs({required this.ref});
  final ProviderRef ref;

  /// 按讚
  Future<WsPostAddLikeRes> wsPostAddLike(WsPostAddLikeReq wsPostAddLikeReq, {
    required Function(String) onConnectSuccess,
    required Function(String) onConnectFail,
  }) async {
    final userInfo = ref.read(userInfoProvider);
    final WsBaseReq msg = WsParamsReq.postAddLike
      ..tId = userInfo.commToken ?? "emptyToken"
      ..msg = wsPostAddLikeReq;

    /// 傳送ws send
    final res = await WebSocketHandler.sendData(msg,
        funcCode: WsParamsReq.postAddLike.f,
        onConnectSuccess: (msg) => onConnectSuccess(msg),
        onConnectFail: (errMsg) => onConnectFail(errMsg));

    return res.resultMap == null ? WsPostAddLikeRes() :  WsPostAddLikeRes.fromJson(res.resultMap);
  }

  /// 收回讚
  Future<WsPostReturnLikeRes> wsPostReturnLike(WsPostReturnLikeReq wsPostReturnLikeReq, {
    required Function(String) onConnectSuccess,
    required Function(String) onConnectFail,
  }) async {
    final userInfo = ref.read(userInfoProvider);
    final WsBaseReq msg = WsParamsReq.postReturnLike
      ..tId = userInfo.commToken ?? "emptyToken"
      ..msg = wsPostReturnLikeReq;

    /// 傳送ws send
    final res = await WebSocketHandler.sendData(msg,
        funcCode: WsParamsReq.postReturnLike.f,
        onConnectSuccess: (msg) => onConnectSuccess(msg),
        onConnectFail: (errMsg) => onConnectFail(errMsg));

    return res.resultMap == null ? WsPostReturnLikeRes() : WsPostReturnLikeRes.fromJson(res.resultMap);
  }
}