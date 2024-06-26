
import 'dart:async';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frechat/models/certification_model.dart';
import 'package:frechat/models/ws_res/member/ws_member_info_res.dart';
import 'package:frechat/models/ws_res/notification/ws_notification_search_list_res.dart';
import 'package:frechat/models/zim/zim_message_sent_result_extended_data.dart';
import 'package:frechat/models/zpns/call_payload_model.dart';
import 'package:frechat/system/constant/enum.dart';
import 'package:frechat/system/database/model/activity_message_model.dart';
import 'package:frechat/system/database/model/chat_block_model.dart';
import 'package:frechat/system/database/model/chat_message_model.dart';
import 'package:frechat/system/database/model/chat_user_model.dart';
import 'package:frechat/system/extension/json.dart';
import 'package:frechat/system/provider/chat_block_model_provider.dart';
import 'package:frechat/system/provider/chat_message_model_provider.dart';
import 'package:frechat/system/provider/chat_user_model_provider.dart';
import 'package:frechat/system/provider/user_info_provider.dart';
import 'package:frechat/system/providers.dart';
import 'package:frechat/system/zego_call/interal/zim/call_data_manager.dart';
import 'package:frechat/system/zego_call/interal/zim/shumei_util.dart';
import 'package:frechat/system/zego_call/interal/zim/zim_util.dart';
import 'package:frechat/system/zego_call/model/zego_user_model.dart';
import 'package:frechat/system/zego_call/zego_provider.dart';
import 'package:frechat/system/zego_call/zyg_zego_setting.dart';

import 'zim_service_defines.dart';

class ZIMService {
  ZIMService({required this.ref}) {
    zimUtil = ref.read(zimUtilProvider);
  }
  ProviderRef ref;
  ZIMUserInfo? zimUserInfo;

  late ZIMUtil zimUtil;
  // ZIMService._internal();`
  //
  // factory ZIMService() => instance;
  // static final ZIMService` instance = ZIMService._internal();

  Future<void> init({required int appID, String? appSign}) async {
    initEventHandle();
    ZIM.create(
      ZIMAppConfig()
        ..appID = appID
        ..appSign = appSign ?? '',
    );
  }

  Future<void> dispose() async {
    uninitEventHandle();
    ZIM.getInstance()?.destroy();
  }

  Future<void> connectUser(String userID, String userName, {
    String? token
  }) async {
    final ZIMLoginConfig config = ZIMLoginConfig()
      ..token = token ?? ''
      ..userName = userName;
    final ZIMUserInfo userInfo = ZIMUserInfo()
      ..userID = userID
      ..userName = userName;
    zimUserInfo = userInfo;
    await ZIM.getInstance()!.login(userID, config);
  }

  /// 登出後, 推播也將收不到訊息
  Future<void> disconnectUserAndZpns() async {
    await ZIM.getInstance()!.logout();
  }

  @Deprecated('目前尚未有Room or Group概念，後續群組概念再加入')
  Future<ZIMRoomJoinedResult> joinChatRoom({required String roomID}) async {
    final ZIMRoomJoinedResult result =
        await ZIM.getInstance()!.joinRoom(roomID);
    return result;
  }

  // @Deprecated('目前尚未有Room or Group概念，後續群組概念再加入')
  Future<ZIMRoomLeftResult> exitChatRoom({required String roomID}) async {
    final ZIMRoomLeftResult result = await ZIM.getInstance()!.leaveRoom(roomID);
    return result;
  }

