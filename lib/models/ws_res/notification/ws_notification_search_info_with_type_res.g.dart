// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ws_notification_search_info_with_type_res.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WsNotificationSearchInfoWithTypeRes _$WsNotificationSearchInfoWithTypeResFromJson(
        Map<String, dynamic> json) =>
    WsNotificationSearchInfoWithTypeRes(
        roomCount: json['roomCount'] as num?,
        roomList: json['roomList'] as List<dynamic>?,
        list: (json['list'] == null) ? [] : (json['list'] as List)
            .map((info) => SearchListInfo.fromJson(info))
            .toList());

Map<String, dynamic> _$WsNotificationSearchInfoWithTypeResToJson(
        WsNotificationSearchInfoWithTypeRes instance) =>
    <String, dynamic>{
      'roomCount': instance.roomCount,
      'roomList': instance.roomList,
      'list': instance.list,
    };
