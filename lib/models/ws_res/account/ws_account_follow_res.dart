
import 'package:flutter/cupertino.dart';
import 'package:json_annotation/json_annotation.dart';

part 'ws_account_follow_res.g.dart';

@JsonSerializable()
class WsAccountFollowRes {
  WsAccountFollowRes({
    this.remark,
    this.follow,
  });

  @JsonKey(name: 'remark')
  final String? remark;

  @JsonKey(name: 'follow')
  final bool? follow;

  factory WsAccountFollowRes.fromJson(Map<String, dynamic> json) =>
      _$WsAccountFollowResFromJson(json);
  Map<String, dynamic> toJson() => _$WsAccountFollowResToJson(this);
}