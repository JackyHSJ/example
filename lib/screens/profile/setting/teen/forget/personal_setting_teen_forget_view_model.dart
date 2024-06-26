

import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frechat/system/app_config/app_config.dart';
import 'package:frechat/models/req/send_sms_req.dart';
import 'package:frechat/models/ws_req/member/ws_member_teen_forget_password_req.dart';
import 'package:frechat/system/base_view_model.dart';
import 'package:frechat/system/call_back_function.dart';
import 'package:frechat/system/global.dart';
import 'package:frechat/system/providers.dart';
import 'package:frechat/system/repository/response_code.dart';
import 'package:package_info_plus/package_info_plus.dart';

class PersonalSettingTeenForgetViewModel{
  PersonalSettingTeenForgetViewModel({
    required this.ref,
    required this.context,
    required this.setState,
  });
  WidgetRef ref;
  ViewChange setState;
  BuildContext context;

  late TextEditingController phoneTextController;
  late TextEditingController verifyTextController;
  String? phoneTextErrorMsg;
  String? verifyTextErrorMsg;
  Timer? timer;
  final int countDownPeriodic = 1;
  final int countDownTimeMax = 60;
  int smsCountDown = 60;

  init() {
    phoneTextController = TextEditingController();
    verifyTextController = TextEditingController();
  }

  _initTimer() {
    if(timer != null) {
      return ;
    }
    timer = Timer.periodic(Duration(seconds: countDownPeriodic), (timer) {
      smsCountDown--;
      if(countDownTimeMax <= timer.tick){
        _disposeTimer();
      }
      setState((){});
    });
  }

  _disposeTimer() {
    if(timer == null) {
      return ;
    }
    timer?.cancel();
    timer = null;
    smsCountDown = countDownTimeMax;
  }

  dispose() {
    phoneTextController.dispose();
    verifyTextController.dispose();
    _disposeTimer();
  }

  teenForgetPassword() async {
    final String envStr = await AppConfig.getEnvStr();
    final WsMemberTeenForgetPasswordReq reqBody = WsMemberTeenForgetPasswordReq.create(
        env: envStr,
        phoneNumber: phoneTextController.text,
        tokenOrSms: verifyTextController.text
    );
    ref.read(memberWsProvider).wsMemberTeenForgetPassword(reqBody,
        onConnectSuccess: (succMsg) {
          BaseViewModel.popPage(context);
          BaseViewModel.popPage(context);
        },
        onConnectFail: (errMsg){
          if(errMsg == ResponseCode.CODE_PARAMETER_FORMAT_ERROR){
            BaseViewModel.showToast(context, '动态验证码错误，请重新输入');
          }else{
            BaseViewModel.showToast(context, ResponseCode.map[errMsg]!);
          }
        }
    );
  }

  Future<void> getSms() async {
    if(timer != null) {
      return ;
    }

    String? resultCodeCheck;
    final String phoneNum = ref.read(userInfoProvider).phoneNumber ?? '';
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    final SendSmsReq reqBody = SendSmsReq.create(phonenumber: phoneNum,appId: packageInfo.packageName);
    await ref.read(commApiProvider).sendSms(reqBody,
        onConnectSuccess: (succMsg) => resultCodeCheck = succMsg,
        onConnectFail: (errMsg) => BaseViewModel.showToast(context, ResponseCode.map[errMsg]!));

    if(resultCodeCheck == ResponseCode.CODE_SUCCESS) {
      BaseViewModel.showToast(context, '验证码已发送至 $phoneNum');
      _initTimer();
    }
  }
}