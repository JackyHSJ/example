// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ws_account_call_verification_req.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WsAccountCallVerificationReq _$WsAccountCallVerificationReqFromJson(Map<String, dynamic> json) =>
    WsAccountCallVerificationReq(
      freUserId: json['freUserId'] as num,
      chatType: json['chatType'] as num,
      roomId: json['roomId'] as num
    );

Map<String, dynamic> _$WsAccountCallVerificationReqToJson(WsAccountCallVerificationReq instance) =>
    <String, dynamic>{
      'freUserId': instance.freUserId,
      'chatType': instance.chatType,
      'roomId': instance.roomId
    };
