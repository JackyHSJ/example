import 'dart:async';
import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frechat/models/certification_model.dart';
import 'package:frechat/models/user_info_model.dart';
import 'package:frechat/models/ws_req/account/ws_account_speak_req.dart';
import 'package:frechat/models/ws_res/account/ws_account_get_gift_detail_res.dart';
import 'package:frechat/models/ws_res/account/ws_account_speak_res.dart';
import 'package:frechat/models/ws_res/notification/ws_notification_search_list_res.dart';
import 'package:frechat/models/zim/zim_message_content.dart';
import 'package:frechat/models/zim/zim_message_extended_data.dart';
import 'package:frechat/system/constant/enum.dart';
import 'package:frechat/system/database/model/chat_message_model.dart';
import 'package:frechat/system/global/shared_preferance.dart';
import 'package:frechat/system/provider/chat_message_model_provider.dart';
import 'package:frechat/system/providers.dart';
import 'package:frechat/system/util/audio_util.dart';
import 'package:frechat/system/util/image_picker_util.dart';
import 'package:frechat/system/ws_comm/ws_account.dart';
import 'package:frechat/system/zego_call/interal/zim/zim_service.dart';
import 'package:frechat/system/zego_call/interal/zim/zim_service_defines.dart';
import 'package:frechat/system/zego_call/zego_provider.dart';

import '../repository/response_code.dart';


enum MessageContentType {
  text,
  image,
  file,
  introduction,
  strikeup,
  coinGift,
  backpackGift,
}

enum MessageSendFailType {
  fail,
  timeOut,
  reject,
}

class ChatMessageManager {
  ChatMessageManager({required this.ref}){
    userInfoModel = ref.read(userInfoProvider);
    zimService = ref.read(zimServiceProvider);
    accountWs = ref.read(accountWsProvider);
  }

  ProviderRef ref;
  late UserInfoModel userInfoModel;
  late ZIMService zimService ;
  late AccountWs accountWs;


  //傳送文字
  Future<void> sendTextMessage(
      {required String uuId,
      required int contentType,
      required SearchListInfo? searchListInfo,
      required String? message,
      required bool isStrikeUp,
      required num isReplyPickup,
      required Function(WsAccountSpeakRes, ZIMTextMessage) onConnectSuccess,
      required Function(MessageSendFailType failType,String msg) onConnectFail}) async {

    String chatContent = message ?? '';
    String replyUuid = _getReplyUUid(searchListInfo);
    String userName = searchListInfo?.userName ?? '';
    num roomId = searchListInfo?.roomId ?? 0;

    final reqBody = WsAccountSpeakReq.create(
        roomId: searchListInfo?.roomId ?? 0,
        userId: searchListInfo?.userId ?? 0,
        contentType: isStrikeUp?3:contentType,
        chatContent: chatContent,
        uuId: uuId,
        replyUuid: replyUuid,
        flag: '0',
        giftId: '',
        giftAmount: '',
        isReplyPickup: isReplyPickup);

    String resultCode = '';
    final WsAccountSpeakRes res = await _timeoutCheck(
        action: () async => await accountWs.wsAccountSpeak(
          reqBody,
          onConnectSuccess: (succMsg) {
            resultCode = succMsg;
          },
          onConnectFail: (errMsg) {
            resultCode = errMsg;
          },
        ),
        timeOutAction: () {
          onConnectFail.call(MessageSendFailType.timeOut,'TimeOut');
        } ) as WsAccountSpeakRes;

    if (resultCode == ResponseCode.CODE_SUCCESS) {
      ZimMessageExtendedData extendedData = await _getZimMessageExtendedData(userName: userName, roomId: roomId, isStrikeUp: isStrikeUp, res: res);
      ZimMessageContent messageContent = _getZimMessageContent(uuId: uuId, contentType: contentType, chatContent: chatContent);
      await _zimSendTextMessage(extendedData: extendedData, messageContent: messageContent,
      onConnectSuccess: (zimTextMessage) {
            onConnectSuccess.call(res, zimTextMessage);
          },
          onConnectFail: (errorType,msg) {
            onConnectFail.call(errorType,msg);
          });
    } else {
      onConnectFail.call(MessageSendFailType.fail,resultCode);
    }
  }

