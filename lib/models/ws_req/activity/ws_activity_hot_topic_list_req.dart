import 'package:json_annotation/json_annotation.dart';

part 'ws_activity_hot_topic_list_req.g.dart';

@JsonSerializable()
class WsActivityHotTopicListReq {
  WsActivityHotTopicListReq();

  factory WsActivityHotTopicListReq.create() {
    return WsActivityHotTopicListReq();
  }

  factory WsActivityHotTopicListReq.fromJson(Map<String, dynamic> json) =>
      _$WsActivityHotTopicListReqFromJson(json);
  Map<String, dynamic> toJson() => _$WsActivityHotTopicListReqToJson(this);

  // API 不帶參數的屬性不傳出
  Map<String, dynamic> toBody() {
    Map<String, dynamic> json = toJson();
    json.removeWhere((key, value) => value == null);
    return json;
  }
}
