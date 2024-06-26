// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ws_account_follow_req.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WsAccountFollowReq _$WsAccountFollowReqFromJson(Map<String, dynamic> json) =>
    WsAccountFollowReq(
          friendId: json['friendId'] as num?,
          isFollow: json['isFollow'] as bool?,
    );

Map<String, dynamic> _$WsAccountFollowReqToJson(WsAccountFollowReq instance) =>
    <String, dynamic>{
      'friendId': instance.friendId,
      'isFollow': instance.isFollow,
    };
