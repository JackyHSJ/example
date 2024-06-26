import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frechat/models/ws_res/notification/ws_notification_search_list_res.dart';
import 'package:frechat/models/ws_res/notification/ws_notification_strike_up_res.dart';
import 'package:zyg_sqflite_plugin/zyg_sqflite_plugin.dart';

class ActivityMessageModel extends SQFLiteHandler implements SQFLiteBaseTable {
  final ProviderRef? ref;

  final String? contentUrl;
  final num? feedsId;
  final num? createTime;
  final num? postType;
  final String? fromUserNickName;
  final String? fromUserAvatar;
  final num? fromUserGender;
  final num? notifyType;
  final String? uuid;
  final String? fromUserUserName;


  ActivityMessageModel({
    this.ref,
    this.contentUrl,
    this.feedsId,
    this.createTime,
    this.postType,
    this.fromUserNickName,
    this.fromUserAvatar,
    this.fromUserGender,
    this.notifyType,
    this.uuid,
    this.fromUserUserName
  });

  @override
  int get databaseVersion => 1;

  @override
  String get createTableSql =>
      SQFLiteDDLUtil.create(model: ActivityMessageModel(ref: ref));

  @override
  String get tableName => 'ActivityNotification';

  @override
  List<SQFLiteColumnModel> get columns => [
    SQFLiteColumnModel(name: 'contentUrl', type: String),
    SQFLiteColumnModel(name: 'feedsId', type: num),
    SQFLiteColumnModel(name: 'createTime', type: num),
    SQFLiteColumnModel(name: 'postType', type: num),
    SQFLiteColumnModel(name: 'fromUserNickName', type: String),
    SQFLiteColumnModel(name: 'fromUserAvatar', type: String),
    SQFLiteColumnModel(name: 'fromUserGender', type: num),
    SQFLiteColumnModel(name: 'notifyType', type: num),
    SQFLiteColumnModel(name: 'uuid', type: String, isPrimaryKey: true),
    SQFLiteColumnModel(name: 'fromUserUserName', type: String),

  ];
  @override
  Map<String, dynamic> toMap() {
    return {
      'contentUrl': contentUrl,
      'feedsId': feedsId,
      'createTime': createTime,
      'postType': postType,
      'fromUserNickName': fromUserNickName,
      'fromUserAvatar': fromUserAvatar,
      'fromUserGender': fromUserGender,
      'notifyType': notifyType,
      'uuid': uuid,
      'fromUserUserName': fromUserUserName,

    };
  }

  factory ActivityMessageModel.fromJson(Map<String, dynamic> jsonData) {
    return ActivityMessageModel(
      contentUrl: jsonData['contentUrl'] as String?,
      feedsId: jsonData['feedsId'] as num?,
      createTime: jsonData['createTime'] as num?,
      postType: jsonData['postType'] as num?,
      fromUserNickName: jsonData['fromUserNickName'] as String?,
      fromUserAvatar: jsonData['fromUserAvatar'] as String?,
      fromUserGender: jsonData['fromUserGender'] as num?,
      notifyType: jsonData['notifyType'] as num?,
      uuid: jsonData['uuid'] as String?,
      fromUserUserName: jsonData['fromUserUserName'] as String?,

    );
  }

  factory ActivityMessageModel.fromWsModel(
      ActivityMessageModel activityMessageModel
  ) {
    return ActivityMessageModel(
      contentUrl: activityMessageModel.contentUrl,
      feedsId: activityMessageModel.feedsId,
      createTime: activityMessageModel.createTime,
      postType: activityMessageModel.postType,
      fromUserNickName: activityMessageModel.fromUserNickName,
      fromUserAvatar: activityMessageModel.fromUserAvatar,
      fromUserGender: activityMessageModel.fromUserGender,
      notifyType: activityMessageModel.notifyType,
      uuid: activityMessageModel.uuid,
      fromUserUserName:activityMessageModel.fromUserUserName,
    );
  }

  static String encode(ActivityMessageModel activityMessageModel) =>
      json.encode(ActivityMessageModel().toMap());

  static List<ActivityMessageModel> decode(List<Map<String, dynamic>> activityMessageModel) {
    return activityMessageModel.map<ActivityMessageModel>((item) {
      return ActivityMessageModel.fromJson(item);
    }).toList();
  }
}
