import 'package:json_annotation/json_annotation.dart';

part 'ws_member_point_coin_req.g.dart';

@JsonSerializable()
class WsMemberPointCoinReq {
  WsMemberPointCoinReq();

  factory WsMemberPointCoinReq.create() {
    return WsMemberPointCoinReq();
  }

  factory WsMemberPointCoinReq.fromJson(Map<String, dynamic> json) =>
      _$WsMemberPointCoinReqFromJson(json);
  Map<String, dynamic> toJson() => _$WsMemberPointCoinReqToJson(this);

  Map<String, String> toBody() =>
      toJson().map((key, value) => value == null ? MapEntry(key, 'null') : MapEntry(key, value));
}