  Future<ZIMMessageSentResult> sendMessageWithPeer({
    required String toConversationID,
    required String message,
    required String extendedData,
    ZIMConversationType conversationType = ZIMConversationType.peer,
    ZIMMessageType zimMessageType = ZIMMessageType.text,
    int messageUUID = 0,
    Function(ZIMMessage)? onMessageAttached,
  }) async {
    ZIMTextMessage textMessage = ZIMTextMessage(message: message)
      ..type = zimMessageType
      ..direction = ZIMMessageDirection.send
      ..messageID = messageUUID
      ..receiptStatus = ZIMMessageReceiptStatus.processing
      ..sentStatus = ZIMMessageSentStatus.sending
      ..extendedData = extendedData;

    ZIMMessageSendConfig sendConfig = ZIMMessageSendConfig()
      ..priority = ZIMMessagePriority.high
      ..hasReceipt = true;

    final extendedDataJsonObj = json.decode(extendedData);
    final messageDataJsonObj = json.decode(message);
    final String roomName = await zimUtil.getRoomNameFromExtendData(extendedDataJsonObj: extendedDataJsonObj);
    ZIMPushConfig pushConfig = ZIMPushConfig()
      ..title = roomName
      ..content = messageDataJsonObj['content']
      ..payload = "payload"
      ..resourcesID = ZegoSetting.resourceId_message;

    sendConfig.pushConfig = pushConfig;

    /// onMessageAttached 回调，在消息发送前，可以获得一个临时的 ZIMMessage，
    /// 以便您添加一些业务处理逻辑。例如：在发送消息前，获取到该条消息的 ID 信息。
    /// 开发者在发送“视频”等内容较大的消息时，可以在消息上传完成前，
    /// 获取对应该条消息的 localMessageID，实现发送前 Loading 的效果。
    ZIMMessageSendNotification notification =
        ZIMMessageSendNotification(onMessageAttached: onMessageAttached);

    // 设置会话类型，选择其一向对应的会话类型发送消息
    ZIMConversationType type = conversationType;
    final ZIMMessageSentResult result = await ZIM.getInstance()!
        .sendMessage(textMessage, toConversationID, type, sendConfig, notification)
        .onError((error, stackTrace) {
          ///更新消息DB
          final List<ChatMessageModel> allChatMessageModelList = ref.read(chatMessageModelNotifierProvider);
          final List<ChatUserModel> allChatUserModelList = ref.read(chatUserModelNotifierProvider);
          final Map<String, dynamic> jsonObj = json.decode(message);
          String uuid = jsonObj['uuid'];
          final ChatMessageModel chatMessageModel = allChatMessageModelList.firstWhere((info) => info.messageUuid! == uuid);
          final model = ChatMessageModel(messageUuid: chatMessageModel.messageUuid, senderId: chatMessageModel.senderId, receiverId: chatMessageModel.receiverId, senderName: chatMessageModel.senderName,
              receiverName: chatMessageModel.receiverName, content: chatMessageModel.content, timeStamp: chatMessageModel.timeStamp, gender: chatMessageModel.gender,
              expireTime: chatMessageModel.expireTime, halfTime: chatMessageModel.halfTime, points: chatMessageModel.points, incomeflag: chatMessageModel.incomeflag, type: chatMessageModel.type, unRead: chatMessageModel.unRead,reviewStatus: 1,sendStatus: 3,);
          ref.read(chatMessageModelNotifierProvider.notifier).setDataToSql(chatMessageModelList: [model]);
          ///更新消息列表DB
          final ChatUserModel chatUserModel = allChatUserModelList.firstWhere((info) => info.userName == toConversationID);
          final targetChatUserModel = ChatUserModel(userId: chatUserModel.userId, roomIcon: chatUserModel.roomIcon, cohesionLevel: chatUserModel.cohesionLevel, userCount: chatUserModel.userCount, isOnline: chatUserModel.isOnline,
              userName:chatUserModel.userName, roomId:chatUserModel.roomId, roomName: chatUserModel.roomName, points: chatUserModel.points, remark: chatUserModel.remark, recentlyMessage: '具有违规内容', unRead: chatUserModel.unRead,
              timeStamp: chatUserModel.timeStamp, pinTop: chatUserModel.pinTop,sendStatus: chatUserModel.sendStatus,);
          ref.read(chatUserModelNotifierProvider.notifier).setDataToSql(chatUserModelList: [targetChatUserModel]);

          bool isShumeiMsg = ShumeiUtil.isShumeiMsg(error);
          if(isShumeiMsg) {
            error as PlatformException;
            String? errorMessage = error.message ?? '';
            ZimMessageSentResultExtendedData extendedData = ZimMessageSentResultExtendedData(errorType:1,errorCode:111101,message:errorMessage );
            ShumeiUtil.checkShumeiMsg(error);
            ZIMMessage zimMessage = ZIMMessage();
            zimMessage.sentStatus=ZIMMessageSentStatus.failed;
            zimMessage.extendedData = jsonEncode(extendedData.toJson());
            return ZIMMessageSentResult(message:zimMessage);

          }


          return ZIMMessageSentResult(message: ZIMMessage());
        });

    return result;
  }

