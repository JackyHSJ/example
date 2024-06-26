
import 'package:json_annotation/json_annotation.dart';
part 'ws_notification_search_online_status_req.g.dart';

@JsonSerializable()
class WsNotificationSearchOnlineStatusReq {
  WsNotificationSearchOnlineStatusReq();

  factory WsNotificationSearchOnlineStatusReq.create() {
    return WsNotificationSearchOnlineStatusReq();
  }

  factory WsNotificationSearchOnlineStatusReq.fromJson(Map<String, dynamic> json) =>
      _$WsNotificationSearchOnlineStatusReqFromJson(json);
  Map<String, dynamic> toJson() => _$WsNotificationSearchOnlineStatusReqToJson(this);

  // API 不帶參數的屬性不傳出
  Map<String, dynamic> toBody() {
    Map<String, dynamic> json = toJson();
    json.removeWhere((key, value) => value == null);
    return json;
  }

  // Map<String, String> toBody() =>
  //     toJson().map((key, value) => value == null ? MapEntry(key, 'null') : MapEntry(key, value));
}
