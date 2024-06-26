
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frechat/models/ws_req/notification/ws_notification_search_info_with_type_req.dart';
import 'package:frechat/models/ws_req/notification/ws_notification_search_list_req.dart';
import 'package:frechat/models/ws_res/notification/ws_notification_search_info_with_type_res.dart';
import 'package:frechat/models/ws_res/notification/ws_notification_search_list_res.dart';
import 'package:frechat/system/call_back_function.dart';
import 'package:frechat/system/database/model/chat_message_model.dart';
import 'package:frechat/system/database/model/chat_user_model.dart';
import 'package:frechat/system/extension/chat_user_model.dart';
import 'package:frechat/system/provider/chat_user_model_provider.dart';
import 'package:frechat/system/provider/user_info_provider.dart';
import 'package:frechat/system/providers.dart';
import 'package:frechat/system/repository/response_code.dart';

class StrikeUpListMsgCapsuleDriftViewModel {
  StrikeUpListMsgCapsuleDriftViewModel({
    required this.ref,
    required this.setState,
  });

  WidgetRef ref;
  ViewChange setState;

  String? avatar;
  String? name;

  init() {
  }

  dispose() {

  }



  ChatUserModel getSenderInfo(BuildContext context, {required ChatMessageModel chatMessageModel}) {
    try{
      final List<ChatUserModel> chatUserModelList = ref.watch(chatUserModelNotifierProvider);
      final ChatUserModel chatUserModel = chatUserModelList.firstWhere((model) => model.userName == chatMessageModel.senderName);
      return chatUserModel;
    } catch(e) {
      return ChatUserModel();
    }
  }

  String checkAndDecodeContentForCallMsg({required ChatMessageModel chatMessageModel}) {
    String msg = chatMessageModel.content ?? '';
    try{
      Map officialMessageInfoMap = json.decode(chatMessageModel.content!);
      msg = getCallingTypeRecentlyMessage(chatMessageModel.senderName,msg,_formatDuration(officialMessageInfoMap['duration']), officialMessageInfoMap['type'], officialMessageInfoMap['chatType']);
      return msg;
    } catch(e) {
      return msg;
    }
  }

  String _formatDuration(int seconds) {
    int hours = seconds ~/ 3600;
    int minutes = (seconds ~/ 60) % 60;
    int remainingSeconds = seconds % 60;

    String hoursStr = hours.toString().padLeft(2, '0');
    String minutesStr = minutes.toString().padLeft(2, '0');
    String secondsStr = remainingSeconds.toString().padLeft(2, '0');

    return '$hoursStr:$minutesStr:$secondsStr';
  }


  String getCallingTypeRecentlyMessage(String? caller,String message,String duration, num? type,num? chatType){
    final String userName = ref.read(userInfoProvider).memberInfo?.userName ?? '';
    String msg = message;
    switch(type){
      case 0:
        if(chatType == 1 || chatType == 7){
          msg = '语音通话:'+duration;
        }else{
          msg = '视频通话:'+duration;
        }
        break;
      case 1:
        String typeString = "";
        if(chatType == 1 || chatType == 7){
          typeString = '语音通话';
        }else{
          typeString = '视频通话';
        }
        if(caller == userName){
          msg = '$typeString已取消';
        }else{
          msg = '未接听$typeString';
        }
        break;
      case 2:
        if(chatType == 1 || chatType == 7){
          msg = '语音通话已拒绝';

        }else{
          msg = '视频通话已拒绝';
        }
        break;
      default:
        break;
    }
    return msg;
  }
}