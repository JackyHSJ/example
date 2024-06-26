// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ws_notification_search_online_status_res.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WsNotificationSearchOnlineStatusRes _$WsNotificationSearchOnlineStatusResFromJson(Map<String, dynamic> json) => WsNotificationSearchOnlineStatusRes(
  list: (json['list'] as List).map((info) => SearchOnlineStatusInfo.fromJson(info)).toList(),
);

Map<String, dynamic> _$WsNotificationSearchOnlineStatusResToJson(WsNotificationSearchOnlineStatusRes instance) => <String, dynamic>{
  'list': instance.list,
};

SearchOnlineStatusInfo _$SearchOnlineStatusInfoFromJson(Map<String, dynamic> json) => SearchOnlineStatusInfo(
  roomId: json['roomId'] as num?,
  gender: json['gender'] as num?,
);

Map<String, dynamic> _$SearchOnlineStatusInfoToJson(SearchOnlineStatusInfo instance) => <String, dynamic>{
  'roomId': instance.roomId,
  'gender': instance.gender,
};