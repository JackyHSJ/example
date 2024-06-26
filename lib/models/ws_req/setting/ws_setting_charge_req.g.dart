// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ws_setting_charge_req.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WsSettingChargeReq _$WsSettingChargeReqFromJson(Map<String, dynamic> json) =>
    WsSettingChargeReq(
      messageCharge: json['messageCharge,'] as num?,
      voiceCharge: json['voiceCharge,'] as num?,
      streamCharge: json['streamCharge,'] as num?,
    );

Map<String, dynamic> _$WsSettingChargeReqToJson(WsSettingChargeReq instance) =>
    <String, dynamic>{
      'messageCharge': instance.messageCharge,
      'voiceCharge': instance.voiceCharge,
      'streamCharge': instance.streamCharge,
    };
