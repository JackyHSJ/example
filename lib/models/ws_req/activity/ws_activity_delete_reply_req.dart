import 'package:json_annotation/json_annotation.dart';

part 'ws_activity_delete_reply_req.g.dart';

@JsonSerializable()
class WsActivityDeleteReplyReq {
  WsActivityDeleteReplyReq({
    required this.id,
});
  factory WsActivityDeleteReplyReq.create({
    required num id,
  }) {
    return WsActivityDeleteReplyReq(
      id: id,
    );
  }
  
  /// id
  @JsonKey(name: 'id')
  num id;

  factory WsActivityDeleteReplyReq.fromJson(Map<String, dynamic> json) =>
      _$WsActivityDeleteReplyReqFromJson(json);
  Map<String, dynamic> toJson() => _$WsActivityDeleteReplyReqToJson(this);

  // API 不帶參數的屬性不傳出
  Map<String, dynamic> toBody() {
    Map<String, dynamic> json = toJson();
    json.removeWhere((key, value) => value == null);
    return json;
  }
}
