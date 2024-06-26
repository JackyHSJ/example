import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zyg_sqflite_plugin/zyg_sqflite_plugin.dart';

class ChatAudioModel extends SQFLiteHandler implements SQFLiteBaseTable {
  final ProviderRef? ref;
  final String? messageUuid; //UUID
  final num? senderId; //發送人ID
  final num? receiverId; //接收人ID
  final String? senderName; //發送人Name
  final String? receiverName; //接收人Name
  final String? audioPath; //錄音檔案位置
  final num? timeStamp; //錄音秒數

  ChatAudioModel({
    this.ref,
    this.messageUuid,
    this.senderId,
    this.receiverId,
    this.senderName, //發送人ID
    this.receiverName, //接收人ID
    this.audioPath,
    this.timeStamp,
  });

  @override
  String get createTableSql =>
      SQFLiteDDLUtil.create(model: ChatAudioModel(ref: ref));

  @override
  String get tableName => 'ChatAudioModel';

  @override
  List<SQFLiteColumnModel> get columns => [
        SQFLiteColumnModel(
            name: 'messageUuid', type: String, isPrimaryKey: true),
        SQFLiteColumnModel(
            name: 'senderId', type: int, foreignKey: 'ChatGiftModel(senderId)'),
        SQFLiteColumnModel(
            name: 'receiverId',
            type: int,
            foreignKey: 'ChatGiftModel(receiverId)'),
        SQFLiteColumnModel(
            name: 'senderName',
            type: String,
            foreignKey: 'ChatGiftModel(senderName)'),
        SQFLiteColumnModel(
            name: 'receiverName',
            type: String,
            foreignKey: 'ChatGiftModel(receiverName)'),
        SQFLiteColumnModel(name: 'audioPath', type: String),
        SQFLiteColumnModel(name: 'timeStamp', type: num),
      ];

  @override
  Map<String, dynamic> toMap() {
    return {
      'messageUuid': messageUuid,
      'senderId': senderId,
      'receiverId': receiverId,
      'senderName': senderName,
      'receiverName': receiverName,
      'audioPath': audioPath,
      'timeStamp': timeStamp,
    };
  }

  factory ChatAudioModel.fromJson(Map<String, dynamic> jsonData) {
    return ChatAudioModel(
      messageUuid: jsonData['messageUuid'] as String?,
      senderId: jsonData['senderId'] as int?,
      receiverId: jsonData['receiverId'] as int?,
      senderName: jsonData['senderName'] as String?,
      receiverName: jsonData['receiverName'] as String?,
      audioPath: jsonData['audioPath'] as String?,
      timeStamp: jsonData['timeStamp'] as num?,
    );
  }

  static String encode(ChatAudioModel chatAudioModel) =>
      json.encode(ChatAudioModel().toMap());

  static List<ChatAudioModel> decode(
      List<Map<String, dynamic>> chatAudioModel) {
    return chatAudioModel.map<ChatAudioModel>((item) {
      return ChatAudioModel.fromJson(item);
    }).toList();
  }
}
