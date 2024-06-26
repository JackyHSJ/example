import 'package:json_annotation/json_annotation.dart';

part 'member_login_res.g.dart';

@JsonSerializable()
class MemberLoginRes {
  MemberLoginRes({
    required this.userId,
    this.nickname,
    this.tId,
    this.userName
  });

  @JsonKey(name: 'userId')
  final int userId;

  @JsonKey(name: 'nickname')
  final String? nickname;

  @JsonKey(name: 'tId')
  final String? tId;

  @JsonKey(name: 'userName')
  final String? userName;

  factory MemberLoginRes.fromJson(Map<String, dynamic> json) =>
      _$MemberLoginMapFromJson(json);
  Map<String, dynamic> toJson() => _$MemberLoginResToJson(this);
}
