import 'package:json_annotation/json_annotation.dart';

part 'ws_member_apply_cancel_res.g.dart';

@JsonSerializable()
class WsMemberApplyCancelRes {
  WsMemberApplyCancelRes();

  factory WsMemberApplyCancelRes.fromJson(Map<String, dynamic> json) =>
      _$WsMemberApplyCancelResFromJson(json);
  Map<String, dynamic> toJson() => _$WsMemberApplyCancelResToJson(this);
}
