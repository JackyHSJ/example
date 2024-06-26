import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zyg_sqflite_plugin/zyg_sqflite_plugin.dart';

class ChatBlockModel extends SQFLiteHandler implements SQFLiteBaseTable {
  final ProviderRef? ref;
  final num? userId;
  final num? friendId;
  final String? filePath;
  final String? nickName;
  final String? userName;
  final num? age;
  final num? gender;
  final String? selfIntroduction;

  ChatBlockModel({
    this.ref,
    this.userId,
    this.friendId,
    this.filePath,
    this.nickName,
    this.userName,
    this.age,
    this.gender,
    this.selfIntroduction,
  });

  @override
  String get createTableSql => SQFLiteDDLUtil.create(model: ChatBlockModel(ref: ref));

  @override
  String get tableName => 'ChatBlockModel';

  @override
  List<SQFLiteColumnModel> get columns => [
    SQFLiteColumnModel(name: 'userId', type: num, isPrimaryKey: true, foreignKey: 'ChatUserModel(userId)'),
    SQFLiteColumnModel(name: 'friendId', type: num,  isPrimaryKey: true, foreignKey: 'ChatUserModel(userId)'),
    SQFLiteColumnModel(name: 'filePath', type: String),
    SQFLiteColumnModel(name: 'nickName', type: String),
    SQFLiteColumnModel(name: 'userName', type: String),
    SQFLiteColumnModel(name: 'age', type: num),
    SQFLiteColumnModel(name: 'gender', type: num),
    SQFLiteColumnModel(name: 'selfIntroduction', type: String),
  ];

  @override
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'friendId': friendId,
      'filePath': filePath,
      'nickName': nickName,
      'userName': userName,
      'age': age,
      'gender': gender,
      'selfIntroduction': selfIntroduction,
    };
  }

  factory ChatBlockModel.fromJson(Map<String, dynamic> jsonData) {
    return ChatBlockModel(
      userId: jsonData['userId'] as num?,
      friendId: jsonData['friendId'] as num?,
      filePath: jsonData['filePath'] as String?,
      nickName: jsonData['nickName'] as String?,
      userName: jsonData['userName'] as String?,
      age: jsonData['age'] as num?,
      gender: jsonData['gender'] as num?,
      selfIntroduction: jsonData['selfIntroduction'] as String?,
    );
  }

  static String encode(ChatBlockModel chatImageModel) =>
      json.encode(ChatBlockModel().toMap());

  static List<ChatBlockModel> decode(
      List<Map<String, dynamic>> chatImageModel) {
    return chatImageModel.map<ChatBlockModel>((item) {
      return ChatBlockModel.fromJson(item);
    }).toList();
  }
}
