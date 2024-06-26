

import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frechat/models/ws_res/member/ws_member_info_res.dart';
import 'package:frechat/models/ws_res/notification/ws_notification_search_list_res.dart';
import 'package:frechat/system/base_view_model.dart';
import 'package:frechat/system/constant/enum.dart';
import 'package:frechat/system/database/model/zego_beauty_model.dart';
import 'package:frechat/system/global.dart';
import 'package:frechat/system/provider/zego_beauty_model_provider.dart';
import 'package:frechat/system/providers.dart';
import 'package:frechat/system/repository/response_code.dart';
import 'package:frechat/system/util/permission_util.dart';
import 'package:frechat/system/util/timer.dart';
import 'package:frechat/system/zego_call/interal/effects/beauty_ability/zego_beauty_ability.dart';
import 'package:frechat/system/zego_call/interal/effects/beauty_ability/zego_beauty_type.dart';
import 'package:frechat/system/zego_call/interal/effects/zego_effects_service.dart';
import 'package:frechat/system/zego_call/interal/express/zego_express_service.dart';
import 'package:frechat/system/zego_call/interal/zim/call_data_manager.dart';
import 'package:frechat/system/zego_call/model/zego_user_model.dart';
import 'package:frechat/system/zego_call/zego_callback.dart';
import 'package:frechat/system/zego_call/zego_provider.dart';
import 'package:frechat/system/zego_call/zego_sdk_manager.dart';
import 'package:frechat/widgets/receiver_alertdialog/receiver_alertdialog.dart';
import 'package:frechat/widgets/shared/dialog/base_dialog.dart';

class WaitingPageViewModel {
  WaitingPageViewModel({required this.ref});
  WidgetRef ref;

  Timer? _emptyCountDownTimer;

  initBeauty() async {
    await _permissionRequest();
    final ZEGOSDKManager manager = ref.read(zegoSDKManagerProvider);
    final ExpressService expressService = ref.read(expressServiceProvider);
    await manager.initZegoEffect();
    expressService.turnCameraOn(true);
    await expressService.startPreview();
    manager.loadDbDateToCurrentValue();
  }

  void loadCache({
    required ZegoCallData callData,
    required ZegoUserInfo otherUserInfo,
    required String token,
    required String channel,
    required num roomID,
    required WsMemberInfoRes memberInfoRes,
    required SearchListInfo searchListInfo,
  }) {
    GlobalData.cacheCallData = callData;
    GlobalData.cacheOtherUserInfo = otherUserInfo;
    GlobalData.cacheToken = token;
    GlobalData.cacheChannel = channel;
    GlobalData.cacheRoomID = roomID;
    GlobalData.cacheMemberInfoRes = memberInfoRes;
    GlobalData.cacheSearchListInfo = searchListInfo;
  }

  Future<void> _permissionRequest() async {
    await PermissionUtil.checkAndRequestCameraPermission();
    await PermissionUtil.checkAndRequestMicrophonePermission();
  }

  initEmptyTimer(BuildContext context) {
    if(_emptyCountDownTimer != null) {
      return;
    }
    _emptyCountDownTimer = TimerUtil.periodic(
      timerType: TimerType.seconds,
      timerNum: 5,
      timerCallback: (time) {
        BaseViewModel.popPage(context);
        BaseViewModel.showToast(context, ResponseCode.MEMBER_BUSY);
      });
  }

  disposeEmptyTimer() {
    if(_emptyCountDownTimer != null) {
      _emptyCountDownTimer?.cancel();
      _emptyCountDownTimer = null;
    }
  }

  checkHaveOnHoldWithWaitingCall() {
    final UserCallStatus userCallStatus = ref.read(userInfoProvider).userCallStatus ?? UserCallStatus.init;
    if(userCallStatus == UserCallStatus.callOnHoldWithWaitingCall) {
      _buildReceiverAlertDialog();
    }
  }

  _buildReceiverAlertDialog() {
    final BuildContext currentContext = BaseViewModel.getGlobalContext();
    final ZegoCallBack callBack = ref.read(zegoCallBackProvider);
    BaseDialog(currentContext).showTransparentDialog(
        isDialogCancel: false,
        widget: ReceiverAlertDialog(
            wsMemberInfoRes: callBack.cacheMemberInfoRes, chatType: callBack.cacheData["type"],
            channel: callBack.cacheData['channel'], roomID: callBack.cacheData['roomId'],
            onAcceptCallback: (rtcRes) => callBack.acceptCall(rtcRes, extendData: callBack.cacheExtendData),
            onRejectCallback: callBack.rejectCall,
            callUserId: callBack.cacheData['callUserId'],
            invitationData: ZegoCallStateManager.instance.callData!,
            isStrikeUpMateMode: callBack.cacheData['isStrikeUpMateMode']
        )
    );
  }
}