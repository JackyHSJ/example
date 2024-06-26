import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frechat/models/ws_req/check_in/ws_check_in_req.dart';
import 'package:frechat/models/ws_req/check_in/ws_check_in_search_list_req.dart';
import 'package:frechat/models/ws_req/member/ws_member_point_coin_req.dart';
import 'package:frechat/models/ws_res/check_in/ws_check_in_search_list_res.dart';
import 'package:frechat/models/ws_res/member/ws_member_point_coin_res.dart';
import 'package:frechat/system/base_view_model.dart';
import 'package:frechat/system/call_back_function.dart';
import 'package:frechat/system/provider/user_info_provider.dart';
import 'package:frechat/system/providers.dart';
import 'package:frechat/system/repository/response_code.dart';

import '../../../models/ws_req/account/ws_account_get_gift_detail_req.dart';
import '../../../models/ws_res/account/ws_account_get_gift_detail_res.dart';

class PersonalCheckInViewModel {
  // static WsCheckInSearchListRes? checkInInfo;
  // static bool isLoading = true;
  static WsAccountGetGiftDetailRes? giftInfo;

  static bool todayIsAlreadyCheck(WidgetRef ref) {
    final WsCheckInSearchListRes? checkInInfo = ref.read(userInfoProvider).checkInSearchList;
    num today = checkInInfo?.todayCount ?? 0;
    today = _checkTodayCount(today);
    final getTodayFormList = checkInInfo?.list?.firstWhere((info) => info.day == today);
    return getTodayFormList?.punchInFlag == 1;
  }

  /// 檢查日期1~7 大於8則給7
  static num _checkTodayCount(today) {
    if(today > 7) {
      return 7;
    }
    return today;
  }

  static init(BuildContext context, WidgetRef ref, ViewChange setState) async {
    _getCheckInInfo(context, ref, setState);
  }

  static Future<void> _getCheckInInfo(BuildContext context, WidgetRef ref, ViewChange setState) async {
    String? resultCodeCheck;
    final reqBody = WsCheckInSearchListReq.create();
    final res = await ref.read(checkInWsProvider).wsCheckInSearchList(reqBody,
        onConnectSuccess: (succMsg) => resultCodeCheck = succMsg, onConnectFail: (errMsg) => BaseViewModel.showToast(context, ResponseCode.map[errMsg]!));

    if (resultCodeCheck == ResponseCode.CODE_SUCCESS) {
      ref.read(userUtilProvider.notifier).loadCheckInSearchList(res);
    }
  }

  static Future<void> checkIn(BuildContext context, WidgetRef ref, ViewChange setState, {required Function(String) onConnectSuccess}) async {
    final WsCheckInReq reqBody = WsCheckInReq.create();
    await ref.read(checkInWsProvider).wsCheckIn(reqBody,
      onConnectSuccess: (succMsg) {
        WsCheckInSearchListRes? checkInInfo = ref.read(userInfoProvider).checkInSearchList;
        final num today = checkInInfo?.todayCount ?? 0;
        final int index = checkInInfo?.list?.indexWhere((info) => info.day == today) ?? 0;
        if (index == -1) {
          return;
        }
        checkInInfo?.list?[index].punchInFlag = 1;
        checkInInfo?.continuousNum = (checkInInfo.continuousNum ?? 0) + 1;

        ref.read(userUtilProvider.notifier).loadCheckInSearchList(checkInInfo ?? WsCheckInSearchListRes());
        onConnectSuccess(succMsg);
      },
      onConnectFail: (errMsg) => BaseViewModel.showToast(context, ResponseCode.map[errMsg]!));
  }

  static loadPropertyInfo(BuildContext context, {
    required WidgetRef ref
  }) async {
    String? resultCodeCheck;
    final reqBody = WsMemberPointCoinReq.create();
    final WsMemberPointCoinRes res = await ref.read(memberWsProvider).wsMemberPointCoin(
        reqBody,
        onConnectSuccess: (succMsg) => resultCodeCheck = succMsg,
        onConnectFail: (errMsg) => BaseViewModel.showToast(context, ResponseCode.map[errMsg]!));
    if (resultCodeCheck == ResponseCode.CODE_SUCCESS) {
      ref.read(userUtilProvider.notifier).loadMemberPointCoin(res);
    }
  }
}
