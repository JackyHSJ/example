import 'package:zyg_sqflite_plugin/src/model/sqflite_base_model.dart';
import 'package:zyg_sqflite_plugin/src/model/sqflite_column_model.dart';

class ChatMessageEmojiModel implements SQFLiteBaseTable {
  final int? messageID;
  final int? emojiID;

  ChatMessageEmojiModel({
    this.messageID,
    this.emojiID,
  });

  @override
  String get tableName => 'ChatMessageEmojiModel';

  @override
  List<SQFLiteColumnModel> get columns => [
    SQFLiteColumnModel(name: 'messageID', type: int, isPrimaryKey: true, foreignKey: 'ChatMessagesModel(messageID)'),
    SQFLiteColumnModel(name: 'emojiID',  isPrimaryKey: true, type: int, foreignKey: 'ChatEmojiModel(emojiID)'),
  ];

  @override
  Map<String, dynamic> toMap() {
    throw UnimplementedError();
  }
}
