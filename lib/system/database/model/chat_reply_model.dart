import 'package:zyg_sqflite_plugin/src/model/sqflite_base_model.dart';
import 'package:zyg_sqflite_plugin/src/model/sqflite_column_model.dart';

class ChatReplyModel implements SQFLiteBaseTable {
  final int? replyID;
  final int? messageID;
  final int? senderID;
  final String? content;
  final String? timestamp;

  ChatReplyModel({
    this.replyID,
    this.messageID,
    this.senderID,
    this.content,
    this.timestamp,
  });

  @override
  String get tableName => 'ChatReplyModel';

  @override
  List<SQFLiteColumnModel> get columns => [
    SQFLiteColumnModel(name: 'replyID', type: int, isPrimaryKey: true),
    SQFLiteColumnModel(name: 'messageID', type: int, foreignKey: 'ChatMessageModel(userID)'),
    SQFLiteColumnModel(name: 'senderID', type: int, foreignKey: 'ChatUserModel(userID)'),
    SQFLiteColumnModel(name: 'content', type: String, foreignKey: 'ChatUserModel(groupID)'),
    SQFLiteColumnModel(name: 'timestamp', type: String),
  ];

  @override
  Map<String, dynamic> toMap() {
    throw UnimplementedError();
  }
}
