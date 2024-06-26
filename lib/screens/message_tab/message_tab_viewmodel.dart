import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frechat/models/ws_req/notification/ws_notification_search_list_req.dart';
import 'package:frechat/models/ws_res/account/ws_account_official_message_res.dart';
import 'package:frechat/models/ws_res/notification/ws_notification_block_group_res.dart';
import 'package:frechat/models/ws_res/notification/ws_notification_search_list_res.dart';
import 'package:frechat/system/base_view_model.dart';
import 'package:frechat/system/call_back_function.dart';
import 'package:frechat/system/database/model/chat_audio_model.dart';
import 'package:frechat/system/database/model/chat_block_model.dart';
import 'package:frechat/system/database/model/chat_call_model.dart';
import 'package:frechat/system/database/model/chat_image_model.dart';
import 'package:frechat/system/database/model/chat_user_model.dart';
import 'package:frechat/system/extension/chat_user_model.dart';
import 'package:frechat/system/extension/json.dart';
import 'package:frechat/system/global.dart';
import 'package:frechat/system/online_status/online_status_manager.dart';
import 'package:frechat/system/provider/chat_audio_model_provider.dart';
import 'package:frechat/system/provider/chat_call_model_provider.dart';
import 'package:frechat/system/provider/chat_image_model_provider.dart';
import 'package:frechat/system/provider/chat_message_model_provider.dart';
import 'package:frechat/system/provider/chat_user_model_provider.dart';
import 'package:frechat/system/provider/user_info_provider.dart';
import 'package:frechat/system/providers.dart';
import 'package:frechat/system/repository/response_code.dart';
import 'package:frechat/system/zego_call/interal/zim/zim_service_defines.dart';
import 'package:frechat/system/zego_call/zego_provider.dart';
import 'package:frechat/widgets/shared/dialog/comm_dialog.dart';
import 'package:frechat/widgets/theme/app_color_theme.dart';
import 'package:frechat/widgets/theme/app_linear_gradient_theme.dart';
import 'package:frechat/widgets/theme/app_text_theme.dart';
import 'package:frechat/widgets/theme/app_theme.dart';
import 'package:frechat/widgets/theme/original/app_texts.dart';

class MessageTabViewModel {
  WidgetRef ref;
  ViewChange? setState;
  BuildContext context;

  MessageTabViewModel({required this.ref, this.setState, required this.context});

  WsNotificationSearchListRes? notificationSearchListRes;
  bool showBlockType = false;

  // get sendStatus => null; // 10. 審核中

  Future<void> init() async {
    ref.read(chatUserModelNotifierProvider.notifier).loadDataFromSql();
    showBlockType = ref.read(userInfoProvider).buttonConfigList?.blockType == 1 ? true : false;

    await getRoomList();
    /// 用戶上線狀態
    ref.read(onlineManagerProvider).init();
  }

  void deactivate() {
    ref.read(onlineManagerProvider).dispose();
  }

  initTab({
    required TickerProvider tickerProvider,
    required int tabLength
  }) {
    if(messageTabController != null) {
      return ;
    }
    messageTabController = TabController(vsync: tickerProvider, length: tabLength);
  }

  disposeTab() {
    if(messageTabController == null) {
      return ;
    }
    messageTabController?.dispose();
    messageTabController = null;
  }

