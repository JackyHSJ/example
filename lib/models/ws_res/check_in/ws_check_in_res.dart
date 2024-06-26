import 'package:json_annotation/json_annotation.dart';

part 'ws_check_in_res.g.dart';

@JsonSerializable()
class WsCheckInRes {
  WsCheckInRes();

  factory WsCheckInRes.fromJson(Map<String, dynamic> json) =>
      _$WsCheckInResFromJson(json);
  Map<String, dynamic> toJson() => _$WsCheckInResToJson(this);
}
