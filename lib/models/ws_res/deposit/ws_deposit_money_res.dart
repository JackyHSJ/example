import 'package:json_annotation/json_annotation.dart';

part 'ws_deposit_money_res.g.dart';

@JsonSerializable()
class WsDepositMoneyRes {
  WsDepositMoneyRes({
    this.alipayOrderInfo,
    this.transactionId,
    this.weChatPayOrderInfo,
    this.weChatPartnerId,
    this.weChatAppId,
  });

  /// 支付寶訂單資訊
  @JsonKey(name: 'alipayOrderInfo')
  String? alipayOrderInfo;

  /// 我方訂單編號 (交易號)
  @JsonKey(name: 'transactionId')
  String? transactionId;

  /// 微信訂單資訊 (prepay_id)
  @JsonKey(name: 'weChatPayOrderInfo')
  String? weChatPayOrderInfo;

  /// 微信商戶 mchId
  @JsonKey(name: 'weChatPartnerId')
  String? weChatPartnerId;

  /// 微信商戶 appId
  @JsonKey(name: 'weChatAppId')
  String? weChatAppId;

  factory WsDepositMoneyRes.fromJson(Map<String, dynamic> json) =>
      _$WsDepositMoneyResFromJson(json);
  Map<String, dynamic> toJson() => _$WsDepositMoneyResToJson(this);
}