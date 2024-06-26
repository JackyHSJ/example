
import 'package:json_annotation/json_annotation.dart';

part 'ws_account_end_call_res.g.dart';

@JsonSerializable()
class WsAccountEndCallRes {
  WsAccountEndCallRes();


  factory WsAccountEndCallRes.fromJson(Map<String, dynamic> json) =>
      _$WsAccountEndCallResFromJson(json);
  Map<String, dynamic> toJson() => _$WsAccountEndCallResToJson(this);
}