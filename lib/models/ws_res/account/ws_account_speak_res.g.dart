// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ws_account_speak_res.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WsAccountSpeakRes _$WsAccountSpeakResFromJson(Map<String, dynamic> json) => WsAccountSpeakRes(
  id: json['id'] as num?,
  createTime: json['createTime'] as num?,
  nickName: json['nickName'] as String?,
  chatContent: json['chatContent'] as String?,
  contentType: json['contentType'] as num?,
  userId: json['userId'] as num?,
  roomId: json['roomId'] as num?,
  uuId: json['uuId'] as String?,
  cost: json['cost'] as num?,
  expireTime: json['expireTime'] as num?,
  halfTime: json['halfTime'] as num?,
  incomeflag: json['incomeflag'] as num?,
  remainCoins: json['remainCoins'] as num?,
  points: json['points'] as num?,
  flag: json['flag'] as num?,
  giftId: json['giftId'] as String?,
  giftAmount: json['giftAmount'] as num?,
  cohesionPoints: json['cohesionPoints'] as num?,
  charmPoints: json['charmPoints'] as num?,
  isCharmLevelUp: json['isCharmLevelUp'] as bool?,
  isCohesionLevelUp: json['isCohesionLevelUp'] as bool?,
  isReplyPickup: json['isReplyPickup'] as bool?,
  cohesionLevel: json['cohesionLevel'] as num?,
  expireDuration: json['expireDuration'] as num?,
  halfDuration: json['halfDuration'] as num?,
);

Map<String, dynamic> _$WsAccountSpeakResToJson(WsAccountSpeakRes instance) => <String, dynamic>{
  'id' : instance.id,
  'createTime' : instance.createTime,
  'nickName' : instance.nickName,
  'chatContent' : instance.chatContent,
  'contentType' : instance.contentType,
  'userId' : instance.userId,
  'roomId' : instance.roomId,
  'uuId' : instance.uuId,
  'cost:': instance.cost,
  'expireTime:': instance.expireTime,
  'halfTime:': instance.halfTime,
  'incomeflag:': instance.incomeflag,
  'remainCoins:': instance.remainCoins,
  'points:': instance.points,
  'flag': instance.flag,
  'giftId': instance.giftId,
  'giftAmount': instance.giftAmount,
  'cohesionPoints': instance.cohesionPoints,
  'charmPoints': instance.charmPoints,
  'isCharmLevelUp': instance.isCharmLevelUp,
  'isCohesionLevelUp': instance.isCohesionLevelUp,
  'isReplyPickup': instance.isReplyPickup,
  'cohesionLevel': instance.cohesionLevel,
  'expireDuration': instance.expireDuration,
  'halfDuration': instance.halfDuration,
};
