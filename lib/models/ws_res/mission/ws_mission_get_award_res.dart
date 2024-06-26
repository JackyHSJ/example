
import 'package:json_annotation/json_annotation.dart';
part 'ws_mission_get_award_res.g.dart';

@JsonSerializable()
class WsMissionGetAwardRes {
  WsMissionGetAwardRes();

  factory WsMissionGetAwardRes.fromJson(Map<String, dynamic> json) =>
      _$WsMissionGetAwardResFromJson(json);
  Map<String, dynamic> toJson() => _$WsMissionGetAwardResToJson(this);
}