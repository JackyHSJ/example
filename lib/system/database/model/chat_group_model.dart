import 'package:zyg_sqflite_plugin/src/model/sqflite_base_model.dart';
import 'package:zyg_sqflite_plugin/src/model/sqflite_column_model.dart';

class ChatGroupModel implements SQFLiteBaseTable {
  final int? groupID;
  final String? groupName;
  final String? groupAvatar;
  final String? groupStatus;

  ChatGroupModel({
    this.groupID,
    this.groupName,
    this.groupAvatar,
    this.groupStatus,
  });

  @override
  String get tableName => 'ChatGroupModel';

  @override
  List<SQFLiteColumnModel> get columns => [
    SQFLiteColumnModel(name: 'groupID', type: int, isPrimaryKey: true),
    SQFLiteColumnModel(name: 'groupName', type: String),
    SQFLiteColumnModel(name: 'groupAvatar', type: String),
    SQFLiteColumnModel(name: 'groupStatus', type: String),
  ];

  @override
  Map<String, dynamic> toMap() {
    throw UnimplementedError();
  }
}
