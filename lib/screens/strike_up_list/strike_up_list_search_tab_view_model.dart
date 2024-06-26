
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frechat/models/ws_req/member/ws_member_info_req.dart';
import 'package:frechat/models/ws_res/member/ws_member_fate_recommend_res.dart';
import 'package:frechat/models/ws_res/member/ws_member_info_res.dart';
import 'package:frechat/system/call_back_function.dart';
import 'package:frechat/system/providers.dart';
import 'package:frechat/system/repository/response_code.dart';
import 'package:frechat/system/task_manager/task_manager.dart';

import '../../system/base_view_model.dart';

class StrikeUpListSearchTabViewModel {
  StrikeUpListSearchTabViewModel({
    required this.ref,
    required this.setState,
  });
  WidgetRef ref;
  ViewChange setState;

  late TaskManager taskManager;
  FateListInfo? fateListInfo;

  init() {
    taskManager = TaskManager();
  }

  dispose() {}

  // API 2-2
  Future<void> searchMemberInfo({required String userName}) async {
    String resultCodeCheck = '';
    final WsMemberInfoReq reqBody = WsMemberInfoReq.create(userName: userName);

    final WsMemberInfoRes memberInfo = await ref.read(memberWsProvider).wsMemberInfo(reqBody,
        onConnectSuccess: (succMsg) => resultCodeCheck = succMsg,
        onConnectFail: (errMsg) => resultCodeCheck = errMsg
    );

    if (resultCodeCheck == ResponseCode.CODE_SUCCESS) {
      fateListInfo = FateListInfo(
          age: memberInfo?.age ?? 0,
          occupation: memberInfo?.occupation ?? '',
          nickName: memberInfo?.nickName ?? '',
          userName: memberInfo?.userName ?? '',
          weight: memberInfo?.weight ?? 0,
          height: memberInfo?.height ?? 0,
          selfIntroduction: memberInfo?.selfIntroduction ?? '',
          isOnline: memberInfo?.isOnline?.toInt() ?? 0,
          location: memberInfo?.location ?? '',
          realPersonAuth: memberInfo?.realPersonAuth ?? 0,
          realNameAuth: memberInfo?.realNameAuth ?? 0,
          avatar: memberInfo?.avatarPath,
          gender: memberInfo?.gender
      );
    } else {
      final BuildContext currentContext = BaseViewModel.getGlobalContext();
      if (currentContext.mounted) BaseViewModel.showToast(currentContext,  ResponseCode.map[resultCodeCheck]!);
    }

    setState(() {});
  }
}