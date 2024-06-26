// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ws_contact_search_list_req.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WsContactSearchListReq _$WsContactSearchListReqFromJson(Map<String, dynamic> json) =>
    WsContactSearchListReq(
        querykeyword: json['querykeyword'] as String?,
        sort: json['sort'] as String?,
        dir: json['dir'] as String?,
        page: json['page'] as String?,
        size: json['size'] as String?,
    );

Map<String, dynamic> _$WsContactSearchListReqToJson(WsContactSearchListReq instance) =>
    <String, dynamic>{
        'querykeyword': instance.querykeyword,
        'sort': instance.sort,
        'dir': instance.dir,
        'page': instance.page,
        'size': instance.size,
    };