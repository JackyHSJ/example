// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'zim_message_extended_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ZimMessageExtendedData _$ZimMessageExtendedDataFromJson(Map<String, dynamic> json) =>
    ZimMessageExtendedData(
      remainCoins: json['remainCoins'] as num?,
      expireTime: json['expireTime'] as num?,
      halfTime: json['halfTime'] as num?,
      incomeflag: json['incomeflag'] as num?,
      uuid: json['uuid'] as String?,
      isGift: json['isGift'] as num,
      giftUrl: json['giftUrl'] as String?,
      svgaFileId: json['svgaFileId'] as num?,
      svgaUrl: json['svgaUrl'] as String?,
      giftSendAmount: json['giftSendAmount'] as num?,
      giftName: json['giftName'] as String?,
      coins: json['coins'] as num?,
      giftId: json['giftId'] as String?,
      giftCategoryName: json['giftCategoryName'] as String?,
      sender: json['sender'] as String,
      receiver: json['receiver'] as String,
      roomName: json['roomName'] as String,
      avatar: json['avatar'] as String,
      gender: json['gender'] as num,
      roomId: json['roomId'] as num,
      points: json['points'] as num,
      cohesionPoints: json['cohesionPoints'] as num,
      cohesionLevel: json['cohesionLevel'] as num,
      isReplyPickup: json['isReplyPickup'] as num,
      expireDuration: json['expireDuration'] as num,
      halfDuration: json['halfDuration'] as num,
      audioTime: json['audioTime'] as num?,
      createTime: json['createTime'] as num?,


    );

Map<String, dynamic> _$ZimMessageExtendedDataToJson(ZimMessageExtendedData instance) =>
    <String, dynamic>{
      'remainCoins': instance.remainCoins,
      'expireTime': instance.expireTime,
      'halfTime': instance.halfTime,
      'incomeflag': instance.incomeflag,
      'uuid': instance.uuid,
      'isGift': instance.isGift,
      'giftUrl': instance.giftUrl,
      'svgaFileId': instance.svgaFileId,
      'svgaUrl': instance.svgaUrl,
      'giftSendAmount': instance.giftSendAmount,
      'giftName': instance.giftName,
      'coins': instance.coins,
      'giftId': instance.giftId,
      'giftCategoryName': instance.giftCategoryName,
      'sender': instance.sender,
      'receiver': instance.receiver,
      'roomName': instance.roomName,
      'avatar': instance.avatar,
      'gender': instance.gender,
      'roomId': instance.roomId,
      'points': instance.points,
      'cohesionPoints': instance.cohesionPoints,
      'cohesionLevel': instance.cohesionLevel,
      'isReplyPickup': instance.isReplyPickup,
      'expireDuration': instance.expireDuration,
      'halfDuration': instance.halfDuration,
      'audioTime':instance.audioTime,
      'createTime':instance.createTime,
    };
