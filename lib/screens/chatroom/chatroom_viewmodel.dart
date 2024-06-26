import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frechat/models/certification_model.dart';
import 'package:frechat/models/user_info_model.dart';
import 'package:frechat/models/ws_req/account/ws_account_call_verification_req.dart';
import 'package:frechat/models/ws_req/account/ws_account_get_rtc_token_req.dart';
import 'package:frechat/models/ws_req/account/ws_account_speak_req.dart';
import 'package:frechat/models/ws_req/notification/ws_notification_search_intimacy_level_info_req.dart';
import 'package:frechat/models/ws_req/member/ws_member_info_req.dart';
import 'package:frechat/models/ws_req/setting/ws_setting_charm_achievement_req.dart';
import 'package:frechat/models/ws_res/account/ws_account_call_package_res.dart';
import 'package:frechat/models/ws_res/account/ws_account_call_verification_res.dart';
import 'package:frechat/models/ws_res/account/ws_account_get_gift_detail_res.dart';
import 'package:frechat/models/ws_res/account/ws_account_get_rtc_token_res.dart';
import 'package:frechat/models/ws_res/account/ws_account_official_message_res.dart';
import 'package:frechat/models/ws_res/account/ws_account_speak_res.dart';
import 'package:frechat/models/ws_res/member/ws_member_info_res.dart';
import 'package:frechat/models/ws_res/notification/ws_notification_block_group_res.dart';
import 'package:frechat/models/ws_res/notification/ws_notification_search_intimacy_level_info_res.dart';
import 'package:frechat/models/ws_res/notification/ws_notification_search_list_res.dart';
import 'package:frechat/models/ws_res/setting/ws_setting_charm_achievement_res.dart';
import 'package:frechat/screens/gift_and_bag/gift_and_bag.dart';
import 'package:frechat/screens/intimacy_dialog.dart';
import 'package:frechat/system/app_config/app_config.dart';
import 'package:frechat/system/base_view_model.dart';
import 'package:frechat/system/call_back_function.dart';
import 'package:frechat/system/comm/comm_endpoints.dart';
import 'package:frechat/system/constant/enum.dart';
import 'package:frechat/system/database/model/chat_audio_model.dart';
import 'package:frechat/system/database/model/chat_gift_model.dart';
import 'package:frechat/system/database/model/chat_image_model.dart';
import 'package:frechat/system/database/model/chat_message_model.dart';
import 'package:frechat/system/database/model/chat_user_model.dart';
import 'package:frechat/system/extension/json.dart';
import 'package:frechat/system/global/shared_preferance.dart';
import 'package:frechat/system/message/chat_message_manager.dart';
import 'package:frechat/system/network_status/network_status_setting.dart';
import 'package:frechat/system/provider/chat_Gift_model_provider.dart';
import 'package:frechat/system/provider/chat_audio_model_provider.dart';
import 'package:frechat/system/provider/chat_image_model_provider.dart';
import 'package:frechat/system/provider/chat_message_model_provider.dart';
import 'package:frechat/system/provider/chat_user_model_provider.dart';
import 'package:frechat/system/provider/user_info_provider.dart';
import 'package:frechat/system/providers.dart';
import 'package:frechat/system/repository/http_manager.dart';
import 'package:frechat/system/repository/http_setting.dart';
import 'package:frechat/system/repository/response_code.dart';
import 'package:frechat/system/util/audio_util.dart';
import 'package:frechat/system/util/image_picker_util.dart';
import 'package:frechat/system/util/permission_util.dart';
import 'package:frechat/system/util/recharge_util.dart';
import 'package:frechat/system/util/svga_player_util.dart';
import 'package:frechat/system/widget_binding/app_lifecycle.dart';
import 'package:frechat/system/zego_call/interal/zim/call_data_manager.dart';
import 'package:frechat/system/zego_call/interal/zim/zim_service_defines.dart';
import 'package:frechat/system/zego_call/model/review_audio_res.dart';
import 'package:frechat/system/zego_call/zego_callback.dart';
import 'package:frechat/system/zego_call/zego_provider.dart';
import 'package:frechat/widgets/shared/bottom_sheet/common_bottom_sheet.dart';
import 'package:frechat/widgets/shared/dialog/base_dialog.dart';
import 'package:frechat/widgets/shared/dialog/comm_dialog.dart';
import 'package:frechat/widgets/theme/app_color_theme.dart';
import 'package:frechat/widgets/theme/app_theme.dart';
import 'package:frechat/widgets/theme/original/app_colors.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:uuid/uuid.dart';
import 'package:svgaplayer_flutter/svgaplayer_flutter.dart';


class ChatRoomViewModel {
  WidgetRef ref;
  ViewChange? setState;
  BuildContext context;
  TickerProvider? tickerProvider;

  ChatRoomViewModel({required this.ref, this.setState, required this.context, this.tickerProvider}){
    getNowIntimacy();
    _chatUserModelNotifier = ref.read(chatUserModelNotifierProvider.notifier);
    _chatMessageModelNotifier = ref.read(chatMessageModelNotifierProvider.notifier);
    _chatGiftModelNotifier = ref.read(chatGiftModelNotifierProvider.notifier);
    _chatImageModelNotifier = ref.read(chatImageModelNotifierProvider.notifier);
    _chatAudioModelNotifier =  ref.read(chatAudioModelNotifierProvider.notifier);
    _userInfoModel = ref.read(userInfoProvider);
  }

  WsMemberInfoRes? memberInfoRes;
  late ChatUserModelNotifier _chatUserModelNotifier;
  late ChatMessageModelNotifier _chatMessageModelNotifier;
  late ChatGiftModelNotifier _chatGiftModelNotifier;
  late ChatImageModelNotifier _chatImageModelNotifier;
  late ChatAudioModelNotifier _chatAudioModelNotifier;
  late UserInfoModel _userInfoModel;
  List<String> commonLanguageList = [];
  // XFile? xFile;
  TextEditingController? textEditingController;
  List<ZIMMessage> zimMessageList = [];
  ZIMMessageQueriedResult? zimMessageQueriedResult;
  String nickName = '';
  String userName = '';
  late ZegoCallBack callback;
  final ScrollController scrollController = ScrollController();
  bool messageLoading = true;
  bool commonLanguageLoading = true;
  late Timer timer;
  int seconds = 0;

  Timer? recordingTimer; // 錄音計時器
  int recordingSeconds = 0; // 錄音時間

  // String recordingTime = "0:00";
  TextStyle? style;
  String textFiledHint = "请输入消息";
  // bool isRecordingFinish = false;
  num? userId;
  // String resultCodeCheck = '';
  String showSvgaUrl = '';
  num cohesionPoints = 0;
  num cohesionLevel = 0;
  String imagePath = '';
  Color? cohesionColor;
  static SVGAAnimationController? animationController;
  int nowIntimacy = 1;
  num nextLevelSubtract = 0;
  String nextRelationShip = '';
  Map pointsRuleMap = {};
  bool isCohesionLoading = true;
  bool isLoading = true;
  String cohesionImagePath = '';
  List<Color> intimacyLevelBgColor = [];
  List<String> timeDistinctionList = [];
  bool needShowCharmCharge = false;
  String textCharge = '';
  late Timer sendMsgLimitTimer;
  bool isOnSendMsgLimitTime = false;
  String oppositeUserName = '';
  AnimationController? expandController;
  Animation? heightAnimation;
  num? osType = 1; // 手机系统(0:苹果 1:安卓)

  init(num points, num level,String userName) {
    textEditingController = TextEditingController();
    nickName = ref.read(userInfoProvider).memberInfo?.nickName ?? '';
    this.userName = ref.read(userInfoProvider).memberInfo?.userName ?? '';
    userId = ref.read(userInfoProvider).userId;
    callback = ref.read(zegoCallBackProvider);
    // callback = ZegoCallBack(context, ref);
    ref.read(chatMessageModelNotifierProvider.notifier).loadDataFromSql();
    ref.read(chatImageModelNotifierProvider.notifier).loadDataFromSql();
    ref.read(chatAudioModelNotifierProvider.notifier).loadDataFromSql();
    ref.read(chatGiftModelNotifierProvider.notifier).loadDataFromSql();
    cohesionPoints = points;
    cohesionLevel = level;
    oppositeUserName = userName;

  }

  dispose() {
    expandController?.dispose();
    expandController == null;
  }


