import 'package:json_annotation/json_annotation.dart';

part 'ws_activity_delete_res.g.dart';

@JsonSerializable()
class WsActivityDeleteRes {
  WsActivityDeleteRes();
  
  factory WsActivityDeleteRes.fromJson(Map<String, dynamic> json) =>
      _$WsActivityDeleteResFromJson(json);
  Map<String, dynamic> toJson() => _$WsActivityDeleteResToJson(this);
}
