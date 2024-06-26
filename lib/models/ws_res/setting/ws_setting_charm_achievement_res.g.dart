// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ws_setting_charm_achievement_res.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WsSettingCharmAchievementRes _$WsSettingCharmAchievementResFromJson(
        Map<String, dynamic> json) =>
    WsSettingCharmAchievementRes(
        list: (json['list'] as List)
            .map((info) => CharmAchievementInfo.fromJson(info))
            .toList(),
        personalCharm: PersonalCharmInfo.fromJson(json['personal_charm']));

Map<String, dynamic> _$WsSettingCharmAchievementResToJson(
        WsSettingCharmAchievementRes instance) =>
    <String, dynamic>{
      'list': instance.list,
      'personalCharm': instance.personalCharm
    };

CharmAchievementInfo _$CharmAchievementInfoFromJson(
        Map<String, dynamic> json) =>
    CharmAchievementInfo(
      levelCondition: json['levelCondition'] as String?,
      streamCharge: json['streamCharge'] as String?,
      messageCharge: json['messageCharge'] as String?,
      voiceCharge: json['voiceCharge'] as String?,
      charmLevel: json['charmLevel'] as String?,
    );

Map<String, dynamic> _$CharmAchievementInfoToJson(
        CharmAchievementInfo instance) =>
    <String, dynamic>{
      'levelCondition': instance.levelCondition,
      'streamCharge': instance.streamCharge,
      'messageCharge': instance.messageCharge,
      'voiceCharge': instance.voiceCharge,
      'charmLevel': instance.charmLevel,
    };

PersonalCharmInfo _$PersonalCharmInfoFromJson(Map<String, dynamic> json) =>
    PersonalCharmInfo(
      charmLevelExpire: json['charm_level_expire'] as num?,
      charmLevel: json['charm_level'] as num?,
      charmPoints: json['charm_points'] as num?,
      charmCharge: json['charm_charge'] as String?,
    );

Map<String, dynamic> _$PersonalCharmInfoToJson(PersonalCharmInfo instance) =>
    <String, dynamic>{
      'charm_level_expire': instance.charmLevelExpire,
      'charm_level': instance.charmLevel,
      'charm_points': instance.charmPoints,
      'charm_charge': instance.charmCharge,
    };