  /// ---監聽訊息---
  listenerZimCallBack() {
    final zimService = ref.read(zimServiceProvider);
    zimService.receivePeerMessageListener(
        onReceiveTextMessage: (sendingUser, zimTextMessage) async  {
          final bool isChatRoom = ref.read(userInfoProvider).currentPage == 1;
          Map<String, dynamic> messageDataMap = {};
          Map<String, dynamic> extendedDataMap = {};
          try {
            messageDataMap = json.tryDecode(zimTextMessage.message);
            extendedDataMap = json.tryDecode(zimTextMessage.extendedData);
            String uuid = messageDataMap['uuid'];

            /// 通話紀錄decode
            String chatContent = '';
            bool isCallHistoryType = false;
            OfficialMessageInfo? officialMessageInfo;
            try {
              final WsAccountOfficialMessageRes content = WsAccountOfficialMessageRes.fromJson(messageDataMap['content']);
              officialMessageInfo = OfficialMessageInfo.fromJson(content.message);
              // chatContent = '通话时长: ${officialMessageInfo.duration}s';
              chatContent = json.encode(officialMessageInfo);
              isCallHistoryType = true;
            } catch (e) {
              chatContent = messageDataMap['content'].toString();
            }

            int expireTime = extendedDataMap['expireTime'] ?? 0;
            int halfTime = extendedDataMap['halfTime'] ?? 0;
            num points = extendedDataMap['points'] ?? 0;
            int incomeflag = extendedDataMap['incomeflag'] ?? 0;
            if (chatContent.contains('[礼物]')) {
              String giftCategoryName = extendedDataMap['giftCategoryName'];
              String giftName = extendedDataMap['giftName'];
              String giftId = extendedDataMap['giftId'];
              num coins = extendedDataMap['coins'];
              num svgaFileId = extendedDataMap['svgaFileId'];
              num giftSendAmount = extendedDataMap['giftSendAmount'];
              String svgaUrl = extendedDataMap['svgaUrl'];
              String giftImageUrl = extendedDataMap['giftUrl'];
              num expireDuration = extendedDataMap['expireDuration'];
              num halfDuration = extendedDataMap['halfDuration'];
              num timestamp = extendedDataMap['createTime'] ??zimTextMessage.timestamp;

              ref.read(chatMessageModelNotifierProvider.notifier).setDataToSql(chatMessageModelList: [
                // ChatMessageModel(
                //     messageUuid: uuid, senderName: zimTextMessage.senderUserID, receiverName: ref.read(userInfoProvider).memberInfo?.userName,
                //     content: chatContent, timeStamp: zimTextMessage.timestamp, expireTime: expireTime, halfTime: halfTime,
                //     points: points, incomeflag: incomeflag, type: 3)]);
                ChatMessageModel(
                    messageUuid: uuid, senderName: zimTextMessage.senderUserID, receiverName: ref.read(userInfoProvider).memberInfo?.userName,
                    content: chatContent, timeStamp: timestamp, expireTime: expireTime, halfTime: halfTime,
                    points: points, incomeflag: incomeflag, type: 3, expireDuration: expireDuration, halfDuration: halfDuration,reviewStatus: 0,)]);
              if(isChatRoom){
                final allChatUserModelList = ref.watch(chatUserModelNotifierProvider);
                final targetChatUserModelList = allChatUserModelList.where((info) => info.userName == sendingUser).toList();
                ChatUserModel chatUserModel = targetChatUserModelList[0];
                ref.read(chatUserModelNotifierProvider.notifier).setDataToSql(chatUserModelList: [
                  ChatUserModel(userId: chatUserModel.userId, roomIcon: chatUserModel.roomIcon, cohesionLevel: chatUserModel.cohesionLevel, userCount: chatUserModel.userCount,
                      isOnline: chatUserModel.isOnline, userName: chatUserModel.userName, roomId: chatUserModel.roomId, roomName: chatUserModel.roomName,
                      points: chatUserModel.points, remark: chatUserModel.remark, unRead: chatUserModel.unRead, recentlyMessage: chatContent, timeStamp: timestamp, pinTop: 0,sendStatus:chatUserModel.sendStatus )]);
              }
              ref.read(chatGiftModelNotifierProvider.notifier).setDataToSql(chatGiftModelList: [
                ChatGiftModel(
                    messageUuid: uuid, senderName: zimTextMessage.senderUserID, receiverName: ref.read(userInfoProvider).memberInfo?.userName, giftCategoryName: giftCategoryName, giftName: giftName, giftId: int.parse(giftId), coins: coins, giftImageUrl: giftImageUrl, giftSendAmount: giftSendAmount,
                    svgaFileId: svgaFileId, svgaUrl: svgaUrl, isShowSvga: 0, timeStamp: zimTextMessage.timestamp)]);

              /// 收到的禮物接收者與正在當前房間才會有效果
              final String? currentChatUser = ref.read(userInfoProvider).currentChatUser;
              if(currentChatUser == zimTextMessage.senderUserID) {
                SvgaPlayerUtil.loadAnimation(HttpSetting.baseImagePath + svgaUrl);
              }
            } else if(messageDataMap['type'] == 9) {
              _receiveAudioMsg(zimTextMessage: zimTextMessage, sendingUser: sendingUser);
            } else {
              /// 寫入通話到資料庫
              num expireDuration = extendedDataMap['expireDuration']??0;
              num halfDuration = extendedDataMap['halfDuration']??0;
              num timestamp = extendedDataMap['createTime'] ??zimTextMessage.timestamp;

              if(isCallHistoryType && officialMessageInfo != null) {
                ref.read(chatMessageModelNotifierProvider.notifier).setDataToSql(chatMessageModelList: [
                  // ChatMessageModel(
                  //     messageUuid: uuid, senderName: officialMessageInfo.caller, receiverName: officialMessageInfo.answer, content: chatContent,
                  //     timeStamp: zimTextMessage.timestamp, expireTime: expireTime, halfTime: halfTime, points: officialMessageInfo.points, incomeflag: incomeflag, type: 0)]);

                  ChatMessageModel(
                      messageUuid: uuid, senderName: officialMessageInfo.caller, receiverName: officialMessageInfo.answer, content: chatContent,
                      timeStamp: timestamp, expireTime: expireTime, halfTime: halfTime, points: officialMessageInfo.points, incomeflag: incomeflag, type: 0, expireDuration: expireDuration, halfDuration: halfDuration,reviewStatus: 0)]);
                return ;
              }

              final String receiverName = _getReceiverName(zimTextMessage);

              ref.read(chatMessageModelNotifierProvider.notifier).setDataToSql(chatMessageModelList: [
                ChatMessageModel(
                    messageUuid: uuid, senderName: zimTextMessage.senderUserID, receiverName: receiverName, content: chatContent,
                    timeStamp: timestamp, expireTime: expireTime, halfTime: halfTime, points: points, incomeflag: incomeflag, type: 0, expireDuration: expireDuration, halfDuration: halfDuration,reviewStatus: 0)
              ]);
              if(isChatRoom){
                final allChatUserModelList = ref.watch(chatUserModelNotifierProvider);
                final targetChatUserModelList = allChatUserModelList.where((info) => info.userName == sendingUser).toList();
                ChatUserModel chatUserModel = targetChatUserModelList[0];
                ref.read(chatUserModelNotifierProvider.notifier).setDataToSql(chatUserModelList: [
                  ChatUserModel(userId: chatUserModel.userId, roomIcon: chatUserModel.roomIcon, cohesionLevel: chatUserModel.cohesionLevel, userCount: chatUserModel.userCount,
                      isOnline: chatUserModel.isOnline, userName: chatUserModel.userName, roomId: chatUserModel.roomId, roomName: chatUserModel.roomName, points: chatUserModel.points,
                      remark: chatUserModel.remark, unRead: chatUserModel.unRead, recentlyMessage: chatContent, timeStamp: timestamp, pinTop: 0,sendStatus:chatUserModel.sendStatus )]);
              }
            }
          } on FormatException {
            debugPrint('The info.extendedData is not valid JSON');
          }
        }, onReceiveImageMessage: (sendingUser, zimImageMessage) {

      final bool isChatRoom = ref.read(userInfoProvider).currentPage == 1;
      Map<String, dynamic> extendedDataMap = {};
      try {
        extendedDataMap = json.decode(zimImageMessage.extendedData) as Map<String, dynamic>;
        int expireTime = extendedDataMap['expireTime'] ?? 0;
        int halfTime = extendedDataMap['halfTime'] ?? 0;
        num points = extendedDataMap['points'] ?? 0;
        int incomeflag = extendedDataMap['incomeflag'] ?? 0;
        String uuid = extendedDataMap['uuid'];
        num expireDuration = extendedDataMap['expireDuration'] ?? 0;
        num halfDuration = extendedDataMap['halfDuration'] ?? 0;
        num timestamp = extendedDataMap['createTime'] ??zimImageMessage.timestamp;

        final String receiverName = _getReceiverName(zimImageMessage);
        ref.read(chatMessageModelNotifierProvider.notifier).setDataToSql(chatMessageModelList: [
          // ChatMessageModel(messageUuid: uuid, senderName: zimImageMessage.senderUserID, receiverName: ref.read(userInfoProvider).memberInfo?.userName, content: '[图片]',
          //     timeStamp: zimImageMessage.timestamp, expireTime: expireTime, halfTime: halfTime, points: points, incomeflag: incomeflag, type: 1)]);
          ChatMessageModel(messageUuid: uuid, senderName: zimImageMessage.senderUserID, receiverName: receiverName, content: '[图片]',
              timeStamp: timestamp, expireTime: expireTime, halfTime: halfTime, points: points, incomeflag: incomeflag, type: 1, expireDuration: expireDuration, halfDuration: halfDuration,reviewStatus: 0)]);
        ref.read(chatImageModelNotifierProvider.notifier).setDataToSql(chatImageModelList: [
          ChatImageModel(messageUuid: uuid, senderName: zimImageMessage.senderUserID, receiverName: ref.read(userInfoProvider).memberInfo?.userName,
            imagePath: zimImageMessage.fileDownloadUrl, timeStamp: timestamp,)]);

        if(isChatRoom){
          final allChatUserModelList = ref.watch(chatUserModelNotifierProvider);
          final targetChatUserModelList = allChatUserModelList.where((info) => info.userName == sendingUser).toList();
          ChatUserModel chatUserModel = targetChatUserModelList[0];
          ref.read(chatUserModelNotifierProvider.notifier).setDataToSql(chatUserModelList: [
            ChatUserModel(userId: chatUserModel.userId, roomIcon: chatUserModel.roomIcon, cohesionLevel: chatUserModel.cohesionLevel, userCount: chatUserModel.userCount,
                isOnline: chatUserModel.isOnline, userName: chatUserModel.userName, roomId: chatUserModel.roomId, roomName: chatUserModel.roomName, points: chatUserModel.points,
                remark: chatUserModel.remark, unRead: chatUserModel.unRead, recentlyMessage: '[图片]', timeStamp: timestamp, pinTop: 0,sendStatus:chatUserModel.sendStatus )]);
        }
      } on FormatException {
        debugPrint('The info.extendedData is not valid JSON');
      }
    }, onReceiveFileMessage: (sendingUser, zimFileMessage) {
      final bool isChatRoom = ref.read(userInfoProvider).currentPage == 1;
      Map<String, dynamic> extendedDataMap = {};
      try {
        final String receiverName = _getReceiverName(zimFileMessage);

        extendedDataMap = json.decode(zimFileMessage!.extendedData) as Map<String, dynamic>;
        int expireTime = extendedDataMap['expireTime'] ?? 0;
        int halfTime = extendedDataMap['halfTime'] ?? 0;
        num points = extendedDataMap['points'] ?? 0;
        int incomeFlag = extendedDataMap['incomeflag'] ?? 0;
        String uuid = extendedDataMap['uuid'] ?? '';
        String senderName = zimFileMessage.senderUserID;
        int timeStamp = extendedDataMap['createTime'] ?? zimFileMessage.timestamp;
        ///TODO 影響招呼語取得時間
        num audioTime = extendedDataMap['audioTime'] ??0;
        // if(extendedDataMap['chatContent'] !=null){
        //   Map<String, dynamic> chatContent = extendedDataMap['chatContent'];
        //   audioTime = chatContent['audioTime'] ?? 0;
        // }
        final num audioType = 2;

        final msgModel = ChatMessageModel(
            messageUuid: uuid,
            senderName: senderName,
            receiverName: receiverName,
            content: '[录音]',
            timeStamp: timeStamp,
            expireTime: expireTime,
            halfTime: halfTime,
            points: points,
            incomeflag: incomeFlag,
            type: 2,
            unRead: 0,
            reviewStatus: 0);
        final audioModel = ChatAudioModel(
          messageUuid: uuid,
          senderName: senderName,
          receiverName: ref.read(userInfoProvider).memberInfo?.userName,
          audioPath: zimFileMessage.fileDownloadUrl,
          timeStamp: audioTime,
        );

        ref.read(chatMessageModelNotifierProvider.notifier).setDataToSql(chatMessageModelList: [msgModel]);
        ref.read(chatAudioModelNotifierProvider.notifier).setDataToSql(chatAudioModelList: [audioModel]);
        if(isChatRoom){
          final allChatUserModelList = ref.watch(chatUserModelNotifierProvider);
          final targetChatUserModelList = allChatUserModelList.where((info) => info.userName == sendingUser).toList();
          ChatUserModel chatUserModel = targetChatUserModelList[0];
          final userModel = ChatUserModel(userId: chatUserModel.userId,
              roomIcon: chatUserModel.roomIcon,
              cohesionLevel: chatUserModel.cohesionLevel,
              userCount: chatUserModel.userCount,
              isOnline: chatUserModel.isOnline,
              userName: chatUserModel.userName,
              roomId: chatUserModel.roomId,
              roomName: chatUserModel.roomName,
              points: chatUserModel.points,
              remark: chatUserModel.remark,
              unRead: chatUserModel.unRead,
              recentlyMessage: '[录音]',
              timeStamp: timeStamp,
              pinTop: 0,
          sendStatus: chatUserModel.sendStatus);
          ref.read(chatUserModelNotifierProvider.notifier).setDataToSql(chatUserModelList: [userModel]);
        }

      } on FormatException{
        debugPrint('The info.extendedData is not valid JSON');
      }


      // _receiveAudioMsg();
    }, onAnotherHaveReadMessage: (zimMessageReceiptInfo) {
      final bool isChatRoom = ref.read(userInfoProvider).isInChatroom ?? false;
      final String currentChatUser = ref.read(userInfoProvider).currentChatUser ?? '';
      ///确认聊天室是否存在
      if(isChatRoom && currentChatUser == zimMessageReceiptInfo.first.conversationID){
        final oppositeUserName = zimMessageReceiptInfo.first.conversationID;
        zimService.clearUnReadMessageByConversationID(conversationID: oppositeUserName);
        final allChatUserModel = ref.read(chatUserModelNotifierProvider);
        final list = allChatUserModel.where((info) => info.userName == oppositeUserName).toList();
        ChatUserModel chatUserModel = list[0];
        ChatUserModel updateUserModel = ChatUserModel(unRead: 0,pinTop: 0);
        ChatUserModel whereUserModel = ChatUserModel(userName:chatUserModel.userName );
        ref.read(chatUserModelNotifierProvider.notifier).updateDataToSql(updateModel: updateUserModel, whereModel: whereUserModel);

        final allChatMessageModelList = ref.read(chatMessageModelNotifierProvider);
        /// 自己發送未讀的訊息列表
        final mySendUnReadChatMessagelist = allChatMessageModelList.where((info) => info.senderName == ref.read(userInfoProvider).memberInfo?.userName && info.receiverName == oppositeUserName && info.unRead ==0).toList();
        for(ChatMessageModel model in mySendUnReadChatMessagelist){
          /// 將訊息更新為已讀狀態
          ChatMessageModel updateModel = ChatMessageModel(unRead: 1);
          ChatMessageModel whereModel = ChatMessageModel(messageUuid: model.messageUuid);
          ref.read(chatMessageModelNotifierProvider.notifier).updateDataToSql(updateModel: updateModel, whereModel: whereModel);
        }
      }
    },
        onConversationListChanged: (zimConversationChangeListInfo) {

          final bool isChatRoom = ref.read(userInfoProvider).isInChatroom ?? false;
          ///确认聊天室是否存在
          if(isChatRoom){
            // 判斷 App LifeCycle 狀態是否在前台
            if (AppLifecycle.currentState == AppLifecycleState.resumed) {
              zimService.receiveMessage(conversationID: zimConversationChangeListInfo.first.conversation!.conversationID);
            }
          }
        },
        onTotalUnReadMessage: (totalUnReadMsg) {

        });
  }


  /// ---訊息相關---


  //傳送文字
  Future<void> sendTextMessage({String? messageUUId,SearchListInfo? searchListInfo, String? message, int? contentType, bool isStrikeUp=false}) async {
    String chatContent = message ?? '';
    if (textEditingController != null) {
      textEditingController!.clear();
    }
    if (isOnSendMsgLimitTime) {
      return;
    }


    startSendMsgLimitTimer();
    String uuId = messageUUId ?? const Uuid().v4();
    num isReplyPickup = checkIsReplyPickup();
    _updateTextMessageDB(uuid: uuId, searchListInfo: searchListInfo, chatContent: chatContent, sendStatus: 0, res: null);
    await ref.read(chatMessageManager).sendTextMessage(
        uuId: uuId,
        contentType: contentType ?? 0,
        searchListInfo: searchListInfo,
        message: chatContent,
        isStrikeUp: isStrikeUp,
        isReplyPickup: isReplyPickup,
        onConnectSuccess: (res, zimTextMessage) {
          _updateNowIntimacy(level: res.cohesionLevel!,points: res.cohesionPoints!);
          _updateTextMessageDB(uuid: uuId, searchListInfo: searchListInfo, chatContent: chatContent, sendStatus: 1, res: res);
          zimMessageList.add(zimTextMessage);
        },
        onConnectFail: (errorType,msg) {
          num sendStatus =2;
          if(errorType == MessageSendFailType.reject){
            sendStatus = 3;
          }
          _updateTextMessageDB(uuid: uuId, searchListInfo: searchListInfo, chatContent: chatContent, sendStatus: sendStatus, res: null);
          if (msg == ResponseCode.CODE_COIN_BALANCE_NOT_ENOUGH) {
            rechargeHandler();
          } else {
            String errorMsg = ResponseCode.getLocalizedDisplayStr(msg);
            if(errorMsg == ResponseCode.UNDEFINED_ERROR){
              errorMsg = '传送讯息失败';
            }
            BaseViewModel.showToast(context,errorMsg);
          }
        });
  }

