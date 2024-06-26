// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'send_sms_res.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SendSmsRes _$SendSmsMapFromJson(Map<String, dynamic> json) =>
    SendSmsRes(
      isSend: json['isSend'] as bool?,
      dailyLimit: json['dailyLimit'] as num?,
    );

Map<String, dynamic> _$SendSmsResToJson(SendSmsRes instance) =>
    <String, dynamic>{
      'isSend': instance.isSend,
      'dailyLimit': instance.dailyLimit,
    };
