import 'package:json_annotation/json_annotation.dart';

part 'ws_deposit_apple_reply_receipt_res.g.dart';

@JsonSerializable()
class WsDepositAppleReplyReceiptRes {
  WsDepositAppleReplyReceiptRes();

  factory WsDepositAppleReplyReceiptRes.fromJson(Map<String, dynamic> json) =>
      _$WsDepositAppleReplyReceiptResFromJson(json);
  Map<String, dynamic> toJson() => _$WsDepositAppleReplyReceiptResToJson(this);
}