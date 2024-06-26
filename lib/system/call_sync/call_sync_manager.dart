

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frechat/models/user_info_model.dart';
import 'package:frechat/system/base_view_model.dart';
import 'package:frechat/system/call_authentication_manager/call_authentication_manager.dart';
import 'package:frechat/system/call_sync/call_sync_setting.dart';
import 'package:frechat/system/constant/enum.dart';
import 'package:frechat/system/global.dart';
import 'package:frechat/system/network_status/network_status_setting.dart';
import 'package:frechat/system/providers.dart';
import 'package:frechat/system/util/timer.dart';
import 'package:frechat/system/zego_call/interal/express/express_util.dart';
import 'package:frechat/system/zego_call/interal/express/zego_express_service.dart';
import 'package:frechat/system/zego_call/interal/express/zego_express_service_defines.dart';
import 'package:frechat/system/zego_call/interal/zim/zim_service.dart';
import 'package:frechat/system/zego_call/interal/zim/zim_service_defines.dart';
import 'package:frechat/system/zego_call/zego_provider.dart';
import 'package:frechat/system/zego_call/zego_sdk_manager.dart';
import 'package:frechat/widgets/shared/pip/pip.dart';
import 'package:zego_express_engine/zego_express_engine.dart';

class CallSyncManager {

  CallSyncManager({required this.ref});
  ProviderRef ref;
  Timer? _timer;

  init() {
    initTimer();
  }

  dispose() {
    disposeTimer();
  }

  /// Init timer
  void initTimer() {
    if(_timer != null) {
      return;
    }
    _timer = TimerUtil.periodic(
        timerType: CallSyncSetting.timerType,
        timerNum: CallSyncSetting.timerPeriodic,
        timerCallback: (time) => _checkSyncCallStatus()
    );
  }

  void disposeTimer() {
    if(_timer == null) {
      return ;
    }
    _timer?.cancel();
    _timer = null;
  }

  void _checkSyncCallStatus() {
    final UserInfoModel userInfo = ref.read(userInfoProvider);
    final CallAuthenticationManager callManager = ref.read(callAuthenticationManagerProvider);
    final ExpressUtil expressUtil = ref.read(expressUtilProvider);
    final UserCallStatus clientCallStatus = userInfo.userCallStatus ?? UserCallStatus.init;

    /// client狀態為掛電話狀態
    if(clientCallStatus == UserCallStatus.init) {
      _endZegoCall(callManager: callManager, expressUtil: expressUtil);
    }
  }

  void _endZegoCall({
    required CallAuthenticationManager callManager,
    required ExpressUtil expressUtil
  }) {
    if(callManager.currentStreamList == [] || callManager.currentStreamList.isEmpty) {
      return ;
    }

    // final ZIMService zimService = ref.read(zimServiceProvider);
    // final ExpressService expressService = ref.read(expressServiceProvider);
    // final ZEGOSDKManager manager = ref.read(zegoSDKManagerProvider);
    final String channel = GlobalData.cacheChannel ?? '';
    // final String invitationID = GlobalData.cacheCallData?.callID ?? '';
    // final String inviteeUserID = GlobalData.cacheCallData?.invitee.userID ?? '';

    // zimService.cancelInvitation(
    //   invitationID: invitationID,
    //   invitees: [inviteeUserID],
    // );

    /// 停止拉流 dispose
    final BuildContext currentContext = BaseViewModel.getGlobalContext();
    callManager.endCall(
        currentContext,
        callData: GlobalData.cacheCallData!,
        roomId: GlobalData.cacheRoomID!,
        channel: channel,
        searchListInfo: GlobalData.cacheSearchListInfo!,
        onDispose: () {
          ///
        }
    );
    expressUtil.dispose();
  }
}