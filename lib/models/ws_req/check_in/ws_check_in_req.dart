import 'package:json_annotation/json_annotation.dart';

part 'ws_check_in_req.g.dart';

@JsonSerializable()
class WsCheckInReq {
  WsCheckInReq();
  factory WsCheckInReq.create() {
    return WsCheckInReq();
  }

  factory WsCheckInReq.fromJson(Map<String, dynamic> json) =>
      _$WsCheckInReqFromJson(json);
  Map<String, dynamic> toJson() => _$WsCheckInReqToJson(this);

  Map<String, String> toBody() =>
      toJson().map((key, value) => value == null ? MapEntry(key, 'null') : MapEntry(key, value));
}
