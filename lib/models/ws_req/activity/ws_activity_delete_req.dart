import 'package:json_annotation/json_annotation.dart';

part 'ws_activity_delete_req.g.dart';

@JsonSerializable()
class WsActivityDeleteReq {
  WsActivityDeleteReq({
    required this.feedsId,
  });
  factory WsActivityDeleteReq.create({
    required num feedsId,
  }) {
    return WsActivityDeleteReq(
      feedsId: feedsId,
    );
  }

  /// 動態貼文id
  @JsonKey(name: 'feedsId')
  num feedsId;

  factory WsActivityDeleteReq.fromJson(Map<String, dynamic> json) =>
      _$WsActivityDeleteReqFromJson(json);
  Map<String, dynamic> toJson() => _$WsActivityDeleteReqToJson(this);

  // API 不帶參數的屬性不傳出
  Map<String, dynamic> toBody() {
    Map<String, dynamic> json = toJson();
    json.removeWhere((key, value) => value == null);
    return json;
  }
}
