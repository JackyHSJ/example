import 'package:json_annotation/json_annotation.dart';

part 'ws_member_teen_status_res.g.dart';

@JsonSerializable()
class WsMemberTeenStatusRes {
  WsMemberTeenStatusRes({
    this.adolescent,
  });

  /// 青少年開關 true:開 false:關
  @JsonKey(name: 'adolescent')
  bool? adolescent;

  factory WsMemberTeenStatusRes.fromJson(Map<String, dynamic> json) =>
      _$WsMemberTeenStatusResFromJson(json);
  Map<String, dynamic> toJson() => _$WsMemberTeenStatusResToJson(this);
}
