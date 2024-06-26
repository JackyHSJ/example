



import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frechat/system/call_back_function.dart';
import 'package:frechat/system/database/model/activity_message_model.dart';
import 'package:frechat/system/extension/json.dart';
import 'package:frechat/system/provider/activity_message_model_provider.dart';
import 'package:frechat/system/providers.dart';
import 'package:frechat/system/zego_call/interal/zim/zim_service_defines.dart';
import 'package:frechat/system/zego_call/zego_provider.dart';

class ActivityNotificationViewModel {

  WidgetRef ref;
  ViewChange setState;
  BuildContext context;

  ActivityNotificationViewModel({
    required this.setState,
    required this.ref,
    required this.context
  });

  ZIMMessageQueriedResult? zimMessageQueriedResult;

  void init() {
    readAllActivityMessage();
    fetchMoreActivityMessage();
  }

  void dispose() {

  }

  // 清除動態牆未讀訊息
  void readAllActivityMessage() {
    final zimService = ref.read(zimServiceProvider);
    zimService.clearUnReadMessageByConversationID(conversationID: 'feed_notify');
  }

  // 加載更多動態牆通知
  void fetchMoreActivityMessage() async {
    final bool messageListIsEmpty = zimMessageQueriedResult?.messageList.isEmpty ?? true;
    final ZIMMessageQueriedResult history = await ref.read(zimServiceProvider).searchHistoryMessageFromUserName(
      conversationID: 'feed_notify',
      nextMessage: messageListIsEmpty ? null : zimMessageQueriedResult?.messageList.first
    );

    if (zimMessageQueriedResult == null) {
      zimMessageQueriedResult = history;
    } else {
      zimMessageQueriedResult?.messageList.insertAll(0, history.messageList);
    }
    setState((){});
  }

  // convert to activityMessageModel
  static List<ActivityMessageModel> convertToActivityMessageModel(ZIMMessageQueriedResult? zimMessageQueriedResult) {
    List<ActivityMessageModel> models = zimMessageQueriedResult?.messageList.map((item) {
      item as ZIMTextMessage;
      final messageJsonObj = json.tryDecode(item.message);
      final ActivityMessageModel model = ActivityMessageModel.fromJson(messageJsonObj);
      return model;
    }).toList() ?? [];
    return models;
  }



}