// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ws_deposit_money_res.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WsDepositMoneyRes _$WsDepositMoneyResFromJson(Map<String, dynamic> json) =>
    WsDepositMoneyRes(
      alipayOrderInfo: json['alipayOrderInfo'] as String?,
      transactionId: json['transactionId'] as String?,
      weChatPayOrderInfo: json['weChatPayOrderInfo'] as String?,
      weChatPartnerId: json['weChatPartnerId'] as String?,
      weChatAppId: json['weChatAppId'] as String?,
    );

Map<String, dynamic> _$WsDepositMoneyResToJson(WsDepositMoneyRes instance) => 
    <String, dynamic>{
      'alipayOrderInfo': instance.alipayOrderInfo,
      'transactionId': instance.transactionId,
      'weChatPayOrderInfo': instance.weChatPayOrderInfo,
      'weChatPartnerId': instance.weChatPartnerId,
      'weChatAppId': instance.weChatAppId,
    };