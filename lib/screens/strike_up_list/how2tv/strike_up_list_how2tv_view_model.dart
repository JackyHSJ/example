import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frechat/models/ws_res/account/ws_account_on_tv_res.dart';
import 'package:frechat/system/call_back_function.dart';
import 'package:frechat/system/providers.dart';
import 'package:frechat/system/ws_comm/ws_params_req.dart';

import '../../../models/req/account_modify_user_req.dart';
import '../../../models/ws_req/member/ws_member_info_req.dart';
import '../../../models/ws_res/member/ws_member_info_res.dart';
import '../../../system/base_view_model.dart';
import '../../../system/provider/user_info_provider.dart';
import '../../../system/repository/response_code.dart';

class StrikeUpListHowToTvViewModel {
  StrikeUpListHowToTvViewModel({
    required this.setState,
    required this.ref,
    required this.context,
  });
  WidgetRef ref;
  ViewChange setState;
  BuildContext context;

  bool _isWantOnTv = true;

  set isWantOnTv(bool value) {
    String? resultCodeCheck;
    _isWantOnTv = value;
    editWantOnTv(
        onConnectFail: (errMsg) => BaseViewModel.showToast(context, ResponseCode.map[errMsg]!),
        onConnectSuccess: (succMsg) => BaseViewModel.showToast(context, succMsg));
  }

  bool get isWantOnTv {
    return _isWantOnTv;
  }

  editWantOnTv({required Function(String) onConnectFail, required Function(String) onConnectSuccess}) async {
    String? resultCodeCheck;
    final String? commToken = ref.read(userInfoProvider).commToken;

    MemberModifyUserReq req = MemberModifyUserReq.create(
      tId: commToken ?? 'emptyToken',
      tvStatus: _isWantOnTv ? 2 : 1,
    );

    final res = await ref
        .read(commApiProvider)
        .memberModifyUser(req, onConnectSuccess: (succMsg) => resultCodeCheck = succMsg, onConnectFail: (errMsg) => onConnectFail(errMsg));

    if (resultCodeCheck == ResponseCode.CODE_SUCCESS) {
      onConnectSuccess('已设置成功');
    }
  }

  Future<void> loadMemberInfo(BuildContext context) async {
    String? resultCodeCheck;
    final reqBody = WsMemberInfoReq.create();
    final WsMemberInfoRes res = await ref
        .read(memberWsProvider)
        .wsMemberInfo(reqBody, onConnectSuccess: (succMsg) => resultCodeCheck = succMsg, onConnectFail: (errMsg) => BaseViewModel.showToast(context, errMsg));
    if (resultCodeCheck == ResponseCode.CODE_SUCCESS) {
      ref.read(userUtilProvider.notifier).loadMemberInfo(res);
      _isWantOnTv = res.tvStatus == 2;
      setState(() {});
    }
  }
}
