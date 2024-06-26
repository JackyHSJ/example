
import 'package:json_annotation/json_annotation.dart';

part 'ws_notification_leave_group_block_res.g.dart';

@JsonSerializable()
class WsNotificationLeaveGroupBlockRes {
  WsNotificationLeaveGroupBlockRes({
    this.roomId,
  });

  @JsonKey(name: 'roomId')
  final num? roomId;

  factory WsNotificationLeaveGroupBlockRes.fromJson(Map<String, dynamic> json) =>
      _$WsNotificationLeaveGroupBlockResFromJson(json);

  Map<String, dynamic> toJson() => _$WsNotificationLeaveGroupBlockResToJson(this);
}
