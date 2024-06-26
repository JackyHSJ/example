
import 'package:flutter/cupertino.dart';
import 'package:frechat/system/global.dart';
import 'package:json_annotation/json_annotation.dart';

part 'ws_account_speak_res.g.dart';

@JsonSerializable()
class WsAccountSpeakRes {
  WsAccountSpeakRes({
    this.id,
    this.createTime,
    this.nickName,
    this.chatContent,
    this.contentType,
    this.userId,
    this.roomId,
    this.uuId,
    this.cost,
    this.expireTime,
    this.halfTime,
    this.incomeflag,
    this.remainCoins,
    this.points,
    this.flag,
    this.giftId,
    this.giftAmount,
    this.isReplyPickup,
    this.cohesionPoints,
    this.charmPoints,
    this.isCharmLevelUp,
    this.isCohesionLevelUp,
    this.cohesionLevel,
    this.expireDuration,
    this.halfDuration,
  });

  @JsonKey(name: 'id')
  final num? id;

  @JsonKey(name: 'createTime')
  final num? createTime;

  @JsonKey(name: 'nickName')
  final String? nickName;

  @JsonKey(name: 'chatContent')
  final String? chatContent;

  /// 0:文字訊息 1:圖片上傳 2:引言
  @JsonKey(name: 'contentType')
  final num? contentType;

  @JsonKey(name: 'userId')
  final num? userId;

  @JsonKey(name: 'roomId')
  final num? roomId;

  @JsonKey(name: 'uuId')
  final String? uuId;

  @JsonKey(name: 'cost')
  final num? cost;

  @JsonKey(name: 'expireTime')
  final num? expireTime;

  @JsonKey(name: 'halfTime')
  final num? halfTime;

  @JsonKey(name: 'incomeflag')
  final num? incomeflag;

  @JsonKey(name: 'remainCoins')
  final num? remainCoins;

  @JsonKey(name: 'points')
  final num? points;

  @JsonKey(name: 'flag')
  final num? flag;

  @JsonKey(name: 'giftId')
  final String? giftId;

  @JsonKey(name: 'giftAmount')
  final num? giftAmount;

  @JsonKey(name: 'charmPoints')
  final num? charmPoints;

  @JsonKey(name: 'cohesionPoints')
  final num? cohesionPoints;

  @JsonKey(name: 'isCharmLevelUp')
  final bool? isCharmLevelUp;

  @JsonKey(name: 'isCohesionLevelUp')
  final bool? isCohesionLevelUp;

  @JsonKey(name: 'cohesionLevel')
  final num? cohesionLevel;

  /// 回應搭訕  0:否; 1:是
  @JsonKey(name: 'isReplyPickup')
  final bool? isReplyPickup;

  /// 收益逾期時長(分鐘)
  @JsonKey(name: 'expireDuration')
  final num? expireDuration;

  /// 收益減半時常(分鐘)
  @JsonKey(name: 'halfDuration')
  final num? halfDuration;

  factory WsAccountSpeakRes.fromJson(Map<String, dynamic> json) =>
      _$WsAccountSpeakResFromJson(json);
  Map<String, dynamic> toJson() => _$WsAccountSpeakResToJson(this);
}