  //傳送禮物
  Future<void> sendGiftMessage({String? messageUUId,SearchListInfo? searchListInfo, num? unRead, bool isStrikeUp = false, GiftListInfo? giftListInfo })async{
    num giftTyoe = giftListInfo?.giftType ??0;
    int contentType = giftTyoe == 1? 5 :4;
    String chatContent = '[礼物]';
    String uuId = messageUUId ?? const Uuid().v4();
    int isReplyPickup = checkIsReplyPickup();
    _updateGiftMessageDB(uuid: uuId,searchListInfo: searchListInfo, chatContent: chatContent,sendStatus: 0, res:null , giftInfo:giftListInfo );

    await ref.read(chatMessageManager).sendGiftMessage(
        uuId: uuId,
        contentType: contentType,
        searchListInfo: searchListInfo,
        message: chatContent,
        isStrikeUp: isStrikeUp,
        isReplyPickup: isReplyPickup,
        giftListInfo: giftListInfo,
        onConnectSuccess: (res, zimTextMessage) {
          _updateNowIntimacy(level: res.cohesionLevel!,points: res.cohesionPoints!);
          String svgUrl = giftListInfo?.svgaUrl??'';
          SvgaPlayerUtil.loadAnimation(HttpSetting.baseImagePath + svgUrl );
          _updateGiftMessageDB(uuid: uuId,searchListInfo: searchListInfo, chatContent: chatContent,sendStatus: 1, res:res , giftInfo:giftListInfo );
          zimMessageList.add(zimTextMessage);
        },
        onConnectFail: (errorType,msg) {
          num sendStatus = 2;
          if(errorType == MessageSendFailType.reject){
            sendStatus = 3;
          }
          _updateGiftMessageDB(uuid: uuId,searchListInfo: searchListInfo, chatContent: chatContent,sendStatus: sendStatus, res:null , giftInfo:giftListInfo );
          if (msg == ResponseCode.CODE_COIN_BALANCE_NOT_ENOUGH) {
            rechargeHandler();
          } else {
            String errorMsg = ResponseCode.getLocalizedDisplayStr(msg);
            if(errorMsg == ResponseCode.UNDEFINED_ERROR){
              errorMsg = '传送讯息失败';
            };
            BaseViewModel.showToast(context,errorMsg);
          }
        });

  }

  //傳送圖片
  Future<void> sendImageMessage({String? messageUUId,SearchListInfo? searchListInfo, num? unRead, bool isStrikeUp=false, String? imgUrl , bool isLocalImage= false,}) async {
    int contentType = 1;
    String chatContent = '[图片]';
    String uuId = messageUUId ?? const Uuid().v4();
    int isReplyPickup = checkIsReplyPickup();
    String imagePath = imgUrl ??'';
    XFile?xFile;
    if (imagePath.isEmpty) {
      xFile = await ImagePickerUtil.selectImage(needSaveImage: true);
      imagePath = await ImagePickerUtil().renameAndMoveImage(xFile!.path, uuId + path.extension(xFile!.path));
    } else {
      if(!isLocalImage){
        xFile = await DioUtil.getUrlAsXFile(HttpSetting.baseImagePath + imagePath);
        imagePath = await ImagePickerUtil().renameAndMoveImage(xFile!.path, uuId + path.extension(xFile!.path));
      }
    }

    _updateImageMessageDB(uuid: uuId, searchListInfo: searchListInfo, chatContent: chatContent, sendStatus: 0, res: null, imagePath: imagePath);
    await ref.read(chatMessageManager).sendImageMessage(
        uuId: uuId,
        contentType: contentType,
        searchListInfo: searchListInfo,
        message: chatContent,
        isStrikeUp: isStrikeUp,
        isReplyPickup: isReplyPickup,
        imagePath: imagePath,
        onConnectSuccess: (res, zimImageMessage) {
          _updateNowIntimacy(level: res.cohesionLevel!,points: res.cohesionPoints!);

          _updateImageMessageDB(uuid: uuId, searchListInfo: searchListInfo, chatContent: chatContent, sendStatus: 1, res: res, imagePath: imagePath);
          zimMessageList.add(zimImageMessage);

        },
        onConnectFail: (errorType,msg) {
          num sendStatus = 2;
          if(errorType == MessageSendFailType.reject){
            sendStatus = 3;
          }
          _updateImageMessageDB(uuid: uuId, searchListInfo: searchListInfo, chatContent: chatContent, sendStatus: sendStatus, res: null, imagePath: imagePath);
          if (msg == ResponseCode.CODE_COIN_BALANCE_NOT_ENOUGH) {
            rechargeHandler();
          } else {
            String errorMsg = ResponseCode.getLocalizedDisplayStr(msg);
            if(errorMsg == ResponseCode.UNDEFINED_ERROR){
              errorMsg = '传送讯息失败';
            };
            BaseViewModel.showToast(context,errorMsg);          }
        });

  }

  //傳送錄音
  Future<void> sendVoiceMessage({String? messageUUId,SearchListInfo? searchListInfo, num? unRead, bool isStrikeUp = false, String? audioUrl,num? audioTime, bool isLocalFile= false}) async {
    int contentType = 9;
    String chatContent = '[录音]';
    String uuId = messageUUId ?? const Uuid().v4();
    int isReplyPickup = checkIsReplyPickup();
    if (audioUrl != null ) {
      if(isLocalFile){
        AudioUtils.filePath = audioUrl;
      }else{
        final XFile? xFile = await DioUtil.getUrlAsXFile(HttpSetting.baseImagePath + audioUrl);
        AudioUtils.filePath = xFile!.path;
      }
    }
    String resultPath = await ImagePickerUtil().renameAndMoveImage(AudioUtils.filePath!, uuId + ".aac");
    String filePath = AudioUtils.filePath!;
    num time;
    if(audioTime !=null){
      time = audioTime;
    }else{
      Duration? audioTimeDuration = await AudioUtils.getAudioTime( audioUrl: AudioUtils.filePath!, addBaseImagePath: false);
      time = audioTimeDuration?.inMilliseconds ?? 0;
    }
    _updateVoiceMessageDB(uuid: uuId, searchListInfo: searchListInfo, chatContent: chatContent, sendStatus: 0, res: null, audioTime: time,filePath: filePath);
    await ref.read(chatMessageManager).sendVoiceMessage(
        uuId: uuId,
        contentType: contentType,
        searchListInfo: searchListInfo,
        message: chatContent,
        isStrikeUp: isStrikeUp,
        isReplyPickup: isReplyPickup,
        voiceUrl: resultPath,
        audioTime: time,
        onConnectSuccess: (res, zimFileMessage) {
          _updateNowIntimacy(level: res.cohesionLevel!,points: res.cohesionPoints!);
          _updateVoiceMessageDB(uuid: uuId, searchListInfo: searchListInfo, chatContent: chatContent, sendStatus: 1, res: res, audioTime: time,filePath: filePath);
          zimMessageList.add(zimFileMessage);
        },
        onConnectFail: (errorType,msg) {
          num sendStatus = 2;
          if(errorType == MessageSendFailType.reject){
            sendStatus = 3;
          }
          _updateVoiceMessageDB(uuid: uuId, searchListInfo: searchListInfo, chatContent: chatContent, sendStatus: sendStatus, res: null, audioTime: time,filePath: resultPath);
          if (msg == ResponseCode.CODE_COIN_BALANCE_NOT_ENOUGH) {
            rechargeHandler();
          } else {
            String errorMsg = ResponseCode.getLocalizedDisplayStr(msg);
            if(errorMsg == ResponseCode.UNDEFINED_ERROR){
              errorMsg = '传送讯息失败';
            };
            BaseViewModel.showToast(context,errorMsg);
          }
        });
  }

  void startSendMsgLimitTimer() {
    seconds = 0;
    isOnSendMsgLimitTime = true;
    const oneSec = Duration(seconds: 1);
    sendMsgLimitTimer = Timer.periodic(oneSec, (Timer timer) {
      sendMsgLimitTimer.cancel();
      isOnSendMsgLimitTime = false;
    });
  }

  //已讀所有訊息
  void readAllMessage(String oppositeUserName) {
    final zimService = ref.read(zimServiceProvider);
    zimService.clearUnReadMessageByConversationID(conversationID: oppositeUserName);
    zimService.receiveMessage(conversationID: oppositeUserName);
    final allChatUserModelList = ref.read(chatUserModelNotifierProvider);
    final resultList = allChatUserModelList.where((info) => info.userName == memberInfoRes?.userName).toList();
    final list = allChatUserModelList.where((info) => info.userName == 'java_system').toList();
    if(resultList.isNotEmpty){
      ChatUserModel chatUserModel = resultList[0];
      ref.read(chatUserModelNotifierProvider.notifier).setDataToSql(chatUserModelList: [
        ChatUserModel(
            userId: chatUserModel.userId,
            roomIcon: memberInfoRes?.avatarPath,
            cohesionLevel: chatUserModel.cohesionLevel,
            userCount: chatUserModel.userCount,
            isOnline: chatUserModel.isOnline,
            userName: chatUserModel.userName,
            roomId: chatUserModel.roomId,
            roomName: chatUserModel.roomName,
            points: chatUserModel.points,
            remark: chatUserModel.remark,
            unRead: 0,
            recentlyMessage: chatUserModel.recentlyMessage,
            timeStamp: chatUserModel.timeStamp,
            pinTop: chatUserModel.pinTop,
            charmCharge: memberInfoRes?.charmCharge ?? chatUserModel.charmCharge,
            sendStatus: chatUserModel.sendStatus)
      ]);
    }
    if(oppositeUserName == 'java_system'){
      if(list.isNotEmpty){
        ChatUserModel chatUserModel = list[0];
        ref.read(chatUserModelNotifierProvider.notifier).setDataToSql(chatUserModelList: [
          ChatUserModel(userId: chatUserModel.userId, roomIcon: chatUserModel.roomIcon, cohesionLevel: chatUserModel.cohesionLevel, userCount: chatUserModel.userCount,
              isOnline: chatUserModel.isOnline, userName: chatUserModel.userName, roomId: chatUserModel.roomId, roomName: chatUserModel.roomName, points: chatUserModel.points,
              remark: chatUserModel.remark, unRead:0 , recentlyMessage: chatUserModel.recentlyMessage, timeStamp: chatUserModel.timeStamp, pinTop: chatUserModel.pinTop,sendStatus: chatUserModel.sendStatus)]);
      }
    }
  }

  //取得聊天歷史資料
  Future<void> getHistoryMessage(String oppositeUserName, {required SearchListInfo searchListInfo}) async {
    final zimService = ref.read(zimServiceProvider);
    final bool messageListIsEmpty = zimMessageQueriedResult?.messageList.isEmpty ?? true;
    final ZIMMessageQueriedResult history = await zimService.searchHistoryMessageFromUserName(
        conversationID: oppositeUserName,
        nextMessage: messageListIsEmpty ? null : zimMessageQueriedResult?.messageList.first // _getFirstZimMsg(searchListInfo)
    );
    /// 過濾掉傳送失敗的訊息
    // history.messageList.removeWhere((msg) => msg.sentStatus == ZIMMessageSentStatus.failed);
    if(zimMessageQueriedResult == null) {
      zimMessageQueriedResult = history;
    } else {
      zimMessageQueriedResult?.messageList.insertAll(0, history.messageList);
      tidyMessage(oppositeUserName);
    }
  }

  //整理訊息
  void tidyMessage(String oppositeUserName) async {
    final allChatUserModel = ref.read(chatUserModelNotifierProvider);
    final list = allChatUserModel.where((info) => info.userName == oppositeUserName).toList();
    final List<ZIMMessage> messageList = zimMessageQueriedResult?.messageList ?? [];
    if (list.isNotEmpty) {
      ChatUserModel model = list[0];
      num sendStatus = model.sendStatus ?? 1;
      for (int i = 0; i < messageList.length; i++) {
        ZIMMessage zimMessage = messageList[i];
        zimMessageList.add(zimMessage);
      }
      insertDB(oppositeUserName:oppositeUserName ,sendStatus:sendStatus);
    }
    timeDistinctionList.clear();
    setState!(() {
      messageLoading = false;
    });
  }

