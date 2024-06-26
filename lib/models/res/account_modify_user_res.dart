import 'package:json_annotation/json_annotation.dart';

part 'account_modify_user_res.g.dart';

@JsonSerializable()
class MemberModifyUserRes {
  MemberModifyUserRes({
    this.updateTime,
    this.userName,
    this.userid,
  });

  @JsonKey(name: 'updateTime')
  final num? updateTime;

  @JsonKey(name: 'userName')
  final String? userName;

  @JsonKey(name: 'userid')
  final num? userid;

  factory MemberModifyUserRes.fromJson(Map<String, dynamic> json) =>
      _$MemberModifyUserMapFromJson(json);
  Map<String, dynamic> toJson() => _$MemberModifyUserResToJson(this);
}
