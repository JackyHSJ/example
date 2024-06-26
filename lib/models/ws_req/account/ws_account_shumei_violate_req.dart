
import 'package:json_annotation/json_annotation.dart';

part 'ws_account_shumei_violate_req.g.dart';

@JsonSerializable()
class WsAccountShumeiViolateReq {
  WsAccountShumeiViolateReq();

  factory WsAccountShumeiViolateReq.create() {
    return WsAccountShumeiViolateReq();
  }

  factory WsAccountShumeiViolateReq.fromJson(Map<String, dynamic> json) =>
      _$WsAccountShumeiViolateReqFromJson(json);
  Map<String, dynamic> toJson() => _$WsAccountShumeiViolateReqToJson(this);

  Map<String, String> toBody() =>
      toJson().map((key, value) => value == null ? MapEntry(key, 'null') : MapEntry(key, value));
}
