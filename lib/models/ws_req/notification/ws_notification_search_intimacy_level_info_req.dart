
import 'package:json_annotation/json_annotation.dart';

part 'ws_notification_search_intimacy_level_info_req.g.dart';

@JsonSerializable()
class WsNotificationSearchIntimacyLevelInfoReq {
  WsNotificationSearchIntimacyLevelInfoReq();

  factory WsNotificationSearchIntimacyLevelInfoReq.create() {
    return WsNotificationSearchIntimacyLevelInfoReq();
  }

  factory WsNotificationSearchIntimacyLevelInfoReq.fromJson(Map<String, dynamic> json) =>
      _$WsNotificationSearchIntimacyLevelInfoReqFromJson(json);
  Map<String, dynamic> toJson() => _$WsNotificationSearchIntimacyLevelInfoReqToJson(this);

  Map<String, String> toBody() =>
      toJson().map((key, value) => value == null ? MapEntry(key, 'null') : MapEntry(key, value));
}
