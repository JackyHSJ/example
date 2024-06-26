// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ws_report_search_type_res.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WsReportSearchTypeRes _$WsReportSearchTypeResFromJson(Map<String, dynamic> json) =>
    WsReportSearchTypeRes(
        list: (json['list'] as List).map((info) => ReportListInfo.fromJson(info)).toList()
    );

Map<String, dynamic> _$WsReportSearchTypeResToJson(WsReportSearchTypeRes instance) => 
    <String, dynamic>{ 'list': instance.list };

ReportListInfo _$ReportListInfoFromJson(Map<String, dynamic> json) =>
    ReportListInfo(
      id: json['id'] as num?,
      type: json['type'] as String?,
      reason: json['reason'] as String?,
      seq: json['seq'] as num?,
      writeTime: json['writeTime'] as num?,
      updateTime: json['updateTime'] as num?,
      systemUser: json['systemUser'] as String?,
      status: json['status'] as num?,
    );

Map<String, dynamic> _$ReportListInfoToJson(ReportListInfo instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'reason': instance.reason,
      'seq': instance.seq,
      'writeTime': instance.writeTime,
      'updateTime': instance.updateTime,
      'systemUser': instance.systemUser,
      'status': instance.status,
};