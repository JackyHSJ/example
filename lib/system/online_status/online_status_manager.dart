
import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frechat/models/ws_req/notification/ws_notification_search_online_status_req.dart';
import 'package:frechat/models/ws_res/notification/ws_notification_search_online_status_res.dart';
import 'package:frechat/system/database/model/chat_user_model.dart';
import 'package:frechat/system/network_status/network_status_callback.dart';
import 'package:frechat/system/network_status/network_status_setting.dart';
import 'package:frechat/system/online_status/online_status_setting.dart';
import 'package:frechat/system/provider/chat_user_model_provider.dart';
import 'package:frechat/system/providers.dart';
import 'package:frechat/system/repository/response_code.dart';
import 'package:frechat/system/util/timer.dart';
import 'package:frechat/system/websocket/websocket_handler.dart';
import 'package:frechat/system/websocket/websocket_status.dart';

class OnlineStatusManager {
  OnlineStatusManager({required this.ref});
  ProviderRef ref;
  Timer? _timer;

  void init() {
    initTimer();
  }

  void dispose() {
    disposeTimer();
  }

  /// Init timer
  void initTimer() {
    if(_timer != null) {
      return;
    }
    _req();
    _timer = TimerUtil.periodic(
        timerType: OnlineStatusSetting.timerType,
        timerNum: OnlineStatusSetting.timerPeriodic,
        timerCallback: (time) => _req()
    );
  }

  void disposeTimer() {
    if(_timer == null) {
      return ;
    }
    _timer?.cancel();
    _timer = null;
  }

  _req() async {
    if(WebSocketHandler.socketStatus != SocketStatus.SocketStatusConnected) {
      return ;
    }

    String? resultCodeCheck;
    final WsNotificationSearchOnlineStatusReq req = WsNotificationSearchOnlineStatusReq.create();
    final WsNotificationSearchOnlineStatusRes res = await ref.read(notificationWsProvider).wsNotificationSearchOnlineStatus(req,
        onConnectSuccess: (succMsg) => resultCodeCheck = succMsg,
        onConnectFail: (errMsg) => resultCodeCheck = errMsg
    );

    if(resultCodeCheck == ResponseCode.CODE_SUCCESS) {
      _changeChatUserModelOnlineStatus(res);
    }
  }

  Future<void> _changeChatUserModelOnlineStatus(WsNotificationSearchOnlineStatusRes onlineStatusRes) async {
    final List<ChatUserModel> chatUserModelList = ref.read(chatUserModelNotifierProvider);
    /// 檢查是否為空
    if(chatUserModelList.length <= 1) {
      return ;
    }

    final List<ChatUserModel> resetList = chatUserModelList.where((model) => model.isOnline == 1).toList();

    final List<SearchOnlineStatusInfo> infoList = onlineStatusRes.list ?? [];
    final List<ChatUserModel> onlineList = chatUserModelList.where((model) {
      final bool isContain = infoList.any((info) => model.roomId == info.roomId);
      return isContain;
    }).toList();

    /// 將上線用戶改為離線, 為了更新為最新狀態
    await _resetToOffline(resetList);

    /// 將上線用戶改為上線
    await _updateToOnline(onlineList);
  }

  Future<void> _resetToOffline(List<ChatUserModel> resetList) async {
    for (var info in resetList) {
      await ref.read(chatUserModelNotifierProvider.notifier).updateDataToSql(
        updateModel: ChatUserModel(userName: info.userName, isOnline: 0),
        whereModel: ChatUserModel(userName: info.userName)
      );
    }
  }

  Future<void> _updateToOnline(List<ChatUserModel> onlineList) async {
    for (var info in onlineList) {
      await ref.read(chatUserModelNotifierProvider.notifier).updateDataToSql(
          updateModel: ChatUserModel(userName: info.userName, isOnline: 1),
          whereModel: ChatUserModel(userName: info.userName)
      );
    }
  }
}