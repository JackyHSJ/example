// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ws_account_intimacy_level_up_res.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WsAccountIntimacyLevelUpRes _$WsAccountIntimacyLevelUpResFromJson(Map<String, dynamic> json) => WsAccountIntimacyLevelUpRes(
  isCohesionLevelUp: json['isCohesionLevelUp'] as bool?,
  cohesionLevel: json['cohesionLevel'] as num?,
  cohesionPoints: json['cohesionPoints'] as num?,
  userList: json['userList'] as List?,
);

Map<String, dynamic> _$WsAccountIntimacyLevelUpResToJson(WsAccountIntimacyLevelUpRes instance) => <String, dynamic>{
  'isCohesionLevelUp': instance.isCohesionLevelUp,
  'cohesionLevel': instance.cohesionLevel,
  'cohesionPoints': instance.cohesionPoints,
  'userList': instance.userList,
};
