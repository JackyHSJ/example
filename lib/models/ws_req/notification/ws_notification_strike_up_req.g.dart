// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ws_notification_strike_up_req.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WsNotificationStrikeUpReq _$WsNotificationStrikeUpReqFromJson(Map<String, dynamic> json) =>
    WsNotificationStrikeUpReq(
      userName: json['userName'] as String,
      type: json['type'] as int
    );

Map<String, dynamic> _$WsNotificationStrikeUpReqToJson(WsNotificationStrikeUpReq instance) =>
    <String, dynamic>{
      'userName' : instance.userName,
      'type': instance.type
    };
