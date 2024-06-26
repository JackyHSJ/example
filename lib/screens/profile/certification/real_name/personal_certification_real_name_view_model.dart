
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frechat/system/app_config/app_config.dart';
import 'package:frechat/models/ws_req/member/ws_member_info_req.dart';
import 'package:frechat/models/ws_req/member/ws_member_real_name_auth_req.dart';
import 'package:frechat/models/ws_res/member/ws_member_info_res.dart';
import 'package:frechat/system/base_view_model.dart';
import 'package:frechat/system/call_back_function.dart';
import 'package:frechat/system/global.dart';
import 'package:frechat/system/provider/user_info_provider.dart';
import 'package:frechat/system/providers.dart';
import 'package:frechat/system/repository/response_code.dart';
import 'package:frechat/widgets/shared/dialog/check_dialog.dart';

class PersonalCertificationRealNameViewModel {
  PersonalCertificationRealNameViewModel({required this.ref, required this.setState});
  WidgetRef ref;
  ViewChange setState;

  late TextEditingController realNameTextController;
  late TextEditingController idTextController;

  init() {
    realNameTextController = TextEditingController();
    idTextController = TextEditingController();
  }

  dispose() {
    realNameTextController.dispose();
    idTextController.dispose();
  }

  Future<bool> sendRealNameAuth(BuildContext context) async {
    final String envStr = await AppConfig.getEnvStr();
    final WsMemberRealNameAuthReq reqBody = WsMemberRealNameAuthReq.create(
        env: envStr,
        realName: realNameTextController.text,
        idCardNumber: idTextController.text
    );
    String resultCheckCode = '';
    await ref.read(memberWsProvider).wsMemberRealNameAuth(reqBody,
        onConnectSuccess: (resultCode) async {
          resultCheckCode = resultCode;
        },
        onConnectFail: (resultCode) async {
          resultCheckCode = resultCode;
        }
    );

    if (resultCheckCode == ResponseCode.CODE_SUCCESS) {
      if (context.mounted) {
        await _loadMemberInfo(context);
      }
      if (context.mounted) {
        BaseViewModel.showToast(context, '认证成功');
      }
      return true;
    } else {
      //收起鍵盤
      FocusManager.instance.primaryFocus?.unfocus();
      if (context.mounted) {
        BaseViewModel.showToast(context, ResponseCode.getLocalizedDisplayStr(resultCheckCode));
        // await CheckDialog.show(context,
        //     titleText: '错误',
        //     messageText: ResponseCode.getLocalizedDisplayStr(resultCheckCode),
        //     confirmButtonText: '确认');
      }
      return false;
    }
  }

  //這會立即更新 memberInfo
  Future<void> _loadMemberInfo(BuildContext context) async {
    String? resultCodeCheck;
    final reqBody = WsMemberInfoReq.create();
    final WsMemberInfoRes res = await ref.read(memberWsProvider).wsMemberInfo(
        reqBody,
        onConnectSuccess: (succMsg) => resultCodeCheck = succMsg,
        onConnectFail: (errMsg) => BaseViewModel.showToast(context, errMsg)
    );
    if (resultCodeCheck == ResponseCode.CODE_SUCCESS) {
      ref.read(userUtilProvider.notifier).loadMemberInfo(res);
    }
  }
}