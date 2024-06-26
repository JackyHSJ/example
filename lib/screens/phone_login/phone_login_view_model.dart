

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frechat/models/ws_req/account/ws_account_get_rtm_token_req.dart';
import 'package:frechat/models/ws_req/banner/ws_banner_info_req.dart';
import 'package:frechat/models/ws_req/member/ws_member_info_req.dart';
import 'package:frechat/models/ws_req/notification/ws_notification_search_list_req.dart';
import 'package:frechat/models/ws_res/account/ws_account_get_rtm_token_res.dart';
import 'package:frechat/models/ws_res/banner/ws_banner_info_res.dart';
import 'package:frechat/models/ws_res/member/ws_member_info_res.dart';
import 'package:frechat/models/ws_res/notification/ws_notification_search_list_res.dart';
import 'package:frechat/system/base_view_model.dart';
import 'package:frechat/system/call_back_function.dart';
import 'package:frechat/system/jiguang_mob_auth/jiguang_mob_auth.dart';
import 'package:frechat/system/ntesdun/ntesdun_mob_auth.dart';
import 'package:frechat/system/provider/user_info_provider.dart';
import 'package:frechat/system/providers.dart';
import 'package:frechat/system/repository/response_code.dart';
import 'package:frechat/system/zego_call/zego_login.dart';
import 'package:frechat/system/zego_call/zego_provider.dart';
import 'package:frechat/models/ws_req/mission/ws_mission_search_status_req.dart';
import 'package:frechat/models/ws_res/mission/ws_mission_search_status_res.dart';
import 'package:frechat/models/ws_res/setting/ws_setting_charm_achievement_res.dart';
import 'package:frechat/models/ws_req/setting/ws_setting_charm_achievement_req.dart';

class PhoneLoginViewModel {
  PhoneLoginViewModel({required this.ref, required this.setState});
  WidgetRef ref;
  ViewChange setState;
  bool canGetVerifyCode = true;
  final TextEditingController phoneController = TextEditingController();
  final FocusNode phoneInputFocus = FocusNode();
  final TextEditingController verificationCodeController = TextEditingController();
  final FocusNode verificationCodeInputFocus = FocusNode();
  Timer? timer;
  final int countDownPeriodic = 1;
  final int countDownTimeMax = 60;
  int smsCountDown = 60;
  bool canSendSms = true;

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

  getSms(BuildContext context) {
    if (phoneController.text.length != 11) {
      BaseViewModel.showToast(context, '电话号码长度有误');
      return ;
    }
    if(canSendSms == false) {
      BaseViewModel.showToast(context, '验证发送过频繁');
      return ;
    }
    initTimer();
    NTESDUNMobAuth.getSMSCode(phoneController.text, ref, context, onConnectFail: (){
      _disposeTimer();
    });
    // JIGUANGMobAuth.getSMSCode(phoneController.text, ref, context,onConnectFail: (){
    //   _disposeTimer();
    // });
    BaseViewModel.showToast(context, '验证码已发送至 ${phoneController.text}');
  }

  initTimer() {
    canSendSms = false;
    timer = Timer.periodic(Duration(seconds: countDownPeriodic), (timer) {
      smsCountDown--;
      if(countDownTimeMax <= timer.tick){
        _disposeTimer();
      }
      setState((){});
    });
  }

  _disposeTimer() {
    timer!.cancel();
    timer = null;
    smsCountDown = countDownTimeMax;
    canSendSms = true;
  }

  dispose() {
    /// 清除Timer
    if(timer != null) {
      _disposeTimer();
    }
  }
}