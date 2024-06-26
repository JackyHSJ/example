// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'member_login_req.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MemberLoginReq _$MemberLoginReqFromJson(Map<String, dynamic> json) =>
    MemberLoginReq(
      data: json['data'] as String,
      tdata: json['tdata'] as String,
      type: json['type'] as num?,
      express: json['express'] as bool?,
      appId: json['appId'] as String?,
      location: json['location'] as String?,
      osType: json['osType'] as int?,
      resp3rd: json['resp3rd'] as String?,
      token1: json['token1'] as String?,
      token2: json['token2'] as String?,
      tokenType: json['tokenType'] as String,
      merchant: json['merchant'] as String,
      version: json['version'] as String,
    );

Map<String, dynamic> _$MemberLoginReqToJson(MemberLoginReq instance) =>
    <String, dynamic>{
          'data': instance.data,
          'tdata': instance.tdata,
          'type': instance.type,
          'express': instance.express,
          'appId': instance.appId,
          'location': instance.location,
          'osType': instance.osType,
          'resp3rd': instance.resp3rd,
          'token1': instance.token1,
          'token2': instance.token2,
          'merchant': instance.merchant,
          'tokenType': instance.tokenType,
          'version': instance.version,
    };
