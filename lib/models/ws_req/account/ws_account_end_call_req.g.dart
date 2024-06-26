// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ws_account_end_call_req.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WsAccountEndCallReq _$WsAccountEndCallReqFromJson(Map<String, dynamic> json) =>
    WsAccountEndCallReq(
      roomId: json['roomId'] as num,
          channel: json['channel'] as String,
    );

Map<String, dynamic> _$WsAccountEndCallReqToJson(WsAccountEndCallReq instance) =>
    <String, dynamic>{
      'roomId' : instance.roomId,
      'channel' : instance.channel,
    };
