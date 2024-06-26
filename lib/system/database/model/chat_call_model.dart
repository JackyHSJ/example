import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zyg_sqflite_plugin/zyg_sqflite_plugin.dart';


class ChatCallModel extends SQFLiteHandler implements SQFLiteBaseTable {
  final ProviderRef? ref;
  final String? messageUuid;
  final String? oppositeAvatarPath;
  final String? callerName;
  final String? receiverName;
  final num? groupID;
  final num? startTime;
  final num? endTime;
  final num? isGroupCall;
  final num? callType;//0:語音、1：視訊

  ChatCallModel({
    this.ref,
    this.messageUuid,
    this.oppositeAvatarPath,
    this.callerName,
    this.receiverName,
    this.groupID,
    this.startTime,
    this.endTime,
    this.isGroupCall,
    this.callType,
  });

  @override
  String get createTableSql => SQFLiteDDLUtil.create(model: ChatCallModel(ref: ref));

  @override
  String get tableName => 'ChatCallModel';

  @override
  List<SQFLiteColumnModel> get columns => [
    SQFLiteColumnModel(name: 'messageUuid', type: num, foreignKey: 'ChatMessageModel(messageUuid)'),
    SQFLiteColumnModel(name: 'callerName', type: num, foreignKey: 'ChatUserModel(userName)'),
    SQFLiteColumnModel(name: 'receiverName', type: num, foreignKey: 'ChatUserModel(userName)'),
    SQFLiteColumnModel(name: 'groupId', type: num, foreignKey: 'ChatUserModel(groupId)'),
    SQFLiteColumnModel(name: 'oppositeAvatarPath', type: String),
    SQFLiteColumnModel(name: 'startTime', type: num),
    SQFLiteColumnModel(name: 'endTime', type: num),
    SQFLiteColumnModel(name: 'isGroupCall', type: num),
    SQFLiteColumnModel(name: 'callType', type: num),
  ];

  @override
  Map<String, dynamic> toMap() {
    return {
      'messageUuid': messageUuid,
      'oppositeAvatarPath': oppositeAvatarPath,
      'callerName': callerName,
      'receiverName': receiverName,
      'groupID': groupID,
      'startTime': startTime,
      'endTime': endTime,
      'isGroupCall': isGroupCall,
      'callType': callType,
    };
  }

  factory ChatCallModel.fromJson(Map<String, dynamic> jsonData) {
    return ChatCallModel(
      messageUuid: jsonData['messageUuid'] as String?,
      oppositeAvatarPath: jsonData['oppositeAvatarPath'] as String?,
      callerName: jsonData['callerName'] as String?,
      receiverName: jsonData['receiverName'] as String?,
      groupID: jsonData['groupID'] as num?,
      startTime: jsonData['startTime'] as num?,
      endTime: jsonData['endTime'] as num?,
      isGroupCall: jsonData['isGroupCall'] as num?,
      callType: jsonData['callType'] as num?,
    );
  }

  static String encode(ChatCallModel chatImageModel) =>
      json.encode(ChatCallModel().toMap());

  static List<ChatCallModel> decode(
      List<Map<String, dynamic>> chatImageModel) {
    return chatImageModel.map<ChatCallModel>((item) {
      return ChatCallModel.fromJson(item);
    }).toList();
  }
}