  //取得列表
  Future<void> getRoomList() async {
    List<ChatUserModel> chatUserModel = [];
    final WsNotificationSearchListRes notiSearchList = await _getNotiSearchList();
    if (notiSearchList.list!.isNotEmpty) {
      // ref.read(userUtilProvider.notifier).loadNotificationListInfo(notificationSearchListRes!);
      List<ZIMConversation> zimConversationList = await loadZegoData(notiSearchList);
      for(int i =0; i<zimConversationList.length; i++){
        if(zimConversationList[i].conversationID != 'java_system'){
          final SearchListInfo searchListInfo = notiSearchList.list?.firstWhere((info) => info.userName == zimConversationList[i].conversationID) ?? SearchListInfo();
          // getHistoryMessageIntoDb(searchListInfo);
          num userId =  searchListInfo.userId!;
          String roomIcon =  searchListInfo.roomIcon ??"";
          num cohesionLevel = searchListInfo.cohesionLevel!;
          num userCount = searchListInfo.userCount!;
          num isOnline = searchListInfo.isOnline!;
          String userName = searchListInfo.userName!;
          num roomId = searchListInfo.roomId!;
          String? roomName = (searchListInfo.roomName == '' || searchListInfo.roomName == null)
              ? searchListInfo.userName!
              : searchListInfo.roomName;
          num points = searchListInfo.points!;
          String remark = searchListInfo.remark ?? '';
          String recentlyMessage ='';
          num timeStamp =0;
          num unRead =0;
          num sendStatus = searchListInfo.sendStatus ?? 1;
          if (searchListInfo.remark != null && searchListInfo.remark != '') {
            roomName = searchListInfo.remark!;
          }
          ZIMConversation zimConversation = zimConversationList[i];
          if(zimConversation.lastMessage != null){
            if(zimConversation.lastMessage!.type == ZIMMessageType.text){
              ///文字
              ZIMTextMessage? zimTextMessage = zimConversation.lastMessage as ZIMTextMessage?;
              Map<String, dynamic> messageDataMap = {};
              /// 解讀通話 與 一般文字訊息
              messageDataMap = json.tryDecode(zimTextMessage!.message);
              try {
                final WsAccountOfficialMessageRes content = WsAccountOfficialMessageRes.fromJson(messageDataMap['content']);
                final OfficialMessageInfo message = OfficialMessageInfo.fromJson(content.message);
                recentlyMessage = getCallingTypeRecentlyMessage(message.caller, formatDuration(message.duration!.toInt()), message.type, message.chatType);
              } catch (e) {
                /// 判斷是否為音黨
                recentlyMessage = messageDataMap['content'].toString();
                if(messageDataMap['type'] == 9) {
                  recentlyMessage = '[录音]';
                }
              }
              timeStamp = zimTextMessage.timestamp;
              unRead = zimConversation.unreadMessageCount;
            } else if(zimConversation.lastMessage!.type == ZIMMessageType.image){
              ///圖片
              ZIMImageMessage? zimImageMessage = zimConversation.lastMessage as ZIMImageMessage?;
              Map<String, dynamic> extendedDataMap = {};
              extendedDataMap = json.decode(zimImageMessage!.extendedData) as Map<String, dynamic>;
              recentlyMessage = '[图片]';
              if(zimImageMessage.fileDownloadUrl == '') {
                recentlyMessage = '[具有违规图片]';
              }
              timeStamp = zimImageMessage.timestamp;
              unRead = zimConversation.unreadMessageCount;
              String uuid = extendedDataMap['uuid'];
              //更新DB圖片位置為url
              ref.read(chatImageModelNotifierProvider.notifier).setDataToSql(chatImageModelList: [
                ChatImageModel(
                  messageUuid: uuid,
                  senderId: ref.read(userInfoProvider).userId,
                  senderName: ref.read(userInfoProvider).userName,
                  receiverId: userId,
                  receiverName: userName,
                  imagePath: (zimImageMessage.fileDownloadUrl.isEmpty)?zimImageMessage.fileLocalPath:zimImageMessage.fileDownloadUrl,
                )]);
            }else{
              ///錄音
              ZIMFileMessage? zimFileMessage = zimConversation.lastMessage! as ZIMFileMessage?;
              Map<String, dynamic> extendedDataMap = {};
              extendedDataMap = json.decode(zimFileMessage!.extendedData) as Map<String, dynamic>;
              recentlyMessage = '[录音]';
              /// 預留處理 shumei 用
              if(zimFileMessage.fileDownloadUrl == '') {
                recentlyMessage = '[录音]';
              }
              timeStamp = zimFileMessage.timestamp;
              unRead = zimConversation.unreadMessageCount;
              String uuid = extendedDataMap['uuid'];
              //更新DB錄音位置為url
              ref.read(chatAudioModelNotifierProvider.notifier).setDataToSql(chatAudioModelList: [
                ChatAudioModel(
                  messageUuid: uuid,
                  senderId: ref.read(userInfoProvider).userId,
                  senderName: ref.read(userInfoProvider).userName,
                  receiverId: userId,
                  receiverName: userName,
                  audioPath: zimFileMessage.fileDownloadUrl,
                )]);
            }

            final allChatUserModelList = ref.read(chatUserModelNotifierProvider);
            final catUserModelList = allChatUserModelList.where((info) => info.userName == userName).toList();
            num pinTop = 0;
            if(catUserModelList.isNotEmpty){
              if(catUserModelList[0].pinTop == null){
                pinTop = 0;
              }else{
                pinTop = catUserModelList[0].pinTop!;
              }
            }
            chatUserModel.add(ChatUserModel(userId: userId, roomIcon: roomIcon, cohesionLevel: cohesionLevel, userCount: userCount, isOnline: isOnline,
                userName:userName, roomId:roomId, roomName: roomName, points: points, remark: remark, recentlyMessage: recentlyMessage, unRead: unRead,
                timeStamp: timeStamp, pinTop: pinTop,sendStatus:sendStatus));
          }
        } else {
          num userId =  0;
          String roomIcon = 'assets/images/system_avatar.png';
          num cohesionLevel = 0;
          num userCount = 0;
          num isOnline = 0;
          String userName = 'java_system';
          num roomId = 0;
          String roomName = '官方讯息';
          num points = 0;
          String remark = '';
          String recentlyMessage ='';
          num timeStamp =0;
          num unRead =0;
          num sendStatus = 1;

          ZIMConversation zimConversation = zimConversationList[i];
          ZIMTextMessage? zimTextMessage = zimConversation.lastMessage as ZIMTextMessage?;
          Map<String, dynamic> messageDataMap = {};
          messageDataMap = json.decode(zimTextMessage!.message) as Map<String, dynamic>;
          final contentMap = messageDataMap['content'];

          if (messageDataMap['type'] == 3) {
            // 任務紅包
            int gender = ref.read(userInfoProvider).memberInfo?.gender?.toInt() ?? 0;
            final List<String> titles = contentMap['message'].split('-')[gender].split('/');
            final String title = '${titles[0]}已完成';
            recentlyMessage = title;
          } else {
            // 暫時處理後端傳值格式不對問題
            try{
              recentlyMessage =  contentMap['message'];
            }catch(e){
              recentlyMessage = contentMap;
            }
          }

          timeStamp = zimTextMessage.timestamp;
          unRead = zimConversation.unreadMessageCount;

          final allChatUserModelList = ref.read(chatUserModelNotifierProvider);
          final catUserModelList = allChatUserModelList.where((info) => info.userName == userName).toList();
          num pinTop = 0;
          if(catUserModelList.isNotEmpty){
            pinTop = catUserModelList[0].pinTop!;
          }
          chatUserModel.add(ChatUserModel(userId: userId, roomIcon: roomIcon, cohesionLevel: cohesionLevel, userCount: userCount, isOnline: isOnline,
              userName:userName, roomId:roomId, roomName: roomName, points: points, remark: remark, recentlyMessage: recentlyMessage, unRead: unRead,
              timeStamp: timeStamp, pinTop: pinTop,sendStatus: sendStatus));
        }
      }
      ///存入DB
      await ref.read(chatUserModelNotifierProvider.notifier).setDataToSql(chatUserModelList: chatUserModel);
    }else{
      List<SearchListInfo>? list = [SearchListInfo(userName: 'java_system')];
      WsNotificationSearchListRes wsNotificationSearchListRes = WsNotificationSearchListRes(list: list);
      List<ZIMConversation> zimConversationList = await loadZegoData(wsNotificationSearchListRes);
      num userId =  0;
      String roomIcon = 'assets/images/system_avatar.png';
      num cohesionLevel = 0;
      num userCount = 0;
      num isOnline = 0;
      String userName = 'java_system';
      num roomId = 0;
      String roomName = '官方讯息';
      num points = 0;
      String remark = '';
      String recentlyMessage ='';
      num timeStamp =0;
      num unRead =0;
      num sendStatus = 1;

      ZIMConversation zimConversation;
      final javalSystemzimConversationList = zimConversationList.where((info) => info.conversationID == 'java_system').toList();
      if(javalSystemzimConversationList.isNotEmpty){
        zimConversation = javalSystemzimConversationList[0];
      }else{
        zimConversation = ZIMConversation();
      }
      ZIMTextMessage? zimTextMessage = zimConversation.lastMessage as ZIMTextMessage?;
      Map<String, dynamic> messageDataMap = {};
      messageDataMap = json.decode(zimTextMessage?.message ?? '{}') as Map<String, dynamic>;
      final contentMap = messageDataMap['content'];

      if (messageDataMap['type'] == 3) {
        // 任務紅包
        int gender = ref.read(userInfoProvider).memberInfo?.gender?.toInt() ?? 0;
        final List<String> titles = contentMap['message'].split('-')[gender].split('/');
        final String title = '${titles[0]}已完成';
        recentlyMessage = title;
      } else {
        // 暫時處理後端傳值格式不對問題
        try{
          recentlyMessage =  contentMap['message'];
        }catch(e){
          recentlyMessage = contentMap ?? '';
        }
      }

      timeStamp = zimTextMessage?.timestamp ?? 0;
      unRead = zimConversation.unreadMessageCount;
      await ref.read(chatUserModelNotifierProvider.notifier).setDataToSql(chatUserModelList: [
        ChatUserModel(userId: userId, roomIcon: roomIcon, cohesionLevel: cohesionLevel, userCount: userCount, isOnline: isOnline,
            userName:userName, roomId:roomId, roomName: roomName, points: points, remark: remark, recentlyMessage: recentlyMessage, unRead: unRead,
            timeStamp: timeStamp, pinTop: 0,sendStatus: sendStatus)
      ]);
    }
  }


