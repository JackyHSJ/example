
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frechat/system/app_config/app_config.dart';
import 'package:frechat/models/device_platform_model.dart';
import 'package:frechat/models/ws_req/account/ws_account_follow_and_fans_list_req.dart';
import 'package:frechat/models/ws_req/account/ws_account_get_rtm_token_req.dart';
import 'package:frechat/models/ws_req/agent/ws_agent_member_list_req.dart';
import 'package:frechat/models/ws_req/agent/ws_agent_promoter_info_req.dart';
import 'package:frechat/models/ws_req/banner/ws_banner_info_req.dart';
import 'package:frechat/models/ws_req/greet/ws_greet_module_list_req.dart';
import 'package:frechat/models/ws_req/member/ws_member_info_req.dart';
import 'package:frechat/models/ws_req/member/ws_member_point_coin_req.dart';
import 'package:frechat/models/ws_req/notification/ws_notification_block_group_req.dart';
import 'package:frechat/models/ws_req/notification/ws_notification_search_list_req.dart';
import 'package:frechat/models/ws_req/setting/ws_setting_charm_achievement_req.dart';
import 'package:frechat/models/ws_res/account/ws_account_get_rtm_token_res.dart';
import 'package:frechat/models/ws_res/agent/ws_agent_member_list_res.dart';
import 'package:frechat/models/ws_res/agent/ws_agent_promoter_info_res.dart';
import 'package:frechat/models/ws_res/banner/ws_banner_info_res.dart';
import 'package:frechat/models/ws_res/greet/ws_greet_module_list_res.dart';
import 'package:frechat/models/ws_res/member/ws_member_info_res.dart';
import 'package:frechat/models/ws_res/member/ws_member_point_coin_res.dart';
import 'package:frechat/models/ws_res/notification/ws_notification_block_group_res.dart';
import 'package:frechat/models/ws_res/notification/ws_notification_search_list_res.dart';
import 'package:frechat/models/ws_res/setting/ws_setting_charm_achievement_res.dart';
import 'package:frechat/screens/launch/launch.dart';
import 'package:frechat/system/base_view_model.dart';
import 'package:frechat/system/constant/enum.dart';
import 'package:frechat/system/global.dart';
import 'package:frechat/system/provider/chat_Gift_model_provider.dart';
import 'package:frechat/system/provider/chat_audio_model_provider.dart';
import 'package:frechat/system/provider/chat_block_model_provider.dart';
import 'package:frechat/system/provider/chat_call_model_provider.dart';
import 'package:frechat/system/provider/chat_image_model_provider.dart';
import 'package:frechat/system/provider/chat_message_model_provider.dart';
import 'package:frechat/system/provider/chat_user_model_provider.dart';
import 'package:frechat/system/provider/user_info_provider.dart';
import 'package:frechat/system/provider/zego_beauty_model_provider.dart';
import 'package:frechat/system/providers.dart';
import 'package:frechat/system/repository/response_code.dart';
import 'package:frechat/system/util/date_format_util.dart';
import 'package:frechat/system/zego_call/zego_login.dart';
import 'package:frechat/system/zego_call/zego_provider.dart';
import 'package:frechat/models/ws_req/mission/ws_mission_search_status_req.dart';
import 'package:frechat/models/ws_res/mission/ws_mission_search_status_res.dart';
import 'package:frechat/widgets/theme/app_theme.dart';


class LaunchViewModel {
  LaunchViewModel({
    required this.ref
  });
  WidgetRef ref;

  init() {

  }

  dispose() {

  }

  Future<WsAccountGetRTMTokenRes> getRTMToken(BuildContext context, {
    required Function(String) onConnectSuccess
  }) async {
    WsAccountGetRTMTokenReq reqBody = WsAccountGetRTMTokenReq.create();
    final WsAccountGetRTMTokenRes res = await ref.read(accountWsProvider).wsAccountGetRTMToken(reqBody,
        onConnectSuccess: (succMsg) => onConnectSuccess(succMsg),
        onConnectFail: (errMsg) => BaseViewModel.showToast(context, ResponseCode.map[errMsg]!)
    );
    return res;
  }

  logout(BuildContext context) {
    ref.read(authenticationProvider).logout(
        onConnectSuccess: (succMsg) => BaseViewModel.pushAndRemoveUntil(context, GlobalData.launch ?? const Launch()),
        onConnectFail: (errMsg) => BaseViewModel.showToast(context, errMsg));
  }
}