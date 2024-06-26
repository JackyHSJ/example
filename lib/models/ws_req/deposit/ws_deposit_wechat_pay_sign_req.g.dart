// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ws_deposit_wechat_pay_sign_req.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WsDepositWeChatPaySignReq _$WsDepositWeChatPaySignReqFromJson(Map<String, dynamic> json) =>
    WsDepositWeChatPaySignReq(
      prepayId: json['prepayId'] as String,
      timestamp: json['timestamp'] as String,
      nonceStr: json['nonceStr'] as String,
      transactionId: json['transactionId'] as String,
    );

Map<String, dynamic> _$WsDepositWeChatPaySignReqToJson(WsDepositWeChatPaySignReq instance) =>
    <String, dynamic>{
      'prepayId': instance.prepayId,
      'timestamp': instance.timestamp,
      'nonceStr': instance.nonceStr,
      'transactionId': instance.transactionId,
    };