import 'package:json_annotation/json_annotation.dart';

part 'ws_member_apply_cancel_req.g.dart';

@JsonSerializable()
class WsMemberApplyCancelReq {
  WsMemberApplyCancelReq();

  factory WsMemberApplyCancelReq.create() {
    return WsMemberApplyCancelReq();
  }

  factory WsMemberApplyCancelReq.fromJson(Map<String, dynamic> json) =>
      _$WsMemberApplyCancelReqFromJson(json);
  Map<String, dynamic> toJson() => _$WsMemberApplyCancelReqToJson(this);

  Map<String, String> toBody() =>
      toJson().map((key, value) => value == null ? MapEntry(key, 'null') : MapEntry(key, value));
}
