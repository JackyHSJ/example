
import 'package:json_annotation/json_annotation.dart';

part 'ws_mission_search_status_req.g.dart';

@JsonSerializable()
class WsMissionSearchStatusReq {
  WsMissionSearchStatusReq();

  factory WsMissionSearchStatusReq.create() {
    return WsMissionSearchStatusReq(
    );
  }

  factory WsMissionSearchStatusReq.fromJson(Map<String, dynamic> json) =>
      _$WsMissionSearchStatusReqFromJson(json);
  Map<String, dynamic> toJson() => _$WsMissionSearchStatusReqToJson(this);

  Map<String, String> toBody() =>
      toJson().map((key, value) => value == null ? MapEntry(key, 'null') : MapEntry(key, value));
}
