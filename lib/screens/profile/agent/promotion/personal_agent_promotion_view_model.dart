
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frechat/models/ws_req/agent/ws_agent_promoter_info_req.dart';
import 'package:frechat/models/ws_res/agent/ws_agent_promoter_info_res.dart';
import 'package:frechat/system/base_view_model.dart';
import 'package:frechat/system/call_back_function.dart';
import 'package:frechat/system/provider/user_info_provider.dart';
import 'package:frechat/system/providers.dart';
import 'package:frechat/system/repository/response_code.dart';

class PersonalAgentPromotionViewModel {
  PersonalAgentPromotionViewModel({required this.ref, required this.setState});
  WidgetRef ref;
  ViewChange setState;

  init(BuildContext context) {
    _getAgentPromoterInfo(context);
  }

  /// 16-2
  _getAgentPromoterInfo(BuildContext context) async {
    String? resultCodeCheck;
    final reqBody = WsAgentPromoterInfoReq.create();
    final WsAgentPromoterInfoRes res = await ref.read(agentWsProvider).wsAgentPromoterInfo(
        reqBody,
        onConnectSuccess: (succMsg) => resultCodeCheck = succMsg,
        onConnectFail: (errMsg) => BaseViewModel.showToast(context, ResponseCode.map[errMsg]!)
    );
    if(resultCodeCheck == ResponseCode.CODE_SUCCESS) {
      ref.read(userUtilProvider.notifier).loadAgentPromoterInfo(res);
    }
  }
}