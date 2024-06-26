

import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frechat/models/user_info_model.dart';
import 'package:frechat/models/ws_req/member/ws_member_new_user_to_top_list_req.dart';
import 'package:frechat/models/ws_res/member/ws_member_new_user_to_top_list_res.dart';
import 'package:frechat/models/ws_res/ws_hand_shake_res.dart';
import 'package:frechat/system/constant/enum.dart';
import 'package:frechat/system/database/model/new_user_behavior_tracker_model.dart';
import 'package:frechat/system/provider/new_user_behavior_model_provider.dart';
import 'package:frechat/system/providers.dart';
import 'package:frechat/system/repository/response_code.dart';
import 'package:frechat/system/websocket/websocket_setting.dart';
import 'package:zyg_websocket_plugin/status.dart';

class NewUserBehaviorTrackerManager {
  NewUserBehaviorTrackerManager({required this.ref});
  ProviderRef ref;

  StreamController<NewUserBehaviorState> stateController = StreamController.broadcast();
  StreamSubscription? streamSubscription;

  init() {
    final UserInfoModel userInfoModel = ref.read(userInfoProvider);
    final OrderComputeConditionInfo? conditionInfo = userInfoModel.orderComputeCondition;
    final NewUserBehaviorTrackerModel newUserInfoBehavior = _getNewUserInfo(userInfoModel);

    final num status = newUserInfoBehavior.status ?? 0;
    final bool isExpired = _checkIsExpired(userInfoModel);
    /// 0: 未傳送過, 1: 已過期 or 已傳送
    /// 0 未傳送過 才有接下去的執行
    if(status != 0 || isExpired == true) {
      final NewUserBehaviorTrackerModel model = NewUserBehaviorTrackerModel(
        userName: newUserInfoBehavior.userName,
        status: 1,
        onlineDuration: conditionInfo?.onlineDuration ?? 0,
        regTimeLimit: conditionInfo?.pickupCount ?? 0,
        pickupCount: conditionInfo?.pickupCount ?? 0,
      );
      ref.read(newUserBehaviorModelNotifierProvider.notifier).setDataToSql(newUserBehaviorModelList: [model]);
      return ;
    }

    _initListener();
  }

  _initListener() {
    if(streamSubscription != null) {
      return ;
    }

    streamSubscription = stateController.stream.listen((state) async {
      if(state == NewUserBehaviorState.strike) {
        await _strikeUp();
      }

      if(state == NewUserBehaviorState.onlineDuration) {
        await _onlineDuration();
      }
    });
  }

  dispose() {
    _disposeListener();
  }

  _disposeListener() {
    if(streamSubscription == null) {
      return ;
    }
    streamSubscription?.cancel();
    streamSubscription = null;
  }

  _strikeUp() async {
    /// 檢查是否過期或傳送過
    final UserInfoModel userInfoModel = ref.read(userInfoProvider);
    final NewUserBehaviorTrackerModel newUserInfoBehavior = _getNewUserInfo(userInfoModel);
    final num status = newUserInfoBehavior.status ?? 0;
    if(status != 0) {
      return ;
    }

    num onlineDuration = newUserInfoBehavior.onlineDuration ?? 0;
    num pickupCount = newUserInfoBehavior.pickupCount ?? 0;
    pickupCount ++;
    final NewUserBehaviorTrackerModel model = NewUserBehaviorTrackerModel(
      status: 0,
      userName: userInfoModel.userName,
      pickupCount: pickupCount,
      onlineDuration: onlineDuration
    );
    await ref.read(newUserBehaviorModelNotifierProvider.notifier).setDataToSql(newUserBehaviorModelList: [model]);

    await _checkConditionToSendReq(model);
  }

