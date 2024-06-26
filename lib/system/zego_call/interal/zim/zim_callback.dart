
import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frechat/models/ws_req/account/ws_account_end_call_req.dart';
import 'package:frechat/models/ws_req/account/ws_account_get_rtm_token_req.dart';
import 'package:frechat/models/ws_req/notification/ws_notification_search_list_req.dart';
import 'package:frechat/models/ws_req/ws_base_req.dart';
import 'package:frechat/models/ws_res/account/ws_account_end_call_res.dart';
import 'package:frechat/models/ws_res/account/ws_account_get_rtm_token_res.dart';
import 'package:frechat/models/ws_res/account/ws_account_official_message_res.dart';
import 'package:frechat/models/ws_res/notification/ws_notification_search_list_res.dart';
import 'package:frechat/screens/activity/activity_notification_view_model.dart';
import 'package:frechat/screens/launch/launch.dart';
import 'package:frechat/screens/profile/mission/personal_mission_bonus.dart';
import 'package:frechat/screens/profile/mission/personal_mission_dialog.dart';
import 'package:frechat/system/base_view_model.dart';
import 'package:frechat/system/constant/enum.dart';
import 'package:frechat/system/database/model/activity_message_model.dart';
import 'package:frechat/system/database/model/chat_block_model.dart';
import 'package:frechat/system/database/model/chat_call_model.dart';
import 'package:frechat/system/database/model/chat_message_model.dart';
import 'package:frechat/system/database/model/chat_user_model.dart';
import 'package:frechat/system/extension/chat_user_model.dart';
import 'package:frechat/system/extension/json.dart';
import 'package:frechat/system/global.dart';
import 'package:frechat/system/global/shared_preferance.dart';
import 'package:frechat/system/provider/activity_message_model_provider.dart';
import 'package:frechat/system/provider/chat_block_model_provider.dart';
import 'package:frechat/system/provider/chat_call_model_provider.dart';
import 'package:frechat/system/provider/chat_message_model_provider.dart';
import 'package:frechat/system/provider/chat_user_model_provider.dart';
import 'package:frechat/system/provider/user_info_provider.dart';
import 'package:frechat/system/providers.dart';
import 'package:frechat/system/repository/response_code.dart';
import 'package:frechat/system/unread_message/unread_message_manager.dart';
import 'package:frechat/system/util/dialog_util.dart';
import 'package:frechat/system/websocket/websocket_handler.dart';
import 'package:frechat/system/ws_comm/ws_params_req.dart';
import 'package:frechat/system/zego_call/interal/express/zego_express_service.dart';
import 'package:frechat/system/zego_call/interal/zim/call_data_manager.dart';
import 'package:frechat/system/zego_call/interal/zim/zim_service_defines.dart';
import 'package:frechat/system/zego_call/interal/zim/zim_util.dart';
import 'package:frechat/system/zego_call/model/zego_user_model.dart';
import 'package:frechat/system/zego_call/zego_provider.dart';
import 'package:frechat/widgets/shared/dialog/check_dialog.dart';
import 'package:frechat/widgets/theme/app_theme.dart';
import 'package:frechat/widgets/theme/original/app_colors.dart';
import 'package:zego_express_engine/zego_express_engine.dart';
import '../../../../models/ws_req/setting/ws_setting_charm_achievement_req.dart';
import '../../../../screens/profile/setting/charm/personal_setting_charm_dialog.dart';

class ZIMCallback {
  ZIMCallback({required this.ref}) {
    zimUtil = ref.read(zimUtilProvider);
  }

  ProviderRef ref;

  Function(String, ZIMTextMessage)? onReceiveTextMessage;
  Function(String, ZIMCommandMessage)? onReceiveCommandMessage;
  Function(String, ZIMImageMessage)? onReceiveImageMessage;
  Function(String, ZIMFileMessage)? onReceiveFileMessage;
  Function(String, ZIMAudioMessage)? onReceiveAudioMessage;
  Function(String, ZIMVideoMessage)? onReceiveVideoMessage;
  Function(String, ZIMBarrageMessage)? onReceiveBarrageMessage;
  Function(String, ZIMRevokeMessage)? onReceiveRevokeMessage;
  Function(String, ZIMSystemMessage)? onReceiveSystemMessage;
  Function(String, ZIMMessage)? onExceptionMessageType;

  /// 已讀
  Function(List<ZIMMessageReceiptInfo>)? onAnotherHaveReadMessage;

  /// 所有未讀訊息
  Function(int)? onTotalUnReadMessage;
  Function(List<ZIMConversationChangeInfo>)? onConversationListChanged;

  late ZIMUtil zimUtil;
  static List<ZegoStream> currentStreamList = [];

