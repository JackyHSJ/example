import 'package:zyg_sqflite_plugin/src/model/sqflite_base_model.dart';
import 'package:zyg_sqflite_plugin/src/model/sqflite_column_model.dart';

class ChatSearchHistoryModel implements SQFLiteBaseTable {
  final int? userID;
  final String? searchKeyword;
  final String? searchTime;

  ChatSearchHistoryModel({
    this.userID,
    this.searchKeyword,
    this.searchTime,
  });

  @override
  String get tableName => 'ChatSearchHistoryModel';

  @override
  List<SQFLiteColumnModel> get columns => [
    SQFLiteColumnModel(name: 'SearchHistoryID', type: int, foreignKey: 'ChatUserModel(userID)'),
    SQFLiteColumnModel(name: 'SearchHistoryerID', type: String),
    SQFLiteColumnModel(name: 'receiverID', type: String)
  ];

  @override
  Map<String, dynamic> toMap() {
    throw UnimplementedError();
  }
}