  //將ChatMessageModel 轉成 ZIMMessage
  ZIMMessage transferToZimMessage(ChatMessageModel chatMessageModel, bool isShowGiftSvga) {

    switch (chatMessageModel.type) {
    ///文字
      case 0:
        String content = jsonEncode({
          'uuid': chatMessageModel.messageUuid,
          'type': 0,
          'gift_id': '',
          'gift_count': '',
          'gift_url': '',
          'gift_name': '',
          'content': chatMessageModel.content
        });
        String extendedData = jsonEncode({
          'remainCoins': chatMessageModel.remainCoins,
          'expireTime': chatMessageModel.expireTime,
          'halfTime': chatMessageModel.halfTime,
          'points': chatMessageModel.points,
          'incomeflag': chatMessageModel.incomeflag,
          'uuid': chatMessageModel.messageUuid,
          'expireDuration': chatMessageModel.expireDuration,
          'halfDuration': chatMessageModel.halfDuration,
        });

        ZIMTextMessage zimTextMessage = ZIMTextMessage(message: content);
        zimTextMessage.type = ZIMMessageType.text;
        zimTextMessage.timestamp = chatMessageModel.timeStamp!.toInt();
        zimTextMessage.senderUserID = chatMessageModel.senderName!;
        zimTextMessage.conversationID = chatMessageModel.receiverName!;
        zimTextMessage.extendedData = extendedData;
        if (chatMessageModel.unRead == 0) {
          zimTextMessage.receiptStatus = ZIMMessageReceiptStatus.processing;
        } else {
          zimTextMessage.receiptStatus = ZIMMessageReceiptStatus.done;
        }
        return zimTextMessage;

    ///圖片
      case 1:
        final DBHistoryImageModel = ref.read(chatImageModelNotifierProvider);
        final list = DBHistoryImageModel.where(
                (info) => info.messageUuid == chatMessageModel.messageUuid)
            .toList();
        String extendedData = jsonEncode({
          'remainCoins': chatMessageModel.remainCoins,
          'expireTime': chatMessageModel.expireTime,
          'halfTime': chatMessageModel.halfTime,
          'points': chatMessageModel.points,
          'incomeflag': chatMessageModel.incomeflag,
          'uuid': chatMessageModel.messageUuid,
          'expireDuration': chatMessageModel.expireDuration,
          'halfDuration': chatMessageModel.halfDuration
        });
        if(list.isNotEmpty){
          ZIMImageMessage zimImageMessage = ZIMImageMessage(list[0].imagePath!);
          zimImageMessage.fileDownloadUrl = list[0].imagePath!;
          zimImageMessage.type = ZIMMessageType.image;
          zimImageMessage.timestamp = chatMessageModel.timeStamp!.toInt();
          zimImageMessage.senderUserID = chatMessageModel.senderName!;
          zimImageMessage.conversationID = chatMessageModel.receiverName!;
          zimImageMessage.extendedData = extendedData;
          if (chatMessageModel.unRead == 0) {
            zimImageMessage.receiptStatus = ZIMMessageReceiptStatus.processing;
          } else {
            zimImageMessage.receiptStatus = ZIMMessageReceiptStatus.done;
          }
          return zimImageMessage;
        }

        return ZIMMessage();

    ///錄音
      case 2 || 9 || 7:
        String extendedData = jsonEncode({
          'remainCoins': chatMessageModel.remainCoins,
          'expireTime': chatMessageModel.expireTime,
          'halfTime': chatMessageModel.halfTime,
          'points': chatMessageModel.points,
          'incomeflag': chatMessageModel.incomeflag,
          'uuid': chatMessageModel.messageUuid,
          'expireDuration': chatMessageModel.expireDuration,
          'halfDuration': chatMessageModel.halfDuration,
        });
        final DBHistoryAudioModel = ref.read(chatAudioModelNotifierProvider);
        ChatAudioModel? model;
        try {
          model = DBHistoryAudioModel.firstWhere((info) => info.messageUuid == chatMessageModel.messageUuid);
        } catch (e) {
          // 处理找不到符合条件的元素的异常情况
          print('找不到符合条件的音频元素');
        }

        if (model != null) {
          final Map<String, dynamic> jsonObj = {
            'f': '3-3', 'uuid': model.messageUuid,
            'createTime': model.timeStamp, 'type': 9,
            'content': {
              'message': {
                "reviewResult": chatMessageModel.type == 2 ? true : false,
                "download_url": model.audioPath,
                "audioTime":model.timeStamp,
              }
            }
          };
          ZIMTextMessage zimTextMessage = ZIMTextMessage(message: json.encode(jsonObj));
          zimTextMessage.type = ZIMMessageType.text;
          zimTextMessage.timestamp = chatMessageModel.timeStamp!.toInt();
          zimTextMessage.senderUserID = chatMessageModel.senderName!;
          zimTextMessage.conversationID = chatMessageModel.receiverName!;
          zimTextMessage.extendedData = extendedData;

          if (chatMessageModel.unRead == 0) {
            zimTextMessage.receiptStatus = ZIMMessageReceiptStatus.processing;
          } else {
            zimTextMessage.receiptStatus = ZIMMessageReceiptStatus.done;
          }

          return zimTextMessage;
        } else {
          // 处理找不到符合条件的音频元素的情况，例如返回一个默认的消息
          return ZIMMessage();
        }

    ///禮物
      case 3:
        final DBHistoryGiftModel = ref.read(chatGiftModelNotifierProvider);
        ChatGiftModel? model;

        try {
          model = DBHistoryGiftModel.firstWhere((info) => info.messageUuid == chatMessageModel.messageUuid);
        } catch (e) {
          // 找不到符合条件的元素，处理异常情况
          print('找不到符合条件的元素');
        }

        if (model != null) {
          String extendedData = jsonEncode({
            'remainCoins': chatMessageModel.remainCoins,
            'expireTime': chatMessageModel.expireTime,
            'halfTime': chatMessageModel.halfTime,
            'points': chatMessageModel.points,
            'incomeflag': chatMessageModel.incomeflag,
            'uuid': chatMessageModel.messageUuid,
            "giftUrl": model.giftImageUrl,
            'giftName': model.giftName,
            'giftSendAmount': model.giftSendAmount,
            'expireDuration': chatMessageModel.expireDuration,
            'halfDuration': chatMessageModel.halfDuration
          });

          ZIMTextMessage zimTextMessage = ZIMTextMessage(message: '[礼物]');
          zimTextMessage.type = ZIMMessageType.text;
          zimTextMessage.timestamp = chatMessageModel.timeStamp!.toInt();
          zimTextMessage.senderUserID = chatMessageModel.senderName!;
          zimTextMessage.conversationID = chatMessageModel.receiverName!;
          zimTextMessage.extendedData = extendedData;

          if (chatMessageModel.unRead == 0) {
            zimTextMessage.receiptStatus = ZIMMessageReceiptStatus.processing;
          } else {
            zimTextMessage.receiptStatus = ZIMMessageReceiptStatus.done;
          }

          if (isShowGiftSvga) {
            showSvga(model);
          }

          return zimTextMessage;
        } else {
          // 返回一个默认的消息或者处理其他异常情况
          return ZIMMessage();
        }

    ///通話紀錄
      case 4:
      // String content = jsonEncode({
      //   'uuid': chatMessageModel.messageUuid,
      //   'type': 0,
      //   'gift_id': '',
      //   'gift_count': '',
      //   'gift_url': '',
      //   'gift_name': '',
      //   'content': chatMessageModel.content
      // });
      // String extendedData = jsonEncode({
      //   'remainCoins': chatMessageModel.remainCoins,
      //   'expireTime': chatMessageModel.expireTime,
      //   'halfTime': chatMessageModel.halfTime,
      //   'points': chatMessageModel.points,
      //   'incomeflag': chatMessageModel.incomeflag,
      //   'uuid': chatMessageModel.messageUuid
      // });
      // ZIMTextMessage zimTextMessage = ZIMTextMessage(message: content);
      // zimTextMessage.type = ZIMMessageType.text;
      // zimTextMessage.timestamp = chatMessageModel.timeStamp!.toInt();
      // zimTextMessage.senderUserID = chatMessageModel.senderName!;
      // zimTextMessage.conversationID = chatMessageModel.receiverName!;
      // zimTextMessage.extendedData = extendedData;
      // if (chatMessageModel.unRead == 0) {
      //   zimTextMessage.receiptStatus = ZIMMessageReceiptStatus.processing;
      // } else {
      //   zimTextMessage.receiptStatus = ZIMMessageReceiptStatus.done;
      // }
      // return zimTextMessage;
      default:
        return ZIMMessage();
    }
  }

  //禮物SVG
  Future<void> showSvga(ChatGiftModel chatGiftModel) async {
    if (chatGiftModel.isShowSvga == 0) {
      String svgurl = chatGiftModel.svgaUrl!;
      if(!svgurl.contains('https')){
        svgurl = HttpSetting.baseImagePath+chatGiftModel.svgaUrl!;
      }

      final String myUserName = ref.read(userInfoProvider).memberInfo?.userName ?? '';
      final String sender = chatGiftModel.senderName ?? '';
      if(myUserName != sender) {
        SvgaPlayerUtil.loadAnimation(svgurl);
      }

      ref.read(chatGiftModelNotifierProvider.notifier)
          .setDataToSql(chatGiftModelList: [
        ChatGiftModel(
            messageUuid: chatGiftModel.messageUuid,
            senderId: chatGiftModel.senderId,
            receiverId: chatGiftModel.receiverId,
            senderName: chatGiftModel.senderName,
            receiverName: chatGiftModel.receiverName,
            giftCategoryName: chatGiftModel.giftCategoryName,
            giftName: chatGiftModel.giftName,
            giftId: chatGiftModel.giftId,
            coins: chatGiftModel.coins,
            giftImageUrl: chatGiftModel.giftImageUrl,
            giftSendAmount: chatGiftModel.giftSendAmount,
            svgaFileId: chatGiftModel.svgaFileId,
            svgaUrl: chatGiftModel.svgaUrl,
            isShowSvga: 1,
            timeStamp: chatGiftModel.timeStamp)
      ]);
    }
  }

  // 訊息時間排序
  List<ChatMessageModel> sortChatMessages(List<ChatMessageModel> list1, List<ChatMessageModel> list2) {
    // 合并两个列表
    List<ChatMessageModel> mergedList = [...list1, ...list2];
    // 使用List的sort方法按时间戳升序排序
    mergedList.sort((a, b) => a.timeStamp!.compareTo(b.timeStamp!));
    // 返回排序后的消息列表
    return mergedList;
  }


  /// ---語音視訊相關---

  void _receiveAudioMsg({required ZIMTextMessage zimTextMessage, required String sendingUser}) {
    final bool isChatRoom = ref.read(userInfoProvider).currentPage == 1;
    Map<String, dynamic> extendedDataMap = {};
    Map<String, dynamic> messageDataMap = {};
    messageDataMap = json.decode(zimTextMessage.message);
    final ReviewAudioRes reviewAudioRes = ReviewAudioRes.fromJson(messageDataMap['content']['message']);

    num reviewStatus = reviewAudioRes.reviewResult == true ? 0 : 1;// 0:審核過，1:未審過
    num audioType = reviewAudioRes.reviewResult == true ? 2 : 7; // 2 錄音檔，7:錄音檔（封鎖）
    num sendStatus = reviewAudioRes.reviewResult == true ? 1 : 2;// 1 傳送成功，2:傳送失敗
    if(reviewStatus == 1){
      //如果為未審過，且訊息不是發送訊息的本人，則此訊息不顯示跟不儲存DB
      //此判斷是因為即使未審過訊息，後端依然會將訊息發送出去給兩端，所以需要預防此狀況
      if(zimTextMessage.senderUserID != ref.read(userInfoProvider).memberInfo?.userName){
        return;
      }
      BaseViewModel.showToast(context, '您的发言内容不恰当，请注意我们的用户协议');
    }
    try {
      extendedDataMap = json.decode(zimTextMessage.extendedData) as Map<String, dynamic>;
      final int expireTime = extendedDataMap['expireTime'] ?? 0;
      final int halfTime = extendedDataMap['halfTime'] ?? 0;
      final num points = extendedDataMap['points'] ?? 0;
      final int incomeFlag = extendedDataMap['incomeflag'] ?? 0;
      final String uuid = messageDataMap['uuid'] ?? '';
      final String sender = extendedDataMap['sender'] ?? '';
      final String receiver = extendedDataMap['receiver'] ?? '';
      final num timeStamp = messageDataMap['createTime'] ?? '';
      final num audioTime = extendedDataMap['chatContent']['audioTime'] ?? 0;

      final msgModel = ChatMessageModel(
          messageUuid: uuid, senderName: sender, receiverName: receiver, content: '[录音]',
          timeStamp: timeStamp, expireTime: expireTime, halfTime: halfTime,
          points: points, incomeflag: incomeFlag, type: audioType, unRead: 0,reviewStatus: reviewStatus,
          sendStatus: sendStatus,
      );

      ref.read(chatMessageModelNotifierProvider.notifier).setDataToSql(chatMessageModelList: [msgModel]);
      ref.read(chatAudioModelNotifierProvider.notifier).setDataToSql(chatAudioModelList: [
        ChatAudioModel(messageUuid: uuid, senderName: zimTextMessage.senderUserID, receiverName: ref.read(userInfoProvider).memberInfo?.userName, audioPath: reviewAudioRes.download_url,
          timeStamp: audioTime,)]);
      if(isChatRoom){
        final allChatUserModelList = ref.watch(chatUserModelNotifierProvider);
        final targetChatUserModelList = allChatUserModelList.where((info) => info.userName == sendingUser).toList();
        ChatUserModel chatUserModel = targetChatUserModelList[0];
        ref.read(chatUserModelNotifierProvider.notifier).setDataToSql(chatUserModelList: [
          ChatUserModel(userId: chatUserModel.userId, roomIcon: chatUserModel.roomIcon, cohesionLevel: chatUserModel.cohesionLevel,
              userCount: chatUserModel.userCount, isOnline: chatUserModel.isOnline, userName: chatUserModel.userName, roomId: chatUserModel.roomId, roomName: chatUserModel.roomName,
              points: chatUserModel.points, remark: chatUserModel.remark, unRead: chatUserModel.unRead, recentlyMessage: '[录音]', timeStamp: zimTextMessage.timestamp, pinTop: 0,sendStatus: chatUserModel.sendStatus)]);
      }
    } on FormatException {
      debugPrint('The info.extendedData is not valid JSON');
    }
  }

