import 'package:json_annotation/json_annotation.dart';

part 'ws_activity_delete_reply_res.g.dart';

@JsonSerializable()
class WsActivityDeleteReplyRes {
  WsActivityDeleteReplyRes();
  
  factory WsActivityDeleteReplyRes.fromJson(Map<String, dynamic> json) =>
      _$WsActivityDeleteReplyResFromJson(json);
  Map<String, dynamic> toJson() => _$WsActivityDeleteReplyResToJson(this);
}
