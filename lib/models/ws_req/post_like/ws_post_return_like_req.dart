import 'package:json_annotation/json_annotation.dart';

part 'ws_post_return_like_req.g.dart';

@JsonSerializable()
class WsPostReturnLikeReq {
  WsPostReturnLikeReq({
    required this.articlesId,
    required this.type,
  });
  factory WsPostReturnLikeReq.create({
    required String articlesId,
    required String type,
  }) {
    return WsPostReturnLikeReq(
      articlesId: articlesId,
      type: type,
    );
  }

  /// 動態ID或回复ID (必填)
  @JsonKey(name: 'articlesId')
  String articlesId;

  /// 按讚類型 0:按讚動態 1:按讚回复 (必填)
  @JsonKey(name: 'type')
  String type;

  factory WsPostReturnLikeReq.fromJson(Map<String, dynamic> json) =>
      _$WsPostReturnLikeReqFromJson(json);
  Map<String, dynamic> toJson() => _$WsPostReturnLikeReqToJson(this);

  // API 不帶參數的屬性不傳出
  Map<String, dynamic> toBody() {
    Map<String, dynamic> json = toJson();
    json.removeWhere((key, value) => value == null);
    return json;
  }
}
