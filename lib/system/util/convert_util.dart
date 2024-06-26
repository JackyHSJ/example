

import 'package:frechat/system/app_config/app_config.dart';
import 'package:frechat/models/ws_res/notification/ws_notification_search_list_res.dart';
import 'package:frechat/system/database/model/chat_user_model.dart';

class ConvertUtil {

  //將ChatUserModel轉成SearchListInfo
  static SearchListInfo? transferChatUserModelToSearchListInfo(ChatUserModel chatUserModel){
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

  // 備註名優先
  // 其次暱稱
  // 再來 userName
  static String displayName(String userName, String nickName, String remarkName) {
    if (remarkName.isNotEmpty) return remarkName;
    if (nickName.isNotEmpty) return nickName;
    if (userName.isNotEmpty) return userName;
    return userName;
  }

  // 轉人民幣
  static String toRMB(num income, {int decimal = 3}) {
    final double sum = income / AppConfig.RMBRatio;
    final String result = sum.toStringAsFixed(decimal).substring(0, sum.toStringAsFixed(decimal).length - 1);
    return result;
  }

  // 名稱太長取前 maxLength 個字加上 ...
  static String truncateString(String input, int maxLength) {
    if (input.length <= maxLength) {
      return input;
    } else {
      return "${input.substring(0, maxLength)}...";
    }
  }
}