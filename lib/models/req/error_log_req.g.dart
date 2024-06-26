// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'error_log_req.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ErrorLogReq _$ErrorLogReqFromJson(Map<String, dynamic> json) =>
    ErrorLogReq(
      delayTime: json['delayTime'] as String?,
      userName: json['userName'] as String?,
      funcCode: json['funcCode'] as String?,
      resultCode: json['resultCode'] as String?,
      resultMsg: json['resultMsg'] as dynamic,
    );

Map<String, dynamic> _$ErrorLogReqToJson(ErrorLogReq instance) =>
    <String, dynamic>{
      'delayTime': instance.delayTime,
      'userName': instance.userName,
      'funcCode': instance.funcCode,
      'resultCode': instance.resultCode,
      'resultMsg': instance.resultMsg,
    };
