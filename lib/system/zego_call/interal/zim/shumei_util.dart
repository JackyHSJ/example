

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frechat/system/base_view_model.dart';
import 'package:frechat/system/zego_call/interal/zim/zim_service_defines.dart';

class ShumeiUtil {
  static const String _errCode = '111101';

  static checkShumeiMsg(Object? error) {
    error as PlatformException;
    final String errorMessage = error.message ?? '';
    if(errorMessage.contains(_errCode)) {
      final BuildContext currentContext = BaseViewModel.getGlobalContext();
      BaseViewModel.showToast(currentContext, '您的发言内容不恰当，请注意我们的用户协议');
    }
  }
  static bool isShumeiMsg(Object? error){
    error as PlatformException;
    final String errorMessage = error.message ?? '';
    if(errorMessage.contains(_errCode)) {
      return true;
    }
    return false;
  }

  static ZIMConversation checkLastMsg(ZIMConversation info) {
    if(info.lastMessage?.type == ZIMMessageType.text) {
      final ZIMTextMessage result = _fixZimTextMsg(info);
      info.lastMessage = result;
    } else if(info.lastMessage?.type == ZIMMessageType.image) {
      final ZIMImageMessage result = _fixZimImgMsg(info);
      info.lastMessage = result;
    }// else if (info.lastMessage?.type == ZIMMessageType.file) {
    //   final ZIMFileMessage result = _fixZimFileMsg(info);
    //   info.lastMessage = result;
    // }
    return info;
  }

  static ZIMTextMessage _fixZimTextMsg(ZIMConversation info) {
    final ZIMTextMessage textMsg = info.lastMessage as ZIMTextMessage;
    final String message = textMsg.message;
    final Map<String, dynamic> jsonObj = json.decode(message);
    jsonObj['content'] = '具有违规内容';
    textMsg.message = json.encode(jsonObj);
    return textMsg;
  }

  static ZIMImageMessage _fixZimImgMsg(ZIMConversation info) {
    final ZIMImageMessage imgMsg = info.lastMessage as ZIMImageMessage;
    imgMsg.fileDownloadUrl = '';
    return imgMsg;
  }

  // static ZIMFileMessage _fixZimFileMsg(ZIMConversation info) {
  //   final ZIMFileMessage fileMsg = info.lastMessage as ZIMFileMessage;
  //   fileMsg.fileDownloadUrl = '';
  //   return fileMsg;
  // }
}