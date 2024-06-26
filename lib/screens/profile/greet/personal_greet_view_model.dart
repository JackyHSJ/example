

import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frechat/models/ws_req/greet/ws_greet_module_list_req.dart';
import 'package:frechat/models/ws_req/greet/ws_greet_module_use_req.dart';
import 'package:frechat/models/ws_res/greet/ws_greet_module_list_res.dart';
import 'package:frechat/models/ws_res/greet/ws_greet_module_use_res.dart';
import 'package:frechat/system/base_view_model.dart';
import 'package:frechat/system/call_back_function.dart';
import 'package:frechat/system/provider/user_info_provider.dart';
import 'package:frechat/system/providers.dart';
import 'package:frechat/system/repository/response_code.dart';
import 'package:frechat/widgets/shared/dialog/check_dialog.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frechat/widgets/shared/dialog/comm_dialog.dart';
import 'package:frechat/widgets/theme/original/app_colors.dart';

class PersonalGreetViewModel {
  PersonalGreetViewModel({
    required this.ref,
    required this.setState
  });
  ViewChange setState;
  WidgetRef ref;
  List<GreetModuleInfo> greetList = [];
  int key = 0;

  init(BuildContext context) {
    getGreetList(context);
  }

  getGreetList(BuildContext context) async {
    final WsGreetModuleListReq reqBody = WsGreetModuleListReq.create();
    String? resultCodeCheck;
    final WsGreetModuleListRes res = await ref.read(greetWsProvider).wsGreetModuleList(reqBody,
        onConnectSuccess: (succMsg) => resultCodeCheck = succMsg,
        onConnectFail: (errMsg) => BaseViewModel.showToast(context, ResponseCode.map[errMsg]!)
    );

    if(resultCodeCheck == ResponseCode.CODE_SUCCESS) {
      greetList = res.list ?? [];
      ref.read(userUtilProvider.notifier).loadGreetInfo(res);
    }
  }

  useGreet(BuildContext context, {
    num? id,
    num? status,
    required Function() onShowAuthDialog
  }) async {
    key++;
    final WsGreetModuleUseReq reqBody = WsGreetModuleUseReq.create(id: id, status: status);
    await ref.read(greetWsProvider).wsGreetModuleUse(reqBody,
    onConnectSuccess: (succMsg) => getGreetList(context),
    onConnectFail: (errMsg) {
      BaseViewModel.showToast(context, ResponseCode.map[errMsg]!);
      if(errMsg == ResponseCode.CODE_GREETING_TEMPLATE_UNAVAILABLE) {
        onShowAuthDialog();
      }
    });
  }
}
