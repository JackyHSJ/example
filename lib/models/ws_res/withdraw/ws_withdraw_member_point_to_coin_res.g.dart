// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ws_withdraw_member_point_to_coin_res.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WsWithdrawMemberPointToCoinRes _$WsWithdrawMemberPointToCoinResFromJson(Map<String, dynamic> json) =>
    WsWithdrawMemberPointToCoinRes(
      userId: json['userId'] as num?,
      coins: json['coins'] as num?,
      points: json['points'] as num?,
    );

Map<String, dynamic> _$WsWithdrawMemberPointToCoinResToJson(WsWithdrawMemberPointToCoinRes instance) => 
    <String, dynamic>{
      'userId': instance.userId,
      'coins': instance.coins,
      'points': instance.points,
    };