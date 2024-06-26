import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frechat/models/ws_req/activity/ws_activity_search_info_req.dart';
import 'package:frechat/models/ws_res/activity/ws_activity_search_info_res.dart';
import 'package:frechat/models/ws_res/notification/ws_notification_search_list_res.dart';
import 'package:frechat/screens/activity/activity_post_detail.dart';
import 'package:frechat/screens/chatroom/chatroom.dart';
import 'package:frechat/system/base_view_model.dart';
import 'package:frechat/system/database/model/chat_user_model.dart';
import 'package:frechat/system/global.dart';
import 'package:frechat/system/repository/http_setting.dart';
import 'package:frechat/system/repository/response_code.dart';
import 'package:frechat/system/util/avatar_util.dart';
import 'package:frechat/system/util/convert_util.dart';
import 'package:frechat/system/ws_comm/ws_activity.dart';
import 'package:frechat/widgets/constant_value.dart';
import 'package:frechat/widgets/home/home_msg_drift.dart';
import 'package:frechat/widgets/theme/app_theme.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:flutter_screenutil/src/size_extension.dart';


class LocalNotification {
  // 聊天室或官方訊息推播
  static void show({
    required String roomName,
    String? avatar,
    required String des,
    required num gender,
    required num roomId,
    required String sender,
    required bool isSystemMessage
  }) async {
    final Widget avatarWidget = (avatar == null || avatar == '')
        ? AvatarUtil.defaultAvatar(gender, size: 64.w)
        : (isSystemMessage) ? AvatarUtil.localAvatar('assets/avatar/system_avatar.png', size: 64.w) : AvatarUtil.userAvatar(HttpSetting.baseImagePath + avatar, size: 64.w);
    showSimpleNotification(
        GestureDetector(
          onTap: () => pushToChatRoom(sender),
          child: HomeMsgDrift(avatar: avatarWidget, nickName: roomName, des: des, replyText: '回复'),
        ),
        background: Colors.transparent,
        elevation: 0,
        duration: const Duration(seconds: 2),
        contentPadding: EdgeInsets.symmetric(horizontal: WidgetValue.horizontalPadding)
    );
  }

  // push 到聊天室
  static Future<void> pushToChatRoom(String? userName) async {
    final currentContext = BaseViewModel.getGlobalContext();
    final List<Map<String, dynamic>> jsonList = await ChatUserModel().selectMatching(model: ChatUserModel(userName: userName));
    final ChatUserModel chatUserModel = ChatUserModel.fromJson(jsonList.first);
    if(currentContext.mounted) {
      final Widget chatRoom = _getChatRoom(userName: userName, chatUserModel: chatUserModel);
      if(Navigator.canPop(currentContext)){
        BaseViewModel.pushReplacement(currentContext, chatRoom);
      }else{
        BaseViewModel.pushPage(currentContext, chatRoom);
      }
    }
  }

  static Widget _getChatRoom({
    required String? userName,
    required ChatUserModel chatUserModel
}) {
    Widget chatRoom = ChatRoom(
      searchListInfo: ConvertUtil.transferChatUserModelToSearchListInfo(chatUserModel),
      isSystem: (userName == 'java_system') ? true : false,
    );

    /// 引用插件當plugin用 帶入的Chat Room
    if(GlobalData.chatRoom != null) {
      chatRoom = (GlobalData.chatRoom as dynamic)
        ..searchListInfo = ConvertUtil.transferChatUserModelToSearchListInfo(chatUserModel)
        ..isSystem = (userName == 'java_system') ? true : false;
    }

    return chatRoom;
  }

  //
  //
  //
  //
  //

  // 動態牆推播
  static void activityShow({
    required String fromUserNickName,
    String? fromUserAvatar,
    required num fromUserGender,
    required String des,
    required num feedsId,
    required ActivityWs activityWs
  }) async {

    final Widget avatarWidget = fromUserAvatar == null || fromUserAvatar == ''
      ? AvatarUtil.defaultAvatar(fromUserGender, size: 64.w)
      : AvatarUtil.userAvatar(HttpSetting.baseImagePath + fromUserAvatar, size: 64.w);

    showSimpleNotification(
        GestureDetector(
          onTap: () => pushToActivityPost(feedsId, activityWs),
          child: HomeMsgDrift(avatar: avatarWidget, nickName: fromUserNickName, des: des, replyText: '去看看'),
        ),
        background: Colors.transparent,
        elevation: 0,
        duration: const Duration(seconds: 2),
        contentPadding: EdgeInsets.symmetric(horizontal: WidgetValue.horizontalPadding)
    );
}

  // push 到動態牆貼文
  static Future<void> pushToActivityPost(num feedsId, ActivityWs activityWs) async {
    String resultCodeCheck = '';
    final WsActivitySearchInfoReq reqBody = WsActivitySearchInfoReq.create(type: '6', condition: '0', id: feedsId);
    final WsActivitySearchInfoRes res = await activityWs.wsActivitySearchInfo(
      reqBody,
      onConnectSuccess: (succMsg) => resultCodeCheck = succMsg,
      onConnectFail: (errMsg) => resultCodeCheck = errMsg,
    );

    if (resultCodeCheck == ResponseCode.CODE_SUCCESS) {
      List<ActivityPostInfo?> list = res?.list ?? [];
      List<dynamic> likeList = res?.likeList ?? [];
      final currentContext = BaseViewModel.getGlobalContext();

      if (currentContext.mounted) {
        if (list.isNotEmpty) {
          BaseViewModel.pushPage(currentContext, ActivityPostDetail(postInfo: list.first!));
        } else {
          BaseViewModel.showToast(currentContext, '查无贴文');
        }
      }
    }
  }
}
