import 'package:json_annotation/json_annotation.dart';

part 'ws_withdraw_money_req.g.dart';

@JsonSerializable()
class WsWithdrawMoneyReq {
  WsWithdrawMoneyReq({
    this.type,
    this.amount,
  });
  factory WsWithdrawMoneyReq.create({
    num? type,
    num? amount,
  }) {
    return WsWithdrawMoneyReq(
      type: type,
      amount: amount,
    );
  }

  /// 提現方式 0:微信 1:支付寶 2:蘋果
  @JsonKey(name: 'type')
  num? type;

  /// 金額
  @JsonKey(name: 'amount')
  num? amount;

  factory WsWithdrawMoneyReq.fromJson(Map<String, dynamic> json) =>
      _$WsWithdrawMoneyReqFromJson(json);
  Map<String, dynamic> toJson() => _$WsWithdrawMoneyReqToJson(this);

  Map<String, String> toBody() =>
      toJson().map((key, value) => value == null ? MapEntry(key, 'null') : MapEntry(key, value));
}