  //電話和視訊選項彈窗
  void callOrVideoBottomDialog({WsMemberInfoRes? memberInfo, SearchListInfo? searchListInfo}) async {

    String videoLabel = '视频通话', videoSubLabel = '', voiceLabel = '语音通话', voiceSubLabel = '';
    num voiceCost = 0;
    num videoCost = 0;

    if (memberInfo?.gender == 0) {
      final String? oppositeUserName = memberInfo?.userName;
      final WsMemberInfoReq reqBody = WsMemberInfoReq.create(userName: oppositeUserName);
      // 重新取得對方的資料，收費設置
      final WsMemberInfoRes res = await ref.read(memberWsProvider).wsMemberInfo(reqBody,
          onConnectSuccess: (succMsg) {},
          onConnectFail: (errMsg) {}
      );

      // 信息｜語音｜視頻
      List<String> costs = (res.charmCharge ?? '').split('|'); // 女性收費標準

      WsSettingChargeAchievementReq wsSettingChargeAchievementReq = WsSettingChargeAchievementReq.create();
      final WsSettingCharmAchievementRes charmAchievement = await ref.read(settingWsProvider).wsSettingCharmAchievement(wsSettingChargeAchievementReq,
          onConnectSuccess: (succMsg) => {},
          onConnectFail: (errMsg) => BaseViewModel.showToast(context, ResponseCode.map[errMsg]!));

      final List<CharmAchievementInfo>? charmAchievementInfoList= charmAchievement.list;
      final WsNotificationSearchIntimacyLevelInfoRes intimacyLevelInfo = ref.read(userInfoProvider).notificationSearchIntimacyLevelInfo ?? WsNotificationSearchIntimacyLevelInfoRes();
      final List<String> newUserProtect = (intimacyLevelInfo.newUserProtect ?? '').split('|');

      // 後台受保護的親密點數、魅力等級、開關
      num protectIntimacyPoints = double.parse(newUserProtect[0]) ?? 0;
      String protectCharmLevel = newUserProtect[1];
      String protectEnable = newUserProtect[2];

      // 收費價格
      CharmAchievementInfo? charmAchievementInfoVoice;
      CharmAchievementInfo? charmAchievementInfoVideo;

      // 親密度大於等於後台親密度設定
      if (cohesionPoints >= protectIntimacyPoints ) {
        // 恢復成女性用戶設定扣費
        charmAchievementInfoVoice = charmAchievementInfoList?.firstWhere((info) => info.charmLevel == costs[1], orElse: () => CharmAchievementInfo(charmLevel: "0",voiceCharge:'0' ));
        charmAchievementInfoVideo  = charmAchievementInfoList?.firstWhere((info) => info.charmLevel == costs[2], orElse: () => CharmAchievementInfo(charmLevel: "0",streamCharge:'0'));
      } else {
        // 顯示後台設定的魅力等級扣費標準
        charmAchievementInfoVoice = charmAchievementInfoList?.firstWhere((info) => info.charmLevel == protectCharmLevel, orElse: () => CharmAchievementInfo(charmLevel: "0",voiceCharge:'0' ));
        charmAchievementInfoVideo  = charmAchievementInfoList?.firstWhere((info) => info.charmLevel == protectCharmLevel, orElse: () => CharmAchievementInfo(charmLevel: "0",streamCharge:'0'));
        if (protectEnable == '0') {
          // 顯示女性用戶設定扣費
          charmAchievementInfoVoice = charmAchievementInfoList?.firstWhere((info) => info.charmLevel == costs[1], orElse: () => CharmAchievementInfo(charmLevel: "0",voiceCharge:'0' ));
          charmAchievementInfoVideo  = charmAchievementInfoList?.firstWhere((info) => info.charmLevel == costs[2], orElse: () => CharmAchievementInfo(charmLevel: "0",streamCharge:'0'));
        }
      }

      videoLabel = '视频通话';
      videoSubLabel = '消耗 ${charmAchievementInfoVideo!.streamCharge} 金币/分钟';
      videoCost = int.parse(charmAchievementInfoVideo!.streamCharge!); // 對方視頻收費
      voiceLabel = '语音通话';
      voiceSubLabel = '消耗 ${charmAchievementInfoVoice!.voiceCharge} 金币/分钟';
      voiceCost = int.parse(charmAchievementInfoVoice!.voiceCharge!); // 對方語音收費
    }


    AppTheme theme = ref.watch(userInfoProvider).theme ?? AppTheme(themeType: AppThemeType.original);
    AppColorTheme appColorTheme = theme.getAppColorTheme;

    if (context.mounted) {
      CommonBottomSheet.show(
        context,
        actions: [
          CommonBottomSheetAction(
            title: videoLabel,
            titleStyle: TextStyle(fontSize: 16, color: appColorTheme.bottomSheetCallTitleTextColor, fontWeight: FontWeight.w400),
            subtitle: videoSubLabel,
            subtitleStyle: TextStyle(fontSize: 10, color: appColorTheme.bottomSheetCallSubTitleTextColor, fontWeight: FontWeight.w400),
            onTap: () => videoCallHandler(videoCost, searchListInfo),
          ),
          CommonBottomSheetAction(
            title: voiceLabel,
            titleStyle: TextStyle(fontSize: 16, color: appColorTheme.bottomSheetCallTitleTextColor, fontWeight: FontWeight.w400),
            subtitle: voiceSubLabel ,
            subtitleStyle: TextStyle(fontSize: 10, color: appColorTheme.bottomSheetCallSubTitleTextColor, fontWeight: FontWeight.w400),
            onTap: () => voiceCallHandler(voiceCost, searchListInfo),
          ),
        ],
      );
    }
  }

  // 打語音前判斷
  Future<void> voiceCallHandler(voiceCost, searchListInfo) async {
    final num personalGender = ref.read(userInfoProvider).memberInfo?.gender ?? 0; // 個人性別
    final num coin = ref.read(userInfoProvider).memberPointCoin?.coins ?? 0; // 個人金幣
    final bool isPermission = await _checkPermission(1);//檢查mic權限
    if(isPermission == false ){
      return;
    }
    if (personalGender == 1) {
      // 如果個人金幣不足要跳彈窗
      if (coin < voiceCost) {
        rechargeHandler();
      } else {
        callOrVideo(type: 1, searchListInfo: searchListInfo);
        // Navigator.pop(context);
      }
    } else {
      callOrVideo(type: 1, searchListInfo: searchListInfo);
      // Navigator.pop(context);

    }
  }

  // 打視訊前判斷
  Future<void> videoCallHandler(videoCost, searchListInfo) async {
    final num personalGender = ref.read(userInfoProvider).memberInfo?.gender ?? 0; // 個人性別
    final num coin = ref.read(userInfoProvider).memberPointCoin?.coins ?? 0; // 個人金幣
    final int regTime = ref.read(userInfoProvider).memberInfo?.regTime; // 註冊時間
    bool isNewMember = isWithin7Days(regTime); // 註冊時間有沒有小於 7 天內
    bool isPermission = await _checkPermission(2);//檢查mic、camera權限
    if(isPermission == false ){
      return;
    }

    if (personalGender == 1) {
      // 如果個人金幣不足要跳彈窗
      if (coin < videoCost) {
        // 新用戶有免費視訊時間
        if (isNewMember) {
          callOrVideo(type: 2, searchListInfo: searchListInfo);
        } else {
          rechargeHandler();
        }
      } else {
        callOrVideo(type: 2, searchListInfo: searchListInfo);
        // Navigator.of(context).pop();

      }
    } else {
      callOrVideo(type: 2, searchListInfo: searchListInfo);
      // Navigator.of(context).pop();

    }
  }


  /// --- 語音視訊API---

  //打語音或視頻電話
  Future<void> callOrVideo({int? type, SearchListInfo? searchListInfo}) async {
    ///3-96
    WsAccountCallVerificationRes? res = await accountCallOrVideoVerification(ref, searchListInfo!.userId!, searchListInfo.roomId!, type!, context);
    if(res == null) {
      return ;
    }
    if (context.mounted) {
      ref.read(callAuthenticationManagerProvider).startCall(
          callType: (type == 1) ? ZegoCallType.voice : ZegoCallType.video,
          invitedName: searchListInfo.userName!,
          isOfflineCall: true,
          isNeedLoading: false,
          callUserId: userId!,
          token: res.call!.rtcToken!,
          channel: res.call!.channel!,
          searchListInfo: searchListInfo,
          otherMemberInfoRes: memberInfoRes!
      );
      BaseViewModel.popPage(context);
    }
  }


  //通話視訊查驗(3-96)
  Future<WsAccountCallVerificationRes?> accountCallOrVideoVerification(WidgetRef ref, num freUserID, num roomID, int chatType, BuildContext context) async {
    final reqBody = WsAccountCallVerificationReq.create(
      freUserId: freUserID, //接聽方
      chatType: chatType, //0:閒置 1:語聊 2:視訊
      roomId: roomID,
    );
    String? resultCodeCheck;
    String? resultErrorCodeCheck;
    final res = await ref.read(accountWsProvider).wsAccountCallVerification(reqBody,
        onConnectSuccess: (succMsg) => resultCodeCheck = succMsg,
        onConnectFail: (errMsg) => resultErrorCodeCheck = errMsg
    );

    /// 餘額不足
    if (resultErrorCodeCheck == ResponseCode.CODE_COIN_BALANCE_NOT_ENOUGH) {
      rechargeHandler();
      return null;
    }

    /// 153: 黑單 or GM type
    if (resultErrorCodeCheck == ResponseCode.CODE_CALL_CHANNEL_ERROR
        || resultErrorCodeCheck == ResponseCode.CODE_CALL_IS_BLACK_LISTED_ERROR
        || resultErrorCodeCheck == ResponseCode.CODE_MEMBER_BUSY
    ) {
      final ZegoCallType type = chatType == 1 ? ZegoCallType.voice : ZegoCallType.video;
      pushEmptyCallWaitingPage(type, roomID);
      return null;
    }

    if(resultCodeCheck == ResponseCode.CODE_SUCCESS) {
      return res;
    }
  }

  //建立音視訊Token(3-99)
  Future<WsAccountGetRTCTokenRes> accountGetRTCToken(WidgetRef ref, int callUserId, int roomId, int chatType, BuildContext context) async {
    String resultCodeCheck = '';
    String errorMsgCheck = '';
    final reqBody = WsAccountGetRTCTokenReq.create(chatType: chatType, roomId: roomId, callUserId: callUserId);
    WsAccountGetRTCTokenRes res = await ref.read(accountWsProvider).wsAccountGetRTCToken(reqBody, onConnectSuccess: (succMsg) {
      print('succMsg:$succMsg');
    }, onConnectFail: (errMsg) {
      BaseViewModel.showToast(context, ResponseCode.map[errMsg]!);
    });
    return res;
  }


  /// ---DB---

