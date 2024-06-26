import 'package:json_annotation/json_annotation.dart';

part 'ws_deposit_alipay_reply_error_req.g.dart';

@JsonSerializable()
class WsDepositAlipayReplyErrorReq {
  WsDepositAlipayReplyErrorReq({
    this.transactionId,
  });
  factory WsDepositAlipayReplyErrorReq.create({
    String? transactionId,
  }) {
    return WsDepositAlipayReplyErrorReq(
      transactionId: transactionId,
    );
  }

  /// 交易號
  @JsonKey(name: 'transactionId')
  String? transactionId;

  factory WsDepositAlipayReplyErrorReq.fromJson(Map<String, dynamic> json) =>
      _$WsDepositAlipayReplyErrorReqFromJson(json);
  Map<String, dynamic> toJson() => _$WsDepositAlipayReplyErrorReqToJson(this);

  Map<String, String> toBody() =>
      toJson().map((key, value) => value == null ? MapEntry(key, 'null') : MapEntry(key, value));
}
