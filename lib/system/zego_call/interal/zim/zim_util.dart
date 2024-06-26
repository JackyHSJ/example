
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frechat/models/user_info_model.dart';
import 'package:frechat/models/ws_req/account/ws_account_end_call_req.dart';
import 'package:frechat/models/ws_req/account/ws_account_get_rtc_token_req.dart';
import 'package:frechat/models/ws_req/account/ws_account_get_rtm_token_req.dart';
import 'package:frechat/models/ws_req/notification/ws_notification_search_info_with_type_req.dart';
import 'package:frechat/models/ws_res/account/ws_account_get_rtc_token_res.dart';
import 'package:frechat/models/ws_res/account/ws_account_get_rtm_token_res.dart';
import 'package:frechat/models/ws_res/notification/ws_notification_search_info_with_type_res.dart';
import 'package:frechat/models/ws_res/notification/ws_notification_search_list_res.dart';
import 'package:frechat/models/zpns/call_payload_model.dart';
import 'package:frechat/system/base_view_model.dart';
import 'package:frechat/system/constant/enum.dart';
import 'package:frechat/system/database/model/chat_block_model.dart';
import 'package:frechat/system/database/model/chat_message_model.dart';
import 'package:frechat/system/database/model/chat_user_model.dart';
import 'package:frechat/system/provider/chat_block_model_provider.dart';
import 'package:frechat/system/provider/chat_message_model_provider.dart';
import 'package:frechat/system/provider/chat_user_model_provider.dart';
import 'package:frechat/system/provider/user_info_provider.dart';
import 'package:frechat/system/providers.dart';
import 'package:frechat/system/repository/response_code.dart';
import 'package:frechat/system/util/audioplayer_util.dart';
import 'package:frechat/system/websocket/websocket_handler.dart';
import 'package:frechat/system/websocket/websocket_status.dart';
import 'package:frechat/system/ws_comm/ws_activity.dart';
import 'package:frechat/system/zego_call/interal/zim/call_data_manager.dart';
import 'package:frechat/system/zego_call/interal/zim/zim_service_defines.dart';
import 'package:frechat/system/zego_call/zego_provider.dart';
import 'package:frechat/widgets/shared/local_notification/local_notification.dart';
import 'package:frechat/widgets/theme/app_theme.dart';

class ZIMUtil {
  ZIMUtil({required this.ref});
  ProviderRef ref;
  Duration reconnectPeriod = const Duration(seconds: 1);

  Future<WsAccountGetRTMTokenRes?> reloadZego() async {
    WsAccountGetRTMTokenRes? res;
    bool connected = false;
    /// 迴圈直到重連
    while (!connected) {
      /// socket連線判斷, 當socket 未連線則也不需嘗試取得rtcToken方法
      /// 但會繼續進入迴圈內等待socket連線進行嘗試重連
      if (WebSocketHandler.socketStatus == SocketStatus.SocketStatusClosed || WebSocketHandler.socketStatus == SocketStatus.SocketStatusFailed) {
        await Future.delayed(reconnectPeriod);
        continue;
      }

      try {
        final bool connectResult = await connectZego();
        if(connectResult == true) {
          connected = true;
        } else {
          /// 失敗等待一秒後重連
          await Future.delayed(reconnectPeriod);
        }
      } catch (e) {
        /// 失敗等待一秒後重連
        await Future.delayed(reconnectPeriod);
      }
    }
    return res; // 最终返回成功的连接结果
  }

  Future<bool> connectZego() async {
    final WsAccountGetRTMTokenRes currentRtcTokenRes = await getRtcToken();
    if(currentRtcTokenRes.rtcToken == null) {
      return false;
    }
    ref.read(userUtilProvider.notifier).setDataToPrefs(rtcToken: currentRtcTokenRes.rtcToken ?? '');
    final String userName = ref.read(userInfoProvider).memberInfo?.userName ?? '';
    final String nickName = ref.read(userInfoProvider).memberInfo?.nickName ?? '';
    ref.read(zegoLoginProvider).init(userName: userName, nickName: nickName, token: currentRtcTokenRes.rtcToken ?? '');

    return true;
  }

  buildLocalNotification({
    required String roomName,
    required String des,
    String? avatar,
    required num gender,
    required num roomId,
    required String sender,
    required bool isSystemMessage
  }) {
    /// 檢查是不是空, 如果是則不發送推播
    if(roomName == '') {
      return ;
    }

    final UserInfoModel userInfo = ref.read(userInfoProvider);
    final String currentChatUser = userInfo.currentChatUser ?? '';
    final num currentPage = userInfo.currentPage ?? 0;
    final bool isInChatRoomOrCallingPage = (currentPage == 1 || currentPage == 2);
    if(isInChatRoomOrCallingPage == true && currentChatUser == sender) {
      return ;
    }else if(currentPage == 6 && currentChatUser == sender){
      return ;
    }

    AudioPlayerUtils.playAssetAudio('aac/notificationsound.aac',false);
    LocalNotification.show(
      roomName: roomName,
      avatar: avatar,
      des: des,
      gender: gender,
      roomId: roomId,
      sender: sender,
      isSystemMessage: isSystemMessage,
    );
  }