  Future<ZIMMessageSentResult> sendImageMessageWithPeer({
    required String toConversationID,
    required String extendedData,
    ZIMConversationType conversationType = ZIMConversationType.peer,
    ZIMMessageType zimMessageType = ZIMMessageType.image,
    int messageUUID = 0,
    required String imagePath,
    Function(ZIMMessage)? onMessageAttached,
  }) async {
    ZIMImageMessage imageMessage = ZIMImageMessage(imagePath)
      ..type = zimMessageType
      ..direction = ZIMMessageDirection.send
      ..messageID = messageUUID
      ..receiptStatus = ZIMMessageReceiptStatus.processing
      ..sentStatus = ZIMMessageSentStatus.sending
      ..extendedData = extendedData;

    ZIMMessageSendConfig sendConfig = ZIMMessageSendConfig()
      ..priority = ZIMMessagePriority.high
      ..hasReceipt = true;
    final jsonObj = json.decode(extendedData);
    final String roomName = await zimUtil.getRoomNameFromExtendData(extendedDataJsonObj: jsonObj);
    ZIMPushConfig pushConfig = ZIMPushConfig()
      ..title = roomName
      ..content = "亲～您有图片讯息呦"
      ..payload = "payload"
      ..resourcesID = ZegoSetting.resourceId_message;

    sendConfig.pushConfig = pushConfig;

    /// onMessageAttached 回调，在消息发送前，可以获得一个临时的 ZIMMessage，
    /// 以便您添加一些业务处理逻辑。例如：在发送消息前，获取到该条消息的 ID 信息。
    /// 开发者在发送“视频”等内容较大的消息时，可以在消息上传完成前，
    /// 获取对应该条消息的 localMessageID，实现发送前 Loading 的效果。
    ZIMMediaMessageSendNotification notification =
        ZIMMediaMessageSendNotification(onMessageAttached: onMessageAttached);
    final ZIMMessageSentResult result = await ZIM.getInstance()!
      .sendMediaMessage(imageMessage, toConversationID, conversationType, sendConfig, notification)
      .onError((error, stackTrace) {
      final List<ChatMessageModel> allChatMessageModelList = ref.read(chatMessageModelNotifierProvider);
      final Map<String, dynamic> jsonObj = json.decode(extendedData);
      String uuid = jsonObj['uuid'];
      final ChatMessageModel chatMessageModel = allChatMessageModelList.firstWhere((info) => info.messageUuid! == uuid);
      final model = ChatMessageModel(messageUuid: chatMessageModel.messageUuid, senderId: chatMessageModel.senderId, receiverId: chatMessageModel.receiverId, senderName: chatMessageModel.senderName,
          receiverName: chatMessageModel.receiverName, content: chatMessageModel.content, timeStamp: chatMessageModel.timeStamp, gender: chatMessageModel.gender,
          expireTime: chatMessageModel.expireTime, halfTime: chatMessageModel.halfTime, points: chatMessageModel.points, incomeflag: chatMessageModel.incomeflag, type: chatMessageModel.type, unRead: chatMessageModel.unRead,sendStatus: chatMessageModel.sendStatus);
      ref.read(chatMessageModelNotifierProvider.notifier).setDataToSql(chatMessageModelList: [model]);

      ///更新消息列表DB
      final List<ChatUserModel> allChatUserModelList = ref.read(chatUserModelNotifierProvider);
      final ChatUserModel chatUserModel = allChatUserModelList.firstWhere((info) => info.userName == toConversationID);
      final targetChatUserModel = ChatUserModel(userId: chatUserModel.userId, roomIcon: chatUserModel.roomIcon, cohesionLevel: chatUserModel.cohesionLevel, userCount: chatUserModel.userCount, isOnline: chatUserModel.isOnline,
          userName:chatUserModel.userName, roomId:chatUserModel.roomId, roomName: chatUserModel.roomName, points: chatUserModel.points, remark: chatUserModel.remark, recentlyMessage: '具有违规图片', unRead: chatUserModel.unRead,
          timeStamp: chatUserModel.timeStamp, pinTop: chatUserModel.pinTop,sendStatus: chatMessageModel.sendStatus);
      ref.read(chatUserModelNotifierProvider.notifier).setDataToSql(chatUserModelList: [targetChatUserModel]);

      bool isisShumeiMsg = ShumeiUtil.isShumeiMsg(error);
      if(isisShumeiMsg) {
        error as PlatformException;
        String? errorMessage = error.message ?? '';
        ZimMessageSentResultExtendedData extendedData = ZimMessageSentResultExtendedData(errorType:1,errorCode:111101,message:errorMessage );
        ShumeiUtil.checkShumeiMsg(error);
        ZIMMessage zimMessage = ZIMMessage();
        zimMessage.sentStatus=ZIMMessageSentStatus.failed;
        zimMessage.extendedData = jsonEncode(extendedData.toJson());
        return ZIMMessageSentResult(message:zimMessage);

      }

        return ZIMMessageSentResult(message: ZIMMessage());
      });
    return result;
  }