  //傳送禮物
  Future<void> sendGiftMessage(
      {required String uuId,
      required int contentType,
      required SearchListInfo? searchListInfo,
      required String message,
      required bool isStrikeUp,
      required num isReplyPickup,
      GiftListInfo? giftListInfo,
      required Function(WsAccountSpeakRes, ZIMTextMessage) onConnectSuccess,
      required Function(MessageSendFailType failType,String msg) onConnectFail}) async {

    String chatContent = message ??'[礼物]';
    String replyUuid = _getReplyUUid(searchListInfo);
    String userName = searchListInfo?.userName ?? '';
    num roomId = searchListInfo?.roomId ?? 0;
    num giftId =  giftListInfo?.giftId ??0;
    String giftAmount = giftListInfo?.giftSendAmount.toString() ??'';

    WsAccountSpeakReq reqBody = WsAccountSpeakReq(
        roomId: searchListInfo?.roomId ?? 0,
        userId: searchListInfo?.userId ?? 0,
        contentType: isStrikeUp?3:contentType,
        chatContent: chatContent,
        uuId: uuId,
        flag: '0',
        replyUuid: replyUuid,
        giftId:giftId.toString(),
        giftAmount: giftAmount,
        isReplyPickup: isReplyPickup);


    String resultCode = '';
    final WsAccountSpeakRes res = await _timeoutCheck(
        action: () async => await accountWs.wsAccountSpeak(
          reqBody,
          onConnectSuccess: (succMsg) {
            resultCode = succMsg;
          },
          onConnectFail: (errMsg) {
            resultCode = errMsg;
          },
        ),
        timeOutAction: () {
          onConnectFail.call(MessageSendFailType.timeOut,'TimeOut');
        } ) as WsAccountSpeakRes;
    if (resultCode == ResponseCode.CODE_SUCCESS) {
      ZimMessageExtendedData extendedData = await _getZimMessageExtendedData(userName: userName, roomId: roomId, isStrikeUp: isStrikeUp, res: res,giftInfo: giftListInfo);
      ZimMessageContent messageContent = _getZimMessageContent(uuId: uuId, contentType: contentType, chatContent: chatContent);
      _zimSendTextMessage(extendedData: extendedData, messageContent: messageContent,
      onConnectSuccess: (zimTextMessage) {
            onConnectSuccess.call(res, zimTextMessage);
          },
          onConnectFail: (errorType,msg) {
            onConnectFail.call(errorType,msg);
          });
    } else {

      onConnectFail.call(MessageSendFailType.fail,resultCode);
    }

  }

  //傳送圖片
  Future<void> sendImageMessage(
      {required String uuId,
      required int contentType,
      required SearchListInfo? searchListInfo,
      required String message,
      required bool isStrikeUp,
      required num isReplyPickup,
      required String imagePath,
      required Function(WsAccountSpeakRes, ZIMImageMessage) onConnectSuccess,
      required Function(MessageSendFailType failType,String msg) onConnectFail}) async {

    String chatContent = message ?? '';
    String replyUuid = _getReplyUUid(searchListInfo);
    String userName = searchListInfo?.userName ?? '';
    num roomId = searchListInfo?.roomId ?? 0;
    final reqBody = WsAccountSpeakReq.create(
        roomId: searchListInfo?.roomId ?? 0,
        userId: searchListInfo?.userId ?? 0,
        contentType: isStrikeUp?3:contentType,
        chatContent: chatContent,
        uuId: uuId,
        replyUuid: replyUuid,
        flag: '0',
        giftId: '',
        giftAmount: '',
        isReplyPickup: isReplyPickup);

    String resultCode = '';
    final WsAccountSpeakRes res = await _timeoutCheck(
        action: () async => await accountWs.wsAccountSpeak(
          reqBody,
          onConnectSuccess: (succMsg) {
            resultCode = succMsg;
          },
          onConnectFail: (errMsg) {
            resultCode = errMsg;
          },
        ),
        timeOutAction: () {
          onConnectFail.call(MessageSendFailType.timeOut,resultCode);
        } ) as WsAccountSpeakRes;
    if (resultCode == ResponseCode.CODE_SUCCESS) {
      ZimMessageExtendedData extendedData = await _getZimMessageExtendedData(userName: userName, roomId: roomId, isStrikeUp: isStrikeUp, res: res);
      _zimSendImageMessage(extendedData: extendedData, imagePath: imagePath,
      onConnectSuccess: (zimImageMessage) {
            onConnectSuccess.call(res, zimImageMessage);
          },
          onConnectFail: (errorTyep,msg) {
            onConnectFail.call(errorTyep,msg);
          });
    } else {
      onConnectFail.call(MessageSendFailType.fail,resultCode);
    }

  }