  Future<WsNotificationSearchListRes> _getNotiSearchList() async {
    await ref.read(authenticationProvider).loadSearchListInDB() ?? [];
    final List<ChatUserModel> list = ref.read(chatUserModelNotifierProvider);
    final List<SearchListInfo> searchInfoList = list.map((info) => info.toSearchListInfo()).toList();
    final result = WsNotificationSearchListRes(list: searchInfoList);
    return result;
  }

  //通话讯息转时间
  String formatDuration(int seconds) {
    int hours = seconds ~/ 3600;
    int minutes = (seconds ~/ 60) % 60;
    int remainingSeconds = seconds % 60;

    String hoursStr = hours.toString().padLeft(2, '0');
    String minutesStr = minutes.toString().padLeft(2, '0');
    String secondsStr = remainingSeconds.toString().padLeft(2, '0');

    return '$hoursStr:$minutesStr:$secondsStr';
  }

  //讀取Zego列表取得最近消息和未讀數量
  Future<List<ZIMConversation>> loadZegoData(WsNotificationSearchListRes searchListRes) async {
    final zimService = ref.read(zimServiceProvider);
    List<ZIMConversation> zimConversationList = await zimService.getConversationList();
    return zimConversationList;
  }

  //排序消息列表
  List<ChatUserModel> sortChatUsers(List<ChatUserModel> userList) {
    // 首先将 pinTop 为 1 的 ChatUserModel 排到前面
    List<ChatUserModel> pinnedUsers = [];
    List<ChatUserModel> nonPinnedUsers = [];

    for (var user in userList) {
      if (user.pinTop == 1 || user.userName == 'java_system') {
        pinnedUsers.add(user);
      } else {
        nonPinnedUsers.add(user);
      }
    }
    // 对置顶的用户按照 timeStamp 排序，最新时间在最前面
    pinnedUsers.sort((a, b) => b.timeStamp!.compareTo(a.timeStamp!));
    // 对非置顶的用户按照 timeStamp 排序，最新时间在最前面
    nonPinnedUsers.sort((a, b) => b.timeStamp!.compareTo(a.timeStamp!));
    // 合并两个列表：置顶的用户在前面，非置顶用户也按照时间排序
    List<ChatUserModel> sortedUsers = [...pinnedUsers, ...nonPinnedUsers];

    bool isContainJavaSystem = false;
    int index = 0;
    ChatUserModel? chatUserModelJavaSystem;
    for(int i =0;i<sortedUsers.length;i++){
      ChatUserModel chatUserModel = sortedUsers[i];
      if(chatUserModel.userName == 'java_system'){
        chatUserModelJavaSystem = chatUserModel;
        isContainJavaSystem = true;
        index = i;
        break;
      }
    }
    if(isContainJavaSystem){
      sortedUsers.removeAt(index);
      sortedUsers.insert(0, chatUserModelJavaSystem!);
    } else {
      if (showBlockType) {
        sortedUsers.insert(0, ChatUserModel(userName: "java_system", points: 0, roomName: '官方讯息'));
      }
    }

    return sortedUsers;
  }

