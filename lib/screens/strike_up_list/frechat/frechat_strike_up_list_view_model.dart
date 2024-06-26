




import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frechat/screens/chatroom/chatroom.dart';
import 'package:frechat/system/base_view_model.dart';
import 'package:frechat/system/call_back_function.dart';
import 'package:frechat/system/database/model/chat_user_model.dart';
import 'package:frechat/system/extension/chat_user_model.dart';
import 'package:frechat/system/provider/chat_user_model_provider.dart';
import 'package:frechat/system/providers.dart';

class FrechatStrikeUpListViewModel {

  WidgetRef ref;
  ViewChange setState;
  BuildContext context;

  FrechatStrikeUpListViewModel({
    required this.ref,
    required this.setState,
    required this.context,
  });


  init() {
  }

  dispose() {

  }

  void pushToChatRoom(ChatUserModel chatUserModel) {
    final currentContext = BaseViewModel.getGlobalContext();
    if (currentContext.mounted) {
      BaseViewModel.pushPage(currentContext, ChatRoom(searchListInfo: chatUserModel.toSearchListInfo()));
    }
  }

  List<ChatUserModel> loadUnReadLastMsgList() {
    // final msgList = ref.watch(chatMessageModelNotifierProvider);
    final chatUserList = ref.watch(chatUserModelNotifierProvider);
    final String myUserName = ref.read(userInfoProvider).memberInfo?.userName ?? '';

    final List<ChatUserModel> unReadMsgList = chatUserList.where((user) {
      // 過濾掉已讀、senderName 是自己、senderName 是 feed_notify (動態牆通知)
      return user.unRead != 0 &&  user.userName != 'feed_notify' && user.userName != 'java_system' && user.userName != '';
    }).toList();

    // 使用fold方法按senderName分組訊息
    final Map<String, List<ChatUserModel>> groupedMessages =
    unReadMsgList.fold(
      {},
          (Map<String, List<ChatUserModel>> map, ChatUserModel msg) {
        if (!map.containsKey(msg.userName)) {
          map[msg.userName ?? ''] = [];
        }
        map[msg.userName ?? '']?.add(msg);
        return map;
      },
    );

    // 從每個組中選取最後一條訊息
    DateTime dateTimeNow = DateTime.now();
    final List<ChatUserModel> lastMessagesFromEachSender = [];
    groupedMessages.forEach((senderName, messages) {
      int lastTimStamp = messages.last.timeStamp!.toInt();
      DateTime date = DateTime.fromMillisecondsSinceEpoch(lastTimStamp);
      Duration difference = dateTimeNow.difference(date);
      int differenceInMinutes = difference.inMinutes;
      // 避免帳號換裝置首次登入時，顯示已讀訊息(5分鐘以內更換裝置保持顯示)
      if (differenceInMinutes < 5) {
        lastMessagesFromEachSender.add(messages.last);
      }
    });

    return lastMessagesFromEachSender;
  }
}