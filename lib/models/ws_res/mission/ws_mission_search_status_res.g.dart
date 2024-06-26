// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ws_mission_search_status_res.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WsMissionSearchStatusRes _$WsMissionSearchStatusResFromJson(Map<String, dynamic> json) => WsMissionSearchStatusRes(
      list: (json['list'] as List).map((info) => MissionStatusList.fromJson(info)).toList(),
    );

Map<String, dynamic> _$WsMissionSearchStatusResToJson(WsMissionSearchStatusRes instance) => <String, dynamic>{
      'list': instance.list,
    };

MissionStatusList _$MissionStatusListFromJson(Map<String, dynamic> json) => MissionStatusList(
      coins: json['coins'] as num?,
      name: json['name'] as String?,
      points: json['points'] as num?,
      status: json['status'] as String?,
      target: json['target'] as num?,
    );

Map<String, dynamic> _$MissionStatusListToJson(MissionStatusList instance) => <String, dynamic>{
      'coins': instance.coins,
      'name': instance.name,
      'points': instance.points,
      'status': instance.status,
      'target': instance.target,
    };
