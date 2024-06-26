// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ws_activity_search_info_req.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WsActivitySearchInfoReq _$WsActivitySearchInfoReqFromJson(Map<String, dynamic> json) =>
    WsActivitySearchInfoReq(
      type: json['type'] as String,
      sort: json['sort'] as String?,
      dir: json['dir'] as String?,
      page: json['page'] as String?,
      size: json['size'] as String?,
      condition: json['condition'] as String,
      userId: json['condition'] as num?,
      topicId: json['topicId'] as String?,
      gender: json['gender'] as num?,
      userName: json['userName'] as String?,
      pageNumber: json['pageNumber'] as num?,
      id: json['id'] as num?,
      searchTime: json['searchTime'] as num?,

    );

Map<String, dynamic> _$WsActivitySearchInfoReqToJson(WsActivitySearchInfoReq instance) =>
    <String, dynamic>{
      'type': instance.type,
      'sort': instance.sort,
      'dir': instance.dir,
      'page': instance.page,
      'size': instance.size,
      'condition': instance.condition,
      'userId': instance.userId,
      'topicId': instance.topicId,
      'gender':instance.gender,
      'userName':instance.userName,
      'pageNumber':instance.pageNumber,
      'id':instance.id,
       'searchTime':instance.searchTime,
    };