  //將Zego歷史資料存在ＤＢ
  Future<void> insertDB({required String oppositeUserName ,num? sendStatus}) async {
    final chatMessageModelList = ref.read(chatMessageModelNotifierProvider);
    for (int i = 0; i < zimMessageList.length; i++) {
      ZIMMessage zimMessage = zimMessageList[i];
      try {
        switch (zimMessage.type) {
          case ZIMMessageType.text:
          ///文字或禮物
            ZIMTextMessage? zimTextMessage = zimMessage as ZIMTextMessage?;
            Map<String, dynamic> messageDataMap = {};
            Map<String, dynamic> extendedDataMap = {};
            messageDataMap = json.tryDecode(zimTextMessage!.message);
            extendedDataMap = json.tryDecode(zimTextMessage.extendedData);

            String uuid = messageDataMap['uuid'] ?? '';
            String chatContent='';
            if(oppositeUserName == 'java_system'){
              final contentMap= messageDataMap['content'];
              chatContent = contentMap['message'];
            } else if(messageDataMap['f'] == '3-3') {
              WsAccountOfficialMessageRes? content = WsAccountOfficialMessageRes.fromJson(messageDataMap['content'] ?? {});
              OfficialMessageInfo? message = OfficialMessageInfo.fromJson(content.message ?? {});
              /// 錄音檔
              if(messageDataMap['type'] == 9) {
                message.type = 9;
                _buildTextAudioMsg(oppositeUserName: oppositeUserName, zimMessage: zimTextMessage);
                ///儲存完後，直接continue避免後面的程式碼執行 導致 錄音檔無法顯示問題
                continue;
              }
              if(messageDataMap['type'] == 8){
                chatContent = zimTextMessage.message;
              }
            } else {
              chatContent = messageDataMap['content'] ?? '';
            }
            int expireTime = extendedDataMap['expireTime'] ?? 0;
            int halfTime = extendedDataMap['halfTime'] ?? 0;
            num points = extendedDataMap['points'] ?? 0;
            int incomeflag = extendedDataMap['incomeflag'] ?? 0;
            num expireDuration = extendedDataMap['expireDuration'] ?? 0;
            num halfDuration = extendedDataMap['halfDuration'] ?? 0;
            int timeStamp = extendedDataMap['createTime'] ?? zimTextMessage.timestamp;

            num unRead = 0;
            if (zimTextMessage.receiptStatus == ZIMMessageReceiptStatus.done) {
              unRead = 1;
            }
            String senderName = '';
            String receieverName = '';
            if (zimTextMessage.senderUserID == userName) {
              senderName = zimTextMessage.senderUserID;
              receieverName = oppositeUserName;
            } else {
              senderName = oppositeUserName;
              receieverName = userName;
            }
            if (chatContent.contains('[礼物]')) {
              String giftCategoryName = extendedDataMap['giftCategoryName']??'';
              String giftName = extendedDataMap['giftName']??'';
              String giftUrl = extendedDataMap['giftUrl']??'';
              String svgaUrl = extendedDataMap['svgaUrl']??'';
              String giftId = extendedDataMap['giftId']??'';
              num giftSendAmount = extendedDataMap['giftSendAmount']??0;
              num svgaFileId = extendedDataMap['svgaFileId']??0;
              num coins = extendedDataMap['coins']??0;
              ///禮物
              final DBHistoryGiftModel = ref.read(chatGiftModelNotifierProvider);
              final list = DBHistoryGiftModel.where((info) => info.messageUuid == uuid)
                  .toList();
              if (list.isEmpty) {
                ref.read(chatMessageModelNotifierProvider.notifier).setDataToSql(chatMessageModelList: [
                  ChatMessageModel(messageUuid: uuid, senderName: senderName, receiverName: receieverName, content: '[礼物]', timeStamp:timeStamp,
                      expireTime: expireTime, halfTime: halfTime, points: points, incomeflag: incomeflag, type: 3, unRead: unRead, expireDuration: expireDuration, halfDuration: halfDuration,reviewStatus: (zimTextMessage.sentStatus == ZIMMessageSentStatus.failed)?1:0,sendStatus: sendStatus)]);
                ref.read(chatGiftModelNotifierProvider.notifier).setDataToSql(chatGiftModelList: [
                  ChatGiftModel(messageUuid: uuid, senderName: senderName, receiverName: receieverName, giftCategoryName: giftCategoryName, giftName: giftName, giftId: int.parse(giftId!),
                      coins: coins, giftImageUrl: giftUrl, giftSendAmount: giftSendAmount, svgaFileId: svgaFileId, svgaUrl: svgaUrl, timeStamp: timeStamp, isShowSvga: 0)
                ]);
              }
            } else {
              ///文字
              final list = chatMessageModelList.where((info) => info.messageUuid == uuid).toList();
              if (list.isEmpty) {
                if(oppositeUserName == 'java_system'){
                  ref.read(chatMessageModelNotifierProvider.notifier).setDataToSql(chatMessageModelList: [
                    ChatMessageModel(messageUuid: uuid, senderName: senderName, receiverName: receieverName, content: zimTextMessage!.message, timeStamp: timeStamp,
                        expireTime: expireTime, halfTime: halfTime, points: points, incomeflag: incomeflag, type: 0, unRead: unRead, expireDuration: expireDuration, halfDuration: halfDuration,sendStatus: sendStatus)]);
                } else {
                  ref.read(chatMessageModelNotifierProvider.notifier).setDataToSql(chatMessageModelList: [
                    ChatMessageModel(messageUuid: uuid, senderName: senderName, receiverName: receieverName, content: chatContent, timeStamp: timeStamp,
                        expireTime: expireTime, halfTime: halfTime, points: points, incomeflag: incomeflag, type: 0, unRead: unRead, expireDuration: expireDuration, halfDuration: halfDuration,reviewStatus: (zimTextMessage.sentStatus == ZIMMessageSentStatus.failed)?1:0,sendStatus: sendStatus)]);
                }
              }
            }
            break;

        ///圖片
          case ZIMMessageType.image:
            ZIMImageMessage? zimImageMessage = zimMessage as ZIMImageMessage?;
            Map<String, dynamic> extendedDataMap = {};
            try {
              extendedDataMap = json.decode(zimImageMessage!.extendedData) as Map<String, dynamic>;
              int expireTime = extendedDataMap['expireTime'] ?? 0;
              int halfTime = extendedDataMap['halfTime'] ?? 0;
              num points = extendedDataMap['points'] ?? 0;
              int incomeflag = extendedDataMap['incomeflag'] ?? 0;
              String uuid = extendedDataMap['uuid'] ?? '';
              num expireDuration = extendedDataMap['expireDuration'] ?? 0;
              num halfDuration = extendedDataMap['halfDuration'] ?? 0;
              int timeStamp = extendedDataMap['createTime'] ?? zimImageMessage.timestamp;

              final DBHistoryImageModel = ref.read(chatImageModelNotifierProvider);
              final list = DBHistoryImageModel.where((info) => info.messageUuid == uuid).toList();
              num unRead = 0;
              if (zimImageMessage.receiptStatus ==
                  ZIMMessageReceiptStatus.done) {
                unRead = 1;
              }
              String senderName = '';
              String receieverName = '';
              if (zimImageMessage.senderUserID == userName) {
                senderName = zimImageMessage.senderUserID;
                receieverName = oppositeUserName;
              } else {
                senderName = oppositeUserName;
                receieverName = userName;
              }
              if (list.isEmpty) {
                ref.read(chatMessageModelNotifierProvider.notifier).setDataToSql(chatMessageModelList: [
                  ChatMessageModel(messageUuid: uuid, senderName: senderName, receiverName: receieverName, content: '[图片]', timeStamp: timeStamp,
                      expireTime: expireTime, halfTime: halfTime, points: points, incomeflag: incomeflag, type: 1, unRead: unRead, expireDuration: expireDuration, halfDuration:  halfDuration, reviewStatus: (zimImageMessage.sentStatus == ZIMMessageSentStatus.failed)?1:0,sendStatus: sendStatus)]);
                ref.read(chatImageModelNotifierProvider.notifier).setDataToSql(chatImageModelList: [
                  ChatImageModel(messageUuid: uuid, senderName: senderName, receiverName: receieverName, imagePath: (zimImageMessage.fileDownloadUrl.isEmpty)?zimImageMessage.fileLocalPath:zimImageMessage.fileDownloadUrl,
                      timeStamp: timeStamp)]);
              } else {
                ChatImageModel originalChatImageModel = list[0];
                ref.read(chatImageModelNotifierProvider.notifier).setDataToSql(chatImageModelList: [
                  ChatImageModel(messageUuid: originalChatImageModel.messageUuid, senderId: originalChatImageModel.senderId, senderName: originalChatImageModel.senderName,
                    receiverId: originalChatImageModel.receiverId, receiverName: originalChatImageModel.receiverName, imagePath: (zimImageMessage.fileDownloadUrl.isEmpty)?zimImageMessage.fileLocalPath:zimImageMessage.fileDownloadUrl, timeStamp: originalChatImageModel.timeStamp,)]);
              }
            } on FormatException {
              debugPrint('The info.extendedData is not valid JSON');
            }
            break;

        /// 錄音檔（）
          case ZIMMessageType.file:
            ZIMFileMessage? zimFileMessage = zimMessage as ZIMFileMessage?;
            Map<String, dynamic> extendedDataMap = {};
            try {
              extendedDataMap = json.decode(zimFileMessage!.extendedData) as Map<String, dynamic>;
              int expireTime = extendedDataMap['expireTime'] ?? 0;
              int halfTime = extendedDataMap['halfTime'] ?? 0;
              num points = extendedDataMap['points'] ?? 0;
              int incomeflag = extendedDataMap['incomeflag'] ?? 0;
              String uuid = extendedDataMap['uuid'] ?? '';
              num audioTime = 0;
              int timeStamp = extendedDataMap['createTime'] ?? zimFileMessage.timestamp;


              ///TODO 影響招呼語取得時間
              // if(extendedDataMap['chatContent'] !=null){
              // Map<String, dynamic> chatContent = extendedDataMap['chatContent'];
              audioTime = extendedDataMap['audioTime'] ?? 0;
              // }
              num audioType = 2;

              num unRead = 0;
              if (zimFileMessage.receiptStatus == ZIMMessageReceiptStatus.done) {unRead = 1;}
              String senderName = '';
              String receieverName = '';
              if (zimFileMessage.senderUserID == userName) {
                senderName = zimFileMessage.senderUserID;
                receieverName = oppositeUserName;
              } else {
                senderName = oppositeUserName;
                receieverName = userName;
              }
              ref.read(chatMessageModelNotifierProvider.notifier).setDataToSql(chatMessageModelList: [
                ChatMessageModel(messageUuid: uuid, senderName: senderName, receiverName: receieverName, content: '[录音]',
                    timeStamp: timeStamp, expireTime: expireTime, halfTime: halfTime, points: points, incomeflag: incomeflag,
                    type: audioType, unRead: unRead,sendStatus: sendStatus)]);
              ref.read(chatAudioModelNotifierProvider.notifier).setDataToSql(chatAudioModelList: [
                ChatAudioModel(messageUuid: uuid, senderName: senderName, receiverName: receieverName, audioPath: zimFileMessage.fileDownloadUrl,
                  timeStamp: audioTime,)]);

            } on FormatException {
              debugPrint('The info.extendedData is not valid JSON');
            }
            break;
          default:
            break;
        }
      } on FormatException {
        debugPrint('The info.extendedData is not valid JSON');
      }
    }
  }

  Future<void> _updateTextMessageDB({required String uuid, required String chatContent,required num sendStatus,SearchListInfo? searchListInfo,WsAccountSpeakRes? res} ) async {
      num type = 0;
      num timeStamp = res?.createTime ?? DateTime.now().millisecondsSinceEpoch;
      await _setMessageDB(type:type,searchListInfo: searchListInfo, uuid: uuid, chatContent: chatContent, expireTime: res?.expireTime, halfTime: res?.halfTime, points: res?.points, incomeflag: res?.incomeflag,sendStatus: sendStatus,timeStamp: timeStamp );
      await _setChatUserModelDB(searchListInfo: searchListInfo, chatContent: chatContent,  points: cohesionPoints,sendStatus:sendStatus,timeStamp: timeStamp );
  }

  Future<void> _updateGiftMessageDB({required String uuid, required String chatContent,required num sendStatus,SearchListInfo? searchListInfo,WsAccountSpeakRes? res,GiftListInfo? giftInfo} ) async{
    num type = 3;
    num timeStamp = res?.createTime ?? DateTime.now().millisecondsSinceEpoch;
    await _setGiftDB(searchListInfo: searchListInfo, uuid: uuid, giftCategoryName: giftInfo?.categoryName, giftName: giftInfo?.giftName, giftId: giftInfo?.giftId,
        coins: giftInfo?.coins, giftUrl: giftInfo?.giftImageUrl, giftSendAmount: giftInfo?.giftSendAmount, svgaFileId: giftInfo?.svgaFileId, svgaUrl: giftInfo?.svgaUrl, isShowSvga: 1,timeStamp: timeStamp);
    await _setMessageDB( type: type,searchListInfo: searchListInfo, uuid: uuid, chatContent: chatContent, expireTime: res?.expireTime, halfTime: res?.halfTime, points: res?.points, incomeflag: res?.incomeflag,sendStatus:sendStatus,timeStamp: timeStamp);
    await _setChatUserModelDB(searchListInfo: searchListInfo, chatContent: chatContent,  points: cohesionPoints,sendStatus:sendStatus,timeStamp: timeStamp);
  }

  Future<void> _updateImageMessageDB({required String uuid, required String chatContent,required num sendStatus,required String imagePath,SearchListInfo? searchListInfo,WsAccountSpeakRes? res}) async {
    num type = 1;
    num timeStamp = res?.createTime ?? DateTime.now().millisecondsSinceEpoch;

    await _setChatImageModelDB(searchListInfo: searchListInfo, uuid: uuid, imagePath: imagePath,timeStamp: timeStamp);
    await _setMessageDB(searchListInfo: searchListInfo, uuid: uuid, chatContent: chatContent, expireTime: res?.expireTime, halfTime: res?.halfTime, points: res?.points,
        incomeflag: res?.incomeflag, type: type,sendStatus:sendStatus,timeStamp: timeStamp );
    await _setChatUserModelDB(searchListInfo: searchListInfo, chatContent: chatContent, points: cohesionPoints,sendStatus:sendStatus,timeStamp: timeStamp);

  }

  Future<void> _updateVoiceMessageDB({required String uuid, required String chatContent,required num sendStatus,required String filePath, required num audioTime, SearchListInfo? searchListInfo,WsAccountSpeakRes? res}) async {
    num type = 2;
    num timeStamp = res?.createTime ?? DateTime.now().millisecondsSinceEpoch;

    final contentJson = jsonEncode({'audioTime': audioTime,});
    await _setChatAudioModelDB(searchListInfo: searchListInfo, uuid: uuid, audioPath: filePath,audioTime: audioTime);
    await _setMessageDB(searchListInfo: searchListInfo, uuid: uuid, chatContent: contentJson, expireTime: res?.expireTime, halfTime: res?.halfTime,
        points: res?.points, incomeflag: res?.incomeflag, type: type,sendStatus: sendStatus,timeStamp: timeStamp);
    await _setChatUserModelDB(searchListInfo: searchListInfo, chatContent: '[录音]', points: cohesionPoints,sendStatus:sendStatus,timeStamp: timeStamp);
  }

  //寫進消息列表人，並更新provider
  Future<void> _setChatUserModelDB({SearchListInfo? searchListInfo, required String chatContent,required num points,num? sendStatus,required num timeStamp})async {
    final chatUserModelList = ref.read(chatUserModelNotifierProvider);
    final list = chatUserModelList.where((info) => info.userName == searchListInfo?.userName).toList();
    ChatUserModel chatUserModel = list[0];
    // 檢查當前聊天室自己發的訊息是否有傳送失敗
    final List<ChatMessageModel> allChatMessageModelList = ref.read(chatMessageModelNotifierProvider);
    List<ChatMessageModel> mySendChatMessageList = allChatMessageModelList.where((info) {
      final senderName = info.senderName;
      final receiverName = info.receiverName;
      final searchUserName = searchListInfo?.userName;
      final userName = ref.read(userInfoProvider).memberInfo?.userName;
      return senderName == userName && receiverName == searchUserName;
    }).toList();
    bool isHasSendStatusError = mySendChatMessageList.any((item) => item.sendStatus == 2);
    // 如果有傳送失敗的訊息，則 sendStatus 設定為2（傳送失敗）
    num status = sendStatus ?? 1;
    if(isHasSendStatusError) {
      status = 2;
    }
    _chatUserModelNotifier.setDataToSql(chatUserModelList: [
      ChatUserModel(userId: searchListInfo?.userId, roomIcon: searchListInfo?.roomIcon, cohesionLevel: cohesionLevel, userCount: searchListInfo?.userCount,
          isOnline: searchListInfo?.isOnline, userName: searchListInfo?.userName, roomId: searchListInfo?.roomId, roomName: searchListInfo?.roomName,
          points: points, remark: chatUserModel.remark, unRead: chatUserModel.unRead??0, recentlyMessage: chatContent, timeStamp: timeStamp,
          pinTop: chatUserModel.pinTop,sendStatus:status )]);

  }

  //寫進訊息DB，並更新provider
  Future<void> _setMessageDB({SearchListInfo? searchListInfo, String? uuid, String? chatContent, num? expireTime, num? halfTime, num? points, num? incomeflag, num? type,num? sendStatus,required num timeStamp}) async{
    final model = ChatMessageModel(messageUuid: uuid, senderId: _userInfoModel.userId, receiverId: searchListInfo?.userId, senderName: _userInfoModel.userName,
        receiverName: searchListInfo?.userName, content: chatContent, timeStamp: timeStamp, gender: _userInfoModel.memberInfo!.gender,
        expireTime: expireTime, halfTime: halfTime, points: points, incomeflag: incomeflag, type: type, unRead: 0,reviewStatus: 0,sendStatus: sendStatus);
    _chatMessageModelNotifier.setDataToSql(chatMessageModelList: [model]);
  }

  //寫進禮物DB，並更新provider
  Future<void> _setGiftDB({SearchListInfo? searchListInfo, String? uuid, String? giftCategoryName, String? giftName, num? giftId, num? coins, String? giftUrl, num? giftSendAmount,
    num? svgaFileId, String? svgaUrl, num? isShowSvga,required num timeStamp})async {
    final model = ChatGiftModel(messageUuid: uuid, senderId: _userInfoModel.userId, receiverId: userId, senderName: _userInfoModel.userName,
        receiverName: searchListInfo!.userName, giftCategoryName: giftCategoryName, giftName: giftName, giftId: giftId, coins: coins,
        giftImageUrl: giftUrl, giftSendAmount: giftSendAmount, svgaFileId: svgaFileId, svgaUrl: svgaUrl, isShowSvga: isShowSvga, timeStamp: timeStamp);
    _chatGiftModelNotifier.setDataToSql(chatGiftModelList: [model]);
  }

