import 'package:json_annotation/json_annotation.dart';

part 'ws_activity_add_reply_res.g.dart';

@JsonSerializable()
class WsActivityAddReplyRes {
  WsActivityAddReplyRes();
  
  factory WsActivityAddReplyRes.fromJson(Map<String, dynamic> json) =>
      _$WsActivityAddReplyResFromJson(json);
  Map<String, dynamic> toJson() => _$WsActivityAddReplyResToJson(this);
}
