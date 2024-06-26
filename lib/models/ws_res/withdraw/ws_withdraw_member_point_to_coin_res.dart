import 'package:json_annotation/json_annotation.dart';

part 'ws_withdraw_member_point_to_coin_res.g.dart';

@JsonSerializable()
class WsWithdrawMemberPointToCoinRes {
  WsWithdrawMemberPointToCoinRes({
    this.userId,
    this.coins,
    this.points,
  });

  factory WsWithdrawMemberPointToCoinRes.create({
    num? userId, num? coins, num? points
  }) {
    return WsWithdrawMemberPointToCoinRes(
      userId: userId,
      coins: coins,
      points: points,
    );
  }

  @JsonKey(name: 'userId')
  num? userId;

  @JsonKey(name: 'coins')
  num? coins;

  @JsonKey(name: 'points')
  num? points;

  factory WsWithdrawMemberPointToCoinRes.fromJson(Map<String, dynamic> json) =>
      _$WsWithdrawMemberPointToCoinResFromJson(json);
  Map<String, dynamic> toJson() => _$WsWithdrawMemberPointToCoinResToJson(this);
}