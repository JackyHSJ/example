import 'package:json_annotation/json_annotation.dart';

part 'greet_module_edit_res.g.dart';

@JsonSerializable()
class GreetModuleEditRes {
  GreetModuleEditRes();

  factory GreetModuleEditRes.fromJson(Map<String, dynamic> json) =>
      _$GreetModuleEditMapFromJson(json);
  Map<String, dynamic> toJson() => _$GreetModuleEditResToJson(this);
}