  @Deprecated('不使用的方法')
  Future<ZIMMessageSentResult> sendAudioMessageWithPeer({
    required String toConversationID,
    ZIMConversationType conversationType = ZIMConversationType.peer,
    ZIMMessageType zimMessageType = ZIMMessageType.audio,
    int messageUUID = 0,
    required String audioPath,
    required int audioDuration,
    Function(ZIMMessage)? onMessageAttached,
  }) async {
    ZIMAudioMessage audioMessage = ZIMAudioMessage(audioPath)
      ..sentStatus = ZIMMessageSentStatus.sending
      ..type = zimMessageType
      ..receiptStatus = ZIMMessageReceiptStatus.processing
      ..messageID = messageUUID
      ..audioDuration = audioDuration;

    ZIMMessageSendConfig sendConfig = ZIMMessageSendConfig()
      ..priority = ZIMMessagePriority.high
      ..hasReceipt = true;
    final String roomName = await zimUtil.getRoomName(userName: toConversationID);
    ZIMPushConfig pushConfig = ZIMPushConfig()
      ..title = roomName
      ..content = "亲～您有声音讯息呦"
      ..payload = "payload"
      ..resourcesID = ZegoSetting.resourceId_message;

    sendConfig.pushConfig = pushConfig;

    /// onMessageAttached 回调，在消息发送前，可以获得一个临时的 ZIMMessage，
    /// 以便您添加一些业务处理逻辑。例如：在发送消息前，获取到该条消息的 ID 信息。
    /// 开发者在发送“视频”等内容较大的消息时，可以在消息上传完成前，
    /// 获取对应该条消息的 localMessageID，实现发送前 Loading 的效果。
    ZIMMediaMessageSendNotification notification =
        ZIMMediaMessageSendNotification(onMessageAttached: onMessageAttached);

    final ZIMMessageSentResult result = await ZIM
        .getInstance()!
        .sendMediaMessage(audioMessage, toConversationID, conversationType, sendConfig, notification)
        .onError((error, stackTrace) {
          ShumeiUtil.checkShumeiMsg(error);
          return ZIMMessageSentResult(message: ZIMMessage());
        });
    return result;
  }

  Future<ZIMMessageSentResult> sendFileMessageWithPeer({
    required String toConversationID,
    ZIMConversationType conversationType = ZIMConversationType.peer,
    ZIMMessageType zimMessageType = ZIMMessageType.file,
    int messageUUID = 0,
    required String filePath,
    required String extendedData,
    Function(ZIMMessage)? onMessageAttached,
  }) async {
    ZIMFileMessage fileMessage = ZIMFileMessage(filePath)
      ..sentStatus = ZIMMessageSentStatus.sending
      ..type = zimMessageType
      ..receiptStatus = ZIMMessageReceiptStatus.processing
      ..extendedData = extendedData;

    ZIMMessageSendConfig sendConfig = ZIMMessageSendConfig()
      ..priority = ZIMMessagePriority.high
      ..hasReceipt = true;

    final jsonObj = json.decode(extendedData);
    final String roomName = await zimUtil.getRoomNameFromExtendData(extendedDataJsonObj: jsonObj);
    ZIMPushConfig pushConfig = ZIMPushConfig()
      ..title = roomName
      ..content = "亲～您有档案讯息呦"
      ..payload = "payload"
      ..resourcesID = ZegoSetting.resourceId_message;

    sendConfig.pushConfig = pushConfig;

    /// onMessageAttached 回调，在消息发送前，可以获得一个临时的 ZIMMessage，
    /// 以便您添加一些业务处理逻辑。例如：在发送消息前，获取到该条消息的 ID 信息。
    /// 开发者在发送“视频”等内容较大的消息时，可以在消息上传完成前，
    /// 获取对应该条消息的 localMessageID，实现发送前 Loading 的效果。
    ZIMMediaMessageSendNotification notification =
    ZIMMediaMessageSendNotification(onMessageAttached: onMessageAttached);

    final ZIMMessageSentResult result = await ZIM
        .getInstance()!
        .sendMediaMessage(fileMessage, toConversationID, conversationType, sendConfig, notification)
        .onError((error, stackTrace) {
          return ZIMMessageSentResult(message: ZIMMessage());
        });
    return result;
  }

  Future<ZIMMessageInsertedResult> sendSystemMessageWithPeer({
    required String toConversationID,
    ZIMConversationType conversationType = ZIMConversationType.peer,
    ZIMMessageType zimMessageType = ZIMMessageType.system,
    int messageUUID = 0,
    required String systemContent,
    required String extendedData,
    required String senderUserID,
    Function(ZIMMessage)? onMessageAttached,
  }) async {
    ZIMSystemMessage systemMessage = ZIMSystemMessage(message: systemContent)
      ..sentStatus = ZIMMessageSentStatus.sending
      ..type = zimMessageType
      ..receiptStatus = ZIMMessageReceiptStatus.processing
      ..extendedData = extendedData;

    final ZIMMessageInsertedResult result = await ZIM
        .getInstance()!
        .insertMessageToLocalDB(systemMessage, toConversationID, conversationType,
        senderUserID);
    return result;
  }

