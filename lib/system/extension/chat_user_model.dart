

import 'package:frechat/models/ws_res/notification/ws_notification_search_list_res.dart';
import 'package:frechat/system/database/model/chat_user_model.dart';

extension ChatUserModelExtension on ChatUserModel {
  SearchListInfo toSearchListInfo() {
    final SearchListInfo searchListInfo = SearchListInfo(
      roomId: roomId,
      roomName: roomName,
      roomIcon: roomIcon,
      userCount: userCount,
      cohesionLevel: cohesionLevel,
      points: points,
      isOnline: isOnline,
      userName: userName,
      userId: userId,
      remark: remark,
      notificationFlag: notificationFlag,
      sendStatus: sendStatus,
    );
    return searchListInfo;
  }
}