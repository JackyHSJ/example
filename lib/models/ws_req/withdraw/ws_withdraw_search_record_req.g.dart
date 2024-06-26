// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ws_withdraw_search_record_req.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WsWithdrawSearchRecordReq _$WsWithdrawSearchRecordReqFromJson(Map<String, dynamic> json) => WsWithdrawSearchRecordReq(
      startTime: json['startTime'] as String,
      endTime: json['endTime'] as String,
      page: json['page'] as String?,
      size: json['size'] as num?,
    );

Map<String, dynamic> _$WsWithdrawSearchRecordReqToJson(WsWithdrawSearchRecordReq instance) => <String, dynamic>{
      'startTime': instance.startTime,
      'endTime': instance.endTime,
      'page': instance.page,
      'size': instance.size,
    };
