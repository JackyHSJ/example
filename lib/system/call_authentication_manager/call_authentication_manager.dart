
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frechat/models/ws_req/account/ws_account_end_call_req.dart';
import 'package:frechat/models/ws_res/member/ws_member_info_res.dart';
import 'package:frechat/models/ws_res/notification/ws_notification_search_list_res.dart';
import 'package:frechat/screens/chatroom/chatroom.dart';
import 'package:frechat/screens/strike_up_list/mate/strike_up_list_mate_view_model.dart';
import 'package:frechat/system/base_view_model.dart';
import 'package:frechat/system/global.dart';
import 'package:frechat/system/provider/user_info_provider.dart';
import 'package:frechat/system/providers.dart';
import 'package:frechat/system/zego_call/interal/express/zego_express_service.dart';
import 'package:frechat/system/zego_call/interal/zim/call_data_manager.dart';
import 'package:frechat/system/zego_call/interal/zim/zim_service.dart';
import 'package:frechat/system/zego_call/interal/zim/zim_service_defines.dart';
import 'package:frechat/system/zego_call/zego_callback.dart';
import 'package:frechat/system/zego_call/zego_provider.dart';
import 'package:frechat/system/zego_call/zego_sdk_manager.dart';
import 'package:frechat/widgets/shared/pip/pip.dart';
import 'package:zego_express_engine/zego_express_engine.dart';

import '../constant/enum.dart';

class CallAuthenticationManager {
  CallAuthenticationManager({required this.ref});
  ProviderRef ref;

  List<ZegoStream> currentStreamList = [];

  Future<void> startCall({
    required ZegoCallType callType,
    required String invitedName,
    required String token,
    required String channel,
    required num callUserId,
    bool isOfflineCall = false,
    required bool isNeedLoading,
    required SearchListInfo searchListInfo,
    required WsMemberInfoRes otherMemberInfoRes
  }) async {
    final WsMemberInfoRes? myMemberInfo = ref.read(userInfoProvider).memberInfo;
    final String userName = myMemberInfo?.userName ?? '';
    final String nickName = myMemberInfo?.nickName ?? '';
    final SearchListInfo mySearchListInfo = SearchListInfo(userName: userName, userId: ref.read(userInfoProvider).userId, roomId: searchListInfo.roomId);
    final bool isStrikeUpMateMode = ref.read(userInfoProvider).isStrikeUpMateMode ?? false;
    final extendedData = jsonEncode({
      'type': callType.index,
      'inviterName': nickName,
      'callUserId': callUserId,
      'roomId': searchListInfo.roomId,
      'channel': channel,
      'token': token,
      'memberInfoRes': myMemberInfo,
      'SearchListInfo': mySearchListInfo,
      'isStrikeUpMateMode': isStrikeUpMateMode
    });
    final int timeOut = isStrikeUpMateMode ? 10 : 30;

    final ZIMService zimService = ref.read(zimServiceProvider);
    final ZegoSendInvitationResult result = await zimService.sendInvitation(
      invitees: [invitedName],
      callType: callType,
      extendedData: extendedData,
      isOfflineCall: isOfflineCall,
      timeout: timeOut,
    );

    if (result.error == null || result.error?.code == '0') {
      final bool isStrikeUpMode = ref.read(userInfoProvider).isStrikeUpMateMode ?? false;
      ref.read(zegoCallBackProvider).senderExtendData = extendedData;

      /// 速配模式下不推到等待頁面
      if(isStrikeUpMode) {
        return;
      }

      final ZegoCallBack callback = ref.read(zegoCallBackProvider);
      callback.pushToWaitingPage(
        token: token,
        channel: channel,
        roomID: searchListInfo.roomId!,
        isNeedLoading: isNeedLoading,
        memberInfoRes: otherMemberInfoRes,
        searchListInfo: searchListInfo,
        isEnabledMicSwitch: false,
        isEnabledCamSwitch: false,
      );
    } else {
      print('send call invitation failed: $result');
    }
  }

  ///結束通話
  Future<void> endCall(BuildContext context, {
    required ZegoCallData callData,
    required num roomId,
    required String channel,
    required SearchListInfo searchListInfo,
    required Function() onDispose
  }) async {

    final UserNotifier userUtil = ref.read(userUtilProvider.notifier);
    final ZEGOSDKManager manager = ref.read(zegoSDKManagerProvider);
    final ExpressService expressService = ref.read(expressServiceProvider);
    final bool isStrikeUpMateMode = ref.read(userInfoProvider).isStrikeUpMateMode ?? false;

    final bool isVideoCall = callData.callType == ZegoCallType.video;

    userUtil.setDataToPrefs(userCallStatus: UserCallStatus.init);

    /// 結束通話API
    // _endCall(channel: channel, roomId: roomId);

    /// 停止拉流 dispose
    for (ZegoStream zegoStream in currentStreamList) {
      expressService.stopPlayingStream(zegoStream.streamID);
    }

    expressService.stopPreview();
    expressService.stopPublishingStream();
    expressService.logoutRoom(channel);
    currentStreamList = [];

    if(isVideoCall) {
      manager.disposeZegoEffect();
    }

    final bool isPipMode = PipUtil.pipStatus == PipStatus.piping;
    if(isPipMode) {
      onDispose();
      PipUtil.exitPiPMode();
    } else {
      BaseViewModel.popupDialog();
      BaseViewModel.popPage(context);
    }

    /// 初始化pip status
    PipUtil.pipStatus = PipStatus.init;

    /// 速配聊天大於七秒則會直接進入聊天室
    /// 速配模式下，聊天大於七秒則會寫入DB
    if(isStrikeUpMateMode) {
      Widget chatRoom = _getChatRoom(searchListInfo: searchListInfo);
      BaseViewModel.pushReplacement(context, chatRoom);
      return;
    }

    /// 速配彈窗
    _closeStrikeUpMateDialog(isStrikeUpMateMode);
  }

  void cancelInvitedCall(BuildContext context, {
    required ZegoCallData callData,
    required String? channel,
    required num roomId
}) {
    ref.read(userUtilProvider.notifier).setDataToPrefs(userCallStatus: UserCallStatus.init);

    final zimService = ref.read(zimServiceProvider);
    zimService.cancelInvitation(
      invitationID: callData.callID,
      invitees: [callData.invitee.userID],
    );

    if(channel != null) {
      _endCall(channel: channel, roomId: roomId);
    }

    BaseViewModel.popPage(context);
  }

  /// 關閉 速配彈窗
  void _closeStrikeUpMateDialog(bool isStrikeUpMateMode) {
    if(isStrikeUpMateMode) {
      StrikeUpListMateViewModel.stateController.sink.add(MateState.close);
    }
  }

  void _endCall ({
    required num roomId,
    required String channel
  }) {
    final WsAccountEndCallReq endCallReq = WsAccountEndCallReq(roomId: roomId, channel: channel);
    ref.read(accountWsProvider).wsAccountEndCall(endCallReq,
        onConnectSuccess: (succMsg) { },
        onConnectFail: (succMsg) { }
    );
  }

  static Widget _getChatRoom({required SearchListInfo searchListInfo}) {
    Widget chatRoom = ChatRoom(searchListInfo: searchListInfo,);
    if(GlobalData.chatRoom != null) {
      chatRoom = (GlobalData.chatRoom as dynamic)
        ..searchListInfo =searchListInfo;
    }
    return chatRoom;
  }
}