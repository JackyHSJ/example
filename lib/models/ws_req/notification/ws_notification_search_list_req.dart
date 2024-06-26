
import 'package:json_annotation/json_annotation.dart';
part 'ws_notification_search_list_req.g.dart';

@JsonSerializable()
class WsNotificationSearchListReq {
  WsNotificationSearchListReq({
    required this.page,
    this.roomId,
    this.type,
  });

  factory WsNotificationSearchListReq.create({
    required String page,
    num? roomId,
    num? type,
  }) {
    return WsNotificationSearchListReq(
      page: page,
      roomId: roomId,
      type: type,
    );
  }

  /// 查詢頁數
  @JsonKey(name: 'page')
  String page;

  /// 房間ID(查單一房間時使用)
  @JsonKey(name: 'roomId')
  num? roomId;

  /// 群組類型 0:私聊 1:群聊 (查全部不用帶)
  @JsonKey(name: 'type')
  num? type;

  factory WsNotificationSearchListReq.fromJson(Map<String, dynamic> json) =>
      _$WsNotificationSearchListReqFromJson(json);
  Map<String, dynamic> toJson() => _$WsNotificationSearchListReqToJson(this);

  // API 不帶參數的屬性不傳出
  Map<String, dynamic> toBody() {
    Map<String, dynamic> json = toJson();
    json.removeWhere((key, value) => value == null);
    return json;
  }

  // Map<String, String> toBody() =>
  //     toJson().map((key, value) => value == null ? MapEntry(key, 'null') : MapEntry(key, value));
}
