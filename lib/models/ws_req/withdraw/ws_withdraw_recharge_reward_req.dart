import 'package:json_annotation/json_annotation.dart';

part 'ws_withdraw_recharge_reward_req.g.dart';

@JsonSerializable()
class WsWithdrawRechargeRewardReq {
  WsWithdrawRechargeRewardReq();
  factory WsWithdrawRechargeRewardReq.create() {
    return WsWithdrawRechargeRewardReq( );
  }

  factory WsWithdrawRechargeRewardReq.fromJson(Map<String, dynamic> json) =>
      _$WsWithdrawRechargeRewardFromJson(json);
  Map<String, dynamic> toJson() => _$WsWithdrawRechargeRewardToJson(this);

  Map<String, String> toBody() =>
      toJson().map((key, value) => value == null ? MapEntry(key, 'null') : MapEntry(key, value));
}
