import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zyg_sqflite_plugin/zyg_sqflite_plugin.dart';

class VisitorTimeModel extends SQFLiteHandler implements SQFLiteBaseTable {
  final ProviderRef? ref;
  final String? fromUserName;
  final String? toUserName;
  final num? toUserGender;

  final num? lastVisitTimestamp;
  final num? visitorExpireTime;

  VisitorTimeModel({
    this.ref,
    this.fromUserName,
    this.toUserName,
    this.toUserGender,
    this.lastVisitTimestamp,
    this.visitorExpireTime,
  });

  @override
  String get createTableSql => SQFLiteDDLUtil.create(model: VisitorTimeModel(ref: ref));

  @override
  String get tableName => 'VisitorTimeModel';

  @override
  List<SQFLiteColumnModel> get columns => [
    SQFLiteColumnModel(name: 'fromUserName', type: String, isPrimaryKey: true),
    SQFLiteColumnModel(name: 'toUserName', type: String, isPrimaryKey: true),
    SQFLiteColumnModel(name: 'toUserGender', type: num),
    SQFLiteColumnModel(name: 'lastVisitTimestamp', type: num),
    SQFLiteColumnModel(name: 'visitorExpireTime', type: num),
  ];

  @override
  Map<String, dynamic> toMap() {
    return {
      'fromUserName': fromUserName,
      'toUserName': toUserName,
      'toUserGender': toUserGender,
      'lastVisitTimestamp': lastVisitTimestamp,
      'visitorExpireTime': visitorExpireTime,
    };
  }

  factory VisitorTimeModel.fromJson(Map<String, dynamic> jsonData) {
    return VisitorTimeModel(
      fromUserName: jsonData['fromUserName'] as String?,
      toUserName: jsonData['toUserName'] as String?,
      toUserGender: jsonData['toUserGender'] as num?,
      lastVisitTimestamp: jsonData['lastVisitTimestamp'] as num?,
      visitorExpireTime: jsonData['visitorExpireTime'] as num?,
    );
  }

  static String encode(VisitorTimeModel chatUserModel) =>
      json.encode(VisitorTimeModel().toMap());

  static List<VisitorTimeModel> decode(List<Map<String, dynamic>> chatUserModel) {
    return chatUserModel.map<VisitorTimeModel>((item) {
      return VisitorTimeModel.fromJson(item);
    }).toList();
  }
}