  //取得极构历史纪录并写入DB
  // Future<void> getHistoryMessageIntoDb(SearchListInfo searchListInfo) async {
  //   final zimService = ref.read(zimServiceProvider);
  //   final ZIMMessageQueriedResult history = await zimService.searchHistoryMessageFromUserName(
  //       conversationID: searchListInfo.userName!);
  //   final list = history.messageList;
  //   if(list.isNotEmpty){
  //     List<ChatCallModel> chatCallModelList = [];
  //     for(int i =0;i<list.length;i++){
  //       ZIMMessage zimMessage = list[i];
  //       if(zimMessage.type == ZIMMessageType.text){
  //         ZIMTextMessage? zimTextMessage = zimMessage as ZIMTextMessage?;
  //         if(zimTextMessage!.message.contains('chatType')){
  //           Map<String, dynamic> messageDataMap = {};
  //           messageDataMap = json.decode(zimTextMessage!.message) as Map<String, dynamic>;
  //           Map? officialMessageInfoMap = messageDataMap['content']['message'];
  //           ChatCallModel chatCallModel = ChatCallModel(
  //             messageUuid: messageDataMap['uuid'],
  //             oppositeAvatarPath: searchListInfo.roomIcon,
  //             callerName: officialMessageInfoMap!['caller'],
  //             receiverName: officialMessageInfoMap!['answer'],
  //             groupID: searchListInfo.roomId,
  //             startTime: 0,
  //             endTime: officialMessageInfoMap!['duration'],
  //             isGroupCall: 0,
  //             callType: officialMessageInfoMap!['chatType'],
  //           );
  //           chatCallModelList.add(chatCallModel);
  //         }
  //       }
  //     }
  //     ref.read(chatCallModelNotifierProvider.notifier).setDataToSql(
  //         chatCallModelList: chatCallModelList
  //     );
  //   }
  // }