  //寫進圖片DB，並更新provider
  Future<void> _setChatImageModelDB({SearchListInfo? searchListInfo, required String uuid, required String imagePath,required num timeStamp})async {
    _chatImageModelNotifier.setDataToSql(chatImageModelList: [
      ChatImageModel(messageUuid: uuid, senderId: _userInfoModel.userId, receiverId: searchListInfo?.userId, senderName: _userInfoModel.userName,
        receiverName: searchListInfo?.userName, imagePath: imagePath, timeStamp: timeStamp,)]);
  }

  //寫進錄音DB，並更新provider
  Future<void> _setChatAudioModelDB({SearchListInfo? searchListInfo, required String uuid, required String audioPath ,required num audioTime})async {
    _chatAudioModelNotifier.setDataToSql(chatAudioModelList: [
      ChatAudioModel(messageUuid: uuid, senderId: _userInfoModel.userId, receiverId: userId, senderName:_userInfoModel.userName,
          receiverName: searchListInfo?.userName, audioPath: audioPath, timeStamp: audioTime)]);
  }

  /// ---親密度相關---

  //
  void _updateNowIntimacy({required num level,required num points}){
    if (cohesionLevel != level) {
      cohesionPoints = points;
      getNowIntimacy();
    }
    cohesionPoints = points;
    cohesionLevel = level;
  }


  //取得目前亲密度狀態
  void getNowIntimacy() {
    final WsNotificationSearchIntimacyLevelInfoRes intimacyLevelInfo = ref.read(userInfoProvider).notificationSearchIntimacyLevelInfo ?? WsNotificationSearchIntimacyLevelInfoRes();
    final List<IntimacyLevelInfo>? intimacyLevelInfoList = intimacyLevelInfo.list;
    if (intimacyLevelInfoList != null) {
      for (final intimacyLevelInfo in intimacyLevelInfoList) {
        pointsRuleMap[intimacyLevelInfo.cohesionLevel] = intimacyLevelInfo.points;
      }
    }

    if (cohesionPoints < pointsRuleMap[1]) {
      nowIntimacy = 0;
      cohesionImagePath = 'assets/icons/icon_intimacy_level_1.png';
      cohesionColor = AppColors.cohesionLevelColor[0];
      String nextCohesionName = getCohesionName(nowIntimacy+1);
      nextRelationShip = '【$nextCohesionName】';
      intimacyLevelBgColor = [Color(0xFFACBCED), Color.fromRGBO(234, 238, 250, 0),];
    } else if (pointsRuleMap[1] <= cohesionPoints && cohesionPoints < pointsRuleMap[2]) {
      nowIntimacy = 1;
      cohesionColor = AppColors.cohesionLevelColor[1];
      cohesionImagePath = 'assets/icons/icon_intimacy_level_1.png';
      String nextCohesionName = getCohesionName(nowIntimacy+1);
      nextRelationShip = '【$nextCohesionName】';
      nextLevelSubtract = pointsRuleMap[2] - cohesionPoints.toInt();
      intimacyLevelBgColor = [Color(0xFFACBCED), Color.fromRGBO(234, 238, 250, 0),];
    } else if (pointsRuleMap[2] <= cohesionPoints && cohesionPoints < pointsRuleMap[3]) {
      nowIntimacy = 2;
      cohesionColor = AppColors.cohesionLevelColor[2];
      cohesionImagePath = 'assets/icons/icon_intimacy_level_2.png';
      nextLevelSubtract = pointsRuleMap[3] - cohesionPoints.toInt();
      String nextCohesionName = getCohesionName(nowIntimacy+1);
      nextRelationShip = '【$nextCohesionName】';
      intimacyLevelBgColor = [Color(0xFF81B3E9), Color.fromRGBO(225, 237, 250, 0),];

    } else if (pointsRuleMap[3] <= cohesionPoints && cohesionPoints < pointsRuleMap[4]) {
      nowIntimacy = 3;
      cohesionColor = AppColors.cohesionLevelColor[3];
      cohesionImagePath = 'assets/icons/icon_intimacy_level_3.png';
      nextLevelSubtract = pointsRuleMap[4] - cohesionPoints.toInt();
      String nextCohesionName = getCohesionName(nowIntimacy+1);
      nextRelationShip = '【$nextCohesionName】';
      intimacyLevelBgColor = [Color(0xFF61BC81), Color.fromRGBO(227, 244, 233, 0),];
    } else if (pointsRuleMap[4] <= cohesionPoints && cohesionPoints < pointsRuleMap[5]) {
      nowIntimacy = 4;
      cohesionColor = AppColors.cohesionLevelColor[4];
      cohesionImagePath = 'assets/icons/icon_intimacy_level_4.png';
      nextLevelSubtract = pointsRuleMap[5] - cohesionPoints.toInt();
      String nextCohesionName = getCohesionName(nowIntimacy+1);
      nextRelationShip = '【$nextCohesionName】';
      intimacyLevelBgColor = [Color(0xFFF1B0B8), Color.fromRGBO(236, 153, 162, 0),];
    } else if (pointsRuleMap[5] <= cohesionPoints && cohesionPoints < pointsRuleMap[6]) {
      nowIntimacy = 5;
      cohesionColor = AppColors.cohesionLevelColor[5];
      cohesionImagePath = 'assets/icons/icon_intimacy_level_5.png';
      nextLevelSubtract = pointsRuleMap[6] - cohesionPoints.toInt();
      String nextCohesionName = getCohesionName(nowIntimacy+1);
      nextRelationShip = '【$nextCohesionName】';
      intimacyLevelBgColor = [Color(0xFFF2B0B8), Color.fromRGBO(174, 120, 237, 0),];
    } else if (pointsRuleMap[6] <= cohesionPoints && cohesionPoints < pointsRuleMap[7]) {
      nowIntimacy = 6;
      cohesionImagePath = 'assets/icons/icon_intimacy_level_6.png';
      cohesionColor = AppColors.cohesionLevelColor[6];
      nextLevelSubtract = pointsRuleMap[7] - cohesionPoints.toInt();
      String nextCohesionName = getCohesionName(nowIntimacy+1);
      nextRelationShip = '【$nextCohesionName】';
      intimacyLevelBgColor = [Color(0xFFDE858E), Color.fromRGBO(219, 120, 130, 0),];
    } else if (pointsRuleMap[7] <= cohesionPoints && cohesionPoints < pointsRuleMap[8]) {
      cohesionImagePath = 'assets/icons/icon_intimacy_level_7.png';
      nowIntimacy = 7;
      cohesionColor = AppColors.cohesionLevelColor[7];
      String nextCohesionName = getCohesionName(nowIntimacy+1);
      nextRelationShip = '【$nextCohesionName】';
      intimacyLevelBgColor = [Color(0xFFCC1F18), Color.fromRGBO(176, 46, 37, 0),];
    }else{
      cohesionColor = AppColors.cohesionLevelColor[8];
      cohesionImagePath = 'assets/icons/icon_intimacy_level_8.png';
      nowIntimacy = 8;
      nextRelationShip = '【】';
      intimacyLevelBgColor = [Color(0xFFEAA850), Color.fromRGBO(242, 201, 141, 0),];
    }
    timeDistinctionList.clear();

    if(setState != null) setState!(() {isCohesionLoading = false;});
  }

  String getCohesionName(int intimacyLevel) {
    String cohesionName = '';
    final WsNotificationSearchIntimacyLevelInfoRes intimacyLevelInfo = ref.read(userInfoProvider).notificationSearchIntimacyLevelInfo ?? WsNotificationSearchIntimacyLevelInfoRes();
    List<IntimacyLevelInfo?> levelInfo = intimacyLevelInfo.list?.where((item) => item.cohesionLevel == intimacyLevel).toList() ?? [];
    if (levelInfo.isNotEmpty) {
      cohesionName = levelInfo.first?.cohesionName ?? '';
    }
    return cohesionName;
  }


  /// ---開畫面(彈窗/推頁)---
  //亲密度彈窗
  void showIntimacyDialog(String? avatarIcon) {
    BaseDialog(context).showTransparentDialog(
        isDialogCancel: true,
        widget: IntimacyDialog(
          opponentAvatar: avatarIcon,
          cohesionPoints: cohesionPoints,
          cohesionImagePath:cohesionImagePath,
          pointsRuleMap:pointsRuleMap,
          nextLevelSubtract: nextLevelSubtract,
          nowIntimacy:nowIntimacy,
          nextRelationShip:nextRelationShip,
          osType: osType,
        )
    );
  }

  //禮物彈窗
  Future<void> showBottomSheetGift(SearchListInfo searchListInfo, num unRead) async {
    showModalBottomSheet<dynamic>(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (BuildContext context) {
        return GiftAndBag(
          onTapSendGift: (result) {
            sendGiftMessage(searchListInfo: searchListInfo, unRead: unRead, giftListInfo: result);
          },
        );
      },
    );
  }

