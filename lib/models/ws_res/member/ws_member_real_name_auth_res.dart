import 'package:json_annotation/json_annotation.dart';

part 'ws_member_real_name_auth_res.g.dart';

@JsonSerializable()
class WsMemberRealNameAuthRes {
  WsMemberRealNameAuthRes({
    this.isRealName,
  });

  /// 实名认证結果 true:真 false:假
  @JsonKey(name: 'isRealName')
  bool? isRealName;

  factory WsMemberRealNameAuthRes.fromJson(Map<String, dynamic> json) =>
      _$WsMemberRealNameAuthResFromJson(json);
  Map<String, dynamic> toJson() => _$WsMemberRealNameAuthResToJson(this);
}
