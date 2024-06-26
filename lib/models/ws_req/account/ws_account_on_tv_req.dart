
import 'package:json_annotation/json_annotation.dart';

part 'ws_account_on_tv_req.g.dart';

@JsonSerializable()
class WsAccountOnTVReq {
  WsAccountOnTVReq();

  factory WsAccountOnTVReq.create() {
    return WsAccountOnTVReq();
  }

  factory WsAccountOnTVReq.fromJson(Map<String, dynamic> json) =>
      _$WsAccountOnTVReqFromJson(json);
  Map<String, dynamic> toJson() => _$WsAccountOnTVReqToJson(this);

  Map<String, String> toBody() =>
      toJson().map((key, value) => value == null ? MapEntry(key, 'null') : MapEntry(key, value));
}
