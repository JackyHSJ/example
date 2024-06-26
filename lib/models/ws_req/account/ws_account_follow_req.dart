
import 'package:json_annotation/json_annotation.dart';

part 'ws_account_follow_req.g.dart';

@JsonSerializable()
class WsAccountFollowReq {
  WsAccountFollowReq({
    this.friendId,
    this.isFollow,
  });

  factory WsAccountFollowReq.create({
    num? friendId,
    bool? isFollow,
  }) {
    return WsAccountFollowReq(
      friendId: friendId,
      isFollow: isFollow,
    );
  }

  @JsonKey(name: 'friendId')
  num? friendId;

  @JsonKey(name: 'isFollow')
  bool? isFollow;

  factory WsAccountFollowReq.fromJson(Map<String, dynamic> json) =>
      _$WsAccountFollowReqFromJson(json);
  Map<String, dynamic> toJson() => _$WsAccountFollowReqToJson(this);

  Map<String, String> toBody() =>
      toJson().map((key, value) => value == null ? MapEntry(key, 'null') : MapEntry(key, value));
}
