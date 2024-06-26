import 'package:json_annotation/json_annotation.dart';

part 'greet_module_add_res.g.dart';

@JsonSerializable()
class GreetModuleAddRes {
  GreetModuleAddRes();

  factory GreetModuleAddRes.fromJson(Map<String, dynamic> json) =>
      _$GreetModuleAddMapFromJson(json);
  Map<String, dynamic> toJson() => _$GreetModuleAddResToJson(this);
}
