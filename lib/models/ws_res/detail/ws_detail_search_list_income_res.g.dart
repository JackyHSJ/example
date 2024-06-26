// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ws_detail_search_list_income_res.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WsDetailSearchListIncomeRes _$WsDetailSearchListIncomeResFromJson(Map<String, dynamic> json) => WsDetailSearchListIncomeRes(
    pageNumber: json['pageNumber'] as num?,
    totalPages: json['totalPages'] as num?,
    fullListSize: json['fullListSize'] as num?,
    pageSize: json['pageSize'] as num?,
    list: (json['list'] as List).map((info) => DetailListInfo.fromJson(info)).toList());

Map<String, dynamic> _$WsDetailSearchListIncomeResToJson(WsDetailSearchListIncomeRes instance) => <String, dynamic>{
      'pageNumber': instance.pageNumber,
      'totalPages': instance.totalPages,
      'fullListSize': instance.fullListSize,
      'pageSize': instance.pageSize,
      'list': instance.list,
    };