  Future<void> onReceivePeerMessage(ZIM zim, List<ZIMMessage> messageList, fromUserID) async {
    for (ZIMMessage message in messageList) {
      /// 給定時間限制, 避免就資料無限進入callback 造成阻塞
      final DateTime dateTimeMessage = DateTime.fromMillisecondsSinceEpoch(message.timestamp);
      final bool isOverOneMin = zimUtil.isTimeDifferenceGreaterThanMinutes(dateTimeMessage, differenceMinutes: 1);
      if(isOverOneMin) {
        return ;
      }

      String roomName = '';
      if (fromUserID != 'feed_notify') {
        roomName = await zimUtil.getRoomName(userName: fromUserID);
      }

      switch (message.type) {
        case ZIMMessageType.text:
          message as ZIMTextMessage;
          final messageJsonObj = json.tryDecode(message.message);
          onReceiveTextMessage?.call(fromUserID, message);

          // print('fromUserID: $fromUserID');


          // 青少年模式開啟，消息全部檔住
          bool teenMode = await FcPrefs.getTeenMode();
          if (teenMode) return;

          // 審核中開啟，消息全部檔住
          bool showBlockType = ref.read(userInfoProvider).buttonConfigList?.blockType == 1 ? true : false;
          if (showBlockType) return;

          // 動態牆推播
          if (fromUserID == 'feed_notify') {
            activityNotifier(message);
            return;
          }

          if (fromUserID == 'java_system') {
            final chatUserModel = ref.read(chatUserModelNotifierProvider);
            final list = chatUserModel.where((info) =>
            info.userName == 'java_system').toList();
            final content = messageJsonObj['content'];
            String modifiedMessage = content['message'];

            // 任務紅包
            if (messageJsonObj['type'] == 3) {
              final num gender = ref.read(userInfoProvider).memberInfo?.gender ?? 0;
              modifiedMessage = messageJsonObj['content']['message'].split('-')[gender.toInt()];
            }

            zimUtil.buildLocalNotification(
              roomName: '系统通知',
              avatar: 'assets/images/system_avatar.png',
              des: modifiedMessage,
              gender: 0,
              roomId: 000,
              sender: "java_system",
              isSystemMessage: true,
            );

            if (messageJsonObj['type'] == 6 && content['type'] == 0) {
              String dialogContent = '';
              if (content['lockStatus'] == 2) {
                dialogContent = '您的行为异常，将永久冻结账号';
              } else {
                num timeStamp = content['lockTime'];
                String finalTime = zimUtil.formatTimeStampToDateTime(timeStamp.toInt());
                dialogContent = '您的行为异常，将暂时冻结账号至$finalTime';
              }
              
              final num currentPage = ref.read(userInfoProvider).currentPage ?? 0;
              final bool isInCallingPage = (currentPage == 2);
              if(isInCallingPage){
                String jsonString =  await FcPrefs.getCancelCallInfo();
                Map cancelCallInfoMap = jsonDecode(jsonString);
                final result = cancelCallInfoMap['invitees'];
                List<String> invitees = [];
                invitees.add(result[0]);
                print(invitees);

                wsAccountEndCall(BaseViewModel.getGlobalContext(), cancelCallInfoMap['channel'], cancelCallInfoMap['roomId']);
                final zimService = ref.read(zimServiceProvider);
                zimService.cancelInvitation(
                  invitationID: cancelCallInfoMap['invitationID'],
                  invitees: invitees,
                );

                final ExpressService expressService = ref.read(expressServiceProvider);
                /// 停止拉流 dispose
                for (ZegoStream zegoStream in currentStreamList) {
                  expressService.stopPlayingStream(zegoStream.streamID);
                }
                expressService.stopPreview();
                expressService.stopPublishingStream();
                expressService.logoutRoom(cancelCallInfoMap['channel']);
                BaseViewModel.popPage(BaseViewModel.getGlobalContext());
              }

              WebSocketHandler.bRepeatingLogin = true;
              WebSocketHandler.closeSocket();
              isReportedSuccessDialog('您已被封號', dialogContent);
            }

            if (messageJsonObj['type'] == 7) {

              final num currentPage = ref.read(userInfoProvider).currentPage ?? 0;
              final bool isInCallingPage = (currentPage == 2);
              if(isInCallingPage){
                String jsonString =  await FcPrefs.getCancelCallInfo();
                Map cancelCallInfoMap = jsonDecode(jsonString);
                final result = cancelCallInfoMap['invitees'];
                List<String> invitees = [];
                invitees.add(result[0]);
                print(invitees);

                wsAccountEndCall(BaseViewModel.getGlobalContext(), cancelCallInfoMap['channel'], cancelCallInfoMap['roomId']);
                final zimService = ref.read(zimServiceProvider);
                zimService.cancelInvitation(
                  invitationID: cancelCallInfoMap['invitationID'],
                  invitees: invitees,
                );

                final ExpressService expressService = ref.read(expressServiceProvider);
                /// 停止拉流 dispose
                for (ZegoStream zegoStream in currentStreamList) {
                  expressService.stopPlayingStream(zegoStream.streamID);
                }
                expressService.stopPreview();
                expressService.stopPublishingStream();
                expressService.logoutRoom(cancelCallInfoMap['channel']);
                BaseViewModel.popPage(BaseViewModel.getGlobalContext());
              }

              WebSocketHandler.bRepeatingLogin = true;
              WebSocketHandler.closeSocket();
              isReportedSuccessDialog('您已被冻结', content['message']);
            }

            // 任務紅包
            if (messageJsonObj['type'] == 3) {
              showPersonalMissionBonus(content);
            }

            // 魅力等級升級
            if (messageJsonObj['type'] == 5) {
              showPersonalSettingCharmDialog(content['message']);
            }

            String recentlyMessage = messageJsonObj['content']['message'];
            if (messageJsonObj['type'] == 3) {
              // 任務紅包
              final num gender = ref.read(userInfoProvider).memberInfo?.gender ?? 0;
              final List<String> titles = recentlyMessage.split('-')[gender.toInt()].split('/');
              final String title = '${titles[0]}已完成';
              recentlyMessage = title;
            }

            if (messageJsonObj['type'] == 5) {
              final messages = recentlyMessage.split('\\n');
              recentlyMessage = messages[0];
            }
            ///動態牆
            if(messageJsonObj['type'] == 4){
              String type = content['type']??'0';
              ///動態貼文審核
              if(type == '11'){
                ///當收到動態貼文審核通知時，會將暫時顯示使用者審核中的貼文列表清空
                GlobalData.cacheUserPostActivityPostInfoList = [];
                num status = content['status']?? 0;
                ///審核失敗時，發文限制時間重新計算
                if(status == 2){
                  FcPrefs.setLastPostTime(0);
                }
              }
            }

            if (list.isEmpty) {
              ref.read(chatUserModelNotifierProvider.notifier).setDataToSql(
                  chatUserModelList: [
                    ChatUserModel(userId: 000,
                        roomIcon: 'assets/images/system_avatar.png',
                        cohesionLevel: 0,
                        userCount: 1,
                        isOnline: 0,
                        userName: 'java_system',
                        roomId: 000,
                        roomName: '系统通知',
                        points: 0,
                        remark: '系统通知',
                        recentlyMessage: recentlyMessage,
                        unRead: 1,
                        timeStamp: message.timestamp,
                        pinTop: 0,
                    sendStatus: 1,)
                  ]);
            } else {
              insertToChatUserModel(message, recentlyMessage, true);
            }
            setSysTemMessageToDb(
                messageJsonObj['uuid'], message.message, message.timestamp);
          } else {
            final bool isCallContent = message.extendedData == "{}";
            if (isCallContent) {
              final contentDataJsonObj = json.tryDecode(message.message);
              final WsAccountOfficialMessageRes content = WsAccountOfficialMessageRes.fromJson(contentDataJsonObj['content']);
              final OfficialMessageInfo messageInfo = OfficialMessageInfo.fromJson(content.message);
              final num gender = ref.read(userInfoProvider).memberInfo?.gender ?? 0;

              /// 從後端讀取聊天列表資料
              final List<ChatUserModel> chatUserModels = ref.read(chatUserModelNotifierProvider);
              final List<SearchListInfo> searchListInfo = chatUserModels.map((model) => model.toSearchListInfo()).toList();
              final SearchListInfo searchInfo;
              if(ref.read(userInfoProvider).userName == messageInfo.caller){
                searchInfo = searchListInfo.firstWhere((info) => info.userName == messageInfo.answer);
              } else {
                searchInfo = searchListInfo.firstWhere((info) => info.userName == messageInfo.caller);
              }

              String contentMessage = '';
              String duration = formatDuration(messageInfo.duration!.toInt());
              contentMessage = getCallingTypeRecentlyMessage(messageInfo.caller, contentMessage,duration, messageInfo.type, messageInfo.chatType);

              /// 存入chatUser DB
              // insertToChatUserModel(message, '通话时长: ${messageInfo.duration}s', false, callingType: messageInfo.type, searchInfo: searchInfo,chatType: messageInfo.chatType);
              insertToChatUserModel(message, contentMessage , false, callingType: messageInfo.type, searchInfo: searchInfo, chatType: messageInfo.chatType,duration: duration);

              /// 存入call DB
              insertToChatCallModel(contentDataJsonObj['uuid'], searchInfo: searchInfo, officialMessageInfo: messageInfo);

              zimUtil.buildLocalNotification(
                roomName: roomName,
                avatar: searchInfo.roomIcon,
                des: contentMessage,
                gender: gender == 0 ? 1 : 0,
                roomId: searchInfo.roomId ?? 0,
                sender: searchInfo.userName ?? '',
                isSystemMessage: false,
              );
            } else if (messageJsonObj['type'] == 9) {
              final extendDataJsonObj = json.decode(message.extendedData);
              if(message.receiptStatus != ZIMMessageReceiptStatus.none){
                zimUtil.buildLocalNotification(
                  roomName: roomName,
                  avatar: extendDataJsonObj['avatar'],
                  des: '亲~有人传音档给您',
                  gender: extendDataJsonObj['gender'],
                  roomId: extendDataJsonObj['roomId'],
                  sender: extendDataJsonObj['sender'],
                  isSystemMessage: false,
                );
              }
              insertToChatUserModel(message, '[录音]', false,callingType: null);
            } else {
              insertToChatUserModel(message, messageJsonObj['content'], false);
              final extendDataJsonObj = json.tryDecode(message.extendedData);
              final List<ChatBlockModel> blockList = ref.read(chatBlockModelNotifierProvider);
              bool isInBlockList = blockList.any((ChatBlockModel blockModel) => blockModel.userName == message.senderUserID);
              if(!isInBlockList){
                zimUtil.buildLocalNotification(
                  roomName: roomName,
                  avatar: extendDataJsonObj['avatar'],
                  des: messageJsonObj['content'],
                  gender: extendDataJsonObj['gender'],
                  roomId: extendDataJsonObj['roomId'],
                  sender: extendDataJsonObj['sender'],
                  isSystemMessage: false,
                );
              }
            }
          }
          break;
        case ZIMMessageType.command:
          message as ZIMCommandMessage;
          onReceiveCommandMessage?.call(fromUserID, message);
          break;
        case ZIMMessageType.image:
          message as ZIMImageMessage;
          onReceiveImageMessage?.call(fromUserID, message);
          final extendDataJsonObj = json.decode(message.extendedData);
          zimUtil.buildLocalNotification(
            roomName: roomName,
            avatar: extendDataJsonObj['avatar'],
            des: '亲～有人传图片给您',
            gender: extendDataJsonObj['gender'],
            roomId: extendDataJsonObj['roomId'],
            sender: extendDataJsonObj['sender'],
            isSystemMessage: false,
          );
          insertToChatUserModel(message, '[图片]', false);
          // messageDb(message,0);
          break;
        case ZIMMessageType.file:
          message as ZIMFileMessage;
          onReceiveFileMessage?.call(fromUserID, message);
          final extendDataJsonObj = json.decode(message.extendedData);
          zimUtil.buildLocalNotification(
            roomName: roomName,
            avatar: extendDataJsonObj['avatar'],
            des: '亲~有人传音档给您',
            gender: extendDataJsonObj['gender'],
            roomId: extendDataJsonObj['roomId'],
            sender: extendDataJsonObj['sender'],
            isSystemMessage: false,
          );
          insertToChatUserModel(message, '[录音]', false);
          break;
        case ZIMMessageType.audio:
          message as ZIMAudioMessage;
          onReceiveAudioMessage?.call(fromUserID, message);
          final extendDataJsonObj = json.decode(message.extendedData);
          zimUtil.buildLocalNotification(
            roomName: roomName,
            avatar: extendDataJsonObj['avatar'],
            des: '亲~有人传音档给您',
            gender: extendDataJsonObj['gender'],
            roomId: extendDataJsonObj['roomId'],
            sender: extendDataJsonObj['sender'],
            isSystemMessage: false,
          );
          break;
        case ZIMMessageType.video:
          message as ZIMVideoMessage;
          onReceiveVideoMessage?.call(fromUserID, message);
          final extendDataJsonObj = json.decode(message.extendedData);
          zimUtil.buildLocalNotification(
            roomName: roomName,
            avatar: extendDataJsonObj['avatar'],
            des: '亲～有人传影片给您',
            gender: extendDataJsonObj['gender'],
            roomId: extendDataJsonObj['roomId'],
            sender: extendDataJsonObj['sender'],
            isSystemMessage: false,
          );
          break;
        case ZIMMessageType.barrage:
          message as ZIMBarrageMessage;
          onReceiveBarrageMessage?.call(fromUserID, message);
          break;
        case ZIMMessageType.revoke:
          message as ZIMRevokeMessage;
          onReceiveRevokeMessage?.call(fromUserID, message);
          break;
        case ZIMMessageType.system:
          message as ZIMSystemMessage;
          onReceiveSystemMessage?.call(fromUserID, message);
          final extendDataJsonObj = json.decode(message.extendedData);
          zimUtil.buildLocalNotification(
            roomName: roomName,
            avatar: extendDataJsonObj['avatar'],
            des: '亲～有系统讯息呦',
            gender: extendDataJsonObj['gender'],
            roomId: extendDataJsonObj['roomId'],
            sender: extendDataJsonObj['sender'],
            isSystemMessage: false,
          );
          break;
        default:
          onExceptionMessageType?.call(fromUserID, message);
      }
    }
  }


