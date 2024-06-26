
import 'package:json_annotation/json_annotation.dart';
part 'ws_notification_block_group_req.g.dart';

@JsonSerializable()
class WsNotificationBlockGroupReq {
  WsNotificationBlockGroupReq({
    this.page,
  });

  factory WsNotificationBlockGroupReq.create({
    num? page,
  }) {
    return WsNotificationBlockGroupReq(
      page: page,
    );
  }

  @JsonKey(name: 'page')
  num? page;

  factory WsNotificationBlockGroupReq.fromJson(Map<String, dynamic> json) =>
      _$WsNotificationBlockGroupReqFromJson(json);
  Map<String, dynamic> toJson() => _$WsNotificationBlockGroupReqToJson(this);

  Map<String, String> toBody() =>
      toJson().map((key, value) => value == null ? MapEntry(key, 'null') : MapEntry(key, value));
}
