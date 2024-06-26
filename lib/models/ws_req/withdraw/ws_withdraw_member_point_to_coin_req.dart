import 'package:json_annotation/json_annotation.dart';

part 'ws_withdraw_member_point_to_coin_req.g.dart';

@JsonSerializable()
class WsWithdrawMemberPointToCoinReq {
  WsWithdrawMemberPointToCoinReq({required this.points});
  factory WsWithdrawMemberPointToCoinReq.create({required num points}) {
    return WsWithdrawMemberPointToCoinReq(points: points);
  }

  /// 提現方式 0:微信 1:支付寶 2:蘋果
  @JsonKey(name: 'points')
  num? points;

  factory WsWithdrawMemberPointToCoinReq.fromJson(Map<String, dynamic> json) => _$WsWithdrawMemberPointToCoinReqFromJson(json);
  Map<String, dynamic> toJson() => _$WsWithdrawMemberPointToCoinReqToJson(this);

  Map<String, String> toBody() => toJson().map((key, value) => value == null ? MapEntry(key, 'null') : MapEntry(key, value));
}
