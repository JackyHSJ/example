// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ws_benefit_info_res.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WsBenefitInfoRes _$WsBenefitInfoResFromJson(Map<String, dynamic> json) =>
    WsBenefitInfoRes(
      todayIncome: json['todayIncome'] as num?,
      lastWeekIncome: json['lastWeekIncome'] as num?,
      thisWeekIncome: json['thisWeekIncome'] as num?,
      withdrawalAmount: json['withdrawalAmount'] as num?,
    );

Map<String, dynamic> _$WsBenefitInfoResToJson(WsBenefitInfoRes instance) => 
    <String, dynamic>{
      'todayIncome': instance.todayIncome,
      'lastWeekIncome': instance.lastWeekIncome,
      'thisWeekIncome': instance.thisWeekIncome,
      'withdrawalAmount': instance.withdrawalAmount
    };