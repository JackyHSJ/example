import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frechat/models/ws_req/customer_service_hour/ws_customer_service_hour_req.dart';
import 'package:frechat/models/ws_req/notification/ws_notification_search_intimacy_level_info_req.dart';
import 'package:frechat/models/ws_req/banner/ws_banner_info_req.dart';
import 'package:frechat/models/ws_res/banner/ws_banner_info_res.dart';
import 'package:frechat/models/ws_res/customer_service_hour/ws_customer_service_hour_res.dart';
import 'package:frechat/models/ws_res/notification/ws_notification_search_intimacy_level_info_res.dart';
import 'package:frechat/system/base_view_model.dart';
import 'package:frechat/system/providers.dart';
import 'package:frechat/system/repository/response_code.dart';
import 'package:frechat/system/websocket/websocket_handler.dart';
import 'package:frechat/system/ws_comm/ws_params_req.dart';

import '../../models/ws_req/notification/ws_notification_block_group_req.dart';
import '../../models/ws_req/notification/ws_notification_leave_group_block_req.dart';
import '../../models/ws_req/notification/ws_notification_press_btn_and_remove_black_account_req.dart';
import '../../models/ws_req/notification/ws_notification_search_list_req.dart';
import '../../models/ws_req/notification/ws_notification_strike_up_req.dart';
import '../../models/ws_req/ws_base_req.dart';
import '../../models/ws_res/notification/ws_notification_block_group_res.dart';
import '../../models/ws_res/notification/ws_notification_leave_group_block_res.dart';
import '../../models/ws_res/notification/ws_notification_press_btn_and_remove_black_account_res.dart';
import '../../models/ws_res/notification/ws_notification_search_list_res.dart';
import '../../models/ws_res/notification/ws_notification_strike_up_res.dart';

class CustomerServiceHoursWs {
  CustomerServiceHoursWs({required this.ref});
  final ProviderRef ref;

  /// 客服時段查詢
  Future<WsCustomerServiceHourRes> wsCustomerServiceHoursWs(
      WsCustomerServiceHourReq wsCustomerServiceHourReq, {
        required Function(String) onConnectSuccess,
        required Function(String) onConnectFail,
      }) async {
    final userInfo = ref.read(userInfoProvider);
    final WsBaseReq msg = WsParamsReq.customerServiceHours
      ..tId = userInfo.commToken ?? "emptyToken"
      ..msg = wsCustomerServiceHourReq.toBody();

    /// 傳送ws send
    final res = await WebSocketHandler.sendData(msg,
        funcCode: WsParamsReq.customerServiceHours.f,
        onConnectSuccess: (msg) => onConnectSuccess(msg),
        onConnectFail: (errMsg) => onConnectFail(errMsg));

    return res.resultMap == null ? WsCustomerServiceHourRes() : WsCustomerServiceHourRes.fromJson(res.resultMap);
  }
}
