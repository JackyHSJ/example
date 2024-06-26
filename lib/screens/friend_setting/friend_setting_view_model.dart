

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frechat/models/ws_req/notification/ws_notification_block_group_req.dart';
import 'package:frechat/models/ws_req/notification/ws_notification_leave_group_block_req.dart';
import 'package:frechat/models/ws_res/notification/ws_notification_block_group_res.dart';
import 'package:frechat/models/ws_res/notification/ws_notification_leave_group_block_res.dart';
import 'package:frechat/models/ws_res/notification/ws_notification_search_list_res.dart';
import 'package:frechat/system/base_view_model.dart';
import 'package:frechat/system/call_back_function.dart';
import 'package:frechat/system/database/model/chat_block_model.dart';
import 'package:frechat/system/provider/chat_block_model_provider.dart';
import 'package:frechat/system/provider/user_info_provider.dart';
import 'package:frechat/system/providers.dart';
import 'package:frechat/system/repository/response_code.dart';

class FriendSettingViewModel {
  FriendSettingViewModel({required this.ref, required this.setState});
  WidgetRef ref;
  ViewChange setState;

  //拉黑、退出群組(4-3)
  Future<WsNotificationLeaveGroupBlockRes> wsNotificationLeaveGroupBlock({required num roomId, required Function(String) onConnectSuccess, required Function(String) onConnectFail,
  }) async {
    final reqBody = WsNotificationLeaveGroupBlockReq.create(roomId: roomId);
    final WsNotificationLeaveGroupBlockRes res = await ref.read(notificationWsProvider).wsNotificationLeaveGroupBlock(reqBody, onConnectSuccess: (succMsg) {
      onConnectSuccess(succMsg);
    }, onConnectFail: (errMsg) {
      onConnectFail(errMsg);
    });

    return res;
  }

  insertBlockInfoToSqfLite(SearchListInfo searchListInfo) async {
    final num? userId = ref.read(userInfoProvider).userId;
    final model = ChatBlockModel(
      userId: userId,
      friendId: searchListInfo.userId,
      nickName: searchListInfo.remark ?? searchListInfo.roomName,
      filePath: searchListInfo.roomIcon,
      userName: searchListInfo.userName,
    );
    await ref.read(chatBlockModelNotifierProvider.notifier).setDataToSql(chatBlockModelList: [model]);
    await ref.read(unreadMessageManager).updateUnreadCount();
  }
}