  void receivePeerMessageListener({
    Function(String, ZIMTextMessage)? onReceiveTextMessage,
    Function(String, ZIMCommandMessage)? onReceiveCommandMessage,
    Function(String, ZIMImageMessage)? onReceiveImageMessage,
    Function(String, ZIMFileMessage)? onReceiveFileMessage,
    Function(String, ZIMAudioMessage)? onReceiveAudioMessage,
    Function(String, ZIMVideoMessage)? onReceiveVideoMessage,
    Function(String, ZIMBarrageMessage)? onReceiveBarrageMessage,
    Function(String, ZIMRevokeMessage)? onReceiveRevokeMessage,
    Function(String, ZIMSystemMessage)? onReceiveSystemMessage,
    Function(String, ZIMMessage)? onExceptionMessageType,
    Function(List<ZIMMessageReceiptInfo>)? onAnotherHaveReadMessage,
    Function(int)? onTotalUnReadMessage,
    Function(List<ZIMConversationChangeInfo>)? onConversationListChanged,
  }) {
    final zimCallback = ref.read(zimCallbackProvider);
    zimCallback.onReceiveTextMessage = onReceiveTextMessage;
    zimCallback.onReceiveCommandMessage = onReceiveCommandMessage;
    zimCallback.onReceiveImageMessage = onReceiveImageMessage;
    zimCallback.onReceiveFileMessage = onReceiveFileMessage;
    zimCallback.onReceiveAudioMessage = onReceiveAudioMessage;
    zimCallback.onReceiveVideoMessage = onReceiveVideoMessage;
    zimCallback.onReceiveBarrageMessage = onReceiveBarrageMessage;
    zimCallback.onReceiveRevokeMessage = onReceiveRevokeMessage;
    zimCallback.onReceiveSystemMessage = onReceiveSystemMessage;
    zimCallback.onExceptionMessageType = onExceptionMessageType;

    zimCallback.onAnotherHaveReadMessage = onAnotherHaveReadMessage;
    zimCallback.onTotalUnReadMessage = onTotalUnReadMessage;
    zimCallback.onConversationListChanged = onConversationListChanged;
  }

  /// 聊天室頁面用 已讀userName的未讀訊息
  Future<void> clearUnReadMessageByConversationID({
    required String conversationID,
    ZIMConversationType conversationType = ZIMConversationType.peer
  }) async {
    ZIM.getInstance()!.clearConversationUnreadMessageCount(conversationID, conversationType);
    zimUtil.clearUnReadMessageByConversationIdInDB(conversationID: conversationID);
  }

  Future<void> clearAllUnReadMessage() async {
    ZIM.getInstance()!.clearConversationTotalUnreadMessageCount();
    zimUtil.clearAllUnReadMessageInDB();
  }

  /// 收到訊息傳送，對方進callback發送已讀
  Future<void> receiveMessage({
    required String conversationID,
    ZIMConversationType conversationType = ZIMConversationType.peer
  }) async {
    ZIM.getInstance()!.sendConversationMessageReceiptRead(conversationID, conversationType);
  }

  // 取得所有 ConversationList
  Future<ZIMConversationListQueriedResult> getConversationListPagination(ZIMConversation? nextConversation) async {
    ZIMConversationQueryConfig conversationQueryConfig = ZIMConversationQueryConfig()
      ..nextConversation = nextConversation
      ..count = 100;

    ZIMConversationListQueriedResult res = await ZIM.getInstance()!.queryConversationList(conversationQueryConfig).onError((error, stackTrace) async {
      await zimUtil.connectZego();
      return getConversationListPagination(null); // 第一次查詢
    });

    if (res.conversationList.length >= 100) {
      // 遞迴，查詢下一頁數據
      ZIMConversationListQueriedResult nextPageRes = await getConversationListPagination(res.conversationList.last);
      res.conversationList.addAll(nextPageRes.conversationList);
    }

    return res;
  }

