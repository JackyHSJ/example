

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frechat/models/ws_req/benefit/ws_benefit_info_req.dart';
import 'package:frechat/models/ws_res/benefit/ws_benefit_info_res.dart';
import 'package:frechat/system/ws_comm/ws_params_req.dart';
import 'package:frechat/system/providers.dart';
import 'package:frechat/system/websocket/websocket_handler.dart';

import '../../models/ws_req/ws_base_req.dart';

class BenefitWs {
  BenefitWs({required this.ref});
  final ProviderRef ref;

  /// 我的收益
  Future<WsBenefitInfoRes> wsBenefitInfo(WsBenefitInfoReq wsBenefitInfoReq, {
    required Function(String) onConnectSuccess,
    required Function(String) onConnectFail,
  }) async {
    final userInfo = ref.read(userInfoProvider);
    final WsBaseReq msg = WsParamsReq.benefitInfo
      ..tId = userInfo.commToken ?? "emptyToken"
      ..msg = wsBenefitInfoReq.toBody();

    /// 傳送ws send
    final res = await WebSocketHandler.sendData(msg,
        funcCode: WsParamsReq.benefitInfo.f,
        onConnectSuccess: (msg) => onConnectSuccess(msg),
        onConnectFail: (errMsg) => onConnectFail(errMsg));

    return WsBenefitInfoRes.fromJson(res.resultMap);
  }
}