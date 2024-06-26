import 'package:json_annotation/json_annotation.dart';

part 'ws_deposit_apple_reply_receipt_req.g.dart';

@JsonSerializable()
class WsDepositAppleReplyReceiptReq {
  WsDepositAppleReplyReceiptReq({
    this.receiptId,
    this.transactionId,
  });
  factory WsDepositAppleReplyReceiptReq.create({
    String? receiptId,
    String? transactionId,
  }) {
    return WsDepositAppleReplyReceiptReq(
      receiptId: receiptId,
      transactionId: transactionId,
    );
  }

  /// 蘋果ID
  @JsonKey(name: 'receiptId')
  String? receiptId;

  /// 交易ID
  @JsonKey(name: 'transactionId')
  String? transactionId;

  factory WsDepositAppleReplyReceiptReq.fromJson(Map<String, dynamic> json) =>
      _$WsDepositAppleReplyReceiptReqFromJson(json);
  Map<String, dynamic> toJson() => _$WsDepositAppleReplyReceiptReqToJson(this);

  Map<String, String> toBody() =>
      toJson().map((key, value) => value == null ? MapEntry(key, 'null') : MapEntry(key, value));
}
