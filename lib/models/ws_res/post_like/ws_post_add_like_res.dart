import 'package:json_annotation/json_annotation.dart';

part 'ws_post_add_like_res.g.dart';

@JsonSerializable()
class WsPostAddLikeRes {
  WsPostAddLikeRes();
  
  factory WsPostAddLikeRes.fromJson(Map<String, dynamic> json) =>
      _$WsPostAddLikeResFromJson(json);
  Map<String, dynamic> toJson() => _$WsPostAddLikeResToJson(this);
}
