import 'package:json_annotation/json_annotation.dart';

part 'ws_member_point_coin_res.g.dart';

// 2-8
@JsonSerializable()
class WsMemberPointCoinRes {
  WsMemberPointCoinRes({
    this.userId,
    this.coins,
    this.points,
    this.depositCount,
  });

  @JsonKey(name: 'userId')
  num? userId;

  @JsonKey(name: 'coins')
  num? coins;

  @JsonKey(name: 'points')
  num? points;

  @JsonKey(name: 'depositCount')
  num? depositCount;

  factory WsMemberPointCoinRes.fromJson(Map<String, dynamic> json) =>
      _$WsMemberPointCoinResFromJson(json);
  Map<String, dynamic> toJson() => _$WsMemberPointCoinResToJson(this);
}
