import 'package:json_annotation/json_annotation.dart';

part 'add_activity_post_res.g.dart';

@JsonSerializable()
class AddActivityPostRes {
  AddActivityPostRes();

  factory AddActivityPostRes.fromJson(Map<String, dynamic> json) =>
      _$AddActivityPostMapFromJson(json);
  Map<String, dynamic> toJson() => _$AddActivityPostResToJson(this);
}
