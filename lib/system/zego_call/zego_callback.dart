import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frechat/models/user_info_model.dart';
import 'package:frechat/models/ws_req/account/ws_account_end_call_req.dart';
import 'package:frechat/models/ws_req/member/ws_member_info_req.dart';
import 'package:frechat/models/ws_req/notification/ws_notification_search_list_req.dart';
import 'package:frechat/models/ws_res/account/ws_account_get_rtc_token_res.dart';
import 'package:frechat/models/ws_res/member/ws_member_info_res.dart';
import 'package:frechat/models/ws_res/notification/ws_notification_search_list_res.dart';
import 'package:frechat/screens/call/calling_page.dart';
import 'package:frechat/screens/call/waiting_page/waiting_page.dart';
import 'package:frechat/screens/strike_up_list/mate/strike_up_list_mate_view_model.dart';
import 'package:frechat/system/base_view_model.dart';
import 'package:frechat/system/constant/enum.dart';
import 'package:frechat/system/global.dart';
import 'package:frechat/system/global/shared_preferance.dart';
import 'package:frechat/system/notification/notification_manager.dart';
import 'package:frechat/system/provider/user_info_provider.dart';
import 'package:frechat/system/util/audioplayer_util.dart';
import 'package:frechat/system/util/recharge_util.dart';
import 'package:frechat/system/ws_comm/ws_account.dart';
import 'package:frechat/system/zego_call/interal/zim/call_data_manager.dart';
import 'package:frechat/system/zego_call/interal/zim/zim_service.dart';
import 'package:frechat/system/zego_call/interal/zim/zim_service_defines.dart';
import 'package:frechat/system/zego_call/interal/zim/zim_util.dart';
import 'package:frechat/system/zego_call/model/zego_user_model.dart';
import 'package:frechat/system/zego_call/zego_provider.dart';
import 'package:frechat/widgets/receiver_alertdialog/receiver_alertdialog.dart';
import 'package:frechat/widgets/shared/dialog/base_dialog.dart';
import '../providers.dart';

class ZegoCallBack {
  ZegoCallBack({
    required this.ref,
  }) {
    accountWs = ref.read(accountWsProvider);
  }

  ProviderRef ref;

  String senderExtendData = '';

  String cacheExtendData = '';
  WsMemberInfoRes cacheMemberInfoRes = WsMemberInfoRes();
  Map<String, dynamic> cacheData = {};
  static OfflineCallType type = OfflineCallType.none;
  late AccountWs accountWs;