  //取得通話類型的最近消息
  String getCallingTypeRecentlyMessage(String? caller,String duration, num? type,num? chatType){
    final String userName = ref.read(userInfoProvider).memberInfo?.userName ?? '';
    String msg = '';
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

  /// 判斷 最新訊息不為空 && 是否為blockUser
  List<ChatUserModel> filterChatUserModelList({
    required List<ChatUserModel> chatUserModelList,
    required List<ChatBlockModel> chatBlockModelList
  }) {
    final List<ChatUserModel> filterList = chatUserModelList.where((info) {
      final bool msgIsNotEmpty = info.recentlyMessage?.isNotEmpty ?? false;
      /// 檢查 黑名單內用戶與列表內做比對移除、當chatBlockModel則直接給予true過
      final bool isContainBlock = chatBlockModelList.any((blockUser) => blockUser.userName == info.userName);
      return isContainBlock == false && msgIsNotEmpty;
    }).toList();
    return filterList;
  }

  //一鍵已讀彈窗
  Future<void> oneCLickRead(AppTheme appTheme,AppColorTheme appColorTheme,AppLinearGradientTheme appLinearGradientTheme,AppTextTheme appTextTheme, {
    required List<ChatUserModel> chatUserModelList,
    required List<ChatBlockModel> chatBlockModelList
  }) async {
    CommDialog(context).build(
        theme: appTheme,
        backgroundColor: appColorTheme.dialogBackgroundColor,
        title: '一键已读',
        contentDes: '消息气泡会清除，但消息不会消失',
        leftBtnTitle: '取消',
        rightBtnTitle: '确定',
        leftLinearGradient: appLinearGradientTheme.buttonSecondaryColor,
        rightLinearGradient: appLinearGradientTheme.buttonPrimaryColor,
        leftTextStyle: appTextTheme.buttonSecondaryTextStyle,
        rightTextStyle: appTextTheme.buttonPrimaryTextStyle,
        leftAction: () => BaseViewModel.popPage(context),
        rightAction: () async {
          final zimService = ref.read(zimServiceProvider);

          zimService.clearAllUnReadMessage();
          for(int i = 0; i < chatUserModelList.length; i++) {
            final ChatUserModel model = chatUserModelList[i];
            zimService.receiveMessage(conversationID: model.userName!);

            /// 更新資料庫
            ref.read(chatUserModelNotifierProvider.notifier).updateDataToSql(
                updateModel: ChatUserModel(userName: model.userName, unRead: 0),
                whereModel: ChatUserModel(userName: model.userName)
            );
          }
          BaseViewModel.popupDialog();
          // BaseViewModel.popPage(context);
        }
    );
  }

  //清除訊息彈窗
  Future<void> clearMessage(AppTheme appTheme,AppColorTheme appColorTheme,AppLinearGradientTheme appLinearGradientTheme,AppTextTheme appTextTheme) async {
    CommDialog(context).build(
        theme: appTheme,
        backgroundColor: appColorTheme.dialogBackgroundColor,
        title: '删除全部消息',
        contentDes: '删除后数据无法恢复，请谨慎操作',
        leftBtnTitle: '考虑一下',
        leftLinearGradient: appLinearGradientTheme.buttonSecondaryColor,
        rightLinearGradient: appLinearGradientTheme.buttonPrimaryColor,
        leftTextStyle: appTextTheme.buttonSecondaryTextStyle,
        rightTextStyle: appTextTheme.buttonPrimaryTextStyle,
        rightBtnTitle: '确定删除',
        leftAction: () {
          BaseViewModel.popPage(context);
        },
        rightAction: () {
          if(context.mounted){
            final userModel = ref.read(chatUserModelNotifierProvider);
            final zimService = ref.read(zimServiceProvider);
            List<ChatUserModel> list = [];
            for(int i =0;i<userModel.length;i++){
              ///消息列表清除
              ChatUserModel chatUserModel = userModel[i];
              list.add( ChatUserModel(userId: chatUserModel.userId, roomIcon: chatUserModel.roomIcon, cohesionLevel: chatUserModel.cohesionLevel, userCount: chatUserModel.userCount,
                  isOnline: chatUserModel.isOnline, userName: chatUserModel.userName, roomId: chatUserModel.roomId, roomName: chatUserModel.roomName, points: chatUserModel.points,
                  remark: chatUserModel.remark, unRead: 0, recentlyMessage: '', timeStamp: chatUserModel.timeStamp, pinTop: chatUserModel.pinTop,sendStatus: chatUserModel.sendStatus,));
              // ref.read(chatUserModelNotifierProvider.notifier).clearSql(whereModel: userModel[i]);
              ///清除極構歷史資料
              zimService.deleteMessage(conversationID: userModel[i].userName!);
            }
            ref.read(chatUserModelNotifierProvider.notifier).setDataToSql(chatUserModelList: list);
            ///訊息删除
            final allChatMessageModelList = ref.read(chatMessageModelNotifierProvider);
            for(int i=0;i<allChatMessageModelList.length;i++){
              for(int i =0;i<allChatMessageModelList.length;i++){
                ref.read(chatMessageModelNotifierProvider.notifier).clearSql(whereModel: allChatMessageModelList[i]);
              }
            }
          }
          BaseViewModel.popPage(context);
          BaseViewModel.popPage(context);
        }
    );
  }

  //將ChatUserModel轉成SearchListInfo
  SearchListInfo? transferChatUserModelToSearchListInfo(ChatUserModel chatUserModel){
    SearchListInfo? searchListInfo;
    if (chatUserModel != null) {
      searchListInfo = SearchListInfo(
        roomId: chatUserModel.roomId,
        roomName: chatUserModel.roomName,
        roomIcon: chatUserModel.roomIcon,
        userCount: chatUserModel.userCount,
        cohesionLevel: chatUserModel.cohesionLevel,
        points: chatUserModel.points,
        isOnline: chatUserModel.isOnline,
        userName: chatUserModel.userName,
        userId: chatUserModel.userId,
        remark: chatUserModel.remark,
      );
    }
    return searchListInfo;
  }

}