  Future<List<ZIMConversation>> getConversationList() async {

    final ZIMConversationListQueriedResult res = await getConversationListPagination(null);

    // 跟後端做資料比對
    final List<ChatUserModel> chatUserModels = ref.read(chatUserModelNotifierProvider);
    final bool isBlock = ref.read(userInfoProvider).buttonConfigList?.blockType == 1 ? true : false;

    final List<ZIMConversation> userMessageList = res.conversationList.where((conversation) {
      // 過濾出 userName == conversationID
      final check = chatUserModels.where((info) => info.userName == conversation.conversationID).toList();
      return check.isNotEmpty;
    }).toList();

    final List<ZIMConversation> userMessageFilterList = userMessageList.map((conversation) {
      // 檢查最後一條傳送失敗 & 審核中
      if (conversation.lastMessage?.sentStatus == ZIMMessageSentStatus.failed && isBlock) {
        return conversation = ShumeiUtil.checkLastMsg(conversation); // 顯示具有违规内容
      }
      return conversation;
    }).toList();

    return userMessageFilterList;
  }

  Future<ZIMMessageDeletedResult> deleteMessage({
    required String conversationID,
    ZIMConversationType conversationType = ZIMConversationType.peer,
    List<ZIMMessage>? messageList,
    bool isDeleteAllMessage = true,
  }) async {
    ZIMMessageDeleteConfig config = ZIMMessageDeleteConfig()..isAlsoDeleteServerMessage = true;

    if (isDeleteAllMessage) {
      final res = await ZIM
          .getInstance()!
          .deleteAllMessage(conversationID, conversationType, config);
      return res;
    }
    final list = messageList ?? [];
    final res = await ZIM
        .getInstance()!
        .deleteMessages(list, conversationID, conversationType, config);

    return res;
  }

  // 取得所有與 conversationID 的歷史紀錄
  Future<ZIMMessageQueriedResult> getAllHistoryMessageFromUserName({
    required String conversationID,
    ZIMConversationType conversationType = ZIMConversationType.peer,
    ZIMMessage? nextMessage
  }) async {

    ZIMMessageQueryConfig config = ZIMMessageQueryConfig()
      ..nextMessage = nextMessage
      ..count = 100;

    final ZIMMessageQueriedResult res = await ZIM.getInstance()!.queryHistoryMessage(conversationID, conversationType, config).onError((error, stackTrace) async {
      // await zimUtil.connectZego();
      return getAllHistoryMessageFromUserName(conversationID: conversationID, nextMessage: null);
    });

    if (res.messageList.length >= 100) {
      // 遞迴，查詢下一頁數據
      ZIMMessageQueriedResult nextPageRes = await getAllHistoryMessageFromUserName(conversationID: conversationID, nextMessage: res.messageList.last);
      res.messageList.addAll(nextPageRes.messageList);
    }
    return res;
  }

  Future<ZIMMessageQueriedResult> searchHistoryMessageFromUserName(
      {required String conversationID,
      ZIMConversationType conversationType = ZIMConversationType.peer,
      int messageCount = 30,
      bool messageReverse = true,
      ZIMMessage? nextMessage}) async {
    /// 从后往前获取会话历史消息，每次获取 30 条, 首次获取时 nextMessage 为 null
    ZIMMessageQueryConfig config = ZIMMessageQueryConfig()
      ..nextMessage = nextMessage
      ..count = messageCount
      ..reverse = messageReverse;

    final ZIMMessageQueriedResult result = await ZIM.getInstance()!.queryHistoryMessage(conversationID, conversationType, config)
        .onError((error, stackTrace) async {
          await zimUtil.connectZego();
          final ZIMMessageQueriedResult retryRes = await ZIM.getInstance()!.queryHistoryMessage(conversationID, conversationType, config);
          return retryRes;
        });
    return result;
  }

  /// 離線未接來電清單
  Future<ZIMCallInvitationListQueriedResult> getCallHistoryList() async {
    ZIMCallInvitationQueryConfig config = ZIMCallInvitationQueryConfig()
      ..count = 100;
    final ZIMCallInvitationListQueriedResult res =
        await ZIM.getInstance()!.queryCallInvitationList(config);
    return res;
  }