  // 動態牆推播通知
  void activityNotifier(ZIMMessage message) {
    message as ZIMTextMessage;
    final messageJsonObj = json.tryDecode(message.message);
    final ActivityMessageModel model = ActivityMessageModel.fromJson(messageJsonObj);
    ref.read(activityMessageModelNotifierProvider.notifier).setDataToSql(activityMessageModelList: [model]);

    ///不顯示已黑名單的使用者通知
    final List<ChatBlockModel> blockList = ref.read(chatBlockModelNotifierProvider);
    bool isBlockUser = blockList.any((block) => block.userName == model.fromUserUserName);
    if(isBlockUser) return;

    zimUtil.buildActivityNotification(
      fromUserNickName: model.fromUserNickName ?? '',
      fromUserAvatar: model.fromUserAvatar,
      fromUserGender: model.fromUserGender ?? 0,
      notifyType: model.notifyType ?? 0,
      feedsId: model.feedsId ?? 0,
      fromUserUserName: model.fromUserUserName?? '',
    );
  }

  Future<WsAccountEndCallRes> wsAccountEndCall(BuildContext context, String channel, num roomID) async {
    final reqBody = WsAccountEndCallReq.create(channel: channel, roomId: roomID,);
    final commToken = await FcPrefs.getCommToken();
    String? resultCodeCheck;
    final WsBaseReq msg = WsParamsReq.accountEndCall
      ..tId = commToken
      ..msg = reqBody;

    /// 傳送ws send
    final res = await WebSocketHandler.sendData(msg, funcCode: WsParamsReq.accountEndCall.f,
        onConnectSuccess: (succMsg) => resultCodeCheck = succMsg,
        onConnectFail: (errMsg) => BaseViewModel.showToast(context, ResponseCode.map[errMsg]!));

    return (res.resultMap == null) ? WsAccountEndCallRes() : WsAccountEndCallRes.fromJson(res.resultMap);
  }