  _onlineDuration() async {
    /// 檢查是否過期或傳送過
    final UserInfoModel userInfoModel = ref.read(userInfoProvider);
    final NewUserBehaviorTrackerModel newUserInfoBehavior = _getNewUserInfo(userInfoModel);
    final num status = newUserInfoBehavior.status ?? 0;
    if(status != 0) {
      return ;
    }

    num onlineDuration = newUserInfoBehavior.onlineDuration ?? 0;
    num pickupCount = newUserInfoBehavior.pickupCount ?? 0;
    onlineDuration ++;
    final NewUserBehaviorTrackerModel model = NewUserBehaviorTrackerModel(
      status: 0,
      userName: userInfoModel.userName,
      onlineDuration: onlineDuration,
      pickupCount: pickupCount
    );
    await ref.read(newUserBehaviorModelNotifierProvider.notifier).setDataToSql(newUserBehaviorModelList: [model]);

    await _checkConditionToSendReq(model);
  }

  Future<void> _req() async {
    final WsMemberNewUserToTopListReq reqBody = WsMemberNewUserToTopListReq.create();
    final WsMemberNewUserToTopListRes res = await ref.read(memberWsProvider).wsMemberNewUserToTopList(reqBody,
        onConnectSuccess: (succMsg){},
        onConnectFail: (errMsg){}
    );

    if(res != WsMemberNewUserToTopListRes()) {
      final UserInfoModel userInfoModel = ref.read(userInfoProvider);
      final NewUserBehaviorTrackerModel model = NewUserBehaviorTrackerModel(
        userName: userInfoModel.userName,
        status: 1
      );
      await ref.read(newUserBehaviorModelNotifierProvider.notifier).setDataToSql(newUserBehaviorModelList: [model]);
    }
  }

  NewUserBehaviorTrackerModel _getNewUserInfo (UserInfoModel userInfoModel) {
    final List<NewUserBehaviorTrackerModel> newUserInfoBehaviorList = ref.read(newUserBehaviorModelNotifierProvider);
    final String userName = userInfoModel.memberInfo?.userName ?? '';

    NewUserBehaviorTrackerModel? newUserInfoBehavior;
    try {
      newUserInfoBehavior = newUserInfoBehaviorList.firstWhere((info) => info.userName == userName);
    } catch (e) {
      newUserInfoBehavior = NewUserBehaviorTrackerModel(
          userName: userName
      );
      ref.read(newUserBehaviorModelNotifierProvider.notifier).setDataToSql(newUserBehaviorModelList: [newUserInfoBehavior]);
    }

    return newUserInfoBehavior;
  }

  bool _checkIsExpired(UserInfoModel userInfoModel) {
    final int regTimestamp = userInfoModel.memberInfo?.regTime ?? 0;
    final num regTimeLimit = userInfoModel.orderComputeCondition?.regTimeLimit ?? 0;
    final int regTimestampLimit = Duration(days: regTimeLimit.toInt()).inMilliseconds;
    final num expireTimestamp = regTimestamp + regTimestampLimit;
    final bool isExpired = DateTime.now().millisecondsSinceEpoch > expireTimestamp;
    return isExpired;
  }

  Future<void> _checkConditionToSendReq(NewUserBehaviorTrackerModel newUserInfoBehavior) async {
    final UserInfoModel userInfoModel = ref.read(userInfoProvider);
    final bool isPass = _checkConditionIsPass(userInfoModel: userInfoModel, newUserInfoBehavior: newUserInfoBehavior);
    if(isPass == true) {
      await _req();
    }
  }

  bool _checkConditionIsPass({
    required UserInfoModel userInfoModel,
    required NewUserBehaviorTrackerModel newUserInfoBehavior
  }) {
    final num pickupCountCondition = userInfoModel.orderComputeCondition?.pickupCount ?? 0;
    final num onlineDurationHourCondition = userInfoModel.orderComputeCondition?.onlineDuration ?? 0;
    final num pickupCount = newUserInfoBehavior.pickupCount ?? 0;
    final num onlineDuration = newUserInfoBehavior.onlineDuration ?? 0;

    final num onlineDurationCondition = onlineDurationHourCondition * 3600 / WebSocketSetting.heartTimes;

    if(onlineDuration >= onlineDurationCondition && pickupCount >= pickupCountCondition) {
      return true;
    }
    return false;
  }
}