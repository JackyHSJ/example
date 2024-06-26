import 'package:json_annotation/json_annotation.dart';

part 'ws_member_real_person_veri_res.g.dart';

@JsonSerializable()
class WsMemberRealPersonVeriRes {
  WsMemberRealPersonVeriRes({
    this.realPersonAuth,
  });

  /// 真人认证 0:未認證 1:已審核 2:認證中 3:認證失敗
  @JsonKey(name: 'realPersonAuth')
  num? realPersonAuth;

  factory WsMemberRealPersonVeriRes.fromJson(Map<String, dynamic> json) =>
      _$WsMemberRealPersonVeriResFromJson(json);
  Map<String, dynamic> toJson() => _$WsMemberRealPersonVeriResToJson(this);
}