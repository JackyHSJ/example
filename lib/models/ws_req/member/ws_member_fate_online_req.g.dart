// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ws_member_fate_online_req.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WsMemberFateOnlineReq _$WsMemberFateOnlineReqFromJson(Map<String, dynamic> json) =>
    WsMemberFateOnlineReq(
        page: json['page'] as num?,
        topListPage: json['topListPage'] as num?,
        orderSeq: json['orderSeq'] as num?,
        totalPages: json['totalPages'] as num?
    );

Map<String, dynamic> _$WsMemberFateOnlineReqToJson(WsMemberFateOnlineReq instance) => 
    <String, dynamic>{
        'page': instance.page,
        'topListPage': instance.topListPage,
        'orderSeq': instance.orderSeq,
        'totalPages': instance.totalPages
    };