  String formatDuration(int seconds) {
    int hours = seconds ~/ 3600;
    int minutes = (seconds ~/ 60) % 60;
    int remainingSeconds = seconds % 60;

    String hoursStr = hours.toString().padLeft(2, '0');
    String minutesStr = minutes.toString().padLeft(2, '0');
    String secondsStr = remainingSeconds.toString().padLeft(2, '0');

    return '$hoursStr:$minutesStr:$secondsStr';
  }

  void readSystemMessage() {
    final zimService = ref.read(zimServiceProvider);
    zimService.receiveMessage(conversationID: 'java_system');

    zimService.clearUnReadMessageByConversationID(conversationID: 'java_system');
  }

  void showPersonalSettingCharmDialog(message) async {
    showDialog(
      context: BaseViewModel.getGlobalContext(),
      barrierDismissible: false,
      builder: (BuildContext context) {
        return PersonalSettingCharmDialog(message: message);
      },
    );

    // 魅力等級升級重新打魅力等級 API 拿到最新的資料。
    String? resultCodeCheck;
    final WsSettingChargeAchievementReq reqBody = WsSettingChargeAchievementReq
        .create();
    final res = await ref.read(settingWsProvider).wsSettingCharmAchievement(
        reqBody,
        onConnectSuccess: (succMsg) => resultCodeCheck = succMsg,
        onConnectFail: (errMsg) => {});

    if (resultCodeCheck == ResponseCode.CODE_SUCCESS) {
      ref.read(userUtilProvider.notifier).loadCharmAchievement(res);
    }
  }

