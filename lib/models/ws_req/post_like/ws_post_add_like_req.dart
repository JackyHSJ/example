import 'package:json_annotation/json_annotation.dart';

part 'ws_post_add_like_req.g.dart';

@JsonSerializable()
class WsPostAddLikeReq {
  WsPostAddLikeReq({
    required this.articlesId,
    required this.type,
  });
  factory WsPostAddLikeReq.create({
    required String articlesId,
    required String type,
  }) {
    return WsPostAddLikeReq(
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

  factory WsPostAddLikeReq.fromJson(Map<String, dynamic> json) =>
      _$WsPostAddLikeReqFromJson(json);
  Map<String, dynamic> toJson() => _$WsPostAddLikeReqToJson(this);

  // API 不帶參數的屬性不傳出
  Map<String, dynamic> toBody() {
    Map<String, dynamic> json = toJson();
    json.removeWhere((key, value) => value == null);
    return json;
  }
}