  //傳送錄音
  Future<void> sendVoiceMessage(
      {required String uuId,
      required int contentType,
      required SearchListInfo? searchListInfo,
      required String message,
      required bool isStrikeUp,
      required num isReplyPickup,
      required String voiceUrl,
      required num audioTime,
      required Function(WsAccountSpeakRes, ZIMFileMessage) onConnectSuccess,
      required Function(MessageSendFailType failType,String msg) onConnectFail}) async {

    // String chatContent = message ?? '';
    // 後端會在錄音檔審核後，將『chatContent』，放入extendata中傳給對方，
    // 接收方會在 extendata 中 收到chatContent:{{audioTime:錄音時間}}
    String chatContent =jsonEncode({'audioTime': audioTime,});
    String replyUuid = _getReplyUUid(searchListInfo);
    String userName = searchListInfo?.userName ?? '';
    num roomId = searchListInfo?.roomId ?? 0;

    final reqBody = WsAccountSpeakReq.create(
        roomId: searchListInfo?.roomId ?? 0,
        userId: searchListInfo?.userId ?? 0,
        contentType: isStrikeUp?3:contentType,
        chatContent: chatContent,
        uuId: uuId,
        replyUuid: replyUuid,
        flag: '0',
        giftId: '',
        giftAmount: '',
        isReplyPickup: isReplyPickup);

    String resultCode = '';
    final WsAccountSpeakRes res = await _timeoutCheck(
        action: () async => await accountWs.wsAccountSpeak(
          reqBody,
          onConnectSuccess: (succMsg) {
            resultCode = succMsg;
          },
          onConnectFail: (errMsg) {
            resultCode = errMsg;
          },
        ),
        timeOutAction: () {
          onConnectFail.call(MessageSendFailType.timeOut,resultCode);
        } ) as WsAccountSpeakRes;
    if (resultCode == ResponseCode.CODE_SUCCESS) {
      ZimMessageExtendedData extendedData = await _getZimMessageExtendedData(userName: userName, roomId: roomId, isStrikeUp: isStrikeUp,audioTime:audioTime, res: res);
      _zimSendFileMessage(extendedData: extendedData, filePath: voiceUrl,
          onConnectSuccess: (zimFileMessage) {
            onConnectSuccess.call(res, zimFileMessage);
          },
          onConnectFail: (errorType,msg) {
            onConnectFail.call(errorType,msg);
          });
    } else {
      onConnectFail.call(MessageSendFailType.fail,resultCode);
    }



  }



  Future<void> _zimSendTextMessage({required ZimMessageExtendedData extendedData,required ZimMessageContent messageContent,required Function(ZIMTextMessage) onConnectSuccess,
    required Function(MessageSendFailType,String) onConnectFail,}) async{
    String userName = userInfoModel.memberInfo?.userName ?? '';
    String conversationID = extendedData?.receiver ??'';
    String extendedDataString = jsonEncode(extendedData.toJson());
    String messageContentString = jsonEncode(messageContent.toJson());
    final ZIMMessageSentResult sendMsgRes = await zimService.sendMessageWithPeer(toConversationID:conversationID , message: messageContentString, extendedData: extendedDataString);
    if(sendMsgRes.message.type == ZIMMessageType.unknown && sendMsgRes.message.receiptStatus == ZIMMessageReceiptStatus.none) {

      if(sendMsgRes.message.sentStatus == ZIMMessageSentStatus.failed){
        ///TODO:目前將所有『ZIMMessageSentStatus.failed』都判斷為 審核失敗訊息，後面優化需要判斷sendMsgRes.message.extendata裡面的參數（與ZIMService 中sendMessageWithPeer相關）
        onConnectFail.call(MessageSendFailType.reject,'ZIMMessageFail');
      }else{
        onConnectFail.call(MessageSendFailType.fail,'ZIMMessageFail');
      }

    }else{
      ZIMTextMessage zimTextMessage = ZIMTextMessage(message: messageContentString);
      zimTextMessage.type = ZIMMessageType.text;
      // zimTextMessage.timestamp = DateTime.now().millisecondsSinceEpoch;
      zimTextMessage.timestamp = extendedData.createTime?.toInt() ?? DateTime.now().millisecondsSinceEpoch;
      zimTextMessage.receiptStatus = ZIMMessageReceiptStatus.processing;
      zimTextMessage.message = messageContentString;
      zimTextMessage.extendedData = extendedDataString;
      zimTextMessage.senderUserID = userName;
      onConnectSuccess.call(zimTextMessage);

    }
  }


