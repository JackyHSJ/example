
import 'package:json_annotation/json_annotation.dart';
part 'ws_notification_press_btn_and_remove_black_account_req.g.dart';

@JsonSerializable()
class WsNotificationPressBtnAndRemoveBlackAccountReq {
  WsNotificationPressBtnAndRemoveBlackAccountReq({
    this.friendId,
    this.userId,
  });

  factory WsNotificationPressBtnAndRemoveBlackAccountReq.create({
    num? friendId,
    num? userId,
  }) {
    return WsNotificationPressBtnAndRemoveBlackAccountReq(
      friendId: friendId,
      userId: userId
    );
  }

  /// 對方id
  @JsonKey(name: 'friendId')
  num? friendId;

  /// 自己id
  @JsonKey(name: 'userId')
  num? userId;

  factory WsNotificationPressBtnAndRemoveBlackAccountReq.fromJson(Map<String, dynamic> json) =>
      _$WsNotificationPressBtnAndRemoveBlackAccountReqFromJson(json);
  Map<String, dynamic> toJson() => _$WsNotificationPressBtnAndRemoveBlackAccountReqToJson(this);

  // API 不帶參數的屬性不傳出
  Map<String, dynamic> toBody() {
    Map<String, dynamic> json = toJson();
    json.removeWhere((key, value) => value == null);
    return json;
  }
}