  // _loadSearchInfo() asy/*nc {
  //   String? resultCodeCheck;
  //   WsNotificationSearchListReq reqBody = WsNotificationSearchListReq.create(
  //       page: '1');
  //   final res = await ref.read(notificationWsProvider).wsNotificationSearchList(
  //       reqBody,
  //       onConnectSuccess: (succMsg) => resultCodeCheck = succMsg,
  //       onConnectFail: (errMsg) => print('error')
  //   );
  //
  //   if (resultCodeCheck == ResponseCode.CODE_SUCCESS) {
  //     ref.read(userUtilProvider.notifier).loadNotificationListInfo(res);
  //   }
  // }*/

  void showPersonalMissionBonus(Map map) {

    num? gender = ref.read(userInfoProvider).memberInfo!.gender;
    String message = map['message'];
    final titles = message.split('-')[gender!.toInt()].split('/');
    final target = map['target'];
    final title = titles[0] ?? '';
    final subTitle = titles[1] ?? '';
    String coinsString = map['coins'];
    String pointsString = map['points'];
    int count = 0;

    if (gender == 0 && map['status'] == '-1') {
      count = int.parse(pointsString);
    } else {
      count = int.parse(coinsString);
    }

    if (gender == 1) {
      count = int.parse(coinsString);
    }

    readSystemMessage();
    showDialog(
      context: BaseViewModel.getGlobalContext(),
      barrierDismissible: false,
      builder: (BuildContext context) {
        return PersonalMissionDialog(target: int.parse(target),
          title: title,
          subTitle: subTitle,
          count: count,
          gender: gender!.toInt()
        );
      },
    );
  }

