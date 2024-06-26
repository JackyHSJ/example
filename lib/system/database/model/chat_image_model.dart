import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zyg_sqflite_plugin/zyg_sqflite_plugin.dart';

class ChatImageModel extends SQFLiteHandler implements SQFLiteBaseTable {
  final ProviderRef? ref;
  final String? messageUuid; //UUID
  final num? senderId; //發送人ID
  final num? receiverId; //接收人ID
  final String? senderName; //發送人Name
  final String? receiverName; //接收人Name
  final String? imagePath; //圖片檔案位置
  final num? timeStamp; //時間戳

  ChatImageModel({
    this.ref,
    this.messageUuid,
    this.senderId,
    this.receiverId,
    this.senderName,
    this.receiverName,
    this.imagePath,
    this.timeStamp,
  });

  @override
  String get createTableSql =>
      SQFLiteDDLUtil.create(model: ChatImageModel(ref: ref));

  @override
  String get tableName => 'ChatImageModel';

  @override
  List<SQFLiteColumnModel> get columns => [
        SQFLiteColumnModel(
            name: 'messageUuid', type: String, isPrimaryKey: true),
        SQFLiteColumnModel(
            name: 'senderId',
            type: num,
            foreignKey: 'ChatImageModel(senderId)'),
        SQFLiteColumnModel(
            name: 'receiverId',
            type: num,
            foreignKey: 'ChatImageModel(receiverId)'),
        SQFLiteColumnModel(
            name: 'senderName',
            type: String,
            foreignKey: 'ChatImageModel(senderName)'),
        SQFLiteColumnModel(
            name: 'receiverName',
            type: String,
            foreignKey: 'ChatImageModel(receiverName)'),
        SQFLiteColumnModel(name: 'imagePath', type: String),
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
      'imagePath': imagePath,
      'timeStamp': timeStamp,
    };
  }

  factory ChatImageModel.fromJson(Map<String, dynamic> jsonData) {
    return ChatImageModel(
      messageUuid: jsonData['messageUuid'] as String?,
      senderId: jsonData['senderId'] as num?,
      receiverId: jsonData['receiverId'] as num?,
      senderName: jsonData['senderName'] as String?,
      receiverName: jsonData['receiverName'] as String?,
      imagePath: jsonData['imagePath'] as String?,
      timeStamp: jsonData['timeStamp'] as num?,
    );
  }

  static String encode(ChatImageModel chatImageModel) =>
      json.encode(ChatImageModel().toMap());

  static List<ChatImageModel> decode(
      List<Map<String, dynamic>> chatImageModel) {
    return chatImageModel.map<ChatImageModel>((item) {
      return ChatImageModel.fromJson(item);
    }).toList();
  }
}