  /// 邀请者发起呼叫邀请时，每次可支持邀请一个或多个用户。同一个呼叫中，参与用户不能超过 9 人。
  /// 離線推播的話 pushConfig 需放置訊息。
  Future<ZegoSendInvitationResult> sendInvitation({
    required List<String> invitees,
    required ZegoCallType callType,
    int timeout = 60,
    String extendedData = '',
    required bool isOfflineCall,
    ZIMPushConfig? pushConfig
  }) async {
    final extendedDataJsonObj = json.decode(extendedData);
    final String name = extendedDataJsonObj['inviterName'] ?? '';

    final CallPayloadModel payload = zimUtil.getPayload(timeout: timeout, callWithVoiceOrVideo: callType.index);
    final Map<String, dynamic> payloadMap = payload.toMap();
    final String payloadStr = json.encode(payloadMap);

    pushConfig ??= ZIMPushConfig()
      ..title = name // invitees.first
      ..content = '通话邀请'
      ..resourcesID = ZegoSetting.resourceId_message
      ..payload = payloadStr;

    /// Zim voip
    ZIMVoIPConfig voIPConfig = ZIMVoIPConfig();
    voIPConfig.iOSVoIPHandleType = ZIMCXHandleType.generic;
    //发送方联系人信息
    voIPConfig.iOSVoIPHandleValue = invitees.first;
    //是否为视频通话
    voIPConfig.iOSVoIPHasVideo = false;
    pushConfig.voIPConfig = voIPConfig;

    final pushConfigResult = (isOfflineCall) ? pushConfig : null;
    final config = ZIMCallInviteConfig()
      ..mode = ZIMCallInvitationMode.general
      ..extendedData = extendedData
      ..timeout = timeout
      ..pushConfig = pushConfigResult;

    Map<String, dynamic> extendedDataMap = {};
    extendedDataMap = json.decode(extendedData) as Map<String, dynamic>;
    WsMemberInfoRes memberInfoRes =  WsMemberInfoRes.fromJson(extendedDataMap['memberInfoRes']);
    print(memberInfoRes);
    String nickName = '';
    if(CertificationModel.getType(authNum: memberInfoRes.nickNameAuth) == CertificationType.done){
      nickName = memberInfoRes.nickName!;
    }else{
      nickName = '';
    }

    await ref.read(userUtilProvider.notifier).setDataToPrefs(userCallStatus: UserCallStatus.outGoingRinging);
    return ZIM.getInstance()!.callInvite(invitees, config).then((ZIMCallInvitationSentResult zimResult) {
      ZegoCallStateManager.instance.createCallData(
        zimResult.callID,
        ZegoUserInfo(userID: zimUserInfo?.userID ?? '', userName: nickName),
        ZegoUserInfo(userID: invitees.first, userName: ''),
        ZegoCallUserState.inviting,
        callType,
      );
      return ZegoSendInvitationResult(
        invitationID: zimResult.callID,
        errorInvitees: {
          for (var element in zimResult.info.errorInvitees)
            element.userID: ZegoCallUserState.values[element.state.index]
        },
      );
    }).catchError((error) {
      return ZegoSendInvitationResult(
        invitationID: '',
        errorInvitees: {},
        error: error,
      );
    });
  }

  Future<ZegoCancelInvitationResult> cancelInvitation({
    required String invitationID,
    required List<String> invitees,
    String extendedData = '',
  }) async {
    ZegoCallStateManager.instance.clearCallData();
    return ZIM
        .getInstance()!
        .callCancel(invitees, invitationID,
            ZIMCallCancelConfig()..extendedData = extendedData)
        .then((ZIMCallCancelSentResult zimResult) {
      return ZegoCancelInvitationResult(
        errorInvitees: zimResult.errorInvitees,
      );
    }).catchError((error) {
      return ZegoCancelInvitationResult(
        errorInvitees: invitees,
        error: error,
      );
    });
  }

  Future<ZegoResponseInvitationResult> rejectInvitation({
    required String invitationID,
    String extendedData = '',
  }) {
    if (invitationID == ZegoCallStateManager.instance.callData?.callID) {
      ZegoCallStateManager.instance.clearCallData();
    }
    return ZIM
        .getInstance()!
        .callReject(
            invitationID, ZIMCallRejectConfig()..extendedData = extendedData)
        .then((ZIMCallRejectionSentResult zimResult) {
      return const ZegoResponseInvitationResult();
    }).catchError((error) {
      return ZegoResponseInvitationResult(
        error: error,
      );
    });
  }

  Future<ZegoResponseInvitationResult> acceptInvitation({
    required String invitationID,
    String extendedData = '',
  }) {
    return ZIM.getInstance()!.callAccept(invitationID, ZIMCallAcceptConfig()..extendedData = extendedData).then((ZIMCallAcceptanceSentResult zimResult) {
      ZegoCallStateManager.instance.updateCall(invitationID, ZegoCallUserState.accepted);
      return const ZegoResponseInvitationResult();
    }).catchError((error) {
      return ZegoResponseInvitationResult(error: error);
    });
  }

