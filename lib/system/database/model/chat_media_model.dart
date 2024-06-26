import 'package:zyg_sqflite_plugin/src/model/sqflite_base_model.dart';
import 'package:zyg_sqflite_plugin/src/model/sqflite_column_model.dart';

class ChatMediaModel implements SQFLiteBaseTable {
  final int? mediaID;
  final String? mediaPath;
  final String? mediaType;
  final String? uploadTime;

  ChatMediaModel({
    this.mediaID,
    this.mediaPath,
    this.mediaType,
    this.uploadTime,
  });

  @override
  String get tableName => 'ChatMediaModel';

  @override
  List<SQFLiteColumnModel> get columns => [
    SQFLiteColumnModel(name: 'mediaID', type: int, isPrimaryKey: true),
    SQFLiteColumnModel(name: 'mediaPath', type: String),
    SQFLiteColumnModel(name: 'mediaType', type: String),
    SQFLiteColumnModel(name: 'uploadTime', type: String),
  ];

  @override
  Map<String, dynamic> toMap() {
    throw UnimplementedError();
  }
}
