

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frechat/models/ws_res/notification/ws_notification_block_group_res.dart';
import 'package:frechat/system/database/model/chat_block_model.dart';
import 'package:frechat/system/providers.dart';

extension BlockListInfoExtension on BlockListInfo {
  ChatBlockModel toChatBlockModel({required num? userId}) {
    final ChatBlockModel blockListInfo = ChatBlockModel(
      userId: userId,
      friendId: friendId,
      filePath: filePath,
      nickName: nickName,
      userName: userName,
      age: age,
      gender: gender,
      selfIntroduction: selfIntroduction,
    );
    return blockListInfo;
  }
}