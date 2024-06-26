// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ws_post_add_like_req.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WsPostAddLikeReq _$WsPostAddLikeReqFromJson(Map<String, dynamic> json) =>
    WsPostAddLikeReq(
      articlesId: json['articlesId'] as String,
      type: json['type'] as String,
    );

Map<String, dynamic> _$WsPostAddLikeReqToJson(WsPostAddLikeReq instance) =>
    <String, dynamic>{
      'articlesId': instance.articlesId,
      'type': instance.type,
    };