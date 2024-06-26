import 'package:json_annotation/json_annotation.dart';

part 'ws_check_in_search_list_req.g.dart';

@JsonSerializable()
class WsCheckInSearchListReq {
  WsCheckInSearchListReq();
  factory WsCheckInSearchListReq.create() {
    return WsCheckInSearchListReq();
  }
  factory WsCheckInSearchListReq.fromJson(Map<String, dynamic> json) =>
      _$WsCheckInSearchListReqFromJson(json);
  Map<String, dynamic> toJson() => _$WsCheckInSearchListReqToJson(this);
}