  void isReportedSuccessDialog(String title, String content) {
    final AppTheme theme = ref.read(userInfoProvider).theme ?? AppTheme(themeType: AppThemeType.original);
    CheckDialog.show(
        BaseViewModel.getGlobalContext(),
        appTheme: theme,
        titleText: title,
        barrierDismissible: false,
        titleTextStyle: const TextStyle(
            color: AppColors.textFormBlack,
            fontSize: 18,
            fontWeight: FontWeight.bold
        ),
        messageText: content,
        confirmButtonText: '確認',
        onConfirmPress: () {
          readSystemMessage();
          ref.read(authenticationProvider).logout(
              onConnectSuccess: (succMsg) => BaseViewModel.pushAndRemoveUntil(
                  BaseViewModel.getGlobalContext(), GlobalData.launch ??  const Launch()),
              onConnectFail: (errMsg) => BaseViewModel.showToast(
                  BaseViewModel.getGlobalContext(), errMsg));
        });
  }

  void setSysTemMessageToDb(String uuid, String content, num timeStamp) {
    ref.read(chatMessageModelNotifierProvider.notifier).setDataToSql(
        chatMessageModelList: [
          ChatMessageModel(
              messageUuid: uuid,
              receiverId: ref
                  .read(userInfoProvider)
                  .userId,
              senderName: 'java_system',
              receiverName: ref
                  .read(userInfoProvider)
                  .userName,
              content: content,
              timeStamp: timeStamp,
              gender: ref
                  .read(userInfoProvider)
                  .memberInfo!
                  .gender,
              expireTime: 0,
              halfTime: 0,
              points: 0,
              incomeflag: 0,
              type: 0,
              unRead: 1)
        ]);
  }

