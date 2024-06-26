// import 'dart:async';
// import 'dart:convert';
// import 'dart:ui';
//
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_image_compress/flutter_image_compress.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:frechat/models/certification_model.dart';
// import 'package:frechat/models/ws_req/account/ws_account_call_verification_req.dart';
// import 'package:frechat/models/ws_req/account/ws_account_get_rtc_token_req.dart';
// import 'package:frechat/models/ws_req/account/ws_account_speak_req.dart';
// import 'package:frechat/models/ws_req/notification/ws_notification_search_intimacy_level_info_req.dart';
// import 'package:frechat/models/ws_req/member/ws_member_info_req.dart';
// import 'package:frechat/models/ws_res/account/ws_account_call_package_res.dart';
// import 'package:frechat/models/ws_res/account/ws_account_call_verification_res.dart';
// import 'package:frechat/models/ws_res/account/ws_account_get_gift_detail_res.dart';
// import 'package:frechat/models/ws_res/account/ws_account_get_rtc_token_res.dart';
// import 'package:frechat/models/ws_res/account/ws_account_official_message_res.dart';
// import 'package:frechat/models/ws_res/account/ws_account_speak_res.dart';
// import 'package:frechat/models/ws_res/member/ws_member_info_res.dart';
// import 'package:frechat/models/ws_res/notification/ws_notification_block_group_res.dart';
// import 'package:frechat/models/ws_res/notification/ws_notification_search_intimacy_level_info_res.dart';
// import 'package:frechat/models/ws_res/notification/ws_notification_search_list_res.dart';
// import 'package:frechat/models/ws_res/setting/ws_setting_charm_achievement_res.dart';
// import 'package:frechat/screens/gift_and_bag/gift_and_bag.dart';
// import 'package:frechat/screens/intimacy_dialog.dart';
// import 'package:frechat/system/app_config/app_config.dart';
// import 'package:frechat/system/base_view_model.dart';
// import 'package:frechat/system/call_back_function.dart';
// import 'package:frechat/system/comm/comm_endpoints.dart';
// import 'package:frechat/system/constant/enum.dart';
// import 'package:frechat/system/database/model/chat_audio_model.dart';
// import 'package:frechat/system/database/model/chat_gift_model.dart';
// import 'package:frechat/system/database/model/chat_image_model.dart';
// import 'package:frechat/system/database/model/chat_message_model.dart';
// import 'package:frechat/system/database/model/chat_user_model.dart';
// import 'package:frechat/system/extension/json.dart';
// import 'package:frechat/system/global/shared_preferance.dart';
// import 'package:frechat/system/network_status/network_status_setting.dart';
// import 'package:frechat/system/provider/chat_Gift_model_provider.dart';
// import 'package:frechat/system/provider/chat_audio_model_provider.dart';
// import 'package:frechat/system/provider/chat_image_model_provider.dart';
// import 'package:frechat/system/provider/chat_message_model_provider.dart';
// import 'package:frechat/system/provider/chat_user_model_provider.dart';
// import 'package:frechat/system/provider/user_info_provider.dart';
// import 'package:frechat/system/providers.dart';
// import 'package:frechat/system/repository/http_manager.dart';
// import 'package:frechat/system/repository/http_setting.dart';
// import 'package:frechat/system/repository/response_code.dart';
// import 'package:frechat/system/util/audio_util.dart';
// import 'package:frechat/system/util/image_picker_util.dart';
// import 'package:frechat/system/util/permission_util.dart';
// import 'package:frechat/system/util/recharge_util.dart';
// import 'package:frechat/system/util/svga_player_util.dart';
// import 'package:frechat/system/zego_call/interal/zim/zim_service_defines.dart';
// import 'package:frechat/system/zego_call/model/review_audio_res.dart';
// import 'package:frechat/system/zego_call/zego_callback.dart';
// import 'package:frechat/system/zego_call/zego_provider.dart';
// import 'package:frechat/widgets/shared/bottom_sheet/common_bottom_sheet.dart';
// import 'package:frechat/widgets/shared/dialog/base_dialog.dart';
// import 'package:frechat/widgets/shared/dialog/comm_dialog.dart';
// import 'package:frechat/widgets/theme/app_theme.dart';
// import 'package:frechat/widgets/theme/original/app_colors.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:path/path.dart' as path;
// import 'package:uuid/uuid.dart';
// import 'package:svgaplayer_flutter/svgaplayer_flutter.dart';
//
// /// 舊版
// class ChatRoomViewModel {
//   WidgetRef ref;
//   ViewChange? setState;
//   BuildContext context;
//   TickerProvider? tickerProvider;
//
//   ChatRoomViewModel({required this.ref, this.setState, required this.context, this.tickerProvider}){
//     getNowIntimacy();
//   }
//
//   WsMemberInfoRes? memberInfoRes;
//   List<String> commonLanguageList = [];
//   XFile? xFile;
//   TextEditingController? textEditingController;
//   List<ZIMMessage> zimMessageList = [];
//   ZIMMessageQueriedResult? zimMessageQueriedResult;
//   String nickName = '';
//   String userName = '';
//   late ZegoCallBack callback;
//   final ScrollController scrollController = ScrollController();
//   bool messageLoading = true;
//   bool commonLanguageLoading = true;
//   late Timer timer;
//   int seconds = 0;
//
//   Timer? recordingTimer; // 錄音計時器
//   int recordingSeconds = 0; // 錄音時間
//
//   // String recordingTime = "0:00";
//   TextStyle? style;
//   String textFiledHint = "请输入消息";
//   // bool isRecordingFinish = false;
//   num? userId;
//   String resultCodeCheck = '';
//   String showSvgaUrl = '';
//   num cohesionPoints = 0;
//   num cohesionLevel = 0;
//   String imagePath = '';
//   Color? cohesionColor;
//   static SVGAAnimationController? animationController;
//   int nowIntimacy = 1;
//   num nextLevelSubtract = 0;
//   String nextRelationShip = '';
//   Map pointsRuleMap = {};
//   bool isCohesionLoading = true;
//   bool isLoading = true;
//   String cohesionImagePath = '';
//   List<Color> intimacyLevelBgColor = [];
//   List<String> timeDistinctionList = [];
//   bool needShowCharmCharge = false;
//   String textCharge = '';
//   late Timer sendMsgLimitTimer;
//   bool isOnSendMsgLimitTime = false;
//   String oppositeUserName = '';
//   AnimationController? expandController;
//   Animation? heightAnimation;
//   num? osType = 1; // 手机系统(0:苹果 1:安卓)
//
//   init(num points, num level,String userName) {
//     textEditingController = TextEditingController();
//     nickName = ref.read(userInfoProvider).memberInfo?.nickName ?? '';
//     this.userName = ref.read(userInfoProvider).memberInfo?.userName ?? '';
//     userId = ref.read(userInfoProvider).userId;
//     callback = ref.read(zegoCallBackProvider);
//     // callback = ZegoCallBack(context, ref);
//     ref.read(chatMessageModelNotifierProvider.notifier).loadDataFromSql();
//     ref.read(chatImageModelNotifierProvider.notifier).loadDataFromSql();
//     ref.read(chatAudioModelNotifierProvider.notifier).loadDataFromSql();
//     ref.read(chatGiftModelNotifierProvider.notifier).loadDataFromSql();
//     cohesionPoints = points;
//     cohesionLevel = level;
//     oppositeUserName = userName;
//   }
//
//   dispose() {
//     expandController?.dispose();
//     expandController == null;
//   }
//
//
//   /// ---監聽訊息---
//   listenerZimCallBack() {
//     final zimService = ref.read(zimServiceProvider);
//     zimService.receivePeerMessageListener(
//         onReceiveTextMessage: (sendingUser, zimTextMessage) async {
//           final bool isChatRoom = ref.read(userInfoProvider).currentPage == 1;
//           Map<String, dynamic> messageDataMap = {};
//           Map<String, dynamic> extendedDataMap = {};
//           try {
//             messageDataMap = json.tryDecode(zimTextMessage.message);
//             extendedDataMap = json.tryDecode(zimTextMessage.extendedData);
//             String uuid = messageDataMap['uuid'];
//
//             /// 通話紀錄decode
//             String chatContent = '';
//             bool isCallHistoryType = false;
//             OfficialMessageInfo? officialMessageInfo;
//             try {
//               final WsAccountOfficialMessageRes content = WsAccountOfficialMessageRes.fromJson(messageDataMap['content']);
//               officialMessageInfo = OfficialMessageInfo.fromJson(content.message);
//               // chatContent = '通话时长: ${officialMessageInfo.duration}s';
//               chatContent = json.encode(officialMessageInfo);
//               isCallHistoryType = true;
//             } catch (e) {
//               chatContent = messageDataMap['content'].toString();
//             }
//
//             int expireTime = extendedDataMap['expireTime'] ?? 0;
//             int halfTime = extendedDataMap['halfTime'] ?? 0;
//             num points = extendedDataMap['points'] ?? 0;
//             int incomeflag = extendedDataMap['incomeflag'] ?? 0;
//             if (chatContent.contains('[礼物]')) {
//               String giftCategoryName = extendedDataMap['giftCategoryName'];
//               String giftName = extendedDataMap['giftName'];
//               String giftId = extendedDataMap['giftId'];
//               num coins = extendedDataMap['coins'];
//               num svgaFileId = extendedDataMap['svgaFileId'];
//               num giftSendAmount = extendedDataMap['giftSendAmount'];
//               String svgaUrl = extendedDataMap['svgaUrl'];
//               String giftImageUrl = extendedDataMap['giftUrl'];
//               num expireDuration = extendedDataMap['expireDuration'];
//               num halfDuration = extendedDataMap['halfDuration'];
//               ref.read(chatMessageModelNotifierProvider.notifier).setDataToSql(chatMessageModelList: [
//                 // ChatMessageModel(
//                 //     messageUuid: uuid, senderName: zimTextMessage.senderUserID, receiverName: ref.read(userInfoProvider).memberInfo?.userName,
//                 //     content: chatContent, timeStamp: zimTextMessage.timestamp, expireTime: expireTime, halfTime: halfTime,
//                 //     points: points, incomeflag: incomeflag, type: 3)]);
//                 ChatMessageModel(
//                     messageUuid: uuid, senderName: zimTextMessage.senderUserID, receiverName: ref.read(userInfoProvider).memberInfo?.userName,
//                     content: chatContent, timeStamp: zimTextMessage.timestamp, expireTime: expireTime, halfTime: halfTime,
//                     points: points, incomeflag: incomeflag, type: 3, expireDuration: expireDuration, halfDuration: halfDuration,reviewStatus: 0)]);
//               if(isChatRoom){
//                 final allChatUserModelList = ref.watch(chatUserModelNotifierProvider);
//                 final targetChatUserModelList = allChatUserModelList.where((info) => info.userName == sendingUser).toList();
//                 ChatUserModel chatUserModel = targetChatUserModelList[0];
//                 ref.read(chatUserModelNotifierProvider.notifier).setDataToSql(chatUserModelList: [
//                   ChatUserModel(userId: chatUserModel.userId, roomIcon: chatUserModel.roomIcon, cohesionLevel: chatUserModel.cohesionLevel, userCount: chatUserModel.userCount,
//                       isOnline: chatUserModel.isOnline, userName: chatUserModel.userName, roomId: chatUserModel.roomId, roomName: chatUserModel.roomName,
//                       points: chatUserModel.points, remark: chatUserModel.remark, unRead: chatUserModel.unRead, recentlyMessage: chatContent, timeStamp: zimTextMessage.timestamp, pinTop: 0)]);
//               }
//               ref.read(chatGiftModelNotifierProvider.notifier).setDataToSql(chatGiftModelList: [
//                 ChatGiftModel(
//                     messageUuid: uuid, senderName: zimTextMessage.senderUserID, receiverName: ref.read(userInfoProvider).memberInfo?.userName, giftCategoryName: giftCategoryName, giftName: giftName, giftId: int.parse(giftId), coins: coins, giftImageUrl: giftImageUrl, giftSendAmount: giftSendAmount,
//                     svgaFileId: svgaFileId, svgaUrl: svgaUrl, isShowSvga: 0, timeStamp: zimTextMessage.timestamp)]);
//
//               /// 收到的禮物接收者與正在當前房間才會有效果
//               final String? currentChatUser = ref.read(userInfoProvider).currentChatUser;
//               if(currentChatUser == zimTextMessage.senderUserID) {
//                 SvgaPlayerUtil.loadAnimation(HttpSetting.baseImagePath + svgaUrl);
//               }
//             } else if(messageDataMap['type'] == 9) {
//               _receiveAudioMsg(zimTextMessage: zimTextMessage, sendingUser: sendingUser);
//             } else {
//               /// 寫入通話到資料庫
//               num expireDuration = extendedDataMap['expireDuration']??0;
//               num halfDuration = extendedDataMap['halfDuration']??0;
//               if(isCallHistoryType && officialMessageInfo != null) {
//                 ref.read(chatMessageModelNotifierProvider.notifier).setDataToSql(chatMessageModelList: [
//                   // ChatMessageModel(
//                   //     messageUuid: uuid, senderName: officialMessageInfo.caller, receiverName: officialMessageInfo.answer, content: chatContent,
//                   //     timeStamp: zimTextMessage.timestamp, expireTime: expireTime, halfTime: halfTime, points: officialMessageInfo.points, incomeflag: incomeflag, type: 0)]);
//
//                   ChatMessageModel(
//                       messageUuid: uuid, senderName: officialMessageInfo.caller, receiverName: officialMessageInfo.answer, content: chatContent,
//                       timeStamp: zimTextMessage.timestamp, expireTime: expireTime, halfTime: halfTime, points: officialMessageInfo.points, incomeflag: incomeflag, type: 0, expireDuration: expireDuration, halfDuration: halfDuration,reviewStatus: 0)]);
//                 return ;
//               }
//
//               final String receiverName = _getReceiverName(zimTextMessage);
//
//               ref.read(chatMessageModelNotifierProvider.notifier).setDataToSql(chatMessageModelList: [
//                 ChatMessageModel(
//                     messageUuid: uuid, senderName: zimTextMessage.senderUserID, receiverName: receiverName, content: chatContent,
//                     timeStamp: zimTextMessage.timestamp, expireTime: expireTime, halfTime: halfTime, points: points, incomeflag: incomeflag, type: 0, expireDuration: expireDuration, halfDuration: halfDuration,reviewStatus: 0)
//               ]);
//               if(isChatRoom){
//                 final allChatUserModelList = ref.watch(chatUserModelNotifierProvider);
//                 final targetChatUserModelList = allChatUserModelList.where((info) => info.userName == sendingUser).toList();
//                 ChatUserModel chatUserModel = targetChatUserModelList[0];
//                 ref.read(chatUserModelNotifierProvider.notifier).setDataToSql(chatUserModelList: [
//                   ChatUserModel(userId: chatUserModel.userId, roomIcon: chatUserModel.roomIcon, cohesionLevel: chatUserModel.cohesionLevel, userCount: chatUserModel.userCount,
//                       isOnline: chatUserModel.isOnline, userName: chatUserModel.userName, roomId: chatUserModel.roomId, roomName: chatUserModel.roomName, points: chatUserModel.points,
//                       remark: chatUserModel.remark, unRead: chatUserModel.unRead, recentlyMessage: chatContent, timeStamp: zimTextMessage.timestamp, pinTop: 0)]);
//               }
//             }
//           } on FormatException {
//             debugPrint('The info.extendedData is not valid JSON');
//           }
//         }, onReceiveImageMessage: (sendingUser, zimImageMessage) {
//
//       final bool isChatRoom = ref.read(userInfoProvider).currentPage == 1;
//       Map<String, dynamic> extendedDataMap = {};
//       try {
//         extendedDataMap = json.decode(zimImageMessage.extendedData) as Map<String, dynamic>;
//         int expireTime = extendedDataMap['expireTime'] ?? 0;
//         int halfTime = extendedDataMap['halfTime'] ?? 0;
//         num points = extendedDataMap['points'] ?? 0;
//         int incomeflag = extendedDataMap['incomeflag'] ?? 0;
//         String uuid = extendedDataMap['uuid'];
//         num expireDuration = extendedDataMap['expireDuration'] ?? 0;
//         num halfDuration = extendedDataMap['halfDuration'] ?? 0;
//
//         final String receiverName = _getReceiverName(zimImageMessage);
//         ref.read(chatMessageModelNotifierProvider.notifier).setDataToSql(chatMessageModelList: [
//           // ChatMessageModel(messageUuid: uuid, senderName: zimImageMessage.senderUserID, receiverName: ref.read(userInfoProvider).memberInfo?.userName, content: '[图片]',
//           //     timeStamp: zimImageMessage.timestamp, expireTime: expireTime, halfTime: halfTime, points: points, incomeflag: incomeflag, type: 1)]);
//           ChatMessageModel(messageUuid: uuid, senderName: zimImageMessage.senderUserID, receiverName: receiverName, content: '[图片]',
//               timeStamp: zimImageMessage.timestamp, expireTime: expireTime, halfTime: halfTime, points: points, incomeflag: incomeflag, type: 1, expireDuration: expireDuration, halfDuration: halfDuration,reviewStatus: 0)]);
//         ref.read(chatImageModelNotifierProvider.notifier).setDataToSql(chatImageModelList: [
//           ChatImageModel(messageUuid: uuid, senderName: zimImageMessage.senderUserID, receiverName: ref.read(userInfoProvider).memberInfo?.userName,
//             imagePath: zimImageMessage.fileDownloadUrl, timeStamp: zimImageMessage.timestamp,)]);
//
//         if(isChatRoom){
//           final allChatUserModelList = ref.watch(chatUserModelNotifierProvider);
//           final targetChatUserModelList = allChatUserModelList.where((info) => info.userName == sendingUser).toList();
//           ChatUserModel chatUserModel = targetChatUserModelList[0];
//           ref.read(chatUserModelNotifierProvider.notifier).setDataToSql(chatUserModelList: [
//             ChatUserModel(userId: chatUserModel.userId, roomIcon: chatUserModel.roomIcon, cohesionLevel: chatUserModel.cohesionLevel, userCount: chatUserModel.userCount,
//                 isOnline: chatUserModel.isOnline, userName: chatUserModel.userName, roomId: chatUserModel.roomId, roomName: chatUserModel.roomName, points: chatUserModel.points,
//                 remark: chatUserModel.remark, unRead: chatUserModel.unRead, recentlyMessage: '[图片]', timeStamp: zimImageMessage.timestamp, pinTop: 0)]);
//         }
//       } on FormatException {
//         debugPrint('The info.extendedData is not valid JSON');
//       }
//     }, onReceiveFileMessage: (sendingUser, zimFileMessage) {
//       final bool isChatRoom = ref.read(userInfoProvider).currentPage == 1;
//       Map<String, dynamic> extendedDataMap = {};
//       try {
//         final String receiverName = _getReceiverName(zimFileMessage);
//
//         extendedDataMap = json.decode(zimFileMessage!.extendedData) as Map<String, dynamic>;
//         int expireTime = extendedDataMap['expireTime'] ?? 0;
//         int halfTime = extendedDataMap['halfTime'] ?? 0;
//         num points = extendedDataMap['points'] ?? 0;
//         int incomeFlag = extendedDataMap['incomeflag'] ?? 0;
//         String uuid = extendedDataMap['uuid'] ?? '';
//         String senderName = zimFileMessage.senderUserID;
//         int timeStamp = zimFileMessage.timestamp;
//
//         ///TODO 影響招呼語取得時間
//         num audioTime = 0;
//         if(extendedDataMap['chatContent'] !=null){
//           Map<String, dynamic> chatContent = extendedDataMap['chatContent'];
//           audioTime = chatContent['audioTime'] ?? 0;
//         }
//         final num audioType = 2;
//
//         final msgModel = ChatMessageModel(
//             messageUuid: uuid,
//             senderName: senderName,
//             receiverName: receiverName,
//             content: '[录音]',
//             timeStamp: timeStamp,
//             expireTime: expireTime,
//             halfTime: halfTime,
//             points: points,
//             incomeflag: incomeFlag,
//             type: 2,
//             unRead: 0,
//             reviewStatus: 0);
//         final audioModel = ChatAudioModel(
//           messageUuid: uuid,
//           senderName: senderName,
//           receiverName: ref.read(userInfoProvider).memberInfo?.userName,
//           audioPath: zimFileMessage.fileDownloadUrl,
//           timeStamp: audioTime,
//         );
//
//         ref.read(chatMessageModelNotifierProvider.notifier).setDataToSql(chatMessageModelList: [msgModel]);
//         ref.read(chatAudioModelNotifierProvider.notifier).setDataToSql(chatAudioModelList: [audioModel]);
//         if(isChatRoom){
//           final allChatUserModelList = ref.watch(chatUserModelNotifierProvider);
//           final targetChatUserModelList = allChatUserModelList.where((info) => info.userName == sendingUser).toList();
//           ChatUserModel chatUserModel = targetChatUserModelList[0];
//           final userModel = ChatUserModel(userId: chatUserModel.userId,
//               roomIcon: chatUserModel.roomIcon,
//               cohesionLevel: chatUserModel.cohesionLevel,
//               userCount: chatUserModel.userCount,
//               isOnline: chatUserModel.isOnline,
//               userName: chatUserModel.userName,
//               roomId: chatUserModel.roomId,
//               roomName: chatUserModel.roomName,
//               points: chatUserModel.points,
//               remark: chatUserModel.remark,
//               unRead: chatUserModel.unRead,
//               recentlyMessage: '[录音]',
//               timeStamp: timeStamp,
//               pinTop: 0);
//           ref.read(chatUserModelNotifierProvider.notifier).setDataToSql(chatUserModelList: [userModel]);
//         }
//
//       } on FormatException{
//         debugPrint('The info.extendedData is not valid JSON');
//       }
//
//
//       // _receiveAudioMsg();
//     }, onAnotherHaveReadMessage: (zimMessageReceiptInfo) {
//       final bool isChatRoom = ref.read(userInfoProvider).isInChatroom ?? false;
//       final String currentChatUser = ref.read(userInfoProvider).currentChatUser ?? '';
//       ///确认聊天室是否存在
//       if(isChatRoom && currentChatUser == zimMessageReceiptInfo.first.conversationID){
//         final oppositeUserName = zimMessageReceiptInfo.first.conversationID;
//         zimService.clearAllUnReadMessage(conversationID: oppositeUserName);
//         final allChatUserModel = ref.watch(chatUserModelNotifierProvider);
//         final list = allChatUserModel.where((info) => info.userName == oppositeUserName).toList();
//         ChatUserModel chatUserModel = list[0];
//         ref.read(chatUserModelNotifierProvider.notifier).setDataToSql(chatUserModelList: [
//           ChatUserModel(userId: chatUserModel.userId, roomIcon: chatUserModel.roomIcon, cohesionLevel: chatUserModel.cohesionLevel, userCount: chatUserModel.userCount, isOnline: chatUserModel.isOnline,
//               userName: chatUserModel.userName, roomId: chatUserModel.roomId, roomName: chatUserModel.roomName, points: chatUserModel.points, remark: chatUserModel.remark, unRead: 0,
//               recentlyMessage: chatUserModel.recentlyMessage, timeStamp: DateTime.now().millisecondsSinceEpoch, pinTop: 0)]);
//         final allChatMessageModelList = ref.watch(chatMessageModelNotifierProvider);
//         final mySendChatMessagelist = allChatMessageModelList.where((info) => info.senderName == ref.read(userInfoProvider).memberInfo?.userName && info.receiverName == oppositeUserName).toList();
//         final oppoSiteSendChatMessagelist = allChatMessageModelList.where((info) => info.senderName == oppositeUserName && info.receiverName == ref.read(userInfoProvider).memberInfo?.userName).toList();
//         final List<ChatMessageModel> mergedList = [...mySendChatMessagelist, ...oppoSiteSendChatMessagelist];
//         final List<ChatMessageModel> resultList = mergedList.map((model) => model.copyWith(unRead: 1)).toList();
//         ref.read(chatMessageModelNotifierProvider.notifier).setDataToSql(chatMessageModelList: resultList);
//       }
//     },
//         onConversationListChanged: (zimConversationChangeListInfo) {
//
//           final bool isChatRoom = ref.read(userInfoProvider).isInChatroom ?? false;
//           ///确认聊天室是否存在
//           if(isChatRoom){
//             zimService.receiveMessage(conversationID: zimConversationChangeListInfo.first.conversation!.conversationID);
//           }
//         },
//         onTotalUnReadMessage: (totalUnReadMsg) {
//
//         });
//   }
//
//
//   /// ---訊息相關---
//
//   //傳送文字
//   Future<void> sendTextMessage({SearchListInfo? searchListInfo, String? text, int? contentType, bool isStrikeUp=false, num? unRead}) async {
//     if (textEditingController != null) {
//       textEditingController!.clear();
//     }
//     if (isOnSendMsgLimitTime) {
//       return;
//     }
//     startSendMsgLimitTimer();
//
//     String replyUuid = replyUUid(searchListInfo!);
//     int isReplyPickup = checkIsReplyPickup();
//     await send(searchListInfo: searchListInfo, contentType: 0, chatContent: text!, flag: "0", replyUuid: replyUuid, giftId: '', giftAmount: '',
//         giftUrl: '', giftName: '', svgaFileId: 0, svgaUrl: '', coins: 0, giftCategoryName: '', giftSendAmount: 0, isStrikeUp :isStrikeUp,
//         isReplyPickup: isReplyPickup, unRead: 0);
//   }
//
//   //傳送圖片
//   Future<void> sendImageMessage({SearchListInfo? searchListInfo, num? unRead, int? contentType, bool isStrikeUp=false, String? imgUrl}) async {
//     if (imgUrl == null) {
//       xFile = await ImagePickerUtil.selectImage(needSaveImage: true);
//     } else {
//       xFile = await DioUtil.getUrlAsXFile(HttpSetting.baseImagePath + imgUrl);
//     }
//     String replyUuid = replyUUid(searchListInfo!);
//     int isReplyPickup = checkIsReplyPickup();
//     await send(
//         searchListInfo: searchListInfo,
//         contentType: 1,
//         chatContent: '',
//         flag: "0",
//         replyUuid: replyUuid,
//         giftId: '',
//         giftAmount: '',
//         giftUrl: '',
//         giftName: '',
//         coins: 0,
//         giftCategoryName: '',
//         svgaFileId: 0,
//         svgaUrl: '',
//         giftSendAmount: 0,
//         isStrikeUp: isStrikeUp,
//         isReplyPickup: isReplyPickup,
//         unRead: 0);
//   }
//
//   //傳送錄音
//   Future<void> sendVoiceMessage({SearchListInfo? searchListInfo, num? unRead, int? contentType, bool isStrikeUp = false, String? voiceUrl,num? voicTime}) async {
//     if (voiceUrl != null) {
//       final XFile? xFile = await DioUtil.getUrlAsXFile(HttpSetting.baseImagePath + voiceUrl);
//       AudioUtils.filePath = xFile!.path;
//     }
//     String replyUuid = replyUUid(searchListInfo!);
//     int isReplyPickup = checkIsReplyPickup();
//     num audioTime;
//     if(voicTime !=null){
//       audioTime = voicTime;
//     }else{
//       Duration? audioTimeDuration = await AudioUtils.getAudioTime( audioUrl: AudioUtils.filePath!, addBaseImagePath: false);
//       audioTime = audioTimeDuration!.inMilliseconds;
//     }
//     final chatContent = jsonEncode({
//       'audioTime': audioTime,
//     });
//     await send( searchListInfo: searchListInfo, contentType: 9, chatContent: chatContent, flag: "0", replyUuid: replyUuid, giftId: '', giftAmount: '', giftUrl: '',
//         giftName: '', coins: 0, giftCategoryName: '', svgaFileId: 0, svgaUrl: '', giftSendAmount: 0, unRead: 0, isReplyPickup:isReplyPickup,
//         isStrikeUp: isStrikeUp);
//
//   }
//
//
//   //傳送禮物
//   Future<void> sendGiftMessage({SearchListInfo? searchListInfo, num? unRead, bool isStrikeUp = false, Map<String,dynamic>? giftResult })async{
//     dynamic gift;
//     String svgaUrl = '';
//     String giftCategoryName = '';
//     num svgaFileId = 0;
//     int type = 4;
//     if (giftResult?['gift'] is GiftListInfo) {
//       gift = giftResult?['gift'] as GiftListInfo;
//       if (gift.svgaUrl == null) {
//         svgaUrl = '';
//         svgaFileId = 0;
//         // BaseViewModel.showToast(context, "親～這個沒有SVGA歐，不是App端Bug~");
//       } else {
//         svgaUrl = gift.svgaUrl;
//         svgaFileId = gift.svgaFileId;
//       }
//       giftCategoryName = gift.categoryName;
//     } else {
//       gift = giftResult?['gift'] as FreBackPackListInfo;
//       svgaUrl = gift.svgaUrl ?? '';
//       svgaFileId = gift.svgaFileId ?? 0;
//       giftCategoryName = 'bag';
//       type = 5;
//     }
//     String replyUuid = replyUUid(searchListInfo!);
//     int isReplyPickup = checkIsReplyPickup();
//     send(
//         contentType: type,
//         chatContent: '[礼物]',
//         flag: "0",
//         replyUuid: replyUuid,
//         giftId: gift.giftId.toString(),
//         giftAmount: giftResult?['giveGiftNum'],
//         giftUrl: gift.giftImageUrl,
//         giftName: gift.giftName,
//         coins: gift.coins,
//         giftCategoryName: giftCategoryName,
//         giftSendAmount: int.parse(giftResult?['giveGiftNum']),
//         searchListInfo: searchListInfo,
//         unRead: unRead ?? 0,
//         svgaFileId: svgaFileId,
//         isReplyPickup: isReplyPickup,
//         svgaUrl: svgaUrl);
//   }
//
//
//   void startSendMsgLimitTimer() {
//     seconds = 0;
//     isOnSendMsgLimitTime = true;
//     const oneSec = Duration(seconds: 1);
//     sendMsgLimitTimer = Timer.periodic(oneSec, (Timer timer) {
//       sendMsgLimitTimer.cancel();
//       isOnSendMsgLimitTime = false;
//     });
//   }
//
//   //已讀所有訊息
//   void readAllMessage(String oppositeUserName) {
//     final zimService = ref.read(zimServiceProvider);
//     zimService.clearAllUnReadMessage(conversationID: oppositeUserName);
//     zimService.receiveMessage(conversationID: oppositeUserName);
//     final allChatUserModelList = ref.read(chatUserModelNotifierProvider);
//     final resultList = allChatUserModelList.where((info) => info.userName == memberInfoRes?.userName).toList();
//     final list = allChatUserModelList.where((info) => info.userName == 'java_system').toList();
//     if(resultList.isNotEmpty){
//       ChatUserModel chatUserModel = resultList[0];
//       ref.read(chatUserModelNotifierProvider.notifier).setDataToSql(chatUserModelList: [
//         ChatUserModel(userId: chatUserModel.userId, roomIcon: memberInfoRes!.avatarPath, cohesionLevel: chatUserModel.cohesionLevel, userCount: chatUserModel.userCount,
//             isOnline: chatUserModel.isOnline, userName: chatUserModel.userName, roomId: chatUserModel.roomId, roomName: chatUserModel.roomName, points: chatUserModel.points,
//             remark: chatUserModel.remark, unRead: 0, recentlyMessage: chatUserModel.recentlyMessage, timeStamp: chatUserModel.timeStamp, pinTop: chatUserModel.pinTop, charmCharge: memberInfoRes!.charmCharge)]);
//     }
//     if(oppositeUserName == 'java_system'){
//       if(list.isNotEmpty){
//         ChatUserModel chatUserModel = list[0];
//         ref.read(chatUserModelNotifierProvider.notifier).setDataToSql(chatUserModelList: [
//           ChatUserModel(userId: chatUserModel.userId, roomIcon: chatUserModel.roomIcon, cohesionLevel: chatUserModel.cohesionLevel, userCount: chatUserModel.userCount,
//               isOnline: chatUserModel.isOnline, userName: chatUserModel.userName, roomId: chatUserModel.roomId, roomName: chatUserModel.roomName, points: chatUserModel.points,
//               remark: chatUserModel.remark, unRead:0 , recentlyMessage: chatUserModel.recentlyMessage, timeStamp: chatUserModel.timeStamp, pinTop: chatUserModel.pinTop)]);
//       }
//     }
//   }
//
//   //取得聊天歷史資料
//   Future<void> getHistoryMessage(String oppositeUserName, {required SearchListInfo searchListInfo}) async {
//     final zimService = ref.read(zimServiceProvider);
//     final bool messageListIsEmpty = zimMessageQueriedResult?.messageList.isEmpty ?? true;
//     final ZIMMessageQueriedResult history = await zimService.searchHistoryMessageFromUserName(
//         conversationID: oppositeUserName,
//         nextMessage: messageListIsEmpty ? null : zimMessageQueriedResult?.messageList.first // _getFirstZimMsg(searchListInfo)
//     );
//     /// 過濾掉傳送失敗的訊息
//     // history.messageList.removeWhere((msg) => msg.sentStatus == ZIMMessageSentStatus.failed);
//     if(zimMessageQueriedResult == null) {
//       zimMessageQueriedResult = history;
//     } else {
//       zimMessageQueriedResult?.messageList.insertAll(0, history.messageList);
//       tidyMessage(oppositeUserName);
//     }
//   }
//
//   //整理訊息
//   void tidyMessage(String oppositeUserName) async {
//     final allChatUserModel = ref.read(chatUserModelNotifierProvider);
//     final list = allChatUserModel.where((info) => info.userName == oppositeUserName).toList();
//     final List<ZIMMessage> messageList = zimMessageQueriedResult?.messageList ?? [];
//     if (list.isNotEmpty) {
//       for (int i = 0; i < messageList.length; i++) {
//         ZIMMessage zimMessage = messageList[i];
//         zimMessageList.add(zimMessage);
//       }
//       insertDB(oppositeUserName);
//     }
//     timeDistinctionList.clear();
//     setState!(() {
//       messageLoading = false;
//     });
//   }
//
//   //將ChatMessageModel 轉成 ZIMMessage
//   ZIMMessage transferToZimMessage(ChatMessageModel chatMessageModel, bool isShowGiftSvga) {
//
//     switch (chatMessageModel.type) {
//     ///文字
//       case 0:
//         String content = jsonEncode({
//           'uuid': chatMessageModel.messageUuid,
//           'type': 0,
//           'gift_id': '',
//           'gift_count': '',
//           'gift_url': '',
//           'gift_name': '',
//           'content': chatMessageModel.content
//         });
//         String extendedData = jsonEncode({
//           'remainCoins': chatMessageModel.remainCoins,
//           'expireTime': chatMessageModel.expireTime,
//           'halfTime': chatMessageModel.halfTime,
//           'points': chatMessageModel.points,
//           'incomeflag': chatMessageModel.incomeflag,
//           'uuid': chatMessageModel.messageUuid,
//           'expireDuration': chatMessageModel.expireDuration,
//           'halfDuration': chatMessageModel.halfDuration,
//         });
//
//         ZIMTextMessage zimTextMessage = ZIMTextMessage(message: content);
//         zimTextMessage.type = ZIMMessageType.text;
//         zimTextMessage.timestamp = chatMessageModel.timeStamp!.toInt();
//         zimTextMessage.senderUserID = chatMessageModel.senderName!;
//         zimTextMessage.conversationID = chatMessageModel.receiverName!;
//         zimTextMessage.extendedData = extendedData;
//         if (chatMessageModel.unRead == 0) {
//           zimTextMessage.receiptStatus = ZIMMessageReceiptStatus.processing;
//         } else {
//           zimTextMessage.receiptStatus = ZIMMessageReceiptStatus.done;
//         }
//         return zimTextMessage;
//
//     ///圖片
//       case 1:
//         final DBHistoryImageModel = ref.read(chatImageModelNotifierProvider);
//         final list = DBHistoryImageModel.where(
//                 (info) => info.messageUuid == chatMessageModel.messageUuid)
//             .toList();
//         String extendedData = jsonEncode({
//           'remainCoins': chatMessageModel.remainCoins,
//           'expireTime': chatMessageModel.expireTime,
//           'halfTime': chatMessageModel.halfTime,
//           'points': chatMessageModel.points,
//           'incomeflag': chatMessageModel.incomeflag,
//           'uuid': chatMessageModel.messageUuid,
//           'expireDuration': chatMessageModel.expireDuration,
//           'halfDuration': chatMessageModel.halfDuration
//         });
//         if(list.isNotEmpty){
//           ZIMImageMessage zimImageMessage = ZIMImageMessage(list[0].imagePath!);
//           zimImageMessage.fileDownloadUrl = list[0].imagePath!;
//           zimImageMessage.type = ZIMMessageType.image;
//           zimImageMessage.timestamp = chatMessageModel.timeStamp!.toInt();
//           zimImageMessage.senderUserID = chatMessageModel.senderName!;
//           zimImageMessage.conversationID = chatMessageModel.receiverName!;
//           zimImageMessage.extendedData = extendedData;
//           if (chatMessageModel.unRead == 0) {
//             zimImageMessage.receiptStatus = ZIMMessageReceiptStatus.processing;
//           } else {
//             zimImageMessage.receiptStatus = ZIMMessageReceiptStatus.done;
//           }
//           return zimImageMessage;
//         }
//
//         return ZIMMessage();
//
//     ///錄音
//       case 2 || 9:
//         String extendedData = jsonEncode({
//           'remainCoins': chatMessageModel.remainCoins,
//           'expireTime': chatMessageModel.expireTime,
//           'halfTime': chatMessageModel.halfTime,
//           'points': chatMessageModel.points,
//           'incomeflag': chatMessageModel.incomeflag,
//           'uuid': chatMessageModel.messageUuid,
//           'expireDuration': chatMessageModel.expireDuration,
//           'halfDuration': chatMessageModel.halfDuration,
//         });
//         final DBHistoryAudioModel = ref.read(chatAudioModelNotifierProvider);
//         ChatAudioModel? model;
//         try {
//           model = DBHistoryAudioModel.firstWhere((info) => info.messageUuid == chatMessageModel.messageUuid);
//         } catch (e) {
//           // 处理找不到符合条件的元素的异常情况
//           print('找不到符合条件的音频元素');
//         }
//
//         if (model != null) {
//           final Map<String, dynamic> jsonObj = {
//             'f': '3-3', 'uuid': model.messageUuid,
//             'createTime': model.timeStamp, 'type': 9,
//             'content': {
//               'message': {
//                 "reviewResult": chatMessageModel.type == 2 ? true : false,
//                 "download_url": model.audioPath,
//                 "audioTime":model.timeStamp,
//               }
//             }
//           };
//           ZIMTextMessage zimTextMessage = ZIMTextMessage(message: json.encode(jsonObj));
//           zimTextMessage.type = ZIMMessageType.text;
//           zimTextMessage.timestamp = chatMessageModel.timeStamp!.toInt();
//           zimTextMessage.senderUserID = chatMessageModel.senderName!;
//           zimTextMessage.conversationID = chatMessageModel.receiverName!;
//           zimTextMessage.extendedData = extendedData;
//
//           if (chatMessageModel.unRead == 0) {
//             zimTextMessage.receiptStatus = ZIMMessageReceiptStatus.processing;
//           } else {
//             zimTextMessage.receiptStatus = ZIMMessageReceiptStatus.done;
//           }
//
//           return zimTextMessage;
//         } else {
//           // 处理找不到符合条件的音频元素的情况，例如返回一个默认的消息
//           return ZIMMessage();
//         }
//
//     ///禮物
//       case 3:
//         final DBHistoryGiftModel = ref.read(chatGiftModelNotifierProvider);
//         ChatGiftModel? model;
//
//         try {
//           model = DBHistoryGiftModel.firstWhere((info) => info.messageUuid == chatMessageModel.messageUuid);
//         } catch (e) {
//           // 找不到符合条件的元素，处理异常情况
//           print('找不到符合条件的元素');
//         }
//
//         if (model != null) {
//           String extendedData = jsonEncode({
//             'remainCoins': chatMessageModel.remainCoins,
//             'expireTime': chatMessageModel.expireTime,
//             'halfTime': chatMessageModel.halfTime,
//             'points': chatMessageModel.points,
//             'incomeflag': chatMessageModel.incomeflag,
//             'uuid': chatMessageModel.messageUuid,
//             "giftUrl": model.giftImageUrl,
//             'giftName': model.giftName,
//             'giftSendAmount': model.giftSendAmount,
//             'expireDuration': chatMessageModel.expireDuration,
//             'halfDuration': chatMessageModel.halfDuration
//           });
//
//           ZIMTextMessage zimTextMessage = ZIMTextMessage(message: '[礼物]');
//           zimTextMessage.type = ZIMMessageType.text;
//           zimTextMessage.timestamp = chatMessageModel.timeStamp!.toInt();
//           zimTextMessage.senderUserID = chatMessageModel.senderName!;
//           zimTextMessage.conversationID = chatMessageModel.receiverName!;
//           zimTextMessage.extendedData = extendedData;
//
//           if (chatMessageModel.unRead == 0) {
//             zimTextMessage.receiptStatus = ZIMMessageReceiptStatus.processing;
//           } else {
//             zimTextMessage.receiptStatus = ZIMMessageReceiptStatus.done;
//           }
//
//           if (isShowGiftSvga) {
//             showSvga(model);
//           }
//
//           return zimTextMessage;
//         } else {
//           // 返回一个默认的消息或者处理其他异常情况
//           return ZIMMessage();
//         }
//
//     ///通話紀錄
//       case 4:
//       // String content = jsonEncode({
//       //   'uuid': chatMessageModel.messageUuid,
//       //   'type': 0,
//       //   'gift_id': '',
//       //   'gift_count': '',
//       //   'gift_url': '',
//       //   'gift_name': '',
//       //   'content': chatMessageModel.content
//       // });
//       // String extendedData = jsonEncode({
//       //   'remainCoins': chatMessageModel.remainCoins,
//       //   'expireTime': chatMessageModel.expireTime,
//       //   'halfTime': chatMessageModel.halfTime,
//       //   'points': chatMessageModel.points,
//       //   'incomeflag': chatMessageModel.incomeflag,
//       //   'uuid': chatMessageModel.messageUuid
//       // });
//       // ZIMTextMessage zimTextMessage = ZIMTextMessage(message: content);
//       // zimTextMessage.type = ZIMMessageType.text;
//       // zimTextMessage.timestamp = chatMessageModel.timeStamp!.toInt();
//       // zimTextMessage.senderUserID = chatMessageModel.senderName!;
//       // zimTextMessage.conversationID = chatMessageModel.receiverName!;
//       // zimTextMessage.extendedData = extendedData;
//       // if (chatMessageModel.unRead == 0) {
//       //   zimTextMessage.receiptStatus = ZIMMessageReceiptStatus.processing;
//       // } else {
//       //   zimTextMessage.receiptStatus = ZIMMessageReceiptStatus.done;
//       // }
//       // return zimTextMessage;
//       default:
//         return ZIMMessage();
//     }
//   }
//
//   //禮物SVG
//   Future<void> showSvga(ChatGiftModel chatGiftModel) async {
//     if (chatGiftModel.isShowSvga == 0) {
//       String svgurl = chatGiftModel.svgaUrl!;
//       if(!svgurl.contains('https')){
//         svgurl = HttpSetting.baseImagePath+chatGiftModel.svgaUrl!;
//       }
//
//       final String myUserName = ref.read(userInfoProvider).memberInfo?.userName ?? '';
//       final String sender = chatGiftModel.senderName ?? '';
//       if(myUserName != sender) {
//         SvgaPlayerUtil.loadAnimation(svgurl);
//       }
//
//       ref.read(chatGiftModelNotifierProvider.notifier)
//           .setDataToSql(chatGiftModelList: [
//         ChatGiftModel(
//             messageUuid: chatGiftModel.messageUuid,
//             senderId: chatGiftModel.senderId,
//             receiverId: chatGiftModel.receiverId,
//             senderName: chatGiftModel.senderName,
//             receiverName: chatGiftModel.receiverName,
//             giftCategoryName: chatGiftModel.giftCategoryName,
//             giftName: chatGiftModel.giftName,
//             giftId: chatGiftModel.giftId,
//             coins: chatGiftModel.coins,
//             giftImageUrl: chatGiftModel.giftImageUrl,
//             giftSendAmount: chatGiftModel.giftSendAmount,
//             svgaFileId: chatGiftModel.svgaFileId,
//             svgaUrl: chatGiftModel.svgaUrl,
//             isShowSvga: 1,
//             timeStamp: chatGiftModel.timeStamp)
//       ]);
//     }
//   }
//
//   // 訊息時間排序
//   List<ChatMessageModel> sortChatMessages(
//       List<ChatMessageModel> list1, List<ChatMessageModel> list2) {
//     // 合并两个列表
//     List<ChatMessageModel> mergedList = [...list1, ...list2];
//     // 使用List的sort方法按时间戳升序排序
//     mergedList.sort((a, b) => a.timeStamp!.compareTo(b.timeStamp!));
//     // 返回排序后的消息列表
//     return mergedList;
//   }
//
//   /// --- 訊息API---
//
//   //發送前經過3-1
//   Future<void> send({required SearchListInfo searchListInfo, required int contentType, required String chatContent, required String flag, required String replyUuid,
//     required String giftId, required String giftAmount, required String giftUrl, required String giftName, required num coins, required String giftCategoryName,
//     required num giftSendAmount, required num unRead, required num svgaFileId, required String svgaUrl, bool isStrikeUp = false,required int isReplyPickup}) async {
//     ///3-1
//
//     String uuid = const Uuid().v4();
//     // final sender = ref.read(userInfoProvider).memberInfo?.userName ?? '';
//     // final roomName = ref.read(userInfoProvider).memberInfo?.nickName ?? sender;
//
//     final String sender = ref.read(userInfoProvider).memberInfo?.userName ?? '';
//     final num nickNameAuth = ref.read(userInfoProvider).memberInfo?.nickNameAuth ?? 0;
//     final String? avatar = ref.read(userInfoProvider).memberInfo?.avatarPath;
//     final num gender = ref.read(userInfoProvider).memberInfo?.gender ?? 0;
//
//     CertificationType nickNameCertificationType = CertificationModel.getType(authNum: nickNameAuth);
//
//
//     // http://redmine.zyg.com.tw/issues/1977
//     // 暱稱認證 0:未認證 1:已認證 2:認證中 3:認證失敗 4:已認證重新送審中 5:未通過
//     String roomName = '';
//     String keepNickNameInReview = await FcPrefs.getKeepNickNameInReview();
//     if (nickNameCertificationType == CertificationType.done) {
//       roomName =  ref.read(userInfoProvider).memberInfo?.nickName ?? '';
//     } else {
//       if (keepNickNameInReview.isNotEmpty) {
//         roomName = keepNickNameInReview;
//       } else {
//         roomName = ref.read(userInfoProvider).memberInfo?.userName ?? '';
//       }
//     }
//
//     final WsAccountSpeakRes res = await wsAccountSpeak(ref: ref, roomId: searchListInfo.roomId!, userId: searchListInfo.userId!, contentType: (isStrikeUp)?3:contentType,
//         chatContent: chatContent, uuId: uuid, flag: flag, replyUuid: replyUuid, giftId: giftId, giftAmount: giftAmount, isReplyPickup:isReplyPickup, onConnectSuccess: (SuccesMsg) {},
//         onConnectFail: (errMsg) {});
//     if (resultCodeCheck == ResponseCode.CODE_SUCCESS) {
//       if (res != null) {
//
//         if (cohesionLevel !=res.cohesionLevel) {
//           String roomName = '';
//           cohesionPoints = res.cohesionPoints!;
//           if (searchListInfo.roomName != null) {
//             roomName = searchListInfo.roomName!;
//           } else {
//             roomName = searchListInfo.userName!;
//           }
//           getNowIntimacy();
//         }
//         cohesionPoints = res.cohesionPoints!;
//         cohesionLevel = res.cohesionLevel!;
//         final extendedData = jsonEncode({
//           'remainCoins': res.remainCoins,
//           'expireTime': res.expireTime,
//           'halfTime': res.halfTime,
//           'points': res.points,
//           'incomeflag': res.incomeflag,
//           'uuid': uuid,
//           "isGift": 0,
//           'giftUrl': giftUrl,
//           'svgaFileId': svgaFileId,
//           'svgaUrl': svgaUrl,
//           'giftSendAmount': giftSendAmount,
//           'giftName': giftName,
//           'coins': coins,
//           'giftId': giftId,
//           'giftCategoryName': giftCategoryName,
//           'sender': sender,
//           'receiver': searchListInfo.userName ?? '',
//           'roomName': roomName,
//           'avatar': avatar,
//           'gender': gender,
//           'roomId': searchListInfo.roomId,
//           'points': res.points,
//           'cohesionPoints': res.cohesionPoints,
//           'cohesionLevel': cohesionLevel,
//           'isReplyPickup':(isStrikeUp)?true:false,
//           'expireDuration': res.expireDuration,
//           'halfDuration': res.halfDuration,
//           // 'remark':searchListInfo.remark ?? ''
//         });
//         timeDistinctionList.clear();
//         switch (contentType) {
//           case 0 || 3 || 4 || 5:
//
//           ///存入DB
//             if (chatContent.contains('[礼物]')) {
//               ///禮物
//               setGiftDB(searchListInfo: searchListInfo, uuid: uuid, giftCategoryName: giftCategoryName, giftName: giftName, giftId: giftId,
//                   coins: coins, giftUrl: giftUrl, giftSendAmount: giftSendAmount, svgaFileId: svgaFileId, svgaUrl: svgaUrl, isShowSvga: 1);
//               setChatUserModelDB(searchListInfo: searchListInfo, unRead: unRead, chatContent: '[礼物]',  points: cohesionPoints);
//               setMessageDB(searchListInfo: searchListInfo, uuid: uuid, chatContent: chatContent, expireTime: res.expireTime,
//                   halfTime: res.halfTime, points: res.points, incomeflag: res.incomeflag, type: 3);
//               SvgaPlayerUtil.loadAnimation(HttpSetting.baseImagePath + svgaUrl);
//             } else {
//               ///文字
//               setChatUserModelDB(searchListInfo: searchListInfo, unRead: unRead, chatContent: chatContent,  points: cohesionPoints);
//               setMessageDB(searchListInfo: searchListInfo, uuid: uuid, chatContent: chatContent, expireTime: res.expireTime,
//                   halfTime: res.halfTime, points: res.points, incomeflag: res.incomeflag, type: 0);
//             }
//
//             String content = jsonEncode({
//               'uuid': uuid,
//               'type': contentType,
//               'giftId': giftId,
//               'giftCount': giftAmount,
//               'giftUrl': giftUrl,
//               'giftName': giftName,
//               'content': chatContent,
//             });
//             final zimService = ref.read(zimServiceProvider);
//             final ZIMMessageSentResult sendMsgRes = await zimService.sendMessageWithPeer(toConversationID: searchListInfo.userName!, message: content, extendedData: extendedData);
//             if(sendMsgRes.message.type == ZIMMessageType.unknown && sendMsgRes.message.receiptStatus == ZIMMessageReceiptStatus.none) {
//               return ;
//             }
//             ZIMTextMessage zimTextMessage = ZIMTextMessage(message: content);
//             zimTextMessage.type = ZIMMessageType.text;
//             zimTextMessage.timestamp = DateTime.now().millisecondsSinceEpoch;
//             zimTextMessage.receiptStatus = ZIMMessageReceiptStatus.processing;
//             zimTextMessage.message = content;
//             zimTextMessage.extendedData = extendedData;
//             zimTextMessage.senderUserID = userName;
//             zimMessageList.add(zimTextMessage);
//             break;
//           case 1:
//           ///圖片
//             String imagePath = await ImagePickerUtil().renameAndMoveImage(xFile!.path, uuid + path.extension(xFile!.path));
//             ///存入DB
//             setChatUserModelDB(searchListInfo: searchListInfo, unRead: unRead, chatContent: '[图片]', points: cohesionPoints);
//             setMessageDB(searchListInfo: searchListInfo, uuid: uuid, chatContent: chatContent, expireTime: res.expireTime, halfTime: res.halfTime, points: res.points,
//                 incomeflag: res.incomeflag, type: 1);
//             setChatImageModelDB(searchListInfo: searchListInfo, uuid: uuid, imagePath: imagePath);
//             final zimService = ref.read(zimServiceProvider);
//             final sendImgRes = await zimService.sendImageMessageWithPeer(toConversationID: searchListInfo.userName!, zimMessageType: ZIMMessageType.image, extendedData: extendedData, imagePath: imagePath);
//             if(sendImgRes.message.type == ZIMMessageType.unknown && sendImgRes.message.receiptStatus == ZIMMessageReceiptStatus.none) {
//               return ;
//             }
//             ZIMImageMessage zimImageMessage = ZIMImageMessage(imagePath);
//             zimImageMessage.type = ZIMMessageType.image;
//             zimImageMessage.timestamp = DateTime.now().millisecondsSinceEpoch;
//             zimImageMessage.receiptStatus = ZIMMessageReceiptStatus.processing;
//             zimImageMessage.extendedData =  extendedData;
//             zimMessageList.add(zimImageMessage);
//             break;
//           case 9:
//           ///錄音
//             String resultPath = await ImagePickerUtil().renameAndMoveImage(AudioUtils.filePath!, uuid + ".aac");
//             num audioTime = jsonDecode(chatContent)["audioTime"];
//             ///存入DB
//             setChatUserModelDB(searchListInfo: searchListInfo, unRead: unRead, chatContent: '[录音]', points: cohesionPoints);
//             setMessageDB(searchListInfo: searchListInfo, uuid: uuid, chatContent: chatContent, expireTime: res.expireTime, halfTime: res.halfTime,
//                 points: res.points, incomeflag: res.incomeflag, type: 2);
//             setChatAudioModelDB(searchListInfo: searchListInfo, uuid: uuid, audioPath: AudioUtils.filePath!,audioTime: audioTime);
//             // isRecordingFinish = false;
//             textFiledHint = '按住以开始录音';
//             seconds = 0;
//             Map valueMap = json.decode(extendedData);
//             valueMap['audioTime'] = audioTime;
//             String str = json.encode(valueMap);
//
//             final zimService = ref.read(zimServiceProvider);
//             final ZIMMessageSentResult sendImgRes = await zimService.sendFileMessageWithPeer(toConversationID: searchListInfo.userName!, filePath: resultPath, extendedData: str);
//             // if(sendImgRes.message.type == ZIMMessageType.unknown && sendImgRes.message.receiptStatus == ZIMMessageReceiptStatus.none) {
//             //   return ;
//             // }
//             ZIMFileMessage zimFileMessage = ZIMFileMessage(AudioUtils.filePath!);
//             zimFileMessage.type = ZIMMessageType.file;
//             zimFileMessage.timestamp = DateTime.now().millisecondsSinceEpoch;
//             zimFileMessage.receiptStatus = ZIMMessageReceiptStatus.processing;
//             zimFileMessage.extendedData =str;
//             zimMessageList.add(zimFileMessage);
//             break;
//         }
//         resultCodeCheck = '';
//         // setState!(() {});
//         // Future.delayed(const Duration(seconds: 1), () {
//         //   setState!(() {
//         //     scrollController.jumpTo(scrollController.position.maxScrollExtent);
//         //   });
//         // });
//       }
//     }
//   }
//
//
//   //發話(3-1)
//   Future<WsAccountSpeakRes> wsAccountSpeak({required WidgetRef ref, required num roomId, required num userId, required int contentType,
//     required String chatContent, required String uuId, required String flag, required String replyUuid, required String giftId, required String giftAmount,
//     required int isReplyPickup, required Function(String) onConnectSuccess, required Function(String) onConnectFail,}) async {
//     final reqBody = WsAccountSpeakReq.create(roomId: roomId, userId: userId, contentType: contentType, chatContent: chatContent, uuId: uuId,
//         flag: flag, replyUuid: replyUuid, giftId: giftId, giftAmount: giftAmount, isReplyPickup:isReplyPickup);
//     WsAccountSpeakRes res = await ref.read(accountWsProvider).wsAccountSpeak(reqBody, onConnectSuccess: (succMsg) {
//       resultCodeCheck = succMsg;
//     }, onConnectFail: (errMsg) {
//       // 餘額不足會跳充值彈窗
//       if (errMsg == ResponseCode.CODE_COIN_BALANCE_NOT_ENOUGH) {
//         rechargeHandler();
//       } else {
//         BaseViewModel.showToast(context, ResponseCode.map[errMsg]!);
//       }
//     });
//     return res;
//   }
//
//
//
//   /// ---語音視訊相關---
//
//   void _receiveAudioMsg({required ZIMTextMessage zimTextMessage, required String sendingUser}) {
//     final bool isChatRoom = ref.read(userInfoProvider).currentPage == 1;
//     Map<String, dynamic> extendedDataMap = {};
//     Map<String, dynamic> messageDataMap = {};
//     messageDataMap = json.decode(zimTextMessage.message);
//     final ReviewAudioRes reviewAudioRes = ReviewAudioRes.fromJson(messageDataMap['content']['message']);
//
//     final bool isViolateAudio = reviewAudioRes.reviewResult == false;
//
//     if(isViolateAudio) {
//       if(zimTextMessage.senderUserID == ref.read(userInfoProvider).memberInfo?.userName){
//         final List<ChatMessageModel> allChatMessageModelList = ref.read(chatMessageModelNotifierProvider);
//         final Map<String, dynamic> jsonObj = json.decode(zimTextMessage.message);
//         String uuid = jsonObj['uuid'];
//         final ChatMessageModel chatMessageModel = allChatMessageModelList.firstWhere((info) => info.messageUuid! == uuid);
//         final model = ChatMessageModel(messageUuid: chatMessageModel.messageUuid, senderId: chatMessageModel.senderId, receiverId: chatMessageModel.receiverId, senderName: chatMessageModel.senderName,
//             receiverName: chatMessageModel.receiverName, content: chatMessageModel.content, timeStamp: chatMessageModel.timeStamp, gender: chatMessageModel.gender,
//             expireTime: chatMessageModel.expireTime, halfTime: chatMessageModel.halfTime, points: chatMessageModel.points, incomeflag: chatMessageModel.incomeflag, type: chatMessageModel.type, unRead: chatMessageModel.unRead,reviewStatus: 1);
//         ref.read(chatMessageModelNotifierProvider.notifier).setDataToSql(chatMessageModelList: [model]);
//         setState!(() {});
//         BaseViewModel.showToast(context, '您的发言内容不恰当，请注意我们的用户协议');
//       }
//       return;
//     }
//
//     try {
//       extendedDataMap = json.decode(zimTextMessage.extendedData) as Map<String, dynamic>;
//       final int expireTime = extendedDataMap['expireTime'] ?? 0;
//       final int halfTime = extendedDataMap['halfTime'] ?? 0;
//       final num points = extendedDataMap['points'] ?? 0;
//       final int incomeFlag = extendedDataMap['incomeflag'] ?? 0;
//       final String uuid = messageDataMap['uuid'] ?? '';
//       final String sender = extendedDataMap['sender'] ?? '';
//       final String receiver = extendedDataMap['receiver'] ?? '';
//       final num timeStamp = messageDataMap['createTime'] ?? '';
//       final num audioTime = extendedDataMap['chatContent']['audioTime'] ?? 0;
//
//       final msgModel = ChatMessageModel(
//           messageUuid: uuid, senderName: sender, receiverName: receiver, content: '[录音]',
//           timeStamp: timeStamp, expireTime: expireTime, halfTime: halfTime,
//           points: points, incomeflag: incomeFlag, type: 2, unRead: 0,reviewStatus: 0
//       );
//
//       ref.read(chatMessageModelNotifierProvider.notifier).setDataToSql(chatMessageModelList: [msgModel]);
//       ref.read(chatAudioModelNotifierProvider.notifier).setDataToSql(chatAudioModelList: [
//         ChatAudioModel(messageUuid: uuid, senderName: zimTextMessage.senderUserID, receiverName: ref.read(userInfoProvider).memberInfo?.userName, audioPath: reviewAudioRes.download_url,
//           timeStamp: audioTime,)]);
//       if(isChatRoom){
//         final allChatUserModelList = ref.watch(chatUserModelNotifierProvider);
//         final targetChatUserModelList = allChatUserModelList.where((info) => info.userName == sendingUser).toList();
//         ChatUserModel chatUserModel = targetChatUserModelList[0];
//         ref.read(chatUserModelNotifierProvider.notifier).setDataToSql(chatUserModelList: [
//           ChatUserModel(userId: chatUserModel.userId, roomIcon: chatUserModel.roomIcon, cohesionLevel: chatUserModel.cohesionLevel,
//               userCount: chatUserModel.userCount, isOnline: chatUserModel.isOnline, userName: chatUserModel.userName, roomId: chatUserModel.roomId, roomName: chatUserModel.roomName,
//               points: chatUserModel.points, remark: chatUserModel.remark, unRead: chatUserModel.unRead, recentlyMessage: '[录音]', timeStamp: zimTextMessage.timestamp, pinTop: 0)]);
//       }
//     } on FormatException {
//       debugPrint('The info.extendedData is not valid JSON');
//     }
//   }
//
//
//   //語音視訊方法
//   Future<void> startCall(BuildContext context, {required ZegoCallType callType, required String invitedName, required String token, required String channel,
//     required num callUserId, bool isOfflineCall = false, required bool isNeedLoading, required SearchListInfo searchListInfo,}) async {
//     final myMemberInfoRes = ref.read(userInfoProvider).memberInfo;
//     SearchListInfo mySearchListInfo = SearchListInfo(userName: userName, userId: ref.read(userInfoProvider).userId, roomId: searchListInfo.roomId);
//     final bool isStrikeUpMateMode = ref.read(userInfoProvider).isStrikeUpMateMode ?? false;
//     final extendedData = jsonEncode({
//       'type': callType.index,
//       'inviterName': nickName,
//       'callUserId': callUserId,
//       'roomId': searchListInfo.roomId,
//       'channel': channel,
//       'token': token,
//       'memberInfoRes': myMemberInfoRes,
//       'SearchListInfo': mySearchListInfo,
//       'isStrikeUpMateMode': isStrikeUpMateMode
//     });
//     final int timeOut = isStrikeUpMateMode ? 10 : 30;
//
//     final zimService = ref.read(zimServiceProvider);
//     final ZegoSendInvitationResult result = await zimService.sendInvitation(
//       invitees: [invitedName],
//       callType: callType,
//       extendedData: extendedData,
//       isOfflineCall: isOfflineCall,
//       timeout: timeOut,
//     );
//
//     if (result.error == null || result.error?.code == '0') {
//       final bool isStrikeUpMode = ref.read(userInfoProvider).isStrikeUpMateMode ?? false;
//       ref.read(zegoCallBackProvider).senderExtendData = extendedData;
//
//       /// 速配模式下不推到等待頁面
//       if(isStrikeUpMode) {
//         return;
//       }
//       callback.pushToWaitingPage(
//         token: token,
//         channel: channel,
//         roomID: searchListInfo.roomId!,
//         isNeedLoading: isNeedLoading,
//         memberInfoRes: memberInfoRes!,
//         searchListInfo: searchListInfo,
//         isEnabledMicSwitch: false,
//         isEnabledCamSwitch: false,
//       );
//     } else {
//       print('send call invitation failed: $result');
//     }
//   }
//
//   //電話和視訊選項彈窗
//   void callOrVideoBottomDialog({WsMemberInfoRes? memberInfo, SearchListInfo? searchListInfo}) async {
//
//     String videoLabel = '视频通话', videoSubLabel = '', voiceLabel = '语音通话', voiceSubLabel = '';
//     num voiceCost = 0;
//     num videoCost = 0;
//
//     if (memberInfo?.gender == 0) {
//       final String? oppositeUserName = memberInfo?.userName;
//       final WsMemberInfoReq reqBody = WsMemberInfoReq.create(userName: oppositeUserName);
//       // 重新取得對方的資料，收費設置
//       final WsMemberInfoRes res = await ref.read(memberWsProvider).wsMemberInfo(reqBody,
//           onConnectSuccess: (succMsg) {},
//           onConnectFail: (errMsg) {}
//       );
//
//       // 信息｜語音｜視頻
//       List<String> costs = (res.charmCharge ?? '').split('|'); // 女性收費標準
//
//       final WsSettingCharmAchievementRes charmAchievement = ref.read(userInfoProvider).charmAchievement ?? WsSettingCharmAchievementRes();
//       final List<CharmAchievementInfo>? charmAchievementInfoList= charmAchievement.list;
//
//       final WsNotificationSearchIntimacyLevelInfoRes intimacyLevelInfo = ref.read(userInfoProvider).notificationSearchIntimacyLevelInfo ?? WsNotificationSearchIntimacyLevelInfoRes();
//       final List<String> newUserProtect = (intimacyLevelInfo.newUserProtect ?? '').split('|');
//
//       // 後台受保護的親密點數、魅力等級、開關
//       num protectIntimacyPoints = double.parse(newUserProtect[0]) ?? 0;
//       String protectCharmLevel = newUserProtect[1];
//       String protectEnable = newUserProtect[2];
//
//       // 收費價格
//       CharmAchievementInfo? charmAchievementInfoVoice;
//       CharmAchievementInfo? charmAchievementInfoVideo;
//
//       // 親密度大於等於後台親密度設定
//       if (cohesionPoints >= protectIntimacyPoints ) {
//         // 恢復成女性用戶設定扣費
//         charmAchievementInfoVoice = charmAchievementInfoList?.firstWhere((info) => info.charmLevel == costs[1], orElse: () => CharmAchievementInfo(charmLevel: "0",voiceCharge:'0' ));
//         charmAchievementInfoVideo  = charmAchievementInfoList?.firstWhere((info) => info.charmLevel == costs[2], orElse: () => CharmAchievementInfo(charmLevel: "0",streamCharge:'0'));
//       } else {
//         // 顯示後台設定的魅力等級扣費標準
//         charmAchievementInfoVoice = charmAchievementInfoList?.firstWhere((info) => info.charmLevel == protectCharmLevel, orElse: () => CharmAchievementInfo(charmLevel: "0",voiceCharge:'0' ));
//         charmAchievementInfoVideo  = charmAchievementInfoList?.firstWhere((info) => info.charmLevel == protectCharmLevel, orElse: () => CharmAchievementInfo(charmLevel: "0",streamCharge:'0'));
//         if (protectEnable == '0') {
//           // 顯示女性用戶設定扣費
//           charmAchievementInfoVoice = charmAchievementInfoList?.firstWhere((info) => info.charmLevel == costs[1], orElse: () => CharmAchievementInfo(charmLevel: "0",voiceCharge:'0' ));
//           charmAchievementInfoVideo  = charmAchievementInfoList?.firstWhere((info) => info.charmLevel == costs[2], orElse: () => CharmAchievementInfo(charmLevel: "0",streamCharge:'0'));
//         }
//       }
//
//       videoLabel = '视频通话';
//       videoSubLabel = '消耗 ${charmAchievementInfoVideo!.streamCharge} 金币/分钟';
//       videoCost = int.parse(charmAchievementInfoVideo!.streamCharge!); // 對方視頻收費
//       voiceLabel = '语音通话';
//       voiceSubLabel = '消耗 ${charmAchievementInfoVoice!.voiceCharge} 金币/分钟';
//       voiceCost = int.parse(charmAchievementInfoVoice!.voiceCharge!); // 對方語音收費
//     }
//
//     if (context.mounted) {
//       CommonBottomSheet.show(
//         context,
//         actions: [
//           CommonBottomSheetAction(
//             title: videoLabel,
//             titleStyle: const TextStyle(fontSize: 16, color: AppColors.textFormBlack, fontWeight: FontWeight.w400),
//             subtitle: videoSubLabel,
//             onTap: () => videoCallHandler(videoCost, searchListInfo),
//           ),
//           CommonBottomSheetAction(
//             title: voiceLabel,
//             titleStyle: const TextStyle(fontSize: 16, color: AppColors.textFormBlack, fontWeight: FontWeight.w400),
//             subtitle:voiceSubLabel ,
//             onTap: () => voiceCallHandler(voiceCost, searchListInfo),
//           ),
//         ],
//       );
//     }
//   }
//
//   // 打語音前判斷
//   Future<void> voiceCallHandler(voiceCost, searchListInfo) async {
//     final num personalGender = ref.read(userInfoProvider).memberInfo?.gender ?? 0; // 個人性別
//     final num coin = ref.read(userInfoProvider).memberPointCoin?.coins ?? 0; // 個人金幣
//     final bool isPermission = await _checkPermission(1);//檢查mic權限
//     if(isPermission == false ){
//       return;
//     }
//     if (personalGender == 1) {
//       // 如果個人金幣不足要跳彈窗
//       if (coin < voiceCost) {
//         rechargeHandler();
//       } else {
//         callOrVideo(type: 1, searchListInfo: searchListInfo);
//         // Navigator.pop(context);
//       }
//     } else {
//       callOrVideo(type: 1, searchListInfo: searchListInfo);
//       // Navigator.pop(context);
//
//     }
//   }
//
//   // 打視訊前判斷
//   Future<void> videoCallHandler(videoCost, searchListInfo) async {
//     final num personalGender = ref.read(userInfoProvider).memberInfo?.gender ?? 0; // 個人性別
//     final num coin = ref.read(userInfoProvider).memberPointCoin?.coins ?? 0; // 個人金幣
//     final int regTime = ref.read(userInfoProvider).memberInfo?.regTime; // 註冊時間
//     bool isNewMember = isWithin7Days(regTime); // 註冊時間有沒有小於 7 天內
//     bool isPermission = await _checkPermission(2);//檢查mic、camera權限
//     if(isPermission == false ){
//       return;
//     }
//
//     if (personalGender == 1) {
//       // 如果個人金幣不足要跳彈窗
//       if (coin < videoCost) {
//         // 新用戶有免費視訊時間
//         if (isNewMember) {
//           callOrVideo(type: 2, searchListInfo: searchListInfo);
//         } else {
//           rechargeHandler();
//         }
//       } else {
//         callOrVideo(type: 2, searchListInfo: searchListInfo);
//         // Navigator.of(context).pop();
//
//       }
//     } else {
//       callOrVideo(type: 2, searchListInfo: searchListInfo);
//       // Navigator.of(context).pop();
//
//     }
//   }
//
//
//   /// --- 語音視訊API---
//
//   //打語音或視頻電話(3-96)
//   Future<void> callOrVideo({int? type, SearchListInfo? searchListInfo}) async {
//     ///3-96
//     WsAccountCallVerificationRes? res = await accountCallOrVideoVerification(ref, searchListInfo!.userId!, searchListInfo.roomId!, type!, context);
//     if(res == null) {
//       return ;
//     }
//     if (context.mounted) {
//       startCall(context,
//           callType: (type == 1) ? ZegoCallType.voice : ZegoCallType.video,
//           invitedName: searchListInfo.userName!,
//           isOfflineCall: true,
//           isNeedLoading: false,
//           callUserId: userId!,
//           token: res.call!.rtcToken!,
//           channel: res.call!.channel!,
//           searchListInfo: searchListInfo
//       );
//       BaseViewModel.popPage(context);
//     }
//   }
//
//   //通話視訊查驗(3-96)
//   Future<WsAccountCallVerificationRes?> accountCallOrVideoVerification(WidgetRef ref, num freUserID, num roomID, int chatType, BuildContext context) async {
//     final reqBody = WsAccountCallVerificationReq.create(
//       freUserId: freUserID, //接聽方
//       chatType: chatType, //0:閒置 1:語聊 2:視訊
//       roomId: roomID,
//     );
//     String? resultCodeCheck;
//     String? resultErrorCodeCheck;
//     final res = await ref.read(accountWsProvider).wsAccountCallVerification(reqBody,
//         onConnectSuccess: (succMsg) => resultCodeCheck = succMsg,
//         onConnectFail: (errMsg) => resultErrorCodeCheck = errMsg
//     );
//
//     /// 餘額不足
//     if (resultErrorCodeCheck == ResponseCode.CODE_COIN_BALANCE_NOT_ENOUGH) {
//       rechargeHandler();
//       return null;
//     }
//
//     /// 153: 黑單 or GM type
//     if (resultErrorCodeCheck == ResponseCode.CODE_CALL_CHANNEL_ERROR
//         || resultErrorCodeCheck == ResponseCode.CODE_CALL_IS_BLACK_LISTED_ERROR
//         || resultErrorCodeCheck == ResponseCode.CODE_MEMBER_BUSY
//     ) {
//       final ZegoCallType type = chatType == 1 ? ZegoCallType.voice : ZegoCallType.video;
//       pushEmptyCallWaitingPage(type, roomID);
//       return null;
//     }
//
//     if(resultCodeCheck == ResponseCode.CODE_SUCCESS) {
//       return res;
//     }
//   }
//
//   //建立音視訊Token(3-99)
//   Future<WsAccountGetRTCTokenRes> accountGetRTCToken(WidgetRef ref, int callUserId, int roomId, int chatType, BuildContext context) async {
//     String resultCodeCheck = '';
//     String errorMsgCheck = '';
//     final reqBody = WsAccountGetRTCTokenReq.create(chatType: chatType, roomId: roomId, callUserId: callUserId);
//     WsAccountGetRTCTokenRes res = await ref.read(accountWsProvider).wsAccountGetRTCToken(reqBody, onConnectSuccess: (succMsg) {
//       print('succMsg:$succMsg');
//     }, onConnectFail: (errMsg) {
//       BaseViewModel.showToast(context, ResponseCode.map[errMsg]!);
//     });
//     return res;
//   }
//
//
//   /// ---DB---
//
//   //將Zego歷史資料存在ＤＢ
//   Future<void> insertDB(String oppositeUserName) async {
//     final chatMessageModelList = ref.read(chatMessageModelNotifierProvider);
//     for (int i = 0; i < zimMessageList.length; i++) {
//       ZIMMessage zimMessage = zimMessageList[i];
//       try {
//         switch (zimMessage.type) {
//           case ZIMMessageType.text:
//           ///文字或禮物
//             ZIMTextMessage? zimTextMessage = zimMessage as ZIMTextMessage?;
//             Map<String, dynamic> messageDataMap = {};
//             Map<String, dynamic> extendedDataMap = {};
//             messageDataMap = json.tryDecode(zimTextMessage!.message);
//             extendedDataMap = json.tryDecode(zimTextMessage.extendedData);
//
//             String uuid = messageDataMap['uuid'] ?? '';
//             String chatContent='';
//             if(oppositeUserName == 'java_system'){
//               final contentMap= messageDataMap['content'];
//               chatContent = contentMap['message'];
//             } else if(messageDataMap['f'] == '3-3') {
//               WsAccountOfficialMessageRes? content = WsAccountOfficialMessageRes.fromJson(messageDataMap['content'] ?? {});
//               OfficialMessageInfo? message = OfficialMessageInfo.fromJson(content.message ?? {});
//               /// 錄音檔
//               if(messageDataMap['type'] == 9) {
//                 message.type = 9;
//                 _buildTextAudioMsg(oppositeUserName: oppositeUserName, zimMessage: zimTextMessage);
//                 ///儲存完後，直接continue避免後面的程式碼執行 導致 錄音檔無法顯示問題
//                 continue;
//               }
//               if(messageDataMap['type'] == 8){
//                 chatContent = zimTextMessage.message;
//               }
//             } else {
//               chatContent = messageDataMap['content'] ?? '';
//             }
//             int expireTime = extendedDataMap['expireTime'] ?? 0;
//             int halfTime = extendedDataMap['halfTime'] ?? 0;
//             num points = extendedDataMap['points'] ?? 0;
//             int incomeflag = extendedDataMap['incomeflag'] ?? 0;
//             num expireDuration = extendedDataMap['expireDuration'] ?? 0;
//             num halfDuration = extendedDataMap['halfDuration'] ?? 0;
//             num unRead = 0;
//             if (zimTextMessage.receiptStatus == ZIMMessageReceiptStatus.done) {
//               unRead = 1;
//             }
//             String senderName = '';
//             String receieverName = '';
//             if (zimTextMessage.senderUserID == userName) {
//               senderName = zimTextMessage.senderUserID;
//               receieverName = oppositeUserName;
//             } else {
//               senderName = oppositeUserName;
//               receieverName = userName;
//             }
//             if (chatContent.contains('[礼物]')) {
//               String giftCategoryName = extendedDataMap['giftCategoryName'];
//               String giftName = extendedDataMap['giftName'];
//               String giftUrl = extendedDataMap['giftUrl'];
//               String svgaUrl = extendedDataMap['svgaUrl'];
//               String giftId = extendedDataMap['giftId'];
//               num giftSendAmount = extendedDataMap['giftSendAmount'];
//               num svgaFileId = extendedDataMap['svgaFileId'];
//               num coins = extendedDataMap['coins'];
//               ///禮物
//               final DBHistoryGiftModel =
//               ref.read(chatGiftModelNotifierProvider);
//               final list =
//               DBHistoryGiftModel.where((info) => info.messageUuid == uuid)
//                   .toList();
//               if (list.isEmpty) {
//                 ref.read(chatMessageModelNotifierProvider.notifier).setDataToSql(chatMessageModelList: [
//                   ChatMessageModel(messageUuid: uuid, senderName: senderName, receiverName: receieverName, content: '[礼物]', timeStamp: zimTextMessage.timestamp,
//                       expireTime: expireTime, halfTime: halfTime, points: points, incomeflag: incomeflag, type: 3, unRead: unRead, expireDuration: expireDuration, halfDuration: halfDuration,reviewStatus: (zimTextMessage.sentStatus == ZIMMessageSentStatus.failed)?1:0)]);
//                 ref.read(chatGiftModelNotifierProvider.notifier).setDataToSql(chatGiftModelList: [
//                   ChatGiftModel(messageUuid: uuid, senderName: senderName, receiverName: receieverName, giftCategoryName: giftCategoryName, giftName: giftName, giftId: int.parse(giftId!),
//                       coins: coins, giftImageUrl: giftUrl, giftSendAmount: giftSendAmount, svgaFileId: svgaFileId, svgaUrl: svgaUrl, timeStamp: DateTime.now().millisecondsSinceEpoch, isShowSvga: 0)
//                 ]);
//               }
//             } else {
//               ///文字
//               final list = chatMessageModelList.where((info) => info.messageUuid == uuid).toList();
//               if (list.isEmpty) {
//                 if(oppositeUserName == 'java_system'){
//                   ref.read(chatMessageModelNotifierProvider.notifier).setDataToSql(chatMessageModelList: [
//                     ChatMessageModel(messageUuid: uuid, senderName: senderName, receiverName: receieverName, content: zimTextMessage!.message, timeStamp: zimTextMessage.timestamp,
//                         expireTime: expireTime, halfTime: halfTime, points: points, incomeflag: incomeflag, type: 0, unRead: unRead, expireDuration: expireDuration, halfDuration: halfDuration)]);
//                 } else {
//                   ref.read(chatMessageModelNotifierProvider.notifier).setDataToSql(chatMessageModelList: [
//                     ChatMessageModel(messageUuid: uuid, senderName: senderName, receiverName: receieverName, content: chatContent, timeStamp: zimTextMessage.timestamp,
//                         expireTime: expireTime, halfTime: halfTime, points: points, incomeflag: incomeflag, type: 0, unRead: unRead, expireDuration: expireDuration, halfDuration: halfDuration,reviewStatus: (zimTextMessage.sentStatus == ZIMMessageSentStatus.failed)?1:0)]);
//                 }
//               }
//             }
//             break;
//
//         ///圖片
//           case ZIMMessageType.image:
//             ZIMImageMessage? zimImageMessage = zimMessage as ZIMImageMessage?;
//             Map<String, dynamic> extendedDataMap = {};
//             try {
//               extendedDataMap = json.decode(zimImageMessage!.extendedData) as Map<String, dynamic>;
//               int expireTime = extendedDataMap['expireTime'] ?? 0;
//               int halfTime = extendedDataMap['halfTime'] ?? 0;
//               num points = extendedDataMap['points'] ?? 0;
//               int incomeflag = extendedDataMap['incomeflag'] ?? 0;
//               String uuid = extendedDataMap['uuid'] ?? '';
//               num expireDuration = extendedDataMap['expireDuration'] ?? 0;
//               num halfDuration = extendedDataMap['halfDuration'] ?? 0;
//               final DBHistoryImageModel = ref.read(chatImageModelNotifierProvider);
//               final list = DBHistoryImageModel.where((info) => info.messageUuid == uuid).toList();
//               num unRead = 0;
//               if (zimImageMessage.receiptStatus ==
//                   ZIMMessageReceiptStatus.done) {
//                 unRead = 1;
//               }
//               String senderName = '';
//               String receieverName = '';
//               if (zimImageMessage.senderUserID == userName) {
//                 senderName = zimImageMessage.senderUserID;
//                 receieverName = oppositeUserName;
//               } else {
//                 senderName = oppositeUserName;
//                 receieverName = userName;
//               }
//               if (list.isEmpty) {
//                 ref.read(chatMessageModelNotifierProvider.notifier).setDataToSql(chatMessageModelList: [
//                   ChatMessageModel(messageUuid: uuid, senderName: senderName, receiverName: receieverName, content: '[图片]', timeStamp: zimImageMessage.timestamp,
//                       expireTime: expireTime, halfTime: halfTime, points: points, incomeflag: incomeflag, type: 1, unRead: unRead, expireDuration: expireDuration, halfDuration:  halfDuration, reviewStatus: (zimImageMessage.sentStatus == ZIMMessageSentStatus.failed)?1:0)]);
//                 ref.read(chatImageModelNotifierProvider.notifier).setDataToSql(chatImageModelList: [
//                   ChatImageModel(messageUuid: uuid, senderName: senderName, receiverName: receieverName, imagePath: (zimImageMessage.fileDownloadUrl.isEmpty)?zimImageMessage.fileLocalPath:zimImageMessage.fileDownloadUrl,
//                       timeStamp: zimImageMessage.timestamp)]);
//               } else {
//                 ChatImageModel originalChatImageModel = list[0];
//                 ref.read(chatImageModelNotifierProvider.notifier).setDataToSql(chatImageModelList: [
//                   ChatImageModel(messageUuid: originalChatImageModel.messageUuid, senderId: originalChatImageModel.senderId, senderName: originalChatImageModel.senderName,
//                     receiverId: originalChatImageModel.receiverId, receiverName: originalChatImageModel.receiverName, imagePath: (zimImageMessage.fileDownloadUrl.isEmpty)?zimImageMessage.fileLocalPath:zimImageMessage.fileDownloadUrl, timeStamp: originalChatImageModel.timeStamp,)]);
//               }
//             } on FormatException {
//               debugPrint('The info.extendedData is not valid JSON');
//             }
//             break;
//
//         /// 錄音檔（）
//           case ZIMMessageType.file:
//             ZIMFileMessage? zimFileMessage = zimMessage as ZIMFileMessage?;
//             Map<String, dynamic> extendedDataMap = {};
//             try {
//               extendedDataMap = json.decode(zimFileMessage!.extendedData) as Map<String, dynamic>;
//               int expireTime = extendedDataMap['expireTime'] ?? 0;
//               int halfTime = extendedDataMap['halfTime'] ?? 0;
//               num points = extendedDataMap['points'] ?? 0;
//               int incomeflag = extendedDataMap['incomeflag'] ?? 0;
//               String uuid = extendedDataMap['uuid'] ?? '';
//               num audioTime = 0;
//
//               ///TODO 影響招呼語取得時間
//               // if(extendedDataMap['chatContent'] !=null){
//               // Map<String, dynamic> chatContent = extendedDataMap['chatContent'];
//               audioTime = extendedDataMap['audioTime'] ?? 0;
//               // }
//               num audioType = 2;
//
//               num unRead = 0;
//               if (zimFileMessage.receiptStatus == ZIMMessageReceiptStatus.done) {unRead = 1;}
//               String senderName = '';
//               String receieverName = '';
//               if (zimFileMessage.senderUserID == userName) {
//                 senderName = zimFileMessage.senderUserID;
//                 receieverName = oppositeUserName;
//               } else {
//                 senderName = oppositeUserName;
//                 receieverName = userName;
//               }
//               ref.read(chatMessageModelNotifierProvider.notifier).setDataToSql(chatMessageModelList: [
//                 ChatMessageModel(messageUuid: uuid, senderName: senderName, receiverName: receieverName, content: '[录音]',
//                     timeStamp: zimMessage.timestamp, expireTime: expireTime, halfTime: halfTime, points: points, incomeflag: incomeflag,
//                     type: audioType, unRead: unRead)]);
//               ref.read(chatAudioModelNotifierProvider.notifier).setDataToSql(chatAudioModelList: [
//                 ChatAudioModel(messageUuid: uuid, senderName: senderName, receiverName: receieverName, audioPath: zimFileMessage.fileDownloadUrl,
//                   timeStamp: audioTime,)]);
//
//             } on FormatException {
//               debugPrint('The info.extendedData is not valid JSON');
//             }
//             break;
//           default:
//             break;
//         }
//       } on FormatException {
//         debugPrint('The info.extendedData is not valid JSON');
//       }
//     }
//   }
//
//   //寫進消息列表人，並更新provider
//   void setChatUserModelDB({required SearchListInfo searchListInfo, required num unRead, required String chatContent,required num points}) {
//     final chatUserModelList = ref.read(chatUserModelNotifierProvider);
//     final list = chatUserModelList.where((info) => info.userName == searchListInfo.userName).toList();
//     ChatUserModel chatUserModel = list[0];
//
//     ref.read(chatUserModelNotifierProvider.notifier).setDataToSql(chatUserModelList: [
//       ChatUserModel(userId: searchListInfo.userId, roomIcon: searchListInfo.roomIcon, cohesionLevel: cohesionLevel, userCount: searchListInfo.userCount,
//           isOnline: searchListInfo.isOnline, userName: searchListInfo.userName, roomId: searchListInfo.roomId, roomName: searchListInfo.roomName,
//           points: points, remark: chatUserModel.remark, unRead: unRead, recentlyMessage: chatContent, timeStamp: DateTime.now().millisecondsSinceEpoch,
//           pinTop: chatUserModel.pinTop)]);
//   }
//
//   //寫進訊息DB，並更新provider
//   void setMessageDB({SearchListInfo? searchListInfo, String? uuid, String? chatContent, num? expireTime, num? halfTime, num? points, num? incomeflag, num? type}) {
//     final model = ChatMessageModel(messageUuid: uuid, senderId: ref.read(userInfoProvider).userId, receiverId: searchListInfo!.userId, senderName: ref.read(userInfoProvider).userName,
//         receiverName: searchListInfo.userName, content: chatContent, timeStamp: DateTime.now().millisecondsSinceEpoch, gender: ref.read(userInfoProvider).memberInfo!.gender,
//         expireTime: expireTime, halfTime: halfTime, points: points, incomeflag: incomeflag, type: type, unRead: 0,reviewStatus: 0);
//     ref.read(chatMessageModelNotifierProvider.notifier).setDataToSql(chatMessageModelList: [model]);
//   }
//
//   //寫進禮物DB，並更新provider
//   void setGiftDB({SearchListInfo? searchListInfo, String? uuid, String? giftCategoryName, String? giftName, String? giftId, num? coins, String? giftUrl, num? giftSendAmount,
//     num? svgaFileId, String? svgaUrl, num? isShowSvga}) {
//     ref.read(chatGiftModelNotifierProvider.notifier).setDataToSql(chatGiftModelList: [
//       ChatGiftModel(messageUuid: uuid, senderId: ref.read(userInfoProvider).userId, receiverId: userId, senderName: ref.read(userInfoProvider).userName,
//           receiverName: searchListInfo!.userName, giftCategoryName: giftCategoryName, giftName: giftName, giftId: int.parse(giftId!), coins: coins,
//           giftImageUrl: giftUrl, giftSendAmount: giftSendAmount, svgaFileId: svgaFileId, svgaUrl: svgaUrl, isShowSvga: isShowSvga, timeStamp: DateTime.now().millisecondsSinceEpoch)]);
//   }
//
//   //寫進圖片DB，並更新provider
//   void setChatImageModelDB({required SearchListInfo searchListInfo, required String uuid, required String imagePath}) {
//     ref.read(chatImageModelNotifierProvider.notifier).setDataToSql(chatImageModelList: [
//       ChatImageModel(messageUuid: uuid, senderId: ref.read(userInfoProvider).userId, receiverId: searchListInfo.userId, senderName: ref.read(userInfoProvider).userName,
//         receiverName: searchListInfo.userName, imagePath: imagePath, timeStamp: DateTime.now().millisecondsSinceEpoch,)]);
//   }
//
//   //寫進錄音DB，並更新provider
//   void setChatAudioModelDB({required SearchListInfo searchListInfo, required String uuid, required String audioPath ,required num audioTime}) {
//     ref.read(chatAudioModelNotifierProvider.notifier).setDataToSql(chatAudioModelList: [
//       ChatAudioModel(messageUuid: uuid, senderId: ref.read(userInfoProvider).userId, receiverId: userId, senderName: ref.read(userInfoProvider).userName,
//           receiverName: searchListInfo.userName, audioPath: audioPath, timeStamp: audioTime)]);
//   }
//
//   /// ---親密度相關---
//
//   //取得目前亲密度狀態
//   void getNowIntimacy() {
//     final WsNotificationSearchIntimacyLevelInfoRes intimacyLevelInfo = ref.read(userInfoProvider).notificationSearchIntimacyLevelInfo ?? WsNotificationSearchIntimacyLevelInfoRes();
//     final List<IntimacyLevelInfo>? intimacyLevelInfoList = intimacyLevelInfo.list;
//     if (intimacyLevelInfoList != null) {
//       for (final intimacyLevelInfo in intimacyLevelInfoList) {
//         pointsRuleMap[intimacyLevelInfo.cohesionLevel] = intimacyLevelInfo.points;
//       }
//     }
//
//     if (cohesionPoints < pointsRuleMap[1]) {
//       nowIntimacy = 0;
//       cohesionImagePath = 'assets/icons/icon_intimacy_level_1.png';
//       cohesionColor = AppColors.cohesionLevelColor[0];
//       String nextCohesionName = getCohesionName(nowIntimacy+1);
//       nextRelationShip = '【$nextCohesionName】';
//       intimacyLevelBgColor = [Color(0xFFACBCED), Color.fromRGBO(234, 238, 250, 0),];
//     } else if (pointsRuleMap[1] <= cohesionPoints && cohesionPoints < pointsRuleMap[2]) {
//       nowIntimacy = 1;
//       cohesionColor = AppColors.cohesionLevelColor[1];
//       cohesionImagePath = 'assets/icons/icon_intimacy_level_1.png';
//       String nextCohesionName = getCohesionName(nowIntimacy+1);
//       nextRelationShip = '【$nextCohesionName】';
//       nextLevelSubtract = pointsRuleMap[2] - cohesionPoints.toInt();
//       intimacyLevelBgColor = [Color(0xFFACBCED), Color.fromRGBO(234, 238, 250, 0),];
//     } else if (pointsRuleMap[2] <= cohesionPoints && cohesionPoints < pointsRuleMap[3]) {
//       nowIntimacy = 2;
//       cohesionColor = AppColors.cohesionLevelColor[2];
//       cohesionImagePath = 'assets/icons/icon_intimacy_level_2.png';
//       nextLevelSubtract = pointsRuleMap[3] - cohesionPoints.toInt();
//       String nextCohesionName = getCohesionName(nowIntimacy+1);
//       nextRelationShip = '【$nextCohesionName】';
//       intimacyLevelBgColor = [Color(0xFF81B3E9), Color.fromRGBO(225, 237, 250, 0),];
//
//     } else if (pointsRuleMap[3] <= cohesionPoints && cohesionPoints < pointsRuleMap[4]) {
//       nowIntimacy = 3;
//       cohesionColor = AppColors.cohesionLevelColor[3];
//       cohesionImagePath = 'assets/icons/icon_intimacy_level_3.png';
//       nextLevelSubtract = pointsRuleMap[4] - cohesionPoints.toInt();
//       String nextCohesionName = getCohesionName(nowIntimacy+1);
//       nextRelationShip = '【$nextCohesionName】';
//       intimacyLevelBgColor = [Color(0xFF61BC81), Color.fromRGBO(227, 244, 233, 0),];
//     } else if (pointsRuleMap[4] <= cohesionPoints && cohesionPoints < pointsRuleMap[5]) {
//       nowIntimacy = 4;
//       cohesionColor = AppColors.cohesionLevelColor[4];
//       cohesionImagePath = 'assets/icons/icon_intimacy_level_4.png';
//       nextLevelSubtract = pointsRuleMap[5] - cohesionPoints.toInt();
//       String nextCohesionName = getCohesionName(nowIntimacy+1);
//       nextRelationShip = '【$nextCohesionName】';
//       intimacyLevelBgColor = [Color(0xFFF1B0B8), Color.fromRGBO(236, 153, 162, 0),];
//     } else if (pointsRuleMap[5] <= cohesionPoints && cohesionPoints < pointsRuleMap[6]) {
//       nowIntimacy = 5;
//       cohesionColor = AppColors.cohesionLevelColor[5];
//       cohesionImagePath = 'assets/icons/icon_intimacy_level_5.png';
//       nextLevelSubtract = pointsRuleMap[6] - cohesionPoints.toInt();
//       String nextCohesionName = getCohesionName(nowIntimacy+1);
//       nextRelationShip = '【$nextCohesionName】';
//       intimacyLevelBgColor = [Color(0xFFF2B0B8), Color.fromRGBO(174, 120, 237, 0),];
//     } else if (pointsRuleMap[6] <= cohesionPoints && cohesionPoints < pointsRuleMap[7]) {
//       nowIntimacy = 6;
//       cohesionImagePath = 'assets/icons/icon_intimacy_level_6.png';
//       cohesionColor = AppColors.cohesionLevelColor[6];
//       nextLevelSubtract = pointsRuleMap[7] - cohesionPoints.toInt();
//       String nextCohesionName = getCohesionName(nowIntimacy+1);
//       nextRelationShip = '【$nextCohesionName】';
//       intimacyLevelBgColor = [Color(0xFFDE858E), Color.fromRGBO(219, 120, 130, 0),];
//     } else if (pointsRuleMap[7] <= cohesionPoints && cohesionPoints < pointsRuleMap[8]) {
//       cohesionImagePath = 'assets/icons/icon_intimacy_level_7.png';
//       nowIntimacy = 7;
//       cohesionColor = AppColors.cohesionLevelColor[7];
//       String nextCohesionName = getCohesionName(nowIntimacy+1);
//       nextRelationShip = '【$nextCohesionName】';
//       intimacyLevelBgColor = [Color(0xFFCC1F18), Color.fromRGBO(176, 46, 37, 0),];
//     }else{
//       cohesionColor = AppColors.cohesionLevelColor[8];
//       cohesionImagePath = 'assets/icons/icon_intimacy_level_8.png';
//       nowIntimacy = 8;
//       nextRelationShip = '【】';
//       intimacyLevelBgColor = [Color(0xFFEAA850), Color.fromRGBO(242, 201, 141, 0),];
//     }
//     timeDistinctionList.clear();
//
//     if(setState != null) setState!(() {isCohesionLoading = false;});
//   }
//
//   String getCohesionName(int intimacyLevel) {
//     String cohesionName = '';
//     final WsNotificationSearchIntimacyLevelInfoRes intimacyLevelInfo = ref.read(userInfoProvider).notificationSearchIntimacyLevelInfo ?? WsNotificationSearchIntimacyLevelInfoRes();
//     List<IntimacyLevelInfo?> levelInfo = intimacyLevelInfo.list!.where((item) => item.cohesionLevel == intimacyLevel).toList();
//     if (levelInfo.isNotEmpty) {
//       cohesionName = levelInfo.first?.cohesionName ?? '';
//     }
//     return cohesionName;
//   }
//
//
//   /// ---開畫面(彈窗/推頁)---
//   //亲密度彈窗
//   void showIntimacyDialog(String? avatarIcon) {
//     BaseDialog(context).showTransparentDialog(
//         isDialogCancel: true,
//         widget: IntimacyDialog(
//           opponentAvatar: avatarIcon,
//           cohesionPoints: cohesionPoints,
//           cohesionImagePath:cohesionImagePath,
//           pointsRuleMap:pointsRuleMap,
//           nextLevelSubtract: nextLevelSubtract,
//           nowIntimacy:nowIntimacy,
//           nextRelationShip:nextRelationShip,
//           osType: osType,
//         )
//     );
//   }
//
//   //禮物彈窗
//   Future<void> showBottomSheetGift(SearchListInfo searchListInfo, num unRead) async {
//     showModalBottomSheet<dynamic>(
//       backgroundColor: Colors.transparent,
//       context: context,
//       builder: (BuildContext context) {
//         return GiftAndBag(
//           onTapSendGift: (result) {
//             // sendGiftMessage(searchListInfo: searchListInfo, unRead: unRead, giftResult: result);
//           },
//         );
//       },
//     );
//   }
//
//   //最長錄音時間彈窗
//   void showMaximumRecordingDialog({SearchListInfo? searchListInfo, int? contentType, num? unRead, bool? isVoice, required Function micStatusCallback}) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           contentPadding:
//           EdgeInsets.only(left: 17.w, right: 17.w, top: 20.h, bottom: 20.h),
//           // 移除內容的 padding
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(20.0),
//           ),
//           content: SizedBox(
//             width: 300.w, // 設定最大寬度
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Text(
//                   '提示',
//                   style: TextStyle(
//                     fontSize: 18.sp,
//                     color: AppColors.textFormBlack,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 Container(
//                   margin: EdgeInsets.only(top: 12.h, bottom: 32.h),
//                   child: Text(
//                     '录音达到最大时间，是否发送？',
//                     style: TextStyle(
//                       fontSize: 14.sp,
//                       color: AppColors.textFormBlack,
//                     ),
//                   ),
//                 ),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Expanded(
//                       child: GestureDetector(
//                         child: Container(
//                           height: 44,
//                           alignment: const Alignment(0, 0),
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(24),
//                             gradient:  LinearGradient(
//                               colors: [
//                                 AppColors.mainPink.withOpacity(0.2),
//                                 AppColors.mainPink.withOpacity(0.1),
//                               ],
//                               begin: Alignment.topCenter,
//                               end: Alignment.bottomCenter,
//                             ),
//                           ),
//                           child: Text(
//                             '取消',
//                             style: TextStyle(
//                               color: Color.fromRGBO(236, 97, 147, 1),
//                               fontSize: 14.sp,
//                             ),
//                           ),
//                         ),
//                         onTap: () {
//                           BaseViewModel.popPage(context);
//                           timeDistinctionList.clear();
//                           micStatusCallback(0);
//                           setState!((){
//                             seconds = 0;
//                           });
//                         },
//                       ),
//                     ),
//                     const SizedBox(width: 12),
//                     Expanded(
//                         child: GestureDetector(
//                           child: Container(
//                             height: 44.w,
//                             alignment: const Alignment(0, 0),
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(24),
//                               gradient: AppColors.pinkLightGradientColors,
//                             ),
//                             child: Text(
//                               '发送',
//                               style:
//                               TextStyle(color: Colors.white, fontSize: 14.sp),
//                             ),
//                           ),
//                           onTap: () {
//                             sendVoiceMessage(
//                                 searchListInfo: searchListInfo,
//                                 unRead: unRead
//                             );
//
//                             micStatusCallback(0);
//                             setState!((){
//                               seconds = 0;
//                             });
//
//                             BaseViewModel.popPage(context);
//                           },
//                         )
//                     )
//                   ],
//                 ),
//               ],
//             ),
//           ),
//           // 其他 Dialog 属性
//         );
//       },
//     );
//   }
//
//   //收費彈窗提醒
//   void rechargeHandler() {
//     final num rechargeCounts =  ref.read(userInfoProvider).memberPointCoin?.depositCount ?? 0;
//     final AppTheme theme = ref.watch(userInfoProvider).theme ?? AppTheme(themeType: AppThemeType.original);
//     if (rechargeCounts == 0) {
//       RechargeUtil.showFirstTimeRechargeDialog('余额不足，请先充值'); // 開啟首充彈窗
//     } else {
//       RechargeUtil.showRechargeBottomSheet(theme:theme); // 開啟充值彈窗
//     }
//   }
//
//   //網路延遲狀態提醒
//   void onNetworkTime(int delayTime) {
//     final BuildContext currentContext = BaseViewModel.getGlobalContext();
//     print('網路延遲狀態: $delayTime ms');
//     AppTheme theme = ref.read(userInfoProvider).theme ?? AppTheme(themeType: AppThemeType.original);
//
//     if(delayTime > NetworkStatusSetting.statusVerySlow) {
//       CommDialog(context).build(
//           theme: theme,
//           title: '提示',
//           contentDes:
//           '因网速较慢，通话可能不畅。\n 建议避开用量高峰或切换网络。',
//           horizontalPadding: 32.w,
//           rightBtnTitle: '确认',
//           rightAction: () =>
//               BaseViewModel.popPage(context) );
//     }
//   }
//
//   void pushEmptyCallWaitingPage(ZegoCallType type ,num roomID){
//     callback.pushToWaitingPage(
//         token: '',
//         channel: '',
//         roomID: roomID,
//         isNeedLoading: false,
//         memberInfoRes: memberInfoRes!,
//         searchListInfo: SearchListInfo(),
//         isEnabledMicSwitch: false,
//         isEnabledCamSwitch: false,
//         typeForEmptyCall: type
//     );
//   }
//
//   /// ---其他---
//
//   initTickerProvider() {
//     animationController = SVGAAnimationController(vsync: tickerProvider!);
//   }
//
//   //取得用戶資料
//   Future<void> getUserInfo(String oppositeUserName) async {
//     final reqBody = WsMemberInfoReq.create(
//       userName: oppositeUserName,
//     );
//     memberInfoRes = await ref.read(memberWsProvider).wsMemberInfo(reqBody, onConnectSuccess: (succMsg) {}, onConnectFail: (errMsg) {
//       final gmType = ref.read(userInfoProvider).buttonConfigList?.gmType;
//       if(gmType != 1){
//         BaseViewModel.showToast(context, ResponseCode.map[errMsg]!);
//       }
//     });
//
//     // final chatUserModelList = ref.read(chatUserModelNotifierProvider);
//     // final targetChatUserModel = chatUserModelList.firstWhere((info) => info.userName == memberInfoRes!.userName);
//     // ref.read(chatUserModelNotifierProvider.notifier).setDataToSql(
//     //     chatUserModelList: [
//     //       ChatUserModel(
//     //           userId: targetChatUserModel.userId,
//     //           roomIcon: memberInfoRes!.avatarPath,
//     //           cohesionLevel: targetChatUserModel.cohesionLevel,
//     //           userCount: targetChatUserModel.userCount,
//     //           isOnline: targetChatUserModel.isOnline,
//     //           userName: targetChatUserModel.userName,
//     //           roomId: targetChatUserModel.roomId,
//     //           roomName: targetChatUserModel.roomName,
//     //           points: targetChatUserModel.points,
//     //           remark: targetChatUserModel.remark,
//     //           recentlyMessage: targetChatUserModel.recentlyMessage,
//     //           unRead: targetChatUserModel.unRead,
//     //           timeStamp: targetChatUserModel.timeStamp,
//     //           pinTop: targetChatUserModel.pinTop)
//     //     ]);
//
//     _initExpandFriendController();
//
//     osType = memberInfoRes?.osType ?? 1;
//
//     num gender = ref.read(userInfoProvider).memberInfo?.gender ??0;
//     final chatUserModelList = ref.read(chatUserModelNotifierProvider);
//     final list = chatUserModelList.where((info) => info.userName == oppositeUserName).toList();
//     ChatUserModel chatUserModel = list.first;
//     if(gender == 1){
//       if(chatUserModel.charmCharge == null || chatUserModel.charmCharge!.isEmpty){
//         // needShowCharmCharge = true;
//         List<String> memberInfoCosts = (memberInfoRes!.charmCharge ?? '').split('|');
//         textCharge = memberInfoCosts[0];
//         ref.read(chatUserModelNotifierProvider.notifier).setDataToSql(
//             chatUserModelList: [
//               ChatUserModel(userId: chatUserModel.userId,
//                   roomIcon: memberInfoRes!.avatarPath,
//                   cohesionLevel: cohesionLevel,
//                   userCount: chatUserModel.userCount,
//                   isOnline: chatUserModel.isOnline,
//                   userName: chatUserModel.userName,
//                   roomId: chatUserModel.roomId,
//                   roomName: chatUserModel.roomName,
//                   points: chatUserModel.points,
//                   remark: chatUserModel.remark,
//                   unRead: chatUserModel.unRead,
//                   recentlyMessage: chatUserModel.recentlyMessage,
//                   timeStamp: chatUserModel.timeStamp,
//                   pinTop: chatUserModel.pinTop,
//                   charmCharge: memberInfoRes!.charmCharge??'')
//             ]);
//       }else if(chatUserModel.charmCharge != memberInfoRes!.charmCharge){
//         List<String> dbCosts = (chatUserModel.charmCharge ?? '').split('|');
//         List<String> memberInfoCosts = (memberInfoRes!.charmCharge ?? '').split('|');
//         if(dbCosts[0] != memberInfoCosts[0]){
//           needShowCharmCharge = true;
//           textCharge = memberInfoCosts[0];
//           ref.read(chatUserModelNotifierProvider.notifier).setDataToSql(
//               chatUserModelList: [
//                 ChatUserModel(userId: chatUserModel.userId,
//                     roomIcon: memberInfoRes!.avatarPath,
//                     cohesionLevel: cohesionLevel,
//                     userCount: chatUserModel.userCount,
//                     isOnline: chatUserModel.isOnline,
//                     userName: chatUserModel.userName,
//                     roomId: chatUserModel.roomId,
//                     roomName: chatUserModel.roomName,
//                     points: chatUserModel.points,
//                     remark: chatUserModel.remark,
//                     unRead: chatUserModel.unRead,
//                     recentlyMessage: chatUserModel.recentlyMessage,
//                     timeStamp: chatUserModel.timeStamp,
//                     pinTop: chatUserModel.pinTop,
//                     charmCharge: memberInfoRes!.charmCharge??'')
//               ]);
//         }
//       }
//     }
//
//     ref.read(chatUserModelNotifierProvider.notifier).setDataToSql(
//         chatUserModelList: [
//           ChatUserModel(userId: chatUserModel.userId,
//               roomIcon: memberInfoRes!.avatarPath,
//               cohesionLevel: chatUserModel.cohesionLevel,
//               userCount: chatUserModel.userCount,
//               isOnline: chatUserModel.isOnline,
//               userName: chatUserModel.userName,
//               roomId: chatUserModel.roomId,
//               roomName: chatUserModel.roomName,
//               points: chatUserModel.points,
//               remark: chatUserModel.remark,
//               unRead: chatUserModel.unRead,
//               recentlyMessage: chatUserModel.recentlyMessage,
//               timeStamp: chatUserModel.timeStamp,
//               pinTop: chatUserModel.pinTop,
//               charmCharge: chatUserModel.charmCharge)
//         ]);
//   }
//
//   //常用語取得
//   Future<void> getCommonLanguage() async {
//     commonLanguageList.clear();
//     List<String> customCommonLanguageTexts = [];
//     List<String> defaultCommonLanguageTexts = [];
//     String phoneNumber = await FcPrefs.getPhoneNumber();
//     customCommonLanguageTexts = await FcPrefs.getCustomCommonLanguage('${phoneNumber}_customCommonLanguage');
//     defaultCommonLanguageTexts = await FcPrefs.getDefaultCommonLanguage("${phoneNumber}_defaultCommonLanguage");
//     final num? gender = ref.read(userInfoProvider).memberInfo?.gender;
//     String data = '';
//     if(gender == 1){
//       data = await rootBundle.loadString('assets/txt/commonlanguage_male.txt');
//     }else{
//       data = await rootBundle.loadString('assets/txt/commonlanguage_female.txt');
//     }
//     List<String> dList = const LineSplitter().convert(data);
//     if(customCommonLanguageTexts.isEmpty){
//       if(defaultCommonLanguageTexts.isEmpty){
//         for(int i = 0;i<10;i++){
//           commonLanguageList.add(dList[i]);
//         }
//       }else{
//         commonLanguageList = defaultCommonLanguageTexts;
//       }
//     }else{
//       if(defaultCommonLanguageTexts.isEmpty){
//         commonLanguageList.addAll(customCommonLanguageTexts);
//         for(int i = 0;i<10;i++){
//           commonLanguageList.add(dList[i]);
//         }
//       }else{
//         commonLanguageList.addAll(customCommonLanguageTexts);
//         commonLanguageList.addAll(defaultCommonLanguageTexts);
//       }
//     }
//     timeDistinctionList.clear();
//     setState!(() {
//       commonLanguageLoading = false;
//     });
//   }
//
//   void scrollToEnd({bool? toStart = false}) {
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       if (scrollController.hasClients) {
//         final maxScroll = scrollController.position.maxScrollExtent;
//         scrollController.animateTo(
//           toStart == false ? maxScroll : 0,
//           duration: const Duration(milliseconds: 300),
//           curve: Curves.easeOut,
//         );
//       }
//     });
//   }
//
//   int checkIsReplyPickup(){
//     if(zimMessageList.isNotEmpty){
//       ZIMMessage zimMessage = zimMessageList.last;
//       Map<String, dynamic> extendedDataMap = {};
//       try {
//         extendedDataMap = json.decode(zimMessage.extendedData) as Map<String, dynamic>;
//         if(extendedDataMap['isReplyPickup'] != null){
//           if(extendedDataMap['isReplyPickup']){
//             return 1;
//           }else{
//             return 0;
//           }
//         }else{
//           return 0;
//         }
//       } catch (e) {
//         return 0;
//       }
//     } else{
//       return 0;
//     }
//
//   }
//
//   String replyUUid(SearchListInfo searchListInfo) {
//     String replyUuid = '';
//     List<ChatMessageModel> chatMessageModelList = _getChatMsgFormUserName(searchListInfo);
//     for (int i = chatMessageModelList.length - 1; i >= 0; i--) {
//       if (chatMessageModelList[i].senderName !=
//           ref.read(userInfoProvider).memberInfo!.userName) {
//         if (replyUuid.isEmpty) {
//           replyUuid = chatMessageModelList[i].messageUuid!;
//         } else {
//           replyUuid += ",${chatMessageModelList[i].messageUuid!}";
//         }
//       } else {
//         break;
//       }
//     }
//     return replyUuid;
//   }
//
//   List<ChatMessageModel> _getChatMsgFormUserName (SearchListInfo searchListInfo) {
//     final allChatMessageModelList = ref.watch(chatMessageModelNotifierProvider);
//     final mySendChatMessagelist = allChatMessageModelList.where((info) => info.senderName == ref.read(userInfoProvider).memberInfo?.userName && info.receiverName == searchListInfo!.userName!).toList();
//     final oppoSiteSendChatMessagelist = allChatMessageModelList.where((info) => info.senderName == searchListInfo.userName && info.receiverName == ref.read(userInfoProvider).memberInfo?.userName).toList();
//     List<ChatMessageModel> chatMessageModelList = sortChatMessages(mySendChatMessagelist, oppoSiteSendChatMessagelist);
//     return chatMessageModelList;
//   }
//
//   //錄音時間格式
//   String formatTime(int seconds) {
//     int minutes = seconds ~/ 60;
//     int remainingSeconds = seconds % 60;
//     return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
//   }
//
//   //錄音開始計時
//   void startRecordingTimer() {
//     recordingSeconds = 0;
//     recordingTimer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
//       timeDistinctionList.clear();
//       setState!(() {
//         recordingSeconds++;
//         textFiledHint = "录音中";
//         style = TextStyle(color: AppColors.mainPink, fontSize: 14.sp);
//       });
//     });
//   }
//
//
//   _buildTextAudioMsg({required ZIMTextMessage zimMessage, required String oppositeUserName}) {
//     Map<String, dynamic> messageDataMap = {};
//     Map<String, dynamic> extendedDataMap = {};
//     messageDataMap = json.tryDecode(zimMessage.message);
//     extendedDataMap = json.tryDecode(zimMessage.extendedData);
//
//     try {
//       extendedDataMap = json.decode(zimMessage.extendedData) as Map<String, dynamic>;
//       int expireTime = extendedDataMap['expireTime'] ?? 0;
//       int halfTime = extendedDataMap['halfTime'] ?? 0;
//       num points = extendedDataMap['points'] ?? 0;
//       int incomeflag = extendedDataMap['incomeflag'] ?? 0;
//
//       num audioTime = 0;
//       if(extendedDataMap['chatContent'] !=null){
//         Map<String, dynamic> chatContent = extendedDataMap['chatContent'];
//         audioTime = chatContent['audioTime'] ?? 0;
//       }
//       String uuid = messageDataMap['uuid'];
//       num unRead = 0;
//       if (zimMessage.receiptStatus == ZIMMessageReceiptStatus.done) {
//         unRead = 1;
//       }
//       String senderName = '';
//       String receieverName = '';
//       if (zimMessage.senderUserID == userName) {
//         senderName = zimMessage.senderUserID;
//         receieverName = oppositeUserName;
//       } else {
//         senderName = oppositeUserName;
//         receieverName = userName;
//       }
//       // final DBHistoryAudioModel = ref.read(chatAudioModelNotifierProvider);
//       // final list = DBHistoryAudioModel.where((info) => info.messageUuid == uuid).toList();
//       final ReviewAudioRes reviewAudioRes = ReviewAudioRes.fromJson(messageDataMap['content']['message']);
//       final num audioType = reviewAudioRes.reviewResult == true ? 2 : 7;
//
//       ref.read(chatMessageModelNotifierProvider.notifier).setDataToSql(chatMessageModelList: [
//         ChatMessageModel(messageUuid: uuid, senderName: senderName, receiverName: receieverName, content: '[录音]',
//             timeStamp: zimMessage.timestamp, expireTime: expireTime, halfTime: halfTime, points: points, incomeflag: incomeflag,
//             type: audioType, unRead: unRead)]);
//       ref.read(chatAudioModelNotifierProvider.notifier).setDataToSql(chatAudioModelList: [
//         ChatAudioModel(messageUuid: uuid, senderName: senderName, receiverName: receieverName, audioPath: reviewAudioRes.download_url,
//           timeStamp: audioTime,)]);
//
//
//     } on FormatException {
//       debugPrint('The info.extendedData is not valid JSON');
//     }
//   }
//
//   // 對方資訊頁, 初始化大小動畫
//   _initExpandFriendController() {
//     // 預設高度
//     double endHeight = 60.h;
//
//     // 認證狀態
//
//     if(memberInfoRes?.realNameAuth == 1 || memberInfoRes?.realPersonAuth == 1) {
//       endHeight = endHeight + 30.h;
//     }
//
//     // 相冊
//     final isNullAlbum = memberInfoRes?.albumsPath == null || memberInfoRes!.albumsPath!.isEmpty;
//     if(!isNullAlbum) {
//       endHeight = endHeight + 70.h;
//     }
//
//     if(expandController != null) {
//       expandController?.dispose();
//       expandController == null;
//     }
//
//     expandController = AnimationController(vsync: tickerProvider!,
//       duration: const Duration(milliseconds: 300),
//       reverseDuration: const Duration(milliseconds: 300),
//     );
//
//     heightAnimation = Tween<double>(
//       begin: 60.h,
//       end: endHeight,
//     ).animate(expandController!);
//   }
//
//   dropDownFriendInfo() {
//     final bool isNullRealAuth = memberInfoRes?.realNameAuth != 1 && memberInfoRes?.realPersonAuth != 1;
//     final bool isNullAlbum = memberInfoRes?.albumsPath == null || memberInfoRes!.albumsPath!.isEmpty;
//     print('isNullRealAuth: $isNullRealAuth');
//     print('isNullAlbum: $isNullAlbum');
//
//     if (isNullRealAuth && isNullAlbum) return;
//
//     if(expandController?.status == AnimationStatus.completed) {
//       expandController?.reverse();
//     } else {
//       expandController?.forward();
//     }
//   }
//
//   String _getReceiverName(ZIMMessage zimMessage) {
//     final String myUserName = ref.read(userInfoProvider).userName ?? '';
//     final String receiverName = (zimMessage.senderUserID == myUserName)
//         ? zimMessage.conversationID
//         : myUserName;
//     return receiverName;
//   }
//
//   Future<void> getCohesionPointsRule() async {
//     final reqBody = WsNotificationSearchIntimacyLevelInfoReq.create();
//     WsNotificationSearchIntimacyLevelInfoRes res = await ref.read(notificationWsProvider).wsNotificationSearchIntimacyLevelInfo(reqBody,
//         onConnectSuccess: (succMsg) {}, onConnectFail: (errMsg) {});
//     ref.read(userUtilProvider.notifier).loadNotificationSearchIntimacyLevelInfo(res);
//     final List<IntimacyLevelInfo>? intimacyLevelInfoList = res.list;
//     if (intimacyLevelInfoList != null) {
//       for (final intimacyLevelInfo in intimacyLevelInfoList) {
//         pointsRuleMap[intimacyLevelInfo.cohesionLevel] = intimacyLevelInfo.points;
//       }
//     }
//
//     getNowIntimacy();
//   }
//
//   List<ChatUserModel> sortChatUserstest(List<ChatUserModel> userList) {
//     // 首先将 pinTop 为 1 的 ChatUserModel 排到前面
//     List<ChatUserModel> systemUsers = [];
//     List<ChatUserModel> pinnedUsers = [];
//     List<ChatUserModel> nonPinnedUsers = [];
//
//     for (var user in userList) {
//       if(user.userName =='java_system'){
//         systemUsers.add(user);
//       }else{
//         if (user.pinTop == 1) {
//           pinnedUsers.add(user);
//         } else {
//           nonPinnedUsers.add(user);
//         }
//       }
//     }
//
//     // 对置顶的用户按照 timeStamp 排序，最新时间在最前面
//     pinnedUsers.sort((a, b) => b.timeStamp!.compareTo(a.timeStamp!));
//
//     // 对非置顶的用户按照 timeStamp 排序，最新时间在最前面
//     nonPinnedUsers.sort((a, b) => b.timeStamp!.compareTo(a.timeStamp!));
//
//     // 合并两个列表：置顶的用户在前面，非置顶用户也按照时间排序
//     List<ChatUserModel> sortedUsers = [...systemUsers,...pinnedUsers, ...nonPinnedUsers];
//
//     /// 移除拉黑用戶
//     final WsNotificationBlockGroupRes? blockList = ref.read(userInfoProvider).notificationBlockGroup;
//     final List<String?> blockUserNameList = blockList?.list?.map((blockUser) => blockUser.userName).toList() ?? [];
//     sortedUsers.removeWhere((user) => blockUserNameList.contains(user.userName));
//
//     return sortedUsers;
//   }
//
//   Future<void> checkNetWorkTime() async {
//     final DateTime sendingTime = DateTime.now();
//     try {
//       await DioUtil(baseUrl: AppConfig.baseUri).get(CommEndpoint.checkAliveAndNetWorkSpeed);
//     } catch (e) {
//       print(e);
//     }
//     final DateTime responseTime = DateTime.now();
//     /// 計算網路傳輸時間
//     final Duration resultTime = responseTime.difference(sendingTime);
//     onNetworkTime(resultTime.inMilliseconds);
//   }
//
//   String formatDateTime(DateTime dateTime) {
//     DateTime now = DateTime.now();
//     DateTime beginningOfWeek = now.subtract(Duration(days: now.weekday - 1));
//     DateTime endOfWeek = beginningOfWeek.add(const Duration(days: 6));
//
//     if (dateTime.year == now.year &&
//         dateTime.month == now.month &&
//         dateTime.day == now.day) {
//       // 同一天
//       return '今天';
//     } else if (dateTime.isAfter(beginningOfWeek) &&
//         dateTime.isBefore(endOfWeek)) {
//       // 同一週
//       List<String> weekdays = ['一', '二', '三', '四', '五', '六', '日'];
//       return '星期${weekdays[dateTime.weekday - 1]}';
//     } else {
//       // 不同週
//       return '${dateTime.month}/${dateTime.day}';
//     }
//   }
//
//   bool isWithin7Days(int regTime) {
//     DateTime dateTime1 = DateTime.fromMillisecondsSinceEpoch(regTime);
//     DateTime dateTime2 = DateTime.now();
//
//     Duration difference = dateTime1.difference(dateTime2);
//     return difference.inDays.abs() < 7;
//   }
//
//   //檢查麥克風、鏡頭使用權限（語音通話只需要mic，視訊通話需要mic camera）
//   Future<bool> _checkPermission(int? type) async {
//     bool isMicPermission = await PermissionUtil.checkAndRequestMicrophonePermission();
//     bool isCamPermission = false;
//     if(type == 2){
//       isCamPermission = await PermissionUtil.checkAndRequestCameraPermission();
//     }
//     //語音通話:1/ 視訊通話:2
//     if(type == 1){
//       return isMicPermission;
//     }else{
//       if(isMicPermission==false || isCamPermission == false){
//         return false;
//       }else{
//         return true;
//       }
//     }
//   }
//
//
//
// /// ---未使用---
//
// // void readSystemMeassge(){
// //   final chatUserModel = ref.read(chatUserModelNotifierProvider);
// //   final list = chatUserModel.where((info) => info.userName == 'java_system').toList();
// //   if(list.isNotEmpty){
// //     ChatUserModel chatUserModel = list[0];
// //     ref.read(chatUserModelNotifierProvider.notifier).setDataToSql(chatUserModelList: [
// //       ChatUserModel(userId: chatUserModel.userId, roomIcon: chatUserModel.roomIcon, cohesionLevel: chatUserModel.cohesionLevel, userCount: chatUserModel.userCount,
// //           isOnline: chatUserModel.isOnline, userName: chatUserModel.userName, roomId: chatUserModel.roomId, roomName: chatUserModel.roomName, points: chatUserModel.points,
// //           remark: chatUserModel.remark, unRead: 0, recentlyMessage: chatUserModel.recentlyMessage, timeStamp: chatUserModel.timeStamp, pinTop: chatUserModel.pinTop)]);
// //   }
// // }
// //算時間差
// // String calculateTimeDifference(int timeStamp1, int timeStamp2) {
// //   // 计算时间戳之间的时间差（秒）
// //   int differenceInSeconds = (timeStamp1 - timeStamp2).abs();
// //   // 计算小时、分钟和秒
// //   int hours = differenceInSeconds ~/ 3600;
// //   int minutes = (differenceInSeconds % 3600) ~/ 60;
// //   int seconds = differenceInSeconds % 60;
// //   // 格式化为字符串
// //   String formattedTime =
// //       '$hours:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
// //   return formattedTime;
// // }
//
// //emoji選中回傳
// // onBackspacePressed() {
// //   textEditingController!
// //     ..text = textEditingController!.text.characters.toString()
// //     ..selection = TextSelection.fromPosition(
// //         TextPosition(offset: textEditingController!.text.length));
// // }
//
// // String formatDuration(int seconds) {
// //   int hours = seconds ~/ 3600;
// //   int minutes = (seconds ~/ 60) % 60;
// //   int remainingSeconds = seconds % 60;
// //
// //   String hoursStr = hours.toString().padLeft(2, '0');
// //   String minutesStr = minutes.toString().padLeft(2, '0');
// //   String secondsStr = remainingSeconds.toString().padLeft(2, '0');
// //
// //   return '$hoursStr:$minutesStr:$secondsStr';
// // }
//
// // ZIMMessage _getFirstZimMsg(SearchListInfo searchListInfo) {
// //   final ChatMessageModel firstMsg = _getChatMsgFormUserName(searchListInfo).first;
// //   final ZIMMessage zimMessage = transferToZimMessage(firstMsg, false);
// //   return zimMessage;
// // }
// }
