import 'package:json_annotation/json_annotation.dart';

part 'ws_member_real_person_veri_req.g.dart';

@JsonSerializable()
class WsMemberRealPersonVeriReq {
  WsMemberRealPersonVeriReq();

  factory WsMemberRealPersonVeriReq.create() {
    return WsMemberRealPersonVeriReq();
  }

  factory WsMemberRealPersonVeriReq.fromJson(Map<String, dynamic> json) =>
      _$WsMemberRealPersonVeriReqFromJson(json);
  Map<String, dynamic> toJson() => _$WsMemberRealPersonVeriReqToJson(this);

  Map<String, String> toBody() =>
      toJson().map((key, value) => value == null ? MapEntry(key, 'null') : MapEntry(key, value));
}