  /// 刷新消息列表
  /// callingType 接通狀態 0=接聽後掛斷 1=未接通撥方掛斷 2=未接通接方掛斷
  Future<void> insertToChatUserModel(ZIMMessage zimMessage, String recentlyMessage, bool isSystem, {SearchListInfo? searchInfo,num? callingType = 0,num? chatType = 1, String? duration}) async {
    ChatUserModel? chatUserModel;
    if(zimMessage.senderUserID != ref.read(userInfoProvider).userName){
      try {
        final userModel = ref.read(chatUserModelNotifierProvider);
        chatUserModel = userModel.firstWhere((info) => info.userName == zimMessage.senderUserID);
        if(searchInfo != null){

          recentlyMessage = getCallingTypeRecentlyMessage(zimMessage.senderUserID, recentlyMessage,duration!, callingType, chatType);
        }
      } catch (e) {
        /// 從後端讀取聊天列表資料
        final List<SearchListInfo> searchListInfo = await ref.read(authenticationProvider).loadSearchListInDB(loadAllData: true, updateDb: false) ?? [];
        final SearchListInfo searchInfo = searchListInfo.firstWhere((info) => info.userName == zimMessage.senderUserID);
        if(searchInfo != null){
          recentlyMessage = getCallingTypeRecentlyMessage(zimMessage.senderUserID, recentlyMessage, duration ?? '', callingType, chatType);
        }

        chatUserModel = ChatUserModel(
          userId: searchInfo.userId,
          roomIcon: searchInfo.roomIcon,
          cohesionLevel: searchInfo.cohesionLevel,
          userCount: searchInfo.userCount,
          isOnline: searchInfo.isOnline,
          userName: searchInfo.userName,
          roomId: searchInfo.roomId,
          roomName: searchInfo.roomName,
          points: searchInfo.points,
          remark: searchInfo.remark,
          unRead: 0,
          recentlyMessage: recentlyMessage,
          // pinTop:
        );
      }
    } else {
      recentlyMessage = getCallingTypeRecentlyMessage(zimMessage.senderUserID, recentlyMessage, duration ?? '', callingType, chatType);
      try {
        final userModel = ref.read(chatUserModelNotifierProvider);
        chatUserModel = userModel.firstWhere((info) => info.userName == zimMessage.conversationID);
      } catch (e) {
        /// 從後端讀取聊天列表資料
        final List<SearchListInfo> searchListInfo = await ref.read(authenticationProvider).loadSearchListInDB(loadAllData: true, updateDb: false) ?? [];
        final SearchListInfo searchInfo = searchListInfo.firstWhere((info) =>
        info.userName == zimMessage.conversationID);
        chatUserModel = ChatUserModel(
          userId: searchInfo.userId,
          roomIcon: searchInfo.roomIcon,
          cohesionLevel: searchInfo.cohesionLevel,
          userCount: searchInfo.userCount,
          isOnline: searchInfo.isOnline,
          userName: searchInfo.userName,
          roomId: searchInfo.roomId,
          roomName: searchInfo.roomName,
          points: searchInfo.points,
          remark: searchInfo.remark,
          unRead: 0,
          recentlyMessage: recentlyMessage,
          // pinTop:
        );
      }
    }

    Map<String, dynamic> extendedDataMap = {};
    if (!isSystem) {
      extendedDataMap = json.decode(zimMessage.extendedData) as Map<String, dynamic>;
    }
    num unRead = 0;
    if (chatUserModel.unRead != null) {
      unRead = chatUserModel.unRead! + 1;
    }

    num? cohesionLevel = extendedDataMap['cohesionLevel'];
    num? cohesionPoints = extendedDataMap['cohesionPoints'];

    /// searchInfo 資料 通話才會有
    if (searchInfo != null) {
      cohesionLevel = searchInfo.cohesionLevel;
      cohesionPoints = searchInfo.points;
    }



    ref.read(chatUserModelNotifierProvider.notifier).setDataToSql(
        chatUserModelList: [
          ChatUserModel(userId: chatUserModel.userId,
              roomIcon: chatUserModel.roomIcon,
              cohesionLevel: cohesionLevel,
              userCount: chatUserModel.userCount,
              isOnline: chatUserModel.isOnline,
              userName: chatUserModel.userName,
              roomId: chatUserModel.roomId,
              roomName: chatUserModel.roomName,
              points: cohesionPoints ?? 0,
              remark: chatUserModel.remark,
              unRead: unRead,
              recentlyMessage: recentlyMessage,
              timeStamp: zimMessage.timestamp,
              pinTop: chatUserModel.pinTop,
          charmCharge:chatUserModel.charmCharge,
          sendStatus:chatUserModel.sendStatus ?? 1 )
        ]);
  }

  void insertToChatCallModel(String uuid, {
    required SearchListInfo searchInfo,
    required OfficialMessageInfo officialMessageInfo,
  }) {
    ref.read(chatCallModelNotifierProvider.notifier).setDataToSql(
        chatCallModelList: [ChatCallModel(
          messageUuid: uuid,
          oppositeAvatarPath: searchInfo.roomIcon,
          callerName: officialMessageInfo.caller,
          receiverName: officialMessageInfo.answer,
          groupID: searchInfo.roomId,
          startTime: 0,
          endTime: officialMessageInfo.duration,
          isGroupCall: 0,
          callType: officialMessageInfo.chatType,
        )
        ]
    );
  }

  /// Zego Token即將過期的CallBack
  Future<ZIMTokenRenewedResult> onTokenWillExpire(ZIM zim, int time) async {
    final WsAccountGetRTMTokenRes rtcRes = await zimUtil.getRtcToken();
    final ZIMTokenRenewedResult renewToken = await ZIM.getInstance()!
        .renewToken(rtcRes.rtcToken ?? '')
        .onError((error, stackTrace) async {
          final WsAccountGetRTMTokenRes? reloadRes = await zimUtil.reloadZego();
          return ZIMTokenRenewedResult(token: reloadRes?.rtcToken ?? '');
      });
    return renewToken;
  }

  /// 聊天室頁面用 全部的未讀訊息callback
  void onConversationTotalUnreadMessageCountUpdated(ZIM zim, int totalCount) async {
    await ref.read(unreadMessageManager).updateUnreadCount();
    onTotalUnReadMessage?.call(totalCount);
  }

  void onConversationChanged(ZIM zim,
      List<ZIMConversationChangeInfo> zimMessageReceiptListInfo) {
    onConversationListChanged?.call(zimMessageReceiptListInfo);
  }


  /// 聊天室用 對方已讀的callback
  void onConversationMessageReceiptChanged(ZIM zim, List<ZIMMessageReceiptInfo> messageReceiptList) {
    onAnotherHaveReadMessage?.call(messageReceiptList);
  }

