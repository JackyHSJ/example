import 'package:json_annotation/json_annotation.dart';

part 'ws_deposit_wechat_pay_sign_res.g.dart';

@JsonSerializable()
class WsDepositWeChatPaySignRes {
  WsDepositWeChatPaySignRes({
    this.sign,
  });

  /// 支付寶訂單資訊
  @JsonKey(name: 'sign')
  String? sign;

  factory WsDepositWeChatPaySignRes.fromJson(Map<String, dynamic> json) =>
      _$WsDepositWeChatPaySignResFromJson(json);
  Map<String, dynamic> toJson() => _$WsDepositWeChatPaySignResToJson(this);
}