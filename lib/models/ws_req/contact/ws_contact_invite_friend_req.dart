import 'package:json_annotation/json_annotation.dart';

part 'ws_contact_invite_friend_req.g.dart';

@JsonSerializable()
class WsContactInviteFriendReq {
  WsContactInviteFriendReq();
  factory WsContactInviteFriendReq.create() {
    return WsContactInviteFriendReq();
  }

  factory WsContactInviteFriendReq.fromJson(Map<String, dynamic> json) =>
      _$WsContactInviteFriendReqFromJson(json);
  Map<String, dynamic> toJson() => _$WsContactInviteFriendReqToJson(this);

  Map<String, String> toBody() =>
      toJson().map((key, value) => value == null ? MapEntry(key, 'null') : MapEntry(key, value));
}
