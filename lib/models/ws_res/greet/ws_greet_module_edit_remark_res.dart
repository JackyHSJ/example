
import 'package:flutter/cupertino.dart';
import 'package:json_annotation/json_annotation.dart';

part 'ws_greet_module_edit_remark_res.g.dart';

@JsonSerializable()
class WsGreetModuleEditRemarkRes {
  WsGreetModuleEditRemarkRes();

  factory WsGreetModuleEditRemarkRes.fromJson(Map<String, dynamic> json) =>
      _$WsGreetModuleEditRemarkResFromJson(json);
  Map<String, dynamic> toJson() => _$WsGreetModuleEditRemarkResToJson(this);

}