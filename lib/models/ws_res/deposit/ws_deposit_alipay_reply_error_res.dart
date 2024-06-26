import 'package:json_annotation/json_annotation.dart';

part 'ws_deposit_alipay_reply_error_res.g.dart';

@JsonSerializable()
class WsDepositAlipayReplyErrorRes {
  WsDepositAlipayReplyErrorRes();

  factory WsDepositAlipayReplyErrorRes.fromJson(Map<String, dynamic> json) =>
      _$WsDepositAlipayReplyErrorResFromJson(json);
  Map<String, dynamic> toJson() => _$WsDepositAlipayReplyErrorResToJson(this);
}