
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frechat/models/ws_req/greet/ws_greet_module_delete_req.dart';
import 'package:frechat/models/ws_req/greet/ws_greet_module_edit_remark_req.dart';
import 'package:frechat/models/ws_req/greet/ws_greet_module_list_req.dart';
import 'package:frechat/models/ws_req/greet/ws_greet_module_use_req.dart';
import 'package:frechat/models/ws_res/greet/ws_greet_module_delete_res.dart';
import 'package:frechat/models/ws_res/greet/ws_greet_module_edit_remark_res.dart';
import 'package:frechat/models/ws_res/greet/ws_greet_module_list_res.dart';
import 'package:frechat/models/ws_res/greet/ws_greet_module_use_res.dart';
import 'package:frechat/system/ws_comm/ws_params_req.dart';

import '../../models/ws_req/ws_base_req.dart';
import '../providers.dart';
import '../websocket/websocket_handler.dart';

class GreetWs {
  GreetWs({required this.ref});
  final ProviderRef ref;

  /// 招呼模板清單
  Future<WsGreetModuleListRes> wsGreetModuleList(WsGreetModuleListReq wsGreetModuleListReq, {
    required Function(String) onConnectSuccess,
    required Function(String) onConnectFail,
  }) async {
    final userInfo = ref.read(userInfoProvider);
    final WsBaseReq msg = WsParamsReq.greetModuleList
      ..tId = userInfo.commToken ?? "emptyToken"
      ..msg = wsGreetModuleListReq;

    /// 傳送ws send
    final res = await WebSocketHandler.sendData(msg,
        funcCode: WsParamsReq.greetModuleList.f,
        onConnectSuccess: (msg) => onConnectSuccess(msg),
        onConnectFail: (errMsg) => onConnectFail(errMsg));
    return WsGreetModuleListRes.fromJson(res.resultMap);
  }

  /// 删除招呼模板
  Future<WsGreetModuleDeleteRes> wsGreetModuleDelete(WsGreetModuleDeleteReq wsGreetModuleDeleteReq, {
    required Function(String) onConnectSuccess,
    required Function(String) onConnectFail,
  }) async {
    final userInfo = ref.read(userInfoProvider);
    final WsBaseReq msg = WsParamsReq.greetModuleDelete
      ..tId = userInfo.commToken ?? "emptyToken"
      ..msg = wsGreetModuleDeleteReq;

    /// 傳送ws send
    final res = await WebSocketHandler.sendData(msg,
        funcCode: WsParamsReq.greetModuleDelete.f,
        onConnectSuccess: (msg) => onConnectSuccess(msg),
        onConnectFail: (errMsg) => onConnectFail(errMsg));
    return WsGreetModuleDeleteRes.fromJson(res.resultMap);
  }

  /// 編輯招呼模板備註
  Future<WsGreetModuleEditRemarkRes> wsGreetModuleEditRemark(WsGreetModuleEditRemarkReq wsGreetModuleEditRemarkReq, {
    required Function(String) onConnectSuccess,
    required Function(String) onConnectFail,
  }) async {
    final userInfo = ref.read(userInfoProvider);
    final WsBaseReq msg = WsParamsReq.greetModuleEditRemark
      ..tId = userInfo.commToken ?? "emptyToken"
      ..msg = wsGreetModuleEditRemarkReq;

    /// 傳送ws send
    final res = await WebSocketHandler.sendData(msg,
        funcCode: WsParamsReq.greetModuleList.f,
        onConnectSuccess: (msg) => onConnectSuccess(msg),
        onConnectFail: (errMsg) => onConnectFail(errMsg));
    return WsGreetModuleEditRemarkRes.fromJson(res.resultMap);
  }

  /// 使用招呼模板
  Future<WsGreetModuleUseRes> wsGreetModuleUse(WsGreetModuleUseReq wsGreetModuleUsekReq, {
    required Function(String) onConnectSuccess,
    required Function(String) onConnectFail,
  }) async {
    final userInfo = ref.read(userInfoProvider);
    final WsBaseReq msg = WsParamsReq.greetModuleUse
      ..tId = userInfo.commToken ?? "emptyToken"
      ..msg = wsGreetModuleUsekReq;

    /// 傳送ws send
    final res = await WebSocketHandler.sendData(msg,
        funcCode: WsParamsReq.greetModuleUse.f,
        onConnectSuccess: (msg) => onConnectSuccess(msg),
        onConnectFail: (errMsg) => onConnectFail(errMsg));
    return (res.resultMap == null) ? WsGreetModuleUseRes() : WsGreetModuleUseRes.fromJson(res.resultMap);
  }
}