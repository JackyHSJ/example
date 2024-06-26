import 'package:json_annotation/json_annotation.dart';

part 'ws_activity_donate_post_res.g.dart';

@JsonSerializable()
class WsActivityDonatePostRes {
  WsActivityDonatePostRes();

  factory WsActivityDonatePostRes.fromJson(Map<String, dynamic> json) =>
      _$WsActivityDonatePostResFromJson(json);
  Map<String, dynamic> toJson() => _$WsActivityDonatePostResToJson(this);
}
