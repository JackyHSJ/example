// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ws_deposit_money_req.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WsDepositMoneyReq _$WsDepositMoneyReqFromJson(Map<String, dynamic> json) =>
    WsDepositMoneyReq(
      type: json['type'] as num?,
      amount: json['amount'] as num?,
    );

Map<String, dynamic> _$WsDepositMoneyReqToJson(WsDepositMoneyReq instance) =>
    <String, dynamic>{
      'type': instance.type,
      'amount': instance.amount,
    };