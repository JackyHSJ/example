
import 'package:json_annotation/json_annotation.dart';
part 'ws_notification_strike_up_req.g.dart';

@JsonSerializable()
class WsNotificationStrikeUpReq {
  WsNotificationStrikeUpReq({
    required this.userName,
    required this.type
  });

  factory WsNotificationStrikeUpReq.create({
    required String userName,
    required int type
  }) {
    return WsNotificationStrikeUpReq(
      userName: userName,
      type: type
    );
  }



  /// 好友之 userName
  @JsonKey(name: 'userName')
  String userName;

  /// type ??
  @JsonKey(name: 'type')
  int type;

  factory WsNotificationStrikeUpReq.fromJson(Map<String, dynamic> json) =>
      _$WsNotificationStrikeUpReqFromJson(json);
  Map<String, dynamic> toJson() => _$WsNotificationStrikeUpReqToJson(this);

  // API 不帶參數的屬性不傳出
  Map<String, dynamic> toBody() {
    Map<String, dynamic> json = toJson();
    json.removeWhere((key, value) => value == null);
    return json;
  }

  // Map<String, String> toBody() =>
  //     toJson().map((key, value) => value == null ? MapEntry(key, 'null') : MapEntry(key, value));
}
