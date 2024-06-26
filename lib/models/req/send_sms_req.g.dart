// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'send_sms_req.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SendSmsReq _$SendSmsReqFromJson(Map<String, dynamic> json) =>
    SendSmsReq(
      phonenumber: json['phonenumber'] as String,
      appId: json['appId'] as String,
    );

Map<String, dynamic> _$SendSmsReqToJson(SendSmsReq instance) =>
    <String, dynamic>{
      'phonenumber': instance.phonenumber,
      'appId': instance.appId,
    };