  Future<void> onIncomingCallInvitationReceived(IncomingCallInvitationReveivedEvent event) async {

    // 青少年模式開啟，消息全部檔住
    bool teenMode = await FcPrefs.getTeenMode();
    if (teenMode) return;

    final String extendedData = event.extendedData;
    cacheData = json.decode(extendedData ?? '');
    final currentContext = BaseViewModel.getGlobalContext();
    /// build search list info
    cacheData['SearchListInfo'] = SearchListInfo(
      roomId: cacheData['roomId'],
      userName: cacheData['memberInfoRes']['userName'],
      userId: cacheData['callUserId'],
      roomName: cacheData['memberInfoRes']['nickName'], // http://redmine.zyg.com.tw/issues/1573
    ).toJson();
    cacheExtendData = json.encode(cacheData);
    cacheMemberInfoRes = WsMemberInfoRes.fromJson(cacheData['memberInfoRes']);

    final UserInfoModel userInfo = ref.read(userInfoProvider);
    /// 速配來電時推回主頁顯示彈窗
    final bool isStrikeUpMateMode = userInfo.isStrikeUpMateMode ?? false;
    if(isStrikeUpMateMode){
      BaseViewModel.popPage(currentContext);
      BaseViewModel.popPage(currentContext);
    }

    /// 收到來電訊息的狀態
    ref.read(userUtilProvider.notifier).setDataToPrefs(userCallStatus: UserCallStatus.incomingRinging);

    /// 假通話模式下被插播通話用
    final UserCallStatus userCallStatus = userInfo.userCallStatus ?? UserCallStatus.init;
    if(userCallStatus == UserCallStatus.emptyCall) {
      ref.read(userUtilProvider.notifier).setDataToPrefs(userCallStatus: UserCallStatus.callOnHoldWithWaitingCall);
      return ;
    }

    // https://o411cvvunt4.sg.larksuite.com/docx/OgnDd1tfVo3IYnxUbpmlKdnNg8f
    // http://redmine.zyg.com.tw/issues/1290
    // 針對當前頁面是美顏設置的話，會把美顏設置 popup 再 push 來電彈窗。
    BaseViewModel.popupPageOnCalling('PersonalSettingBeauty');

    // 在充值彈窗中收到來電，會先 popupDialog
    final bool rechargeBottomSheet = RechargeUtil.rechargeBottomSheet;
    if (rechargeBottomSheet) BaseViewModel.popupDialog();

    await NotificationManager.checkAndNavigationCallingPage();

    /// 點擊推播快速開啟通話
    // if(ZegoCallBack.type == OfflineCallType.accept) {
    //   final ZIMUtil zimUtil = ref.read(zimUtilProvider);
    //   final WsAccountGetRTCTokenRes? rtcRes = await zimUtil.acceptCall(invitationData: ZegoCallStateManager.instance.callData!, roomID: cacheData['roomId'], callUserId: cacheData['callUserId']);
    //   if(rtcRes == null) {
    //     return ;
    //   }
    //   acceptCall(rtcRes, extendData: cacheExtendData);
    //   return;
    // }

    /// 點擊推播快速關閉通話
    if(ZegoCallBack.type == OfflineCallType.handout) {
      final ZIMUtil zimUtil = ref.read(zimUtilProvider);
      await zimUtil.endCall(channel: cacheData['channel'], roomID: cacheData['roomId']);
      rejectCall();
      return;
    }

    BaseDialog(currentContext).showTransparentDialog(
      isDialogCancel: false,
        widget: ReceiverAlertDialog(wsMemberInfoRes: cacheMemberInfoRes,chatType: cacheData["type"], channel: cacheData['channel'],
          roomID: cacheData['roomId'], onAcceptCallback: (rtcRes) => acceptCall(rtcRes, extendData: cacheExtendData), onRejectCallback: rejectCall,
          callUserId: cacheData['callUserId'], invitationData: ZegoCallStateManager.instance.callData!, isStrikeUpMateMode: cacheData['isStrikeUpMateMode']
        )
    );
  }

  Future<void> acceptCall(WsAccountGetRTCTokenRes rtcRes, {required String extendData}) async {
    hideIncomingCallDialog();

    final ZIMService zimService = ref.read(zimServiceProvider);
    zimService.acceptInvitation(
      invitationID: ZegoCallStateManager.instance.callData?.callID ?? '',
      extendedData: extendData ?? ''
    );

    /// 通話狀態
    ref.read(userUtilProvider.notifier).setDataToPrefs(userCallStatus: UserCallStatus.calling);

    final Map<String, dynamic> data = json.decode(extendData);
    pushToCallingPage(
      zegoCallUserState: ZegoCallUserState.received,
      channel: rtcRes.answer?.channel ?? '',
      roomID: data['roomId'],
      token: rtcRes.answer?.rtcToken ?? '',
      extendData: extendData,
      isEnabledMicSwitch: true,
      isEnabledCamSwitch: true,
    );
    AudioPlayerUtils.playerStop();

  }

  _endCallReq({
    String? channel,
    num? roomId
}) {
    final String globalChannel = GlobalData.cacheChannel ?? '';
    final num globalRoomId = GlobalData.cacheRoomID ?? 0;
    final WsAccountEndCallReq endCallReq = WsAccountEndCallReq(
        roomId: roomId ?? globalRoomId,
        channel: channel ?? globalChannel
    );
    accountWs.wsAccountEndCall(endCallReq,
        onConnectSuccess: (succMsg){},
        onConnectFail: (errMsg) {}
    );
    AudioPlayerUtils.playerStop();
  }

  Future<void> rejectCall() async {
    hideIncomingCallDialog();

    /// 結束通話req
    _endCallReq();

    final zimService = ref.read(zimServiceProvider);
    zimService.rejectInvitation(
      invitationID: ZegoCallStateManager.instance.callData!.callID,
    );

    /// 通話狀態
    ref.read(userUtilProvider.notifier).setDataToPrefs(userCallStatus: UserCallStatus.init);
    AudioPlayerUtils.playerStop();
  }

