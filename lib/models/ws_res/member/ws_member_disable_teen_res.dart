import 'package:json_annotation/json_annotation.dart';

part 'ws_member_disable_teen_res.g.dart';

@JsonSerializable()
class WsMemberDisableTeenRes {
  WsMemberDisableTeenRes({
    this.adolescent,
  });

  /// 青少年開關 true:開 false:關
  @JsonKey(name: 'adolescent')
  bool? adolescent;

  factory WsMemberDisableTeenRes.fromJson(Map<String, dynamic> json) =>
      _$WsMemberDisableTeenResFromJson(json);
  Map<String, dynamic> toJson() => _$WsMemberDisableTeenResToJson(this);
}
