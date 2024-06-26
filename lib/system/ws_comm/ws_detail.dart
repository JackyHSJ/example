
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frechat/system/ws_comm/ws_params_req.dart';

import '../../models/ws_req/contact/ws_contact_search_list_req.dart';
import '../../models/ws_req/detail/ws_detail_search_list_coin_req.dart';
import '../../models/ws_req/detail/ws_detail_search_list_income_req.dart';
import '../../models/ws_req/ws_base_req.dart';
import '../../models/ws_res/contact/ws_contact_search_list_res.dart';
import '../../models/ws_res/detail/ws_detail_search_list_coin_res.dart';
import '../../models/ws_res/detail/ws_detail_search_list_income_res.dart';
import '../providers.dart';
import '../websocket/websocket_handler.dart';

class DetailWs {
  DetailWs({required this.ref});
  final ProviderRef ref;

  /// 查詢收支明細-金币
  Future<WsDetailSearchListCoinRes> wsDetailSearchListCoin(WsDetailSearchListCoinReq wsDetailSearchListReq, {
    required Function(String) onConnectSuccess,
    required Function(String) onConnectFail,
  }) async {
    final userInfo = ref.read(userInfoProvider);
    final WsBaseReq msg = WsParamsReq.detailSearchListCoin
      ..tId = userInfo.commToken ?? "emptyToken"
      ..msg = wsDetailSearchListReq;

    /// 傳送ws send
    final res = await WebSocketHandler.sendData(msg,
        funcCode: WsParamsReq.detailSearchListCoin.f,
        onConnectSuccess: (msg) => onConnectSuccess(msg),
        onConnectFail: (errMsg) => onConnectFail(errMsg));
    return WsDetailSearchListCoinRes.fromJson(res.resultMap);
  }

  /// 查詢收支明細-收益
  Future<WsDetailSearchListIncomeRes> wsDetailSearchListIncome(WsDetailSearchListIncomeReq wsDetailSearchListIncomeReq, {
    required Function(String) onConnectSuccess,
    required Function(String) onConnectFail,
  }) async {
    final userInfo = ref.read(userInfoProvider);
    final WsBaseReq msg = WsParamsReq.detailSearchListIncome
      ..tId = userInfo.commToken ?? "emptyToken"
      ..msg = wsDetailSearchListIncomeReq;

    /// 傳送ws send
    final res = await WebSocketHandler.sendData(msg,
        funcCode: WsParamsReq.detailSearchListIncome.f,
        onConnectSuccess: (msg) => onConnectSuccess(msg),
        onConnectFail: (errMsg) => onConnectFail(errMsg));
    return WsDetailSearchListIncomeRes.fromJson(res.resultMap);
  }
}