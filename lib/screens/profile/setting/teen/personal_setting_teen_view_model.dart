

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frechat/system/app_config/app_config.dart';
import 'package:frechat/models/ws_req/member/ws_member_disable_teen_req.dart';
import 'package:frechat/models/ws_req/member/ws_member_enable_teen_req.dart';
import 'package:frechat/models/ws_req/member/ws_member_teen_status_req.dart';
import 'package:frechat/screens/home/home.dart';
import 'package:frechat/system/base_view_model.dart';
import 'package:frechat/system/call_back_function.dart';
import 'package:frechat/system/global.dart';
import 'package:frechat/system/global/shared_preferance.dart';
import 'package:frechat/system/provider/user_info_provider.dart';
import 'package:frechat/system/providers.dart';
import 'package:frechat/system/repository/response_code.dart';


class PersonalSettingTeenViewModel{
  PersonalSettingTeenViewModel();

  static late TextEditingController passwordTextController;
  static late TextEditingController confirmPasswordTextController;
  static late TextEditingController closeTeenModePasswordTextController;

  static bool isLoading = false;
  static bool isTeenMode = false;
  static bool isBtnOrFalseIsTextField = true;
  static String? errorText;

  static init() {
    isBtnOrFalseIsTextField = true;
    passwordTextController = TextEditingController();
    confirmPasswordTextController = TextEditingController();
    closeTeenModePasswordTextController = TextEditingController();
  }

  static dispose() {
    passwordTextController.dispose();
    confirmPasswordTextController.dispose();
    closeTeenModePasswordTextController.dispose();
  }

  static getTeenStatus({
    required BuildContext context,
    required WidgetRef ref,
    required ViewChange setState
  }) async {
    final reqBody = WsMemberTeenStatusReq.create();
    String? resultCodeCheck;
    isLoading = true;
    final res = await ref.read(memberWsProvider).wsMemberTeenStatus(reqBody,
        onConnectSuccess: (succMsg) => resultCodeCheck = succMsg,
        onConnectFail: (errMsg) => BaseViewModel.showToast(context, ResponseCode.map[errMsg]!)
    );
    if(resultCodeCheck == ResponseCode.CODE_SUCCESS) {
      isTeenMode = res.adolescent ?? false;
    }
    isLoading = false;
    setState((){});
  }

  static enableTeen({
    required BuildContext context,
    required WidgetRef ref,
    required ViewChange setState,
    required Function() onSuccess
  }) async {
    final String phoneNumber = ref.read(userUtilProvider).phoneNumber ?? '';
    final String envStr = await AppConfig.getEnvStr();
    final reqBody = WsMemberEnableTeenReq.create(
      env: envStr,
      phoneNumber: phoneNumber,
      password: confirmPasswordTextController.text
    );
    isLoading = true;
    await ref.read(memberWsProvider).wsMemberEnableTeen(reqBody,
        onConnectSuccess: (succMsg) async {
          onSuccess();
          isTeenMode = true;
          await FcPrefs.setTeenMode(true);
        },
        onConnectFail: (errMsg) => BaseViewModel.showToast(context,'动态验证码错误，请重新输入')
    );
    isLoading = false;
    setState((){});
  }

  static closeTeen({
    required BuildContext context,
    required WidgetRef ref,
    required ViewChange setState,
    required Function(String) onFail
  }) async {
    final String phoneNumber = ref.read(userUtilProvider).phoneNumber ?? '';
    final String envStr = await AppConfig.getEnvStr();
    WsMemberDisableTeenReq reqBody = WsMemberDisableTeenReq.create(
        env: envStr,
        phoneNumber: phoneNumber,
        password: closeTeenModePasswordTextController.text
    );
    ref.read(memberWsProvider).wsMemberDisableTeen(reqBody,
      onConnectSuccess: (succMsg) async {
        BaseViewModel.popPage(context);
        BaseViewModel.showToast(context, '关闭成功');
        await FcPrefs.setTeenMode(false);

      },
      onConnectFail: (errMsg) => onFail(errMsg)
    );
  }
}