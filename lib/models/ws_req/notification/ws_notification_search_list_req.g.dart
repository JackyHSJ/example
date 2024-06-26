// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ws_notification_search_list_req.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WsNotificationSearchListReq _$WsNotificationSearchListReqFromJson(Map<String, dynamic> json) =>
    WsNotificationSearchListReq(
        page: json['page'] as String,
        roomId: json['roomId'] as num?,
        type: json['type'] as num?,
    );

Map<String, dynamic> _$WsNotificationSearchListReqToJson(WsNotificationSearchListReq instance) =>
    <String, dynamic>{
      'page' : instance.page,
      'roomId' : instance.roomId,
      'type' : instance.type,
    };
