// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ws_notification_search_intimacy_level_info_res.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WsNotificationSearchIntimacyLevelInfoRes _$WsNotificationSearchIntimacyLevelInfoResFromJson(Map<String, dynamic> json) => WsNotificationSearchIntimacyLevelInfoRes(
  list: (json['list'] as List).map((info) => IntimacyLevelInfo.fromJson(info)).toList(),
  newUserProtect: json['newUserProtect'] as String?,
);

Map<String, dynamic> _$WsNotificationSearchIntimacyLevelInfoResToJson(WsNotificationSearchIntimacyLevelInfoRes instance) => <String, dynamic>{
  'list' : instance.list,
  'newUserProtect' : instance.newUserProtect,
};


IntimacyLevelInfo _$IntimacyLevelInfoFromJson(Map<String, dynamic> json) => IntimacyLevelInfo(
  cohesionLevel: json['cohesionLevel'] as num?,
  cohesionName: json['cohesionName'] as String?,
  points: json['points'] as num?,
  updateTime: json['updateTime'] as num?,
  award: json['award'] as String?,
  updateUser: json['updateUser'] as String?,
);

Map<String, dynamic> _$IntimacyLevelInfoToJson(IntimacyLevelInfo instance) => <String, dynamic>{
  'cohesionLevel': instance.cohesionLevel,
  'cohesionName': instance.cohesionName,
  'points': instance.points,
  'updateTime': instance.updateTime,
  'award': instance.award,
  'updateUser': instance.updateUser,
};