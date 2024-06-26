import 'package:zyg_sqflite_plugin/src/model/sqflite_base_model.dart';
import 'package:zyg_sqflite_plugin/src/model/sqflite_column_model.dart';

class ChatEmojiModel implements SQFLiteBaseTable {
  final int? emojiID;
  final String? emojiPath;

  ChatEmojiModel({
    this.emojiID,
    this.emojiPath,
  });

  @override
  String get tableName => 'ChatEmojiModel';

  @override
  List<SQFLiteColumnModel> get columns => [
    SQFLiteColumnModel(name: 'emojiID', type: int, isPrimaryKey: true),
    SQFLiteColumnModel(name: 'emojiPath', type: String),
  ];

  @override
  Map<String, dynamic> toMap() {
    throw UnimplementedError();
  }
}
