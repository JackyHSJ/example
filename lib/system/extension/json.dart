

import 'dart:convert';

import 'package:frechat/system/zego_call/interal/zim/zim_service_defines.dart';

extension JsonCodecExtension on JsonCodec {

  Map<String, dynamic> tryDecode(String jsonStr) {
    try {
      final Map<String, dynamic> messageJsonObj = json.decode(jsonStr);
      return messageJsonObj;
    } catch (e) {
      jsonStr = jsonStr.replaceAll('"{', '{').replaceAll('}"', '}');
      final Map<String, dynamic> messageJsonObj = json.decode(jsonStr);
      return messageJsonObj;
    }
  }

}
