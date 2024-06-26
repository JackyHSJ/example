// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ws_account_call_charge_req.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WsAccountCallChargeReq _$WsAccountCallChargeReqFromJson(Map<String, dynamic> json) =>
    WsAccountCallChargeReq(
      roomId: json['roomId'] as num,
      chatType: json['chatType'] as num,
      channel: json['channel'] as String,
    );

Map<String, dynamic> _$WsAccountCallChargeReqToJson(WsAccountCallChargeReq instance) =>
    <String, dynamic>{
      'roomId': instance.roomId,
      'chatType': instance.chatType,
      'channel': instance.channel,
    };
