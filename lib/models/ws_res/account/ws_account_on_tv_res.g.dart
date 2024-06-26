// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ws_account_on_tv_res.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WsAccountOnTVRes _$WsAccountOnTVResFromJson(Map<String, dynamic> json) => WsAccountOnTVRes(
  giftName: json['giftName'] as String?,
  amount: json['amount'] as num?,
  duration: json['duration'] as num?,
  fromUserNickName: json['fromUserNickName'] as String?,
  toUserNickName: json['toUserNickName'] as String?,
  charmLevel: json['charmLevel'] as num?,
  fromUserAvatar: json['fromUserAvatar'] as String?,
  toUserAvatar: json['toUserAvatar'] as String?,
  fromUserGender: json['fromUserGender'] as int?,
  toUserGender: json['toUserGender'] as int?
);

Map<String, dynamic> _$WsAccountOnTVResToJson(WsAccountOnTVRes instance) => <String, dynamic>{
  'giftName': instance.giftName,
  'amount': instance.amount,
  'duration': instance.duration,
  'fromUserNickName': instance.fromUserNickName,
  'toUserNickName': instance.toUserNickName,
  'charmLevel': instance.charmLevel,
  'fromUserAvatar': instance.fromUserAvatar,
  'toUserAvatar': instance.toUserAvatar,
  'fromUserGender': instance.fromUserGender,
  'toUserGender': instance.toUserGender,
};