  Future<T?> showTopModalSheet<T>(BuildContext context, Widget widget, {bool barrierDismissible = true}) {
    return showGeneralDialog<T?>(
      context: context,
      barrierDismissible: barrierDismissible,
      transitionDuration: const Duration(milliseconds: 250),
      barrierLabel: MaterialLocalizations.of(context).dialogLabel,
      barrierColor: Colors.black.withOpacity(0.5),
      pageBuilder: (context, _, __) => SafeArea(
          child: Column(
            children: [
            const SizedBox(height: 16),
            widget,
        ],
      )),
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return SlideTransition(
          position: CurvedAnimation(parent: animation, curve: Curves.easeOutCubic).drive(Tween<Offset>(begin: const Offset(0, -1.0), end: Offset.zero)),
          child: child,
        );
      },
    );
  }

  void hideIncomingCallDialog() {
    AudioPlayerUtils.playerStop();
    BaseViewModel.popupDialog();
    NotificationManager.clearStatus();
  }

  void onIncomingCallInvitationCanceled(IncomingCallInvitationCanceledEvent event) {
    hideIncomingCallDialog();
    /// 通話狀態
    ref.read(userUtilProvider.notifier).setDataToPrefs(userCallStatus: UserCallStatus.init);
  }

  void onIncomingCallInvitationTimeout(IncomingCallInvitationTimeoutEvent event) {
    hideIncomingCallDialog();
    /// 通話狀態
    ref.read(userUtilProvider.notifier).setDataToPrefs(userCallStatus: UserCallStatus.init);
  }

  void pushToWaitingPage({
    required String token,
    required String channel,
    required num roomID,
    required bool isNeedLoading,
    required WsMemberInfoRes memberInfoRes,
    required SearchListInfo searchListInfo,
    required bool isEnabledMicSwitch,
    required bool isEnabledCamSwitch,
    ZegoCallType? typeForEmptyCall
  }) {
    final currentContext = BaseViewModel.getGlobalContext();
    Navigator.push(
      currentContext,
      MaterialPageRoute(
          fullscreenDialog: true,
          builder: (context) => WaitingPage(
                callData: ZegoCallStateManager.instance.callData ?? _getEmptyZegoCallData(typeForEmptyCall ?? ZegoCallType.voice),
                token: token,
                channel: channel,
                roomID: roomID,
                memberInfoRes: memberInfoRes,
                searchListInfo: searchListInfo,
              )),
    );
  }

  ZegoCallData _getEmptyZegoCallData (ZegoCallType type) {
    final UserInfoModel userModel = ref.read(userInfoProvider);
    final ZegoCallData data = ZegoCallData(
      inviter: ZegoUserInfo(
          userID: '${userModel.userId}',
          userName: userModel.userName ?? ''),
      invitee: ZegoUserInfo(userID: '', userName: ''),
      state: ZegoCallUserState.inviting,
      callType: type, callID: '',
    );
    return data;
  }

  void pushToCallingPage({
    required ZegoCallUserState zegoCallUserState,
    required String token, required String channel,
    required num roomID, required String extendData,
    required bool isEnabledMicSwitch,
    required bool isEnabledCamSwitch,
    WsMemberInfoRes? memberInfo
  }) {
    if (ZegoCallStateManager.instance.callData != null) {
      ZegoUserInfo otherUser;
      final manager = ref.read(zegoSDKManagerProvider);
      if (ZegoCallStateManager.instance.callData!.inviter.userID != manager.localUser.userID) {
        otherUser = ZegoCallStateManager.instance.callData!.inviter;
      } else {
        otherUser = ZegoCallStateManager.instance.callData!.invitee;
      }

      final Map<String, dynamic> data = json.decode(extendData);
      WsMemberInfoRes memberInfoRes = WsMemberInfoRes.fromJson(data['memberInfoRes']);
      SearchListInfo searchListInfo = SearchListInfo.fromJson(data['SearchListInfo']);
      final currentContext = BaseViewModel.getGlobalContext();
      BaseViewModel.pushPage(
          currentContext,
          CallingPage(
            zegoCallUserState: zegoCallUserState,
            token: token,
            channel: channel,
            roomID: roomID,
            callData: ZegoCallStateManager.instance.callData!,
            memberInfoRes: memberInfo ?? memberInfoRes,
            otherUserInfo: otherUser,
            searchListInfo: searchListInfo,
          ),
          arguments: ZegoCallStateManager.instance.callData!);
    }
  }

  /// --------------- 撥打電話用 ---------------

  void onOutgoingCallInvitationRejected(OutgoingCallInvitationRejectedEvent event) {
    final Map<String, dynamic> data = json.decode(senderExtendData);
    final currentContext = BaseViewModel.getGlobalContext();
    BaseViewModel.popPage(currentContext);
    BaseViewModel.showToast(currentContext, '亲～对方正在忙线中呢');

    _endCallReq(
      channel: data['channel'],
      roomId: data['roomId']
    );

    /// 通話狀態
    ref.read(userUtilProvider.notifier).setDataToPrefs(userCallStatus: UserCallStatus.init);

    final bool isStrikeUpMateMode = ref.read(userInfoProvider).isStrikeUpMateMode ?? false;
    if(isStrikeUpMateMode) {
      StrikeUpListMateViewModel.stateController.sink.add(MateState.close);
    }
    Future.delayed(const Duration(seconds: 1), () {
      AudioPlayerUtils.playerStop();
    });

  }

  void onOutgoingCallInvitationTimeout(OutgoingCallInvitationTimeoutEvent event) {
    final Map<String, dynamic> data = json.decode(senderExtendData);
    final currentContext = BaseViewModel.getGlobalContext();
    final bool isStrikeUpMode = ref.read(userInfoProvider).isStrikeUpMateMode ?? false;
    if(isStrikeUpMode == false) {
      BaseViewModel.popPage(currentContext);
    }
    BaseViewModel.showToast(currentContext, '亲～超時了呢');

    _endCallReq(
        channel: data['channel'],
        roomId: data['roomId']
    );

    /// 通話狀態
    ref.read(userUtilProvider.notifier).setDataToPrefs(userCallStatus: UserCallStatus.init);
  }

  void onOutgoingCallInvitationAccepted(OutgoingCallInvitationAcceptedEvent event) async {
    final Map<String, dynamic> data = json.decode(event.extendedData);
    final WsMemberInfoReq memberReqBody = WsMemberInfoReq.create(userName: event.invitee);
    final WsMemberInfoRes memberInfo = await ref.read(memberWsProvider).wsMemberInfo(memberReqBody, onConnectSuccess: (_){}, onConnectFail: (_){});
    final WsNotificationSearchListReq searchListReqBody = WsNotificationSearchListReq.create(page: '1', roomId: data['roomId']);
    final WsNotificationSearchListRes notificationSearchList = await ref.read(notificationWsProvider).wsNotificationSearchList(
        searchListReqBody,
        onConnectSuccess: (succMsg){},
        onConnectFail: (errMsg){}
    );
    final SearchListInfo searchListInfo = notificationSearchList.list!.first;
    data['SearchListInfo'] = searchListInfo.toJson();
    final extendedData = json.encode(data);

    final currentContext = BaseViewModel.getGlobalContext();
    final bool isStrikeUpMateMode = ref.read(userInfoProvider).isStrikeUpMateMode ?? false;

    /// 通話狀態
    ref.read(userUtilProvider.notifier).setDataToPrefs(userCallStatus: UserCallStatus.calling);

    BaseViewModel.popPage(currentContext);
    pushToCallingPage(
      zegoCallUserState: ZegoCallUserState.inviting,
      channel: data['channel'],
      roomID: data['roomId'],
      token: data['token'],
      extendData: extendedData,
      memberInfo: memberInfo,
      isEnabledMicSwitch: false,//速配顯示mic設定
      isEnabledCamSwitch: false,//速配顯示camera設定
    );
    /// 速配模式下才執行
    if(isStrikeUpMateMode) {
      StrikeUpListMateViewModel.stateController.sink.add(MateState.open);
    }
  }
}
