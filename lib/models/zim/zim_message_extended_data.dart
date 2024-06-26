import 'dart:io';
import 'package:dio/dio.dart';
import 'package:frechat/system/util/form_data_util.dart';
import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';
part 'zim_message_extended_data.g.dart';

@JsonSerializable()
class ZimMessageExtendedData {
  ZimMessageExtendedData({
    this.remainCoins,
    this.expireTime,
    this.halfTime,
    this.incomeflag,
    this.uuid,
    this.isGift,
    this.giftUrl,
    this.svgaFileId,
    this.svgaUrl,
    this.giftSendAmount,
    this.giftName,
    this.coins,
    this.giftId,
    this.giftCategoryName,
    this.sender,
    this.receiver,
    this.roomName,
    this.avatar,
    this.gender,
    this.roomId,
    this.points,
    this.cohesionPoints,
    this.cohesionLevel,
    this.isReplyPickup,
    this.expireDuration,
    this.halfDuration,
    this.audioTime,
    this.createTime,
  });

  // Remain coins
  @JsonKey(name: 'remainCoins')
  num? remainCoins;

  // Expire time
  @JsonKey(name: 'expireTime')
  num? expireTime;

  // Half time
  @JsonKey(name: 'halfTime')
  num? halfTime;

  // Income flag
  @JsonKey(name: 'incomeflag')
  num? incomeflag;

  // UUID
  @JsonKey(name: 'uuid')
  String? uuid;

  // Is gift
  @JsonKey(name: 'isGift')
  num? isGift;

  // Gift URL
  @JsonKey(name: 'giftUrl')
  String? giftUrl;

  // SVGA File ID
  @JsonKey(name: 'svgaFileId')
  num? svgaFileId;

  // SVGA URL
  @JsonKey(name: 'svgaUrl')
  String? svgaUrl;

  // Gift send amount
  @JsonKey(name: 'giftSendAmount')
  num? giftSendAmount;

  // Gift name
  @JsonKey(name: 'giftName')
  String? giftName;

  // Coins
  @JsonKey(name: 'coins')
  num? coins;

  // Gift ID
  @JsonKey(name: 'giftId')
  String? giftId;

  // Gift category name
  @JsonKey(name: 'giftCategoryName')
  String? giftCategoryName;

  // Sender
  @JsonKey(name: 'sender')
  String? sender;

  // Receiver
  @JsonKey(name: 'receiver')
  String? receiver;

  // Room name
  @JsonKey(name: 'roomName')
  String? roomName;

  // Avatar
  @JsonKey(name: 'avatar')
  String? avatar;

  // Gender
  @JsonKey(name: 'gender')
  num? gender;

  // Room ID
  @JsonKey(name: 'roomId')
  num? roomId;

  // Cohesion points
  @JsonKey(name: 'points')
  num? points;

  // Cohesion points
  @JsonKey(name: 'cohesionPoints')
  num? cohesionPoints;

  // Cohesion level
  @JsonKey(name: 'cohesionLevel')
  num? cohesionLevel;

  // Is reply pickup
  @JsonKey(name: 'isReplyPickup')
  num? isReplyPickup;

  // Expire duration
  @JsonKey(name: 'expireDuration')
  num? expireDuration;

  // Half duration
  @JsonKey(name: 'halfDuration')
  num? halfDuration;


  // audioTime
  @JsonKey(name: 'audioTime')
  num? audioTime;

  // createTime 訊息時間
  @JsonKey(name: 'createTime')
  num? createTime;

  factory ZimMessageExtendedData.fromJson(Map<String, dynamic> json) =>
      _$ZimMessageExtendedDataFromJson(json);
  Map<String, dynamic> toJson() => _$ZimMessageExtendedDataToJson(this);
}
