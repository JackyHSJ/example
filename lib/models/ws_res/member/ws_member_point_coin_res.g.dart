// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ws_member_point_coin_res.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WsMemberPointCoinRes _$WsMemberPointCoinResFromJson(Map<String, dynamic> json) =>
    WsMemberPointCoinRes(
      userId: json['userId'] as num?,
      coins: json['coins'] as num?,
      points: json['points'] as num?,
      depositCount: json['depositCount'] as num?,
    );

Map<String, dynamic> _$WsMemberPointCoinResToJson(WsMemberPointCoinRes instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'coins': instance.coins,
      'points': instance.points,
      'depositCount': instance.depositCount,
    };
