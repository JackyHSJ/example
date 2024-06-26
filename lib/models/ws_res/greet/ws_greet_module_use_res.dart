
import 'package:flutter/cupertino.dart';
import 'package:json_annotation/json_annotation.dart';

part 'ws_greet_module_use_res.g.dart';

@JsonSerializable()
class WsGreetModuleUseRes {
  WsGreetModuleUseRes();

  factory WsGreetModuleUseRes.fromJson(Map<String, dynamic> json) =>
      _$WsGreetModuleUseResFromJson(json);
  Map<String, dynamic> toJson() => _$WsGreetModuleUseResToJson(this);

}