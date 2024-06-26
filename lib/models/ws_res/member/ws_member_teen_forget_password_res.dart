import 'package:json_annotation/json_annotation.dart';

part 'ws_member_teen_forget_password_res.g.dart';

@JsonSerializable()
class WsMemberTeenForgetPasswordRes {
  WsMemberTeenForgetPasswordRes({
    this.adolescent,
  });

  /// 青少年開關 true:開 false:關
  @JsonKey(name: 'adolescent')
  bool? adolescent;

  factory WsMemberTeenForgetPasswordRes.fromJson(Map<String, dynamic> json) =>
      _$WsMemberTeenForgetPasswordResFromJson(json);
  Map<String, dynamic> toJson() => _$WsMemberTeenForgetPasswordResToJson(this);
}
