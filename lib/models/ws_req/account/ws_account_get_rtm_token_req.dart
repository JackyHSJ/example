
import 'package:json_annotation/json_annotation.dart';
part 'ws_account_get_rtm_token_req.g.dart';

@JsonSerializable()
class WsAccountGetRTMTokenReq {
  WsAccountGetRTMTokenReq();

  factory WsAccountGetRTMTokenReq.create() {
    return WsAccountGetRTMTokenReq();
  }

  factory WsAccountGetRTMTokenReq.fromJson(Map<String, dynamic> json) =>
      _$WsAccountGetRTMTokenReqFromJson(json);
  Map<String, dynamic> toJson() => _$WsAccountGetRTMTokenReqToJson(this);

  Map<String, String> toBody() =>
      toJson().map((key, value) => value == null ? MapEntry(key, 'null') : MapEntry(key, value));
}