  buildActivityNotification({
    String? fromUserAvatar,
    required String fromUserNickName,
    required num fromUserGender,
    required num notifyType,
    required num feedsId,
    required String fromUserUserName,

  }) {

    String content = '';

    // 1:留言 2:回復 3:按讚 4:打賞
    switch (notifyType) {
      case 1:
        content = '在你的动态留言';
        break;
      case 2:
        content = '回复了你的留言';
        break;
      case 3:
        content = '说你的动态赞';
        break;
      case 4:
        content = '打赏了你的动态';
        break;
      default:
        break;
    }
    final ActivityWs activityWs = ref.read(activityWsProvider);
    LocalNotification.activityShow(
      fromUserNickName: fromUserNickName,
      fromUserGender: fromUserGender,
      fromUserAvatar: fromUserAvatar,
      des: content,
      feedsId: feedsId,
      activityWs: activityWs,
    );
  }

  String formatTimeStampToDateTime(int timeStamp) {
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(timeStamp);
    String formattedDateTime = '${dateTime.year}/${_addZeroPrefix(
        dateTime.month)}/${_addZeroPrefix(dateTime.day)} ${_addZeroPrefix(
        dateTime.hour)}:${_addZeroPrefix(dateTime.minute)}:${_addZeroPrefix(
        dateTime.second)}';
    return formattedDateTime;
  }

  String _addZeroPrefix(int value) {
    return value < 10 ? '0$value' : '$value';
  }

  Future<WsAccountGetRTMTokenRes> getRtcToken() async {
    String? resultCodeCheck;
    final WsAccountGetRTMTokenReq reqBody = WsAccountGetRTMTokenReq.create();
    final WsAccountGetRTMTokenRes res = await ref.read(accountWsProvider).wsAccountGetRTMToken(reqBody,
        onConnectSuccess: (succMsg) => resultCodeCheck = succMsg,
        onConnectFail: (errMsg) {
          final currentContext = BaseViewModel.getGlobalContext();
          BaseViewModel.showToast(currentContext, ResponseCode.map[errMsg]!);
        }
    );

    if (resultCodeCheck == ResponseCode.CODE_SUCCESS) {
      ref.read(userUtilProvider.notifier).setDataToPrefs(rtcToken: res.rtcToken);
    }

    return res;
  }

  Future<String> getRoomNameFromExtendData({required dynamic extendedDataJsonObj}) async {
    final String roomName = extendedDataJsonObj['roomName'] ?? '';
    final String remark = extendedDataJsonObj['remark'] ?? '';
    return (roomName.isEmpty || roomName == '') ? remark : roomName;
  }

  Future<String> getRoomName({required String userName}) async {
    String? roomName;
    /// 過濾掉自己
    final UserInfoModel userInfoModel = ref.read(userInfoProvider);
    final String myUserName = userInfoModel.memberInfo?.userName ?? '';
    if(userName == myUserName) {
      return userInfoModel.nickName ?? '';
    }

    try {
      final List<ChatUserModel> chatUserModel = ref.read(chatUserModelNotifierProvider);
      final ChatUserModel sendChatUser = chatUserModel.firstWhere((user) => user.userName == userName);
      roomName = (sendChatUser.remark == '' || sendChatUser.remark == null)
          ? sendChatUser.roomName
          : sendChatUser.remark;
    } catch (e) {
      final List<SearchListInfo>? searchList = await ref.read(authenticationProvider).loadSearchListInDB();
      final SearchListInfo? info = searchList?.firstWhere((info) => info.userName == userName);
      roomName = (info?.remark == '' || info?.remark == null)
          ? info?.roomName
          : info?.remark;
    }

    return roomName ?? '';
  }

  bool isTimeDifferenceGreaterThanMinutes(DateTime secondDateTime, {
    required num differenceMinutes
  }) {
    final DateTime currentTime = DateTime.now();
    final Duration difference = currentTime.difference(secondDateTime);
    final int differenceInMinutes = difference.inMinutes;
    return differenceInMinutes > differenceMinutes;
  }

  CallPayloadModel getPayload({
    required num timeout,
    required num callWithVoiceOrVideo,
    num? callType,
  }) {
    final UserInfoModel userModel = ref.read(userInfoProvider);
    final String nickName = userModel.memberInfo?.nickName ?? '';
    final String userName = userModel.memberInfo?.userName ?? '';
    final String callerName = nickName == '' ? userName : nickName;
    final String callerAvatar = userModel.memberInfo?.avatarPath ?? '';
    final num age = userModel.memberInfo?.age ?? 0;
    final num gender = userModel.memberInfo?.gender ?? 0;
    final payload = CallPayloadModel(
      callerName: callerName,
      callerAvatar: callerAvatar,
      callWithVoiceOrVideo: callWithVoiceOrVideo,
      callType: callType ?? 0,
      timeout: timeout,
      age: age, gender: gender
    );

    return payload;
  }

  // Future<WsAccountGetRTCTokenRes?> acceptCall({
  //   required ZegoCallData invitationData,
  //   required num roomID,
  //   required num callUserId
  // }) async {
  //   final String inviterUserID = invitationData.inviter.userID;
  //   final ZegoCallType type = invitationData.callType;
  //
  //   /// 檢查餘額(男性) 待加入
  //   // final result = await rechargeDialogHandler(inviterUserID, type);
  //   // if (!result) return;
  //
  //   final WsAccountGetRTCTokenRes res = await _buildRtcToken(roomID: roomID, callUserId: callUserId);
  //   if(res.answer?.rtcToken == null || res.answer?.channel == null) {
  //     return null;
  //   }
  //
  //   return res;
  // }

  Future<WsAccountGetRTCTokenRes> _buildRtcToken({
    required num callUserId, required num roomID
  }) async {
    int type = 1;
    if (ZegoCallStateManager.instance.callData!.callType == ZegoCallType.video) {
      type = 2;
    }
    final WsAccountGetRTCTokenReq reqBody = WsAccountGetRTCTokenReq.create(
      chatType: type,
      roomId: roomID,
      callUserId: callUserId,
    );
    final BuildContext currentContext = BaseViewModel.getGlobalContext();
    final WsAccountGetRTCTokenRes res = await ref.read(accountWsProvider).wsAccountGetRTCToken(
        reqBody,
        onConnectSuccess: (succMsg) => BaseViewModel.showToast(currentContext, '通话开始'),
        onConnectFail: (errMsg) => BaseViewModel.showToast(currentContext, ResponseCode.map[errMsg]!)
    );
    return res;
  }

  Future<void> endCall({
    required String channel, required num roomID
  }) async {
    final reqBody = WsAccountEndCallReq.create(
      channel: channel,
      roomId: roomID,
    );
    final BuildContext currentContext = BaseViewModel.getGlobalContext();
    ref.read(accountWsProvider).wsAccountEndCall(reqBody,
        onConnectSuccess: (succMsg) => BaseViewModel.showToast(currentContext, '通话结束'),
        onConnectFail: (errMsg) => BaseViewModel.showToast(currentContext, ResponseCode.map[errMsg]!)
    );
  }

  Future<void> clearUnReadMessageByConversationIdInDB({
    required String conversationID
  }) async {
    /// 讀出DB目前未讀訊息 全部改為已讀
    final String myUserName = ref.read(userInfoProvider).memberInfo?.userName ?? '';

    /// 發送者不是自己 && 訊息狀態為未讀 && 傳送者為conversationID
    final List<ChatMessageModel> unReadListDb = ref.read(chatMessageModelNotifierProvider)
        .where((msg) => msg.senderName == conversationID && msg.unRead != 1 && msg.receiverName == myUserName)
        .toList();

    for(var unread in unReadListDb) {
      ref.read(chatMessageModelNotifierProvider.notifier).updateDataToSql(
          updateModel: ChatMessageModel(senderName: unread.senderName, unRead: 1),
          whereModel: ChatMessageModel(senderName: unread.senderName, messageUuid: unread.messageUuid)
      );
    }
  }

  Future<void> clearAllUnReadMessageInDB() async {
    final String myUserName = ref.read(userInfoProvider).memberInfo?.userName ?? '';
    final List<ChatMessageModel> unReadListDb = ref.read(chatMessageModelNotifierProvider)
        .where((msg) => msg.unRead != 1 && msg.receiverName == myUserName)
        .toList();

    for(var unread in unReadListDb) {
      ref.read(chatMessageModelNotifierProvider.notifier).updateDataToSql(
          updateModel: ChatMessageModel(senderName: unread.senderName, unRead: 1),
          whereModel: ChatMessageModel(senderName: unread.senderName, messageUuid: unread.messageUuid)
      );
    }
  }

  // Future<WsNotificationSearchInfoWithTypeRes> _loadNotificationSearchInfoWithType({
  //   required num type,
  //   List<num>? roomIdList
  // }) async {
  //   final WsNotificationSearchInfoWithTypeReq reqBody = WsNotificationSearchInfoWithTypeReq.create(
  //       type: type,
  //       roomIdList: roomIdList
  //   );
  //   final WsNotificationSearchInfoWithTypeRes res = await ref.read(notificationWsProvider).wsNotificationSearchInfoWithType(
  //       reqBody,
  //       onConnectSuccess: (succMsg){ },
  //       onConnectFail: (errMsg){}
  //   );
  //   return res;
  // }
}