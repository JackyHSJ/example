import 'package:json_annotation/json_annotation.dart';

part 'member_logout_res.g.dart';

@JsonSerializable()
class MemberLogoutRes {
  MemberLogoutRes();

  factory MemberLogoutRes.fromJson(Map<String, dynamic> json) =>
      _$MemberLogoutMapFromJson(json);
  Map<String, dynamic> toJson() => _$MemberLogoutResToJson(this);
}
