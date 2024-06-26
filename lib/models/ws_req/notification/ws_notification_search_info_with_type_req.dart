
import 'package:json_annotation/json_annotation.dart';
part 'ws_notification_search_info_with_type_req.g.dart';

@JsonSerializable()
class WsNotificationSearchInfoWithTypeReq {
  WsNotificationSearchInfoWithTypeReq({
    this.roomIdList,
    this.type,
  });

  factory WsNotificationSearchInfoWithTypeReq.create({
    List<num>? roomIdList,
    num? type,
  }) {
    return WsNotificationSearchInfoWithTypeReq(
      roomIdList: roomIdList,
      type: type,
    );
  }

  /// 房間Id
  @JsonKey(name: 'roomIdList')
  List<num>? roomIdList;

  /// 1/2/3 查詢user總房間數/查詢房間ID列表/查詢房間明細
  @JsonKey(name: 'type')
  num? type;

  factory WsNotificationSearchInfoWithTypeReq.fromJson(Map<String, dynamic> json) =>
      _$WsNotificationSearchInfoWithTypeReqFromJson(json);
  Map<String, dynamic> toJson() => _$WsNotificationSearchInfoWithTypeReqToJson(this);

  // API 不帶參數的屬性不傳出
  Map<String, dynamic> toBody() {
    Map<String, dynamic> json = toJson();
    json.removeWhere((key, value) => value == null);
    return json;
  }
}
