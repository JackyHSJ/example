
import 'package:frechat/models/ws_res/notification/ws_notification_search_list_res.dart';
import 'package:json_annotation/json_annotation.dart';

part 'ws_notification_press_btn_and_remove_black_account_res.g.dart';

@JsonSerializable()
class WsNotificationPressBtnAndRemoveBlackAccountRes {
  WsNotificationPressBtnAndRemoveBlackAccountRes({
    this.result,
  });

  @JsonKey(name: 'result')
  final String? result;

  factory WsNotificationPressBtnAndRemoveBlackAccountRes.fromJson(Map<String, dynamic> json) =>
      _$WsNotificationPressBtnAndRemoveBlackAccountResFromJson(json);

  Map<String, dynamic> toJson() => _$WsNotificationPressBtnAndRemoveBlackAccountResToJson(this);
}