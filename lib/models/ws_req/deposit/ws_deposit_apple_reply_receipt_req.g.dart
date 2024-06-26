// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ws_deposit_apple_reply_receipt_req.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WsDepositAppleReplyReceiptReq _$WsDepositAppleReplyReceiptReqFromJson(Map<String, dynamic> json) =>
    WsDepositAppleReplyReceiptReq(
      receiptId: json['receiptId'] as String?,
      transactionId: json['transactionId'] as String?,
    );

Map<String, dynamic> _$WsDepositAppleReplyReceiptReqToJson(WsDepositAppleReplyReceiptReq instance) =>
    <String, dynamic>{
      'receiptId': instance.receiptId,
      'transactionId': instance.transactionId,
    };