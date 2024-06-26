import 'package:zyg_sqflite_plugin/src/model/sqflite_base_model.dart';
import 'package:zyg_sqflite_plugin/src/model/sqflite_column_model.dart';

class ChatFriendModel implements SQFLiteBaseTable {
  final int? userID;
  final int? friendID;

  ChatFriendModel({
    this.userID,
    this.friendID,
  });

  @override
  String get tableName => 'ChatFriendModel';

  @override
  List<SQFLiteColumnModel> get columns => [
    SQFLiteColumnModel(name: 'userID', type: int, isPrimaryKey: true, foreignKey: 'ChatUserModel(userID)'),
    SQFLiteColumnModel(name: 'friendID', type: int, isPrimaryKey: true, foreignKey: 'ChatUserModel(userID)'),
  ];

  @override
  Map<String, dynamic> toMap() {
    throw UnimplementedError();
  }
}
