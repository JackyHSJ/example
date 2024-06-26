import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frechat/models/ws_res/notification/ws_notification_search_list_res.dart';
import 'package:frechat/models/ws_res/notification/ws_notification_strike_up_res.dart';
import 'package:zyg_sqflite_plugin/zyg_sqflite_plugin.dart';

class NewUserBehaviorTrackerModel extends SQFLiteHandler implements SQFLiteBaseTable {
  final ProviderRef? ref;
  final String? userName;
  final num? onlineDuration;
  final num? regTimeLimit;
  final num? pickupCount;
  /// 首頁用戶排序狀態, ㄧ生只傳一次
  /// 0: 未傳送過, 1: 已過期 or 已傳送,
  final num? status;

  NewUserBehaviorTrackerModel({
    this.ref,
    this.userName,
    this.onlineDuration,
    this.regTimeLimit,
    this.pickupCount,
    this.status,
  });

  @override
  String get createTableSql => SQFLiteDDLUtil.create(model: NewUserBehaviorTrackerModel(ref: ref));

  @override
  String get tableName => 'NewUserBehaviorTrackerModel';

  @override
  List<SQFLiteColumnModel> get columns => [
    SQFLiteColumnModel(name: 'userName', type: String, isPrimaryKey: true),
    SQFLiteColumnModel(name: 'onlineDuration', type: num),
    SQFLiteColumnModel(name: 'regTimeLimit', type: num),
    SQFLiteColumnModel(name: 'pickupCount', type: num),
    SQFLiteColumnModel(name: 'status', type: num),
  ];

  @override
  Map<String, dynamic> toMap() {
    return {
      'userName': userName,
      'onlineDuration': onlineDuration,
      'regTimeLimit': regTimeLimit,
      'pickupCount': pickupCount,
      'status': status,
    };
  }

  factory NewUserBehaviorTrackerModel.fromJson(Map<String, dynamic> jsonData) {
    return NewUserBehaviorTrackerModel(
      userName: jsonData['userName'] as String?,
      onlineDuration: jsonData['onlineDuration'] as num?,
      regTimeLimit: jsonData['regTimeLimit'] as num?,
      pickupCount: jsonData['pickupCount'] as num?,
      status: jsonData['status'] as num?,
    );
  }

  static String encode(NewUserBehaviorTrackerModel newUserBehaviorTrackerModel) =>
      json.encode(NewUserBehaviorTrackerModel().toMap());

  static List<NewUserBehaviorTrackerModel> decode(List<Map<String, dynamic>> newUserBehaviorTrackerModel) {
    return newUserBehaviorTrackerModel.map<NewUserBehaviorTrackerModel>((item) {
      return NewUserBehaviorTrackerModel.fromJson(item);
    }).toList();
  }
}
