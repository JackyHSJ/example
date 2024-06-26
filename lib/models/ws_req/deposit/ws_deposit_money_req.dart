import 'package:json_annotation/json_annotation.dart';

part 'ws_deposit_money_req.g.dart';

@JsonSerializable()
class WsDepositMoneyReq {
  WsDepositMoneyReq({
    this.type,
    this.amount,
  });
  factory WsDepositMoneyReq.create({
    num? type,
    num? amount,
  }) {
    return WsDepositMoneyReq(
      type: type,
      amount: amount,
    );
  }

  /// 支付方式 0:微信 1:支付寶 2:蘋果
  @JsonKey(name: 'type')
  num? type;

  /// 金額
  @JsonKey(name: 'amount')
  num? amount;

  factory WsDepositMoneyReq.fromJson(Map<String, dynamic> json) =>
      _$WsDepositMoneyReqFromJson(json);
  Map<String, dynamic> toJson() => _$WsDepositMoneyReqToJson(this);

  Map<String, String> toBody() =>
      toJson().map((key, value) => value == null ? MapEntry(key, 'null') : MapEntry(key, value));
}
