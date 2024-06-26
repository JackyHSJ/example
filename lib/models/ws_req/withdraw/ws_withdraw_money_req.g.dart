// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ws_withdraw_money_req.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WsWithdrawMoneyReq _$WsWithdrawMoneyReqFromJson(Map<String, dynamic> json) =>
    WsWithdrawMoneyReq(
      type: json['type,'] as num?,
      amount: json['amount,'] as num?,
    );

Map<String, dynamic> _$WsWithdrawMoneyReqToJson(WsWithdrawMoneyReq instance) =>
    <String, dynamic>{
      'type': instance.type,
      'amount': instance.amount,
    };