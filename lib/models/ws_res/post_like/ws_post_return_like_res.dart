import 'package:json_annotation/json_annotation.dart';

part 'ws_post_return_like_res.g.dart';

@JsonSerializable()
class WsPostReturnLikeRes {
  WsPostReturnLikeRes();
  
  factory WsPostReturnLikeRes.fromJson(Map<String, dynamic> json) =>
      _$WsPostReturnLikeResFromJson(json);
  Map<String, dynamic> toJson() => _$WsPostReturnLikeResToJson(this);
}
