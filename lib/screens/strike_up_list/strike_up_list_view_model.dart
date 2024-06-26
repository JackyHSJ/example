import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';
import 'package:frechat/models/ws_req/account/ws_account_quick_match_list_req.dart';
import 'package:frechat/models/ws_req/member/ws_member_point_coin_req.dart';
import 'package:frechat/models/ws_req/notification/ws_notification_search_list_req.dart';
import 'package:frechat/models/ws_res/member/ws_member_point_coin_res.dart';
import 'package:frechat/models/ws_res/notification/ws_notification_search_list_res.dart';
import 'package:frechat/screens/chatroom/chatroom.dart';
import 'package:frechat/system/base_view_model.dart';
import 'package:frechat/system/call_back_function.dart';
import 'package:frechat/system/database/model/chat_audio_model.dart';
import 'package:frechat/system/database/model/chat_gift_model.dart';
import 'package:frechat/system/database/model/chat_image_model.dart';
import 'package:frechat/system/database/model/chat_message_model.dart';
import 'package:frechat/system/database/model/chat_user_model.dart';
import 'package:frechat/system/extension/chat_user_model.dart';
import 'package:frechat/system/provider/chat_Gift_model_provider.dart';
import 'package:frechat/system/provider/chat_audio_model_provider.dart';
import 'package:frechat/system/provider/chat_image_model_provider.dart';
import 'package:frechat/system/provider/chat_message_model_provider.dart';
import 'package:frechat/system/provider/chat_user_model_provider.dart';
import 'package:frechat/system/provider/user_info_provider.dart';
import 'package:frechat/system/providers.dart';
import 'package:frechat/system/repository/response_code.dart';
import 'package:frechat/system/task_manager/task_manager.dart';
import 'package:frechat/system/zego_call/interal/zim/zim_service_defines.dart';
import 'package:frechat/system/zego_call/zego_provider.dart';

class StrikeUpListViewModel {
  StrikeUpListViewModel({
    required this.ref,
    required this.setState,
  });
  WidgetRef ref;
  ViewChange setState;

  init() {
    loadMemberCoinPoint();
  }
  dispose() {}

  // 用戶的 積分, 金幣（金幣+活動金幣）2-8
  Future<void> loadMemberCoinPoint() async {
    String resultCodeCheck = '';
    final WsMemberPointCoinReq reqBody = WsMemberPointCoinReq.create();
    final WsMemberPointCoinRes res = await ref.read(memberWsProvider).wsMemberPointCoin(reqBody,
      onConnectSuccess: (succMsg) => resultCodeCheck = succMsg,
      onConnectFail: (errMsg) => resultCodeCheck = errMsg,
    );

    if (resultCodeCheck == ResponseCode.CODE_SUCCESS) {
      ref.read(userUtilProvider.notifier).loadMemberPointCoin(res);
    } else {
      final BuildContext currentContext = BaseViewModel.getGlobalContext();

      if (currentContext.mounted) BaseViewModel.showToast(currentContext, ResponseCode.map[ResponseCode]!);
    }
    setState(() {});
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

  // 視頻速配新用戶
  Future<String> loadVideoMateList() async {
    String resultCodeCheck = '';

    const String type = '2';
    final WsAccountQuickMatchListReq reqBody = WsAccountQuickMatchListReq.create(
      type: type,
      page: 1
    );
    final res = await ref.read(accountWsProvider).wsAccountQuickMatchList(reqBody,
      onConnectSuccess: (succMsg) => resultCodeCheck = succMsg,
      onConnectFail: (errMsg) => resultCodeCheck = errMsg,
    );
    return resultCodeCheck;
  }
}
