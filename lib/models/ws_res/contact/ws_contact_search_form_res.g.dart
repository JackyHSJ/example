// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ws_contact_search_form_res.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WsContactSearchFormRes _$WsContactSearchFormResFromJson(Map<String, dynamic> json) =>
    WsContactSearchFormRes(
          todayRevenue: json['todayRevenue'] as num?,
          lastWeekRevenue: json['lastWeekRevenue'] as num?,
          thisWeekRevenue: json['thisWeekRevenue'] as num?,
    );

Map<String, dynamic> _$WsContactSearchFormResToJson(WsContactSearchFormRes instance) => 
    <String, dynamic>{
          'todayRevenue': instance.todayRevenue,
          'lastWeekRevenue': instance.lastWeekRevenue,
          'thisWeekRevenue': instance.thisWeekRevenue,
};