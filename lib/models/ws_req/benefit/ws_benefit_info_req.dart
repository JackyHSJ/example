import 'package:json_annotation/json_annotation.dart';

part 'ws_benefit_info_req.g.dart';

@JsonSerializable()
class WsBenefitInfoReq {
  WsBenefitInfoReq();
  factory WsBenefitInfoReq.create() {
    return WsBenefitInfoReq();
  }

  factory WsBenefitInfoReq.fromJson(Map<String, dynamic> json) =>
      _$WsBenefitInfoReqFromJson(json);
  Map<String, dynamic> toJson() => _$WsBenefitInfoReqToJson(this);

  Map<String, String> toBody() =>
      toJson().map((key, value) => value == null ? MapEntry(key, 'null') : MapEntry(key, value));
}
