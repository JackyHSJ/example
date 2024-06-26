

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frechat/models/ws_req/report/ws_report_search_type_req.dart';
import 'package:frechat/models/ws_res/report/ws_report_search_type_res.dart';
import 'package:frechat/system/base_view_model.dart';
import 'package:frechat/system/call_back_function.dart';
import 'package:frechat/system/providers.dart';
import 'package:frechat/system/repository/response_code.dart';

class ActivityReportDialogViewModel {

  ViewChange setState;
  WidgetRef ref;
  BuildContext context;

  ActivityReportDialogViewModel({
    required this.setState,
    required this.ref,
    required this.context,
  });

  List<ReportListInfo?> reportList = [];
  ReportListInfo? currentReportItem;

  void init() {
    _getReportList();
  }

  // 查詢舉報類型 api 6-1
  _getReportList() async {
    String resultCodeCheck = '';

    // 舉報類型 0:全部 1:用戶 2:動態
    final WsReportSearchTypeReq reqBody = WsReportSearchTypeReq.create(type: '2');
    final WsReportSearchTypeRes res = await ref.read(reportWsProvider).wsReportSearchType(reqBody,
      onConnectSuccess: (succMsg) => resultCodeCheck = succMsg,
      onConnectFail: (errMsg) => resultCodeCheck = errMsg
    );

    if (resultCodeCheck == ResponseCode.CODE_SUCCESS) {
      reportList = res.list ?? [];
      setState(() {});
    } else {
      if (context.mounted) {
        BaseViewModel.showToast(context, ResponseCode.map[resultCodeCheck]!);
      }
    }
  }
}