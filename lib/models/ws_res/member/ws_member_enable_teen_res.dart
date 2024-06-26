import 'package:json_annotation/json_annotation.dart';

part 'ws_member_enable_teen_res.g.dart';

@JsonSerializable()
class WsMemberEnableTeenRes {
  WsMemberEnableTeenRes({
    this.adolescent,
  });

  /// 青少年開關 true:開 false:關
  @JsonKey(name: 'adolescent')
  bool? adolescent;

  factory WsMemberEnableTeenRes.fromJson(Map<String, dynamic> json) =>
      _$WsMemberEnableTeenResFromJson(json);
  Map<String, dynamic> toJson() => _$WsMemberEnableTeenResToJson(this);
}