  // 收到語音或視頻的邀请(被動方)
  void onCallInvitationReceived(ZIM zim, ZIMCallInvitationReceivedInfo info, String callID) {
    final zimService = ref.read(zimServiceProvider);

    if (ZegoCallStateManager.instance.callData != null) {
      final zimService = ref.read(zimServiceProvider);
      zimService.rejectInvitation(invitationID: callID, extendedData: 'busy');
      return;
    }

    Map<String, dynamic> callInfoMap = {};
    try {
      callInfoMap = json.decode(info.extendedData) as Map<String, dynamic>;
    } on FormatException {
      debugPrint('The info.extendedData is not valid JSON');
    }

    ZegoCallType type = callInfoMap['type'] == ZegoCallType.video.index
        ? ZegoCallType.video
        : ZegoCallType.voice;
    String inviterName = callInfoMap['inviterName'] as String;
    ZegoCallStateManager.instance.createCallData(
      callID,
      ZegoUserInfo(userID: info.inviter, userName: inviterName),
      ZegoUserInfo(userID: zimService.zimUserInfo?.userID ?? '', userName: zimService.zimUserInfo?.userName ?? ''),
      ZegoCallUserState.received,
      type,
    );

    zimService.incomingCallInvitationReceivedStreamCtrl.add(
      IncomingCallInvitationReveivedEvent(
        callID,
        info.inviter,
        info.extendedData,
      ));
  }

  void onCallInvitationAccepted(ZIM zim, ZIMCallInvitationAcceptedInfo info, String callID) {
    final zimService = ref.read(zimServiceProvider);
    ZegoCallStateManager.instance.updateCall(callID, ZegoCallUserState.accepted);
    zimService.outgoingCallInvitationAcceptedStreamCtrl.add(OutgoingCallInvitationAcceptedEvent(callID, info.invitee, info.extendedData));
  }

  // 收到語音或視頻的取消(被動方)
  void onCallInvitationCancelled(ZIM zim, ZIMCallInvitationCancelledInfo info, String callID) {
    final zimService = ref.read(zimServiceProvider);
    ZegoCallStateManager.instance.updateCall(callID, ZegoCallUserState.cancelled);
    ZegoCallStateManager.instance.clearCallData();
    zimService.incomingCallInvitationCanceledStreamCtrl.add(IncomingCallInvitationCanceledEvent(callID, info.inviter, info.extendedData));
  }

  void onCallInvitationRejected(ZIM zim, ZIMCallInvitationRejectedInfo info, String callID) {
    final zimService = ref.read(zimServiceProvider);
    ZegoCallStateManager.instance.updateCall(callID, ZegoCallUserState.rejected);
    ZegoCallStateManager.instance.clearCallData();
    zimService.outgoingCallInvitationRejectedStreamCtrl.add(OutgoingCallInvitationRejectedEvent(callID, info.invitee, info.extendedData));
  }

  // 通話未接過期(30 秒)
  void onCallInvitationTimeout(ZIM zim, ZIMCallInvitationTimeoutInfo info, String callID) {
    final zimService = ref.read(zimServiceProvider);
    ZegoCallStateManager.instance.updateCall(callID, ZegoCallUserState.offline);
    ZegoCallStateManager.instance.clearCallData();
    zimService.incomingCallInvitationTimeoutStreamCtrl.add(IncomingCallInvitationTimeoutEvent(callID));
  }

  void onCallInviteesAnsweredTimeout(ZIM zim, List<String> invitees,
      String callID) {
    final zimService = ref.read(zimServiceProvider);
    ZegoCallStateManager.instance.updateCall(callID, ZegoCallUserState.offline);
    ZegoCallStateManager.instance.clearCallData();
    zimService.outgoingCallInvitationTimeoutStreamCtrl.add(OutgoingCallInvitationTimeoutEvent(callID, invitees));
  }

  void onConnectionStateChanged(ZIM zim, ZIMConnectionState state,
      ZIMConnectionEvent event, Map extendedData) {
    final zimService = ref.read(zimServiceProvider);
    zimService.connectionStateStreamCtrl.add(ZIMServiceConnectionStateChangedEvent(state, event, extendedData));
  }

  String getCallingTypeRecentlyMessage(String? caller,String message,String duration, num? type,num? chatType){
    final String userName = ref.read(userInfoProvider).memberInfo?.userName ?? '';
    String msg = message;
    switch(type){
      case 0:
        if(chatType == 1 || chatType == 7){
          msg = '语音通话:'+duration;
        }else{
          msg = '视频通话:'+duration;
        }
        break;
      case 1:
        String typeString = "";
        if(chatType == 1 || chatType == 7){
          typeString = '语音通话';
        }else{
          typeString = '视频通话';
        }
        if(caller == userName){
          msg = '$typeString已取消';
        }else{
          msg = '未接听$typeString';
        }
        break;
      case 2:
        if(chatType == 1 || chatType == 7){
          msg = '语音通话已拒绝';

        }else{
          msg = '视频通话已拒绝';
        }
        break;
      default:
        break;
    }
    return msg;
  }
}