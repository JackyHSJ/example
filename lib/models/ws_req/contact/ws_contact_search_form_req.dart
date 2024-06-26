import 'package:json_annotation/json_annotation.dart';

part 'ws_contact_search_form_req.g.dart';

@JsonSerializable()
class WsContactSearchFormReq {
  WsContactSearchFormReq();
  factory WsContactSearchFormReq.create() {
    return WsContactSearchFormReq(
    );
  }

  factory WsContactSearchFormReq.fromJson(Map<String, dynamic> json) =>
      _$WsContactSearchFormReqFromJson(json);
  Map<String, dynamic> toJson() => _$WsContactSearchFormReqToJson(this);

  Map<String, String> toBody() =>
      toJson().map((key, value) => value == null ? MapEntry(key, 'null') : MapEntry(key, value));
}
