// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ws_account_speak_req.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WsAccountSpeakReq _$WsAccountSpeakReqFromJson(Map<String, dynamic> json) =>
    WsAccountSpeakReq(
      roomId: json['roomId'] as num,
      userId: json['userId'] as num,
      contentType: json['contentType'] as num,
      chatContent: json['chatContent'] as String,
      uuId: json['uuId'] as String,
      flag: json['flag'] as String,
      replyUuid: json['replyUuid'] as String,
      giftId: json['giftId'] as String,
      giftAmount: json['giftAmount'] as String,
      isReplyPickup: json['isReplyPickup'] as num,
    );

Map<String, dynamic> _$WsAccountSpeakReqToJson(WsAccountSpeakReq instance) =>
    <String, dynamic>{
      'roomId': instance.roomId,
      'userId': instance.userId,
      'contentType': instance.contentType,
      'chatContent': instance.chatContent,
      'uuId': instance.uuId,
      'flag': instance.flag,
      'replyUuid': instance.replyUuid,
      'giftId': instance.giftId,
      'giftAmount': instance.giftAmount,
      'isReplyPickup': instance.isReplyPickup,
    };
