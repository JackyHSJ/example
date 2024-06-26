// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ws_account_get_rtc_token_req.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WsAccountGetRTCTokenReq _$WsAccountGetRTCTokenReqFromJson(Map<String, dynamic> json) =>
    WsAccountGetRTCTokenReq(
      chatType: json['chatType'] as num,
      roomId: json['roomId'] as num,
      callUserId: json['callUserId'] as num,
    );

Map<String, dynamic> _$WsAccountGetRTCTokenReqToJson(WsAccountGetRTCTokenReq instance) =>
    <String, dynamic>{
      'chatType': instance.chatType,
      'roomId': instance.roomId,
      'callUserId': instance.callUserId,
    };
