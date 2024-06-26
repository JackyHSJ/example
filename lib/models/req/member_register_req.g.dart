// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'member_register_req.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MemberRegisterReq _$MemberRegisterReqFromJson(Map<String, dynamic> json) =>
    MemberRegisterReq(
          data: json['data'] as String,
          avatarImg: json['avatarImg'] as File,
          appId: json['appId'] as String?,
          location: json['location'] as String?,
          osType: json['osType'] as num?,
          merchant: json['merchant'] as String,
          token1: json['token1'] as String?,
    );

Map<String, dynamic> _$MemberRegisterReqToJson(MemberRegisterReq instance) =>
    <String, dynamic>{
      'data': instance.data,
      'avatarImg': instance.avatarImg,
      'appId': instance.appId,
      'location': instance.location,
      'osType': instance.osType,
      'merchant': instance.merchant,
      'token1': instance.token1,
    };
