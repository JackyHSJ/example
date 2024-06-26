// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ws_agent_promoter_info_res.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WsAgentPromoterInfoRes _$WsAgentPromoterInfoResFromJson(Map<String, dynamic> json) =>
    WsAgentPromoterInfoRes(
          todayIncome: json['todayIncome'] as num?,
          todayPrimaryIncome: json['todayPrimaryIncome'] as num?,
          yesterdayIncome: json['yesterdayIncome'] as num?,
          weekIncome: json['weekIncome'] as num?,
          monthIncome: json['monthIncome'] as num?,
          memberCount: json['memberCount'] as num?,
          totalMemberCount: json['totalMemberCount'] as num?,
          totalPromoterCount: json['totalPromoterCount'] as num?,
          promoterCount: json['promoterCount'] as num?,
    );

Map<String, dynamic> _$WsAgentPromoterInfoResToJson(WsAgentPromoterInfoRes instance) => 
    <String, dynamic>{
          'todayIncome': instance.todayIncome,
          'todayPrimaryIncome': instance.todayPrimaryIncome,
          'yesterdayIncome': instance.yesterdayIncome,
          'weekIncome': instance.weekIncome,
          'monthIncome': instance.monthIncome,
          'memberCount': instance.memberCount,
          'totalMemberCount': instance.totalMemberCount,
          'totalPromoterCount': instance.totalPromoterCount,
          'promoterCount': instance.promoterCount,
    };