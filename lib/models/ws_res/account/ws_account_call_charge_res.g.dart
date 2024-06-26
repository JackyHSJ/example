// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ws_account_call_charge_res.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WsAccountCallChargeRes _$WsAccountCallChargeResFromJson(Map<String, dynamic> json) => WsAccountCallChargeRes(
  cost: json['cost'] as num?,
  remainCoins: json['remainCoins'] as num?,
  remainTimes: json['remainTimes'] as num?,
);

Map<String, dynamic> _$WsAccountCallChargeResToJson(WsAccountCallChargeRes instance) => <String, dynamic>{
  'cost': instance.cost,
  'remainCoins': instance.remainCoins,
  'remainTimes': instance.remainTimes,
};
