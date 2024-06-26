// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ws_activity_search_reply_info_req.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WsActivitySearchReplyInfoReq _$WsActivitySearchReplyInfoReqFromJson(Map<String, dynamic> json) =>
    WsActivitySearchReplyInfoReq(
      type: json['type'] as String?,
      sort: json['sort'] as String?,
      dir: json['dir'] as String?,
      page: json['page'] as String?,
      size: json['size'] as String?,
      feedReplyId: json['feedReplyId'] as num?,
    );

Map<String, dynamic> _$WsActivitySearchReplyInfoReqToJson(WsActivitySearchReplyInfoReq instance) =>
    <String, dynamic>{
      'type': instance.type,
      'sort': instance.sort,
      'dir': instance.dir,
      'page': instance.page,
      'size': instance.size,
      'feedReplyId': instance.feedReplyId,
    };