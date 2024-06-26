// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ws_detail_search_list_income_req.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WsDetailSearchListIncomeReq _$WsDetailSearchListIncomeReqFromJson(Map<String, dynamic> json) =>
    WsDetailSearchListIncomeReq(
        startTime: json['startTime'] as String?,
        endTime: json['endTime'] as String?,
        page: json['page'] as String?,
        size: json['size'] as num?,
    );

Map<String, dynamic> _$WsDetailSearchListIncomeReqToJson(WsDetailSearchListIncomeReq instance) =>
    <String, dynamic>{
      'startTime': instance.startTime,
      'endTime': instance.endTime,
      'page': instance.page,
      'size': instance.size,
    };