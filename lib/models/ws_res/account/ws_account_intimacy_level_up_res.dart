
import 'package:flutter/cupertino.dart';
import 'package:frechat/system/global.dart';
import 'package:json_annotation/json_annotation.dart';

part 'ws_account_intimacy_level_up_res.g.dart';

@JsonSerializable()
class WsAccountIntimacyLevelUpRes {
  WsAccountIntimacyLevelUpRes({
    this.isCohesionLevelUp,
    this.cohesionLevel,
    this.cohesionPoints,
    this.userList,
  });

  @JsonKey(name: 'isCohesionLevelUp')
  final bool? isCohesionLevelUp;

  @JsonKey(name: 'cohesionLevel')
  final num? cohesionLevel;

  @JsonKey(name: 'cohesionPoints')
  final num? cohesionPoints;

  @JsonKey(name: 'userList')
  final List? userList;

  factory WsAccountIntimacyLevelUpRes.fromJson(Map<String, dynamic> json) =>
      _$WsAccountIntimacyLevelUpResFromJson(json);
  Map<String, dynamic> toJson() => _$WsAccountIntimacyLevelUpResToJson(this);
}