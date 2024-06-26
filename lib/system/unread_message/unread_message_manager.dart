
import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frechat/models/ws_req/notification/ws_notification_search_online_status_req.dart';
import 'package:frechat/models/ws_res/notification/ws_notification_search_online_status_res.dart';
import 'package:frechat/system/database/model/chat_block_model.dart';
import 'package:frechat/system/database/model/chat_user_model.dart';
import 'package:frechat/system/network_status/network_status_callback.dart';
import 'package:frechat/system/network_status/network_status_setting.dart';
import 'package:frechat/system/online_status/online_status_setting.dart';
import 'package:frechat/system/provider/chat_block_model_provider.dart';
import 'package:frechat/system/provider/chat_user_model_provider.dart';
import 'package:frechat/system/provider/user_info_provider.dart';
import 'package:frechat/system/providers.dart';
import 'package:frechat/system/repository/response_code.dart';
import 'package:frechat/system/util/timer.dart';
import 'package:frechat/system/websocket/websocket_handler.dart';
import 'package:frechat/system/websocket/websocket_status.dart';
import 'package:frechat/system/zego_call/interal/zim/zim_service_defines.dart';
import 'package:frechat/system/zego_call/zego_provider.dart';

class UnreadMessageManager {

  ProviderRef ref;

  UnreadMessageManager({
    required this.ref
  });

  Future<void> updateUnreadCount() async {

    final ZIMConversationListQueriedResult result = await ref.read(zimServiceProvider).getConversationListPagination(null);
    final List<ZIMConversation> conversationList = result.conversationList;

    // 總未讀數
    int totalCount = 0;
    conversationList.forEach((item) {
      totalCount += item.unreadMessageCount;
    });

    // block list
    final List<ChatBlockModel> chatBlockModel = ref.read(chatBlockModelNotifierProvider);
    final List<ZIMConversation> blockConversationList = conversationList.where((item) {
      return chatBlockModel.any((elem) => elem.userName == item.conversationID);
    }).toList();

    // 動態通知未讀數
    int activityUnreadCount = 0;
    final List<ZIMConversation> feedNotify = conversationList.where((item) => item.conversationID == 'feed_notify').toList();
    if (feedNotify.isNotEmpty) activityUnreadCount = feedNotify.first.unreadMessageCount;

    // 黑名單未讀數
    int blockUnreadCount = 0;
    blockConversationList.forEach((item) {
      blockUnreadCount += item.unreadMessageCount;
    });

    // 消息頁未讀數 = 總未讀數 - 動態通知未讀數 - 黑名單未讀數
    int systemAndUserUnreadCount = totalCount - activityUnreadCount - blockUnreadCount;
    ref.read(userUtilProvider.notifier).setDataToPrefs(unreadMesg: systemAndUserUnreadCount);
    ref.read(userUtilProvider.notifier).setDataToPrefs(activityUnreadCount: activityUnreadCount);
  }
}