import 'package:zyg_sqflite_plugin/src/model/sqflite_base_model.dart';
import 'package:zyg_sqflite_plugin/src/model/sqflite_column_model.dart';

class ChatGroupMemberModel implements SQFLiteBaseTable {
  final int? groupID;
  final int? userID;

  ChatGroupMemberModel({
    this.groupID,
    this.userID,
  });

  @override
  String get tableName => 'ChatGroupMemberModel';

  @override
  List<SQFLiteColumnModel> get columns => [
    SQFLiteColumnModel(name: 'groupID', type: int, isPrimaryKey: true, foreignKey: 'ChatGroupModel(groupID)'),
    SQFLiteColumnModel(name: 'userID', type: int, isPrimaryKey: true, foreignKey: 'ChatUserModel(userID)'),
  ];

  @override
  Map<String, dynamic> toMap() {
    throw UnimplementedError();
  }
}
