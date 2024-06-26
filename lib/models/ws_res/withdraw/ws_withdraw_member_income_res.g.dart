// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ws_withdraw_member_income_res.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WsWithdrawMemberIncomeRes _$WsWithdrawMemberIncomeResFromJson(Map<String, dynamic> json) =>
    WsWithdrawMemberIncomeRes(
      list: (json['list'] as List).map((info) => WithdrawIncomeListInfo.fromJson(info)).toList(),
      firstWithdrawal: json['firstWithdrawal'] as String?,
      tip: json['tip'] as String?,
      dailyWithdrawPerDay: json['dailyWithdrawPerDay'] as String?,
      withdrawAmountPerDay: json['withdrawAmountPerDay'] as String?,
    );

Map<String, dynamic> _$WsWithdrawMemberIncomeResToJson(WsWithdrawMemberIncomeRes instance) => 
    <String, dynamic>{
      'list': instance.list,
      'firstWithdrawal': instance.firstWithdrawal,
      'tip': instance.tip,
      'dailyWithdrawPerDay': instance.dailyWithdrawPerDay,
      'withdrawAmountPerDay': instance.withdrawAmountPerDay,
    };

WithdrawIncomeListInfo _$WithdrawIncomeListInfoFromJson(Map<String, dynamic> json) =>
    WithdrawIncomeListInfo(
      pointRange: json['pointRange'] as String?,
      moneyRange: json['moneyRange'] as String?,
      type: json['type'] as String?,
      secondTransfer: json['secondTransfer'] as String?,
    );

Map<String, dynamic> _$WithdrawIncomeListInfoToJson(WithdrawIncomeListInfo instance) =>
    <String, dynamic>{
      'pointRange': instance.pointRange,
      'moneyRange': instance.moneyRange,
      'type': instance.type,
      'secondTransfer': instance.secondTransfer,
    };