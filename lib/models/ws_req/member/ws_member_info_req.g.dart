// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ws_member_info_req.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WsMemberInfoReq _$WsMemberInfoReqFromJson(Map<String, dynamic> json) =>
    WsMemberInfoReq(
      userName: json['userName'] as String?,
      id: json['id'] as num?,
      newVisitor: json['newVisitor'] as num?
    );

Map<String, dynamic> _$WsMemberInfoReqToJson(WsMemberInfoReq instance) =>
    <String, dynamic>{
      'userName': instance.userName,
      'id': instance.id,
      'newVisitor': instance.newVisitor,
    };