  // 取得動態通知未讀數
  Future<int> getActivityUnreadCount({
    int queryCount = 100,
    ZIMConversation? nextConversation}) async {
    ZIMConversationQueryConfig conversationQueryConfig = ZIMConversationQueryConfig()
      ..nextConversation = nextConversation
    // The number of queries per page.
      ..count = queryCount;

    // Get the session list.
    final ZIMConversationListQueriedResult res = await ZIM.getInstance()!
        .queryConversationList(conversationQueryConfig)
        .onError((error, stackTrace) async {
      await zimUtil.connectZego();
      final ZIMConversationListQueriedResult retryRes = await ZIM.getInstance()!
          .queryConversationList(conversationQueryConfig);
      return retryRes;
    });

    int count = 0;

    List<ZIMConversation> feedNotifyMessageList = [];
    feedNotifyMessageList = res.conversationList.where((conversation) => conversation.conversationID == 'feed_notify').toList();
    feedNotifyMessageList = feedNotifyMessageList.where((conversation) {
      ZIMTextMessage? lastTextMessage= conversation.lastMessage as ZIMTextMessage? ;
      String messageJsonString = lastTextMessage?.message ?? '{}';
      final messageJsonObj = json.tryDecode(messageJsonString);
      final ActivityMessageModel model = ActivityMessageModel.fromJson(messageJsonObj);
      final List<ChatBlockModel> blockList = ref.read(chatBlockModelNotifierProvider);
      bool isBlockUser = blockList.any((block) => block.userName == model.fromUserUserName);
      return !isBlockUser;
    }).toList();

    if (feedNotifyMessageList.isNotEmpty) {
      count = feedNotifyMessageList?.first?.unreadMessageCount ?? 0;
    } else {
      count = 0;
    }
    return count;
  }


  void uninitEventHandle() {
    ZIMEventHandler.onCallInvitationReceived = null;
    ZIMEventHandler.onCallInvitationAccepted = null;
    ZIMEventHandler.onCallInvitationRejected = null;
    ZIMEventHandler.onCallInvitationCancelled = null;
    ZIMEventHandler.onCallInvitationTimeout = null;
    ZIMEventHandler.onCallInviteesAnsweredTimeout = null;
    ZIMEventHandler.onConnectionStateChanged = null;
    ZIMEventHandler.onConversationChanged = null;

    ZIMEventHandler.onReceivePeerMessage = null;
    ZIMEventHandler.onConversationMessageReceiptChanged = null;
    ZIMEventHandler.onConversationTotalUnreadMessageCountUpdated = null;
    ZIMEventHandler.onTokenWillExpire = null;
  }

  void initEventHandle() {
    final zimCallback = ref.read(zimCallbackProvider);
    ZIMEventHandler.onCallInvitationReceived =
        zimCallback.onCallInvitationReceived;
    ZIMEventHandler.onCallInvitationAccepted =
        zimCallback.onCallInvitationAccepted;
    ZIMEventHandler.onCallInvitationCancelled =
        zimCallback.onCallInvitationCancelled;
    ZIMEventHandler.onCallInvitationRejected =
        zimCallback.onCallInvitationRejected;
    ZIMEventHandler.onCallInvitationTimeout =
        zimCallback.onCallInvitationTimeout;
    ZIMEventHandler.onCallInviteesAnsweredTimeout =
        zimCallback.onCallInviteesAnsweredTimeout;
    ZIMEventHandler.onConnectionStateChanged =
        zimCallback.onConnectionStateChanged;

    ZIMEventHandler.onReceivePeerMessage = zimCallback.onReceivePeerMessage;

    ZIMEventHandler.onConversationMessageReceiptChanged =
        zimCallback.onConversationMessageReceiptChanged;
    ZIMEventHandler.onConversationTotalUnreadMessageCountUpdated =
        zimCallback.onConversationTotalUnreadMessageCountUpdated;

    ZIMEventHandler.onConversationChanged = zimCallback.onConversationChanged;

    ZIMEventHandler.onTokenWillExpire = zimCallback.onTokenWillExpire;
  }

  final incomingCallInvitationReceivedStreamCtrl =
      StreamController<IncomingCallInvitationReveivedEvent>.broadcast();
  final outgoingCallInvitationAcceptedStreamCtrl =
      StreamController<OutgoingCallInvitationAcceptedEvent>.broadcast();
  final incomingCallInvitationCanceledStreamCtrl =
      StreamController<IncomingCallInvitationCanceledEvent>.broadcast();
  final outgoingCallInvitationRejectedStreamCtrl =
      StreamController<OutgoingCallInvitationRejectedEvent>.broadcast();
  final incomingCallInvitationTimeoutStreamCtrl =
      StreamController<IncomingCallInvitationTimeoutEvent>.broadcast();
  final outgoingCallInvitationTimeoutStreamCtrl =
      StreamController<OutgoingCallInvitationTimeoutEvent>.broadcast();
  final connectionStateStreamCtrl =
      StreamController<ZIMServiceConnectionStateChangedEvent>.broadcast();
}
