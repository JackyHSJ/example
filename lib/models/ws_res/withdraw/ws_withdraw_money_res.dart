import 'package:json_annotation/json_annotation.dart';

part 'ws_withdraw_money_res.g.dart';

@JsonSerializable()
class WsWithdrawMoneyRes {
  WsWithdrawMoneyRes();

  factory WsWithdrawMoneyRes.create() {
    return WsWithdrawMoneyRes(
    );
  }

  factory WsWithdrawMoneyRes.fromJson(Map<String, dynamic> json) =>
      _$WsWithdrawMoneyResFromJson(json);
  Map<String, dynamic> toJson() => _$WsWithdrawMoneyResToJson(this);
}