  Future<void> _zimSendImageMessage({required ZimMessageExtendedData extendedData,required String imagePath,required Function(ZIMImageMessage) onConnectSuccess,
    required Function(MessageSendFailType,String) onConnectFail,}) async{

    String conversationID = extendedData?.receiver ??'';
    String extendedDataString = jsonEncode(extendedData.toJson());
    final ZIMMessageSentResult sendImgRes = await zimService.sendImageMessageWithPeer(toConversationID: conversationID, zimMessageType: ZIMMessageType.image, extendedData: extendedDataString, imagePath: imagePath);

    if(sendImgRes.message.type == ZIMMessageType.unknown && sendImgRes.message.receiptStatus == ZIMMessageReceiptStatus.none) {
      if(sendImgRes.message.sentStatus == ZIMMessageSentStatus.failed){
        ///TODO:目前將所有『ZIMMessageSentStatus.failed』都判斷為 審核失敗訊息，後面優化需要判斷sendMsgRes.message.extendata裡面的參數（與ZIMService 中sendMessageWithPeer相關）
        onConnectFail.call(MessageSendFailType.reject,'ZIMMessageFail');
      }else{
        onConnectFail.call(MessageSendFailType.fail,'ZIMMessageFail');
      }
    }else{
      ZIMImageMessage zimImageMessage = ZIMImageMessage(imagePath);
      zimImageMessage.type = ZIMMessageType.image;
      // zimImageMessage.timestamp = DateTime.now().millisecondsSinceEpoch;
      zimImageMessage.timestamp = extendedData.createTime?.toInt() ?? DateTime.now().millisecondsSinceEpoch;
      zimImageMessage.receiptStatus = ZIMMessageReceiptStatus.processing;
      zimImageMessage.extendedData =  extendedDataString;
      onConnectSuccess.call(zimImageMessage);
    }

  }


  Future<void> _zimSendFileMessage({required ZimMessageExtendedData extendedData,required String filePath,required Function(ZIMFileMessage) onConnectSuccess,
    required Function(MessageSendFailType,String) onConnectFail,}) async{

    String conversationID = extendedData?.receiver ??'';
    String extendedDataString = jsonEncode(extendedData.toJson());

    final ZIMMessageSentResult sendImgRes = await zimService.sendFileMessageWithPeer(toConversationID: conversationID, filePath: filePath, extendedData: extendedDataString);

    //錄音不走ZEGO的CallBack
    // if(sendImgRes.message.type == ZIMMessageType.unknown && sendImgRes.message.receiptStatus == ZIMMessageReceiptStatus.none) {
    //   onConnectFail.call('ZIMMessageFail');
    // }
    ZIMFileMessage zimFileMessage = ZIMFileMessage(AudioUtils.filePath!);
    zimFileMessage.type = ZIMMessageType.file;
    // zimFileMessage.timestamp = DateTime.now().millisecondsSinceEpoch;
    zimFileMessage.timestamp = extendedData.createTime?.toInt() ?? DateTime.now().millisecondsSinceEpoch;
    zimFileMessage.receiptStatus = ZIMMessageReceiptStatus.processing;
    zimFileMessage.extendedData = extendedDataString;
    onConnectSuccess.call(zimFileMessage);
  }

  /// ---工具---

  String _getReplyUUid(SearchListInfo? searchListInfo) {
    String replyUuid = '';
    List<ChatMessageModel> chatMessageModelList = _getChatMsgFormUserName(searchListInfo);
    for (int i = chatMessageModelList.length - 1; i >= 0; i--) {
      if (chatMessageModelList[i].senderName != userInfoModel.memberInfo!.userName) {
        if (replyUuid.isEmpty) {
          replyUuid = chatMessageModelList[i].messageUuid!;
        } else {
          replyUuid += ",${chatMessageModelList[i].messageUuid!}";
        }
      } else {
        ///需要多判断再次重送失败的情况
        if(chatMessageModelList[i].sendStatus == 1){
          break;
        }else{
          continue;
        }
      }
    }
    return replyUuid;
  }

