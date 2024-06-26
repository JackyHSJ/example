import 'package:json_annotation/json_annotation.dart';

part 'ws_account_call_package_req.g.dart';

@JsonSerializable()
class WsAccountCallPackageReq {
  WsAccountCallPackageReq();

  factory WsAccountCallPackageReq.create() {
    return WsAccountCallPackageReq();
  }

  factory WsAccountCallPackageReq.fromJson(Map<String, dynamic> json) =>
      _$WsAccountCallPackageReqFromJson(json);
  Map<String, dynamic> toJson() => _$WsAccountCallPackageReqToJson(this);

  Map<String, String> toBody() =>
      toJson().map((key, value) => value == null ? MapEntry(key, 'null') : MapEntry(key, value));
}