  //最長錄音時間彈窗
  void showMaximumRecordingDialog({SearchListInfo? searchListInfo, int? contentType, num? unRead, bool? isVoice, required Function micStatusCallback}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding:
          EdgeInsets.only(left: 17.w, right: 17.w, top: 20.h, bottom: 20.h),
          // 移除內容的 padding
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          content: SizedBox(
            width: 300.w, // 設定最大寬度
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '提示',
                  style: TextStyle(
                    fontSize: 18.sp,
                    color: AppColors.textFormBlack,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 12.h, bottom: 32.h),
                  child: Text(
                    '录音达到最大时间，是否发送？',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: AppColors.textFormBlack,
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: GestureDetector(
                        child: Container(
                          height: 44,
                          alignment: const Alignment(0, 0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(24),
                            gradient:  LinearGradient(
                              colors: [
                                AppColors.mainPink.withOpacity(0.2),
                                AppColors.mainPink.withOpacity(0.1),
                              ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                          ),
                          child: Text(
                            '取消',
                            style: TextStyle(
                              color: Color.fromRGBO(236, 97, 147, 1),
                              fontSize: 14.sp,
                            ),
                          ),
                        ),
                        onTap: () {
                          BaseViewModel.popPage(context);
                          timeDistinctionList.clear();
                          micStatusCallback(0);
                          setState!((){
                            seconds = 0;
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                        child: GestureDetector(
                          child: Container(
                            height: 44.w,
                            alignment: const Alignment(0, 0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(24),
                              gradient: AppColors.pinkLightGradientColors,
                            ),
                            child: Text(
                              '发送',
                              style:
                              TextStyle(color: Colors.white, fontSize: 14.sp),
                            ),
                          ),
                          onTap: () {
                            sendVoiceMessage(
                                searchListInfo: searchListInfo,
                                unRead: unRead
                            );

                            micStatusCallback(0);
                            setState!((){
                              seconds = 0;
                            });

                            BaseViewModel.popPage(context);
                          },
                        )
                    )
                  ],
                ),
              ],
            ),
          ),
          // 其他 Dialog 属性
        );
      },
    );
  }

  //收費彈窗提醒
  void rechargeHandler() {
    final num rechargeCounts =  ref.read(userInfoProvider).memberPointCoin?.depositCount ?? 0;
    final AppTheme theme = ref.watch(userInfoProvider).theme ?? AppTheme(themeType: AppThemeType.original);
    if (rechargeCounts == 0) {
      RechargeUtil.showFirstTimeRechargeDialog('余额不足，请先充值'); // 開啟首充彈窗
    } else {
      RechargeUtil.showRechargeBottomSheet(theme:theme); // 開啟充值彈窗
    }
  }

  //網路延遲狀態提醒
  void onNetworkTime(int delayTime) {
    final BuildContext currentContext = BaseViewModel.getGlobalContext();
    print('網路延遲狀態: $delayTime ms');
    AppTheme theme = ref.read(userInfoProvider).theme ?? AppTheme(themeType: AppThemeType.original);

    if(delayTime > NetworkStatusSetting.statusVerySlow) {
      CommDialog(context).build(
          theme: theme,
          title: '提示',
          contentDes:
          '因网速较慢，通话可能不畅。\n 建议避开用量高峰或切换网络。',
          horizontalPadding: 32.w,
          rightBtnTitle: '确认',
          rightAction: () =>
              BaseViewModel.popPage(context) );
    }
  }

  void pushEmptyCallWaitingPage(ZegoCallType type ,num roomID){
    callback.pushToWaitingPage(
        token: '',
        channel: '',
        roomID: roomID,
        isNeedLoading: false,
        memberInfoRes: memberInfoRes!,
        searchListInfo: SearchListInfo(),
        isEnabledMicSwitch: false,
        isEnabledCamSwitch: false,
        typeForEmptyCall: type
    );
  }

  /// ---其他---



  initTickerProvider() {
    animationController = SVGAAnimationController(vsync: tickerProvider!);
  }


  //取得用戶資料
  Future<void> initUserInfo(String oppositeUserName) async {
    final reqBody = WsMemberInfoReq.create(
      userName: oppositeUserName,
    );
    memberInfoRes = await ref.read(memberWsProvider).wsMemberInfo(reqBody, onConnectSuccess: (succMsg) {}, onConnectFail: (errMsg) {
      final gmType = ref.read(userInfoProvider).buttonConfigList?.gmType;
      if(gmType != 1){
        BaseViewModel.showToast(context, ResponseCode.map[errMsg]!);
      }
    });
    _initExpandFriendController();

    osType = memberInfoRes?.osType ?? 1;
    num gender = ref.read(userInfoProvider).memberInfo?.gender ??0;
    final chatUserModelList = ref.read(chatUserModelNotifierProvider);
    final list = chatUserModelList.where((info) => info.userName == oppositeUserName).toList();
    ChatUserModel chatUserModel = list.first;
    if(gender == 1){
      if(chatUserModel.charmCharge == null || chatUserModel.charmCharge!.isEmpty){
        // needShowCharmCharge = true;
        List<String> memberInfoCosts = (memberInfoRes!.charmCharge ?? '').split('|');
        textCharge = memberInfoCosts[0];
      }else if(chatUserModel.charmCharge != memberInfoRes!.charmCharge){
        List<String> dbCosts = (chatUserModel.charmCharge ?? '').split('|');
        List<String> memberInfoCosts = (memberInfoRes!.charmCharge ?? '').split('|');
        if(dbCosts[0] != memberInfoCosts[0]){
          needShowCharmCharge = true;
          textCharge = memberInfoCosts[0];
        }
      }
    }
  }

  //常用語取得
  Future<void> getCommonLanguage() async {
    commonLanguageList.clear();
    List<String> customCommonLanguageTexts = [];
    List<String> defaultCommonLanguageTexts = [];
    String phoneNumber = await FcPrefs.getPhoneNumber();
    customCommonLanguageTexts = await FcPrefs.getCustomCommonLanguage('${phoneNumber}_customCommonLanguage');
    defaultCommonLanguageTexts = await FcPrefs.getDefaultCommonLanguage("${phoneNumber}_defaultCommonLanguage");
    final num? gender = ref.read(userInfoProvider).memberInfo?.gender;
    String data = '';
    if(gender == 1){
      data = await rootBundle.loadString('assets/txt/commonlanguage_male.txt');
    }else{
      data = await rootBundle.loadString('assets/txt/commonlanguage_female.txt');
    }
    List<String> dList = const LineSplitter().convert(data);
    if(customCommonLanguageTexts.isEmpty){
      if(defaultCommonLanguageTexts.isEmpty){
        for(int i = 0;i<10;i++){
          commonLanguageList.add(dList[i]);
        }
      }else{
        commonLanguageList = defaultCommonLanguageTexts;
      }
    }else{
      if(defaultCommonLanguageTexts.isEmpty){
        commonLanguageList.addAll(customCommonLanguageTexts);
        for(int i = 0;i<10;i++){
          commonLanguageList.add(dList[i]);
        }
      }else{
        commonLanguageList.addAll(customCommonLanguageTexts);
        commonLanguageList.addAll(defaultCommonLanguageTexts);
      }
    }
    timeDistinctionList.clear();
    setState!(() {
      commonLanguageLoading = false;
    });
  }

  void scrollToEnd({bool? toStart = false}) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        final maxScroll = scrollController.position.maxScrollExtent;
        scrollController.animateTo(
          toStart == false ? maxScroll : 0,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  int checkIsReplyPickup(){
    if(zimMessageList.isNotEmpty){
      ZIMMessage zimMessage = zimMessageList.last;
      Map<String, dynamic> extendedDataMap = {};
      try {
        extendedDataMap = json.decode(zimMessage.extendedData) as Map<String, dynamic>;
        if(extendedDataMap['isReplyPickup'] != null){
          if(extendedDataMap['isReplyPickup']){
            return 1;
          }else{
            return 0;
          }
        }else{
          return 0;
        }
      } catch (e) {
        return 0;
      }
    } else{
      return 0;
    }

  }

  String replyUUid(SearchListInfo searchListInfo) {
    String replyUuid = '';
    List<ChatMessageModel> chatMessageModelList = _getChatMsgFormUserName(searchListInfo);
    for (int i = chatMessageModelList.length - 1; i >= 0; i--) {
      if (chatMessageModelList[i].senderName !=
          ref.read(userInfoProvider).memberInfo!.userName) {
        if (replyUuid.isEmpty) {
          replyUuid = chatMessageModelList[i].messageUuid!;
        } else {
          replyUuid += ",${chatMessageModelList[i].messageUuid!}";
        }
      } else {
        break;
      }
    }
    return replyUuid;
  }

  List<ChatMessageModel> _getChatMsgFormUserName (SearchListInfo searchListInfo) {
    final allChatMessageModelList = ref.watch(chatMessageModelNotifierProvider);
    final mySendChatMessagelist = allChatMessageModelList.where((info) => info.senderName == ref.read(userInfoProvider).memberInfo?.userName && info.receiverName == searchListInfo!.userName!).toList();
    final oppoSiteSendChatMessagelist = allChatMessageModelList.where((info) => info.senderName == searchListInfo.userName && info.receiverName == ref.read(userInfoProvider).memberInfo?.userName).toList();
    List<ChatMessageModel> chatMessageModelList = sortChatMessages(mySendChatMessagelist, oppoSiteSendChatMessagelist);
    return chatMessageModelList;
  }

  //錄音時間格式
  String formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  //錄音開始計時
  void startRecordingTimer() {
    recordingSeconds = 0;
    recordingTimer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      timeDistinctionList.clear();
      setState!(() {
        recordingSeconds++;
        textFiledHint = "录音中";
        style = TextStyle(color: AppColors.mainPink, fontSize: 14.sp);
      });
    });
  }

  _buildTextAudioMsg({required ZIMTextMessage zimMessage, required String oppositeUserName}) {
    Map<String, dynamic> messageDataMap = {};
    Map<String, dynamic> extendedDataMap = {};
    messageDataMap = json.tryDecode(zimMessage.message);
    extendedDataMap = json.tryDecode(zimMessage.extendedData);

    try {
      extendedDataMap = json.decode(zimMessage.extendedData) as Map<String, dynamic>;
      int expireTime = extendedDataMap['expireTime'] ?? 0;
      int halfTime = extendedDataMap['halfTime'] ?? 0;
      num points = extendedDataMap['points'] ?? 0;
      int incomeflag = extendedDataMap['incomeflag'] ?? 0;

      num audioTime = 0;
      if(extendedDataMap['chatContent'] !=null){
        Map<String, dynamic> chatContent = extendedDataMap['chatContent'];
        audioTime = chatContent['audioTime'] ?? 0;
      }
      String uuid = messageDataMap['uuid'];
      num unRead = 0;
      if (zimMessage.receiptStatus == ZIMMessageReceiptStatus.done) {
        unRead = 1;
      }
      String senderName = '';
      String receieverName = '';
      if (zimMessage.senderUserID == userName) {
        senderName = zimMessage.senderUserID;
        receieverName = oppositeUserName;
      } else {
        senderName = oppositeUserName;
        receieverName = userName;
      }
      // final DBHistoryAudioModel = ref.read(chatAudioModelNotifierProvider);
      // final list = DBHistoryAudioModel.where((info) => info.messageUuid == uuid).toList();
      final ReviewAudioRes reviewAudioRes = ReviewAudioRes.fromJson(messageDataMap['content']['message']);
      num reviewStatus = reviewAudioRes.reviewResult == true ? 0 : 1;// 0:審核過，1:未審過
      num audioType = reviewAudioRes.reviewResult == true ? 2 : 7; // 2 錄音檔，7:錄音檔（封鎖）
      num sendStatus = reviewAudioRes.reviewResult == true ? 1 : 2;// 1 傳送成功，2:傳送失敗

      if(reviewStatus == 1){
        //如果為未審過，且訊息不是發送訊息的本人，則此訊息不顯示跟不儲存DB
        //此判斷是因為即使未審過訊息，後端依然會將訊息發送出去給兩端，所以需要預防此狀況
        if(zimMessage.senderUserID != ref.read(userInfoProvider).memberInfo?.userName){
          return;
        }
      }
      ref.read(chatMessageModelNotifierProvider.notifier).setDataToSql(chatMessageModelList: [
        ChatMessageModel(messageUuid: uuid, senderName: senderName, receiverName: receieverName, content: '[录音]',
            timeStamp: zimMessage.timestamp, expireTime: expireTime, halfTime: halfTime, points: points, incomeflag: incomeflag,
            type: audioType, unRead: unRead,reviewStatus: reviewStatus)]);
      ref.read(chatAudioModelNotifierProvider.notifier).setDataToSql(chatAudioModelList: [
        ChatAudioModel(messageUuid: uuid, senderName: senderName, receiverName: receieverName, audioPath: reviewAudioRes.download_url,
          timeStamp: audioTime,)]);


    } on FormatException {
      debugPrint('The info.extendedData is not valid JSON');
    }
  }

  // 對方資訊頁, 初始化大小動畫
  _initExpandFriendController() {
    // 預設高度
    double endHeight = 60.h;

    // 認證狀態

    if(memberInfoRes?.realNameAuth == 1 || memberInfoRes?.realPersonAuth == 1) {
      endHeight = endHeight + 30.h;
    }

    // 相冊
    final isNullAlbum = memberInfoRes?.albumsPath == null || memberInfoRes!.albumsPath!.isEmpty;
    if(!isNullAlbum) {
      endHeight = endHeight + 70.h;
    }

    if(expandController != null) {
      expandController?.dispose();
      expandController == null;
    }

    expandController = AnimationController(vsync: tickerProvider!,
      duration: const Duration(milliseconds: 300),
      reverseDuration: const Duration(milliseconds: 300),
    );

    heightAnimation = Tween<double>(
      begin: 60.h,
      end: endHeight,
    ).animate(expandController!);
  }

  dropDownFriendInfo() {
    final bool isNullRealAuth = memberInfoRes?.realNameAuth != 1 && memberInfoRes?.realPersonAuth != 1;
    final bool isNullAlbum = memberInfoRes?.albumsPath == null || memberInfoRes!.albumsPath!.isEmpty;
    print('isNullRealAuth: $isNullRealAuth');
    print('isNullAlbum: $isNullAlbum');

    if (isNullRealAuth && isNullAlbum) return;

    if(expandController?.status == AnimationStatus.completed) {
      expandController?.reverse();
    } else {
      expandController?.forward();
    }
  }

  String _getReceiverName(ZIMMessage zimMessage) {
    final String myUserName = ref.read(userInfoProvider).userName ?? '';
    final String receiverName = (zimMessage.senderUserID == myUserName)
        ? zimMessage.conversationID
        : myUserName;
    return receiverName;
  }

  Future<void> getCohesionPointsRule() async {
    final reqBody = WsNotificationSearchIntimacyLevelInfoReq.create();
    WsNotificationSearchIntimacyLevelInfoRes res = await ref.read(notificationWsProvider).wsNotificationSearchIntimacyLevelInfo(reqBody,
        onConnectSuccess: (succMsg) {}, onConnectFail: (errMsg) {});
    ref.read(userUtilProvider.notifier).loadNotificationSearchIntimacyLevelInfo(res);
    final List<IntimacyLevelInfo>? intimacyLevelInfoList = res.list;
    if (intimacyLevelInfoList != null) {
      for (final intimacyLevelInfo in intimacyLevelInfoList) {
        pointsRuleMap[intimacyLevelInfo.cohesionLevel] = intimacyLevelInfo.points;
      }
    }

    getNowIntimacy();
  }

  List<ChatUserModel> sortChatUserstest(List<ChatUserModel> userList) {
    // 首先将 pinTop 为 1 的 ChatUserModel 排到前面
    List<ChatUserModel> systemUsers = [];
    List<ChatUserModel> pinnedUsers = [];
    List<ChatUserModel> nonPinnedUsers = [];

    for (var user in userList) {
      if(user.userName =='java_system'){
        systemUsers.add(user);
      }else{
        if (user.pinTop == 1) {
          pinnedUsers.add(user);
        } else {
          nonPinnedUsers.add(user);
        }
      }
    }

    // 对置顶的用户按照 timeStamp 排序，最新时间在最前面
    pinnedUsers.sort((a, b) => b.timeStamp!.compareTo(a.timeStamp!));

    // 对非置顶的用户按照 timeStamp 排序，最新时间在最前面
    nonPinnedUsers.sort((a, b) => b.timeStamp!.compareTo(a.timeStamp!));

    // 合并两个列表：置顶的用户在前面，非置顶用户也按照时间排序
    List<ChatUserModel> sortedUsers = [...systemUsers,...pinnedUsers, ...nonPinnedUsers];

    /// 移除拉黑用戶
    final WsNotificationBlockGroupRes? blockList = ref.read(userInfoProvider).notificationBlockGroup;
    final List<String?> blockUserNameList = blockList?.list?.map((blockUser) => blockUser.userName).toList() ?? [];
    sortedUsers.removeWhere((user) => blockUserNameList.contains(user.userName));

    return sortedUsers;
  }

  Future<void> checkNetWorkTime() async {
    final DateTime sendingTime = DateTime.now();
    try {
      await DioUtil(baseUrl: AppConfig.baseUri).get(CommEndpoint.checkAliveAndNetWorkSpeed);
    } catch (e) {
      print(e);
    }
    final DateTime responseTime = DateTime.now();
    /// 計算網路傳輸時間
    final Duration resultTime = responseTime.difference(sendingTime);
    onNetworkTime(resultTime.inMilliseconds);
  }

  String formatDateTime(DateTime dateTime) {
    DateTime now = DateTime.now();
    DateTime beginningOfWeek = now.subtract(Duration(days: now.weekday - 1));
    DateTime endOfWeek = beginningOfWeek.add(const Duration(days: 6));

    if (dateTime.year == now.year &&
        dateTime.month == now.month &&
        dateTime.day == now.day) {
      // 同一天
      return '今天';
    } else if (dateTime.isAfter(beginningOfWeek) &&
        dateTime.isBefore(endOfWeek)) {
      // 同一週
      List<String> weekdays = ['一', '二', '三', '四', '五', '六', '日'];
      return '星期${weekdays[dateTime.weekday - 1]}';
    } else {
      // 不同週
      return '${dateTime.month}/${dateTime.day}';
    }
  }

  bool isWithin7Days(int regTime) {
    DateTime dateTime1 = DateTime.fromMillisecondsSinceEpoch(regTime);
    DateTime dateTime2 = DateTime.now();

    Duration difference = dateTime1.difference(dateTime2);
    return difference.inDays.abs() < 7;
  }

  //檢查麥克風、鏡頭使用權限（語音通話只需要mic，視訊通話需要mic camera）
  Future<bool> _checkPermission(int? type) async {
    bool isMicPermission = await PermissionUtil.checkAndRequestMicrophonePermission();
    bool isCamPermission = false;
    if(type == 2){
      isCamPermission = await PermissionUtil.checkAndRequestCameraPermission();
    }
    //語音通話:1/ 視訊通話:2
    if(type == 1){
      return isMicPermission;
    }else{
      if(isMicPermission==false || isCamPermission == false){
        return false;
      }else{
        return true;
      }
    }
  }

}
