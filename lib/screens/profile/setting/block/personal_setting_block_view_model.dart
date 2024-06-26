
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frechat/system/base_view_model.dart';
import 'package:frechat/system/database/model/chat_block_model.dart';
import 'package:frechat/system/provider/chat_block_model_provider.dart';
import 'package:frechat/system/provider/user_info_provider.dart';
import 'package:frechat/system/unread_message/unread_message_manager.dart';
import 'package:frechat/widgets/shared/loading_animation.dart';

import '../../../../models/ws_req/notification/ws_notification_block_group_req.dart';
import '../../../../models/ws_req/notification/ws_notification_press_btn_and_remove_black_account_req.dart';
import '../../../../models/ws_res/notification/ws_notification_block_group_res.dart';
import '../../../../system/call_back_function.dart';
import '../../../../system/providers.dart';
import '../../../../system/repository/response_code.dart';

class PersonalSettingBlockViewModel{
  PersonalSettingBlockViewModel({required this.ref, required this.setState});
  WidgetRef ref;
  ViewChange setState;
  num currentPage = 1;
  List<BlockListInfo> blockList = [];
  WsNotificationBlockGroupRes notificationBlockGroupRes = WsNotificationBlockGroupRes(list: []);

  init(BuildContext context) {
    _loadBlockList(context, currentPage: currentPage);
  }

  dispose() {

  }

  _loadBlockList(BuildContext context, {required num currentPage}) async {
    String? resultCodeCheck;
    WsNotificationBlockGroupReq reqBody = WsNotificationBlockGroupReq.create(
      page: currentPage
    );
    final WsNotificationBlockGroupRes res = await ref.read(notificationWsProvider).wsNotificationBlockGroup(reqBody,
        onConnectSuccess: (succMsg) => resultCodeCheck = succMsg,
        onConnectFail: (errMsg) => BaseViewModel.showToast(context, ResponseCode.map[errMsg]!)
    );
    if(resultCodeCheck == ResponseCode.CODE_SUCCESS) {
      final List<BlockListInfo> list = res.list ?? [];
      notificationBlockGroupRes.list?.addAll(list);
      ref.read(userUtilProvider.notifier).loadNotificationBlockGroup(notificationBlockGroupRes);
    }
  }

  unlockBlockMember(BuildContext context, {required num friendId, required Function(String) onConnectFail}) async {
    String? resultCodeCheck;
    final reqBody = WsNotificationPressBtnAndRemoveBlackAccountReq.create(
        friendId: friendId
    );
    await ref.read(notificationWsProvider).wsNotificationPressBtnAndRemoveBlackAccount(reqBody,
        onConnectSuccess: (succMsg) => resultCodeCheck = succMsg,
        onConnectFail: (errMsg) => onConnectFail(errMsg)
    );

    if(resultCodeCheck == ResponseCode.CODE_SUCCESS) {
      notificationBlockGroupRes.list?.removeWhere((info) => info.friendId == friendId);
      ref.read(userUtilProvider.notifier).loadNotificationBlockGroup(notificationBlockGroupRes);
      await _removeBlockUserFromSqflite(friendId);
      await ref.read(unreadMessageManager).updateUnreadCount();
      BaseViewModel.showToast(context, '已取消拉黑');
    }
  }

  Future<void> _removeBlockUserFromSqflite(num? friendId) async {
    await ref.read(chatBlockModelNotifierProvider.notifier).clearSql(
      whereModel: ChatBlockModel(
        friendId: friendId
      )
    );
  }

  refreshHandler() {

  }

  fetchMoreHandler(BuildContext context) {
    currentPage++;
    _loadBlockList(context, currentPage: currentPage);
  }
}