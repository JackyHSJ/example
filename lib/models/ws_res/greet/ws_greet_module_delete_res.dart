
import 'package:flutter/cupertino.dart';
import 'package:json_annotation/json_annotation.dart';

part 'ws_greet_module_delete_res.g.dart';

@JsonSerializable()
class WsGreetModuleDeleteRes {
  WsGreetModuleDeleteRes();

  factory WsGreetModuleDeleteRes.fromJson(Map<String, dynamic> json) =>
      _$WsGreetModuleDeleteResFromJson(json);
  Map<String, dynamic> toJson() => _$WsGreetModuleDeleteResToJson(this);

}