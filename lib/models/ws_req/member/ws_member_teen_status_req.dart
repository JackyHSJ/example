import 'package:json_annotation/json_annotation.dart';

part 'ws_member_teen_status_req.g.dart';

@JsonSerializable()
class WsMemberTeenStatusReq {
  WsMemberTeenStatusReq();

  factory WsMemberTeenStatusReq.create() {
    return WsMemberTeenStatusReq();
  }

  factory WsMemberTeenStatusReq.fromJson(Map<String, dynamic> json) =>
      _$WsMemberTeenStatusReqFromJson(json);
  Map<String, dynamic> toJson() => _$WsMemberTeenStatusReqToJson(this);

  Map<String, String> toBody() =>
      toJson().map((key, value) => value == null ? MapEntry(key, 'null') : MapEntry(key, value));
}
