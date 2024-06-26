import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zyg_sqflite_plugin/zyg_sqflite_plugin.dart';

class ChatGiftModel extends SQFLiteHandler implements SQFLiteBaseTable {
  final ProviderRef? ref;
  final String? messageUuid; //UUID
  final num? senderId; //發送人ID
  final num? receiverId; //接收人ID
  final String? senderName; //發送人Name
  final String? receiverName; //接收人Name
  final String? giftCategoryName; //禮物分類名稱
  final String? giftName; //禮物名稱
  final num? giftId; //禮物ID
  final num? coins; //禮物費用
  final String? giftImageUrl; //禮物圖片位置
  final num? giftSendAmount; //送出禮物數量
  final num? svgaFileId;
  final String? svgaUrl;
  final num? timeStamp; //時間戳
  final num? isShowSvga; //是否已播放Svga

  ChatGiftModel({
    this.ref,
    this.messageUuid,
    this.senderId,
    this.receiverId,
    this.senderName,
    this.receiverName,
    this.giftCategoryName,
    this.giftName,
    this.giftId,
    this.coins,
    this.giftImageUrl,
    this.giftSendAmount,
    this.svgaFileId,
    this.svgaUrl,
    this.timeStamp,
    this.isShowSvga,
  });

  @override
  String get createTableSql =>
      SQFLiteDDLUtil.create(model: ChatGiftModel(ref: ref));

  @override
  String get tableName => 'ChatGiftModel';

  @override
  List<SQFLiteColumnModel> get columns => [
        SQFLiteColumnModel(name: 'messageUuid', type: String, isPrimaryKey: true),
        SQFLiteColumnModel(name: 'senderId', type: num, foreignKey: 'ChatGiftModel(senderId)'),
        SQFLiteColumnModel(name: 'receiverId', type: num, foreignKey: 'ChatGiftModel(receiverId)'),
        SQFLiteColumnModel(name: 'senderName', type: String, foreignKey: 'ChatGiftModel(senderName)'),
        SQFLiteColumnModel(name: 'receiverName', type: String, foreignKey: 'ChatGiftModel(receiverName)'),
        SQFLiteColumnModel(name: 'giftCategoryName', type: String),
        SQFLiteColumnModel(name: 'giftName', type: String),
        SQFLiteColumnModel(name: 'giftId', type: num),
        SQFLiteColumnModel(name: 'coins', type: num),
        SQFLiteColumnModel(name: 'giftImageUrl', type: String),
        SQFLiteColumnModel(name: 'giftSendAmount', type: num),
        SQFLiteColumnModel(name: 'svgaFileId', type: num),
        SQFLiteColumnModel(name: 'svgaUrl', type: String),
        SQFLiteColumnModel(name: 'timeStamp', type: num),
        SQFLiteColumnModel(name: 'isShowSvga', type: num),
      ];

  @override
  Map<String, dynamic> toMap() {
    return {
      'messageUuid': messageUuid,
      'senderId': senderId,
      'receiverId': receiverId,
      'senderName': senderName,
      'receiverName': receiverName,
      'giftCategoryName': giftCategoryName,
      'giftName': giftName,
      'giftId': giftId,
      'coins': coins,
      'giftImageUrl': giftImageUrl,
      'giftSendAmount': giftSendAmount,
      'svgaFileId': svgaFileId,
      'svgaUrl': svgaUrl,
      'timeStamp': timeStamp,
      'isShowSvga': isShowSvga,
    };
  }

  factory ChatGiftModel.fromJson(Map<String, dynamic> jsonData) {
    return ChatGiftModel(
      messageUuid: jsonData['messageUuid'] as String?,
      senderId: jsonData['senderId'] as num?,
      receiverId: jsonData['receiverId'] as num?,
      senderName: jsonData['senderName'] as String?,
      receiverName: jsonData['receiverName'] as String?,
      giftCategoryName: jsonData['giftCategoryName'] as String?,
      giftName: jsonData['giftName'] as String?,
      giftId: jsonData['giftId'] as num?,
      coins: jsonData['coins'] as num?,
      giftImageUrl: jsonData['giftImageUrl'] as String?,
      giftSendAmount: jsonData['giftSendAmount'] as num?,
      svgaFileId: jsonData['svgaFileId'] as num?,
      svgaUrl: jsonData['svgaUrl'] as String?,
      timeStamp: jsonData['timeStamp'] as num?,
      isShowSvga: jsonData['isShowSvga'] as num?,
    );
  }

  static String encode(ChatGiftModel chatGiftModel) =>
      json.encode(ChatGiftModel().toMap());

  static List<ChatGiftModel> decode(List<Map<String, dynamic>> chatGiftModel) {
    return chatGiftModel.map<ChatGiftModel>((item) {
      return ChatGiftModel.fromJson(item);
    }).toList();
  }
}
