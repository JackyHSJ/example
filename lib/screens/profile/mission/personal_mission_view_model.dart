import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frechat/models/ws_req/withdraw/ws_withdraw_recharge_reward_req.dart';
import 'package:frechat/models/ws_res/withdraw/ws_withdraw_recharge_reward_res.dart';
import 'package:frechat/system/provider/user_info_provider.dart';

import 'package:frechat/system/providers.dart';
import 'package:frechat/system/repository/response_code.dart';
import 'package:frechat/system/base_view_model.dart';
import 'package:frechat/system/call_back_function.dart';

import 'package:frechat/models/ws_req/mission/ws_mission_search_status_req.dart';
import 'package:frechat/models/ws_res/mission/ws_mission_search_status_res.dart';
import 'package:frechat/models/ws_req/member/ws_member_point_coin_req.dart';
import 'package:frechat/models/ws_res/member/ws_member_point_coin_res.dart';

class PersonalMissionViewModel {
  PersonalMissionViewModel({required this.ref, required this.setState});
  WidgetRef ref;
  ViewChange setState;

  // WsMissionSearchStatusRes? missionStatusInfo;
  // WsMemberPointCoinRes? memberPointCoinInfo;

  List<MissionStatusList>? missionList = [];

  num? gender = 0;

  Future<void> init(BuildContext context) async {

    gender = ref.read(userInfoProvider).memberInfo?.gender ?? 0;

    final futures = [
      _searchMissionList(context),
      _getMemberCoinsOrPointsData(context)
    ];

    try {
      await Future.wait(futures);
      print('所有 Future 都已完成');
    } catch (e) {
      print('一个或多个 Future 失败: $e');
    }
  }

  void dispose() {
    print('dispose');
  }

  Future<void> _getMemberCoinsOrPointsData(BuildContext context) async {
    String? resultCodeCheck;

    WsMemberPointCoinReq reqBody = WsMemberPointCoinReq.create();
    final res = await ref.read(memberWsProvider).wsMemberPointCoin(reqBody,
        onConnectSuccess: (succMsg) => resultCodeCheck = succMsg,
        onConnectFail: (errMsg) => BaseViewModel.showToast(context, ResponseCode.map[errMsg]!));

    if (resultCodeCheck == ResponseCode.CODE_SUCCESS) {
      ref.read(userUtilProvider.notifier).loadMemberPointCoin(res);
    }
  }

  Future<void>  _searchMissionList(BuildContext context) async {
    String? resultCodeCheck;

    WsMissionSearchStatusReq reqBody = WsMissionSearchStatusReq.create();
    final res = await ref.read(missionWsProvider).wsMissionSearchStatus(reqBody,
        onConnectSuccess: (succMsg) => resultCodeCheck = succMsg,
        onConnectFail: (errMsg) => BaseViewModel.showToast(context, ResponseCode.map[errMsg]!));

    if (resultCodeCheck == ResponseCode.CODE_SUCCESS) {
      ref.read(userUtilProvider.notifier).loadMissionInfo(res);
    }
  }

  Future<void>  getWithdrawRechargeReward() async {
    String resultCodeCheck = '';
    final WsWithdrawRechargeRewardReq reqBody = WsWithdrawRechargeRewardReq.create();

    final WsWithdrawRechargeRewardRes res = await ref.read(withdrawWsProvider).wsWithdrawRechargeReward(reqBody,
        onConnectSuccess: (succMsg) => resultCodeCheck = succMsg,
        onConnectFail: (errMsg) => resultCodeCheck = errMsg
    );
  }




}
