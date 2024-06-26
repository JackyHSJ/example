// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ws_activity_add_reply_req.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WsActivityAddReplyReq _$WsActivityAddReplyReqFromJson(Map<String, dynamic> json) =>
    WsActivityAddReplyReq(
      content: json['content'] as String?,
      feedReplyId: json['feedReplyId'] as num?,
      type: json['type'] as num?,
      freFeedId: json['freFeedId'] as num?,
      userLocation: json['userLocation'] as String?,
      // feedUserName: json['feedUserName'] as String?,
      tagUserName: json['tagUserName'] as String?,
    );

Map<String, dynamic> _$WsActivityAddReplyReqToJson(WsActivityAddReplyReq instance) =>
    <String, dynamic>{
      'content': instance.content,
      'feedReplyId': instance.feedReplyId,
      'freFeedId': instance.freFeedId,
      'type': instance.type,
      'userLocation': instance.userLocation,
      // 'feedUserName': instance.feedUserName,
      'tagUserName': instance.tagUserName,
    };