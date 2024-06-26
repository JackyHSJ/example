// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'report_user_req.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReportUserReq _$ReportUserReqFromJson(Map<String, dynamic> json) =>
    ReportUserReq(
      tId: json['tId'] as String,
      files: json['files'] as List<File>?,
      type: json['type'] as num,
      remark: json['remark'] as String,
      userId: json['userId'] as num,
      reportSettingId: json['reportSettingId'] as num,
      feedsId: json['feedsId'] as num,
      feedReplyId: json['feedReplyId'] as num,
    );

Map<String, dynamic> _$ReportUserReqToJson(ReportUserReq instance) =>
    <String, dynamic>{
      'tId': instance.tId,
      'files': instance.files,
      'type': instance.type,
      'remark': instance.remark,
      'userId': instance.userId,
      'reportSettingId': instance.reportSettingId,
      'feedsId': instance.feedsId,
      'feedReplyId': instance.feedReplyId,
    };
