import 'package:json_annotation/json_annotation.dart';
part 'ws_mission_search_status_res.g.dart';

@JsonSerializable()
class WsMissionSearchStatusRes {
  WsMissionSearchStatusRes({
    this.list,
  });

  @JsonKey(name: 'list')
  final List<MissionStatusList>? list;

  factory WsMissionSearchStatusRes.fromJson(Map<String, dynamic> json) => _$WsMissionSearchStatusResFromJson(json);
  Map<String, dynamic> toJson() => _$WsMissionSearchStatusResToJson(this);
}

@JsonSerializable()
class MissionStatusList {
  MissionStatusList({
    this.coins,
    this.name,
    this.points,
    this.status,
    this.target,
  });

  @JsonKey(name: 'coins')
  final num? coins;
  @JsonKey(name: 'name')
  final String? name;

  @JsonKey(name: 'points')
  final num? points;

  @JsonKey(name: 'status')
  final String? status;

  @JsonKey(name: 'target')
  final num? target;

  factory MissionStatusList.fromJson(Map<String, dynamic> json) => _$MissionStatusListFromJson(json);
  Map<String, dynamic> toJson() => _$MissionStatusListToJson(this);
}
