
import 'package:json_annotation/json_annotation.dart';
part 'ws_notification_leave_group_block_req.g.dart';

@JsonSerializable()
class WsNotificationLeaveGroupBlockReq {
  WsNotificationLeaveGroupBlockReq({
    this.roomId,
  });

  factory WsNotificationLeaveGroupBlockReq.create({
    num? roomId,
  }) {
    return WsNotificationLeaveGroupBlockReq(
      roomId: roomId,
    );
  }

  @JsonKey(name: 'roomId')
  num? roomId;

  factory WsNotificationLeaveGroupBlockReq.fromJson(Map<String, dynamic> json) =>
      _$WsNotificationLeaveGroupBlockReqFromJson(json);
  Map<String, dynamic> toJson() => _$WsNotificationLeaveGroupBlockReqToJson(this);

  Map<String, String> toBody() =>
      toJson().map((key, value) => value == null ? MapEntry(key, 'null') : MapEntry(key, value));
}
