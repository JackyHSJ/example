// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ws_notification_search_info_with_type_req.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WsNotificationSearchInfoWithTypeReq _$WsNotificationSearchInfoWithTypeReqFromJson(Map<String, dynamic> json) =>
    WsNotificationSearchInfoWithTypeReq(
      roomIdList: json['roomIdList'] as List<num>?,
      type: json['type'] as num?,
    );

Map<String, dynamic> _$WsNotificationSearchInfoWithTypeReqToJson(WsNotificationSearchInfoWithTypeReq instance) =>
    <String, dynamic>{
      'roomIdList': instance.roomIdList,
      'type': instance.type,
    };
