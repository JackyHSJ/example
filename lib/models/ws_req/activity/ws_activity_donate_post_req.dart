import 'package:json_annotation/json_annotation.dart';

part 'ws_activity_donate_post_req.g.dart';

@JsonSerializable()
class WsActivityDonatePostReq {
  WsActivityDonatePostReq({
    required this.freFeedId,
  });
  factory WsActivityDonatePostReq.create({
    required num freFeedId,
  }) {
    return WsActivityDonatePostReq(
      freFeedId: freFeedId,
    );
  }

  /// 動態貼文id
  @JsonKey(name: 'freFeedId')
  num freFeedId;

  factory WsActivityDonatePostReq.fromJson(Map<String, dynamic> json) =>
      _$WsActivityDonatePostFromJson(json);
  Map<String, dynamic> toJson() => _$WsActivityDonatePostToJson(this);

  Map<String, dynamic> toBody() {
    Map<String, dynamic> json = toJson();
    json.removeWhere((key, value) => value == null);
    return json;
  }
}