  Future<ZimMessageExtendedData> _getZimMessageExtendedData({required String userName,required num roomId ,required bool isStrikeUp,required WsAccountSpeakRes res,GiftListInfo? giftInfo,num? audioTime}) async {
    final String sender = userInfoModel.memberInfo?.userName ?? '';
    final String avatar = userInfoModel.memberInfo?.avatarPath ?? '';
    final num gender = userInfoModel.memberInfo?.gender ?? 0;

    ///發出訊息如果為搭訕/心動，則isReplyPickup 為1，讓對方能夠依照此參數確認是否要告知後端為回應搭訕
    ///TODO:  extendedData 參數的『isReplyPickup』應該改成『isStrikeUp』不然會搞混
    final num isReplyPickup = isStrikeUp ?1:0;

    String roomName = await _getRoomName();
    ZimMessageExtendedData extendedData = ZimMessageExtendedData(
      roomName: roomName,
      avatar: avatar,
      gender: gender,
      sender: sender,
      receiver: userName,
      roomId: roomId,
      remainCoins: res.remainCoins,
      expireTime: res.expireTime,
      halfTime: res.halfTime,
      points: res.points,
      incomeflag: res.incomeflag,
      uuid: res.uuId,
      expireDuration: res.expireDuration,
      halfDuration: res.halfDuration,
      cohesionPoints: res.cohesionPoints,
      cohesionLevel: res.cohesionLevel,
      createTime: res.createTime,
      isReplyPickup: isReplyPickup,
      isGift: 0,
      giftUrl: giftInfo?.giftImageUrl,
      svgaFileId: giftInfo?.svgaFileId,
      svgaUrl: giftInfo?.svgaUrl,
      giftSendAmount: giftInfo?.giftSendAmount,
      giftName: giftInfo?.giftName,
      coins: giftInfo?.coins,
      giftId: giftInfo?.giftId.toString(),
      giftCategoryName: giftInfo?.categoryName,
      audioTime:audioTime,
    );

    return extendedData;
  }

  ZimMessageContent _getZimMessageContent({required String uuId,required num contentType,required String chatContent,GiftListInfo? giftInfo}){

    ZimMessageContent content = ZimMessageContent(
      uuid: uuId,
      type: contentType,
      content: chatContent,
      giftId: giftInfo?.giftId.toString() ?? '',
      giftCount: giftInfo?.giftSendAmount.toString() ?? '',
      giftUrl: giftInfo?.giftImageUrl ?? '',
      giftName: giftInfo?.giftName ?? '',
    );

    return content;
  }

  Future<String> _getRoomName() async {
    final num nickNameAuth = userInfoModel.memberInfo?.nickNameAuth ?? 0;
    CertificationType nickNameCertificationType = CertificationModel.getType(authNum: nickNameAuth);
    String roomName = '';
    String keepNickNameInReview = await FcPrefs.getKeepNickNameInReview();
    if (nickNameCertificationType == CertificationType.done) {
      roomName =  userInfoModel.memberInfo?.nickName ?? '';
    } else {
      if (keepNickNameInReview.isNotEmpty) {
        roomName = keepNickNameInReview;
      } else {
        roomName = userInfoModel.memberInfo?.userName ?? '';
      }
    }
    return roomName;
  }

  List<ChatMessageModel> _getChatMsgFormUserName (SearchListInfo? searchListInfo) {
    final allChatMessageModelList = ref.watch(chatMessageModelNotifierProvider);
    final mySendChatMessagelist = allChatMessageModelList.where((info) => info.senderName == userInfoModel.memberInfo?.userName && info.receiverName == searchListInfo?.userName).toList();
    final oppoSiteSendChatMessagelist = allChatMessageModelList.where((info) => info.senderName == searchListInfo?.userName && info.receiverName == userInfoModel.memberInfo?.userName).toList();
    List<ChatMessageModel> chatMessageModelList = _sortChatMessages(mySendChatMessagelist, oppoSiteSendChatMessagelist);
    return chatMessageModelList;
  }

  // 訊息時間排序
  List<ChatMessageModel> _sortChatMessages(List<ChatMessageModel> list1, List<ChatMessageModel> list2) {
    // 合并两个列表
    List<ChatMessageModel> mergedList = [...list1, ...list2];
    // 使用List的sort方法按时间戳升序排序
    mergedList.sort((a, b) => a.timeStamp!.compareTo(b.timeStamp!));
    // 返回排序后的消息列表
    return mergedList;
  }


  //TODO:將方法寫成共用工具
  //檢查方法執行時間是否逾時，避免網路不穩狀況
  Future<dynamic> _timeoutCheck({required Function() action,required Function() timeOutAction}) async {
    try {
      final res = await Future.any([
        Future<dynamic>(action),
        Future.delayed(const Duration(seconds: 5), () => throw TimeoutException('亲～网速延迟加载超时啰'))
      ]);
      return res;
    } on TimeoutException catch (msg) {
      timeOutAction();
    }
  }
}