// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ws_detail_search_list_coin_req.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WsDetailSearchListCoinReq _$WsDetailSearchListCoinReqFromJson(Map<String, dynamic> json) =>
    WsDetailSearchListCoinReq(
        startTime: json['startTime'] as String?,
        endTime: json['endTime'] as String?,
        page: json['page'] as String?,
        size: json['size'] as num?,
    );

Map<String, dynamic> _$WsDetailSearchListCoinReqToJson(WsDetailSearchListCoinReq instance) =>
    <String, dynamic>{
      'startTime': instance.startTime,
      'endTime': instance.endTime,
      'page': instance.page,
      'size': instance.size,
    };