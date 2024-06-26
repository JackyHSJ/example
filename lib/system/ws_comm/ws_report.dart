
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frechat/system/ws_comm/ws_params_req.dart';

import '../../models/ws_req/report/ws_report_search_type_req.dart';
import '../../models/ws_req/ws_base_req.dart';
import '../../models/ws_res/report/ws_report_search_type_res.dart';
import '../providers.dart';
import '../websocket/websocket_handler.dart';

class ReportWs {
  ReportWs({required this.ref});
  final ProviderRef ref;

  /// 查詢舉報類型
  Future<WsReportSearchTypeRes> wsReportSearchType(WsReportSearchTypeReq wsReportSearchTypeReq, {
    required Function(String) onConnectSuccess,
    required Function(String) onConnectFail,
  }) async {
    final userInfo = ref.read(userInfoProvider);
    final WsBaseReq msg = WsParamsReq.reportSearchType
      ..tId = userInfo.commToken ?? "emptyToken"
      ..msg = wsReportSearchTypeReq;

    /// 傳送ws send
    final res = await WebSocketHandler.sendData(msg,
        funcCode: WsParamsReq.reportSearchType.f,
        onConnectSuccess: (msg) => onConnectSuccess(msg),
        onConnectFail: (errMsg) => onConnectFail(errMsg));

    return (res.resultMap == null) ? WsReportSearchTypeRes() : WsReportSearchTypeRes.fromJson(res.resultMap);
  }
}