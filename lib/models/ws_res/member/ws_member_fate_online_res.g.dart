// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ws_member_fate_online_res.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WsMemberFateOnlineRes _$WsMemberFateOnlineResFromJson(Map<String, dynamic> json) =>
    WsMemberFateOnlineRes(
      pageNumber: json['pageNumber'] as num?,
      totalPages: json['totalPages'] as num?,
      fullListSize: json['fullListSize'] as num?,
      pageSize: json['pageSize'] as num?,
      list: (json['list'] as List).map((info) => FateListInfo.fromJson(info)).toList(),
      topList: (json['topList'] as List?)?.map((info) => FateListInfo.fromJson(info)).toList(),
      orderSeq: json['orderSeq'] as num?,
      topListPage: json['topListPage'] as num?
    );

Map<String, dynamic> _$WsMemberFateOnlineResToJson(WsMemberFateOnlineRes instance) =>
    <String, dynamic>{
      'pageNumber': instance.pageNumber,
      'totalPages': instance.totalPages,
      'fullListSize': instance.fullListSize,
      'pageSize': instance.pageSize,
      'list': instance.list,
      'topList': instance.topList,
      'orderSeq': instance.orderSeq,
      'topListPage': instance.topListPage
    };