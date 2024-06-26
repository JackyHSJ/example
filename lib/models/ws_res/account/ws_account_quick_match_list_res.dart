import 'package:flutter/cupertino.dart';
import 'package:json_annotation/json_annotation.dart';

part 'ws_account_quick_match_list_res.g.dart';

@JsonSerializable()
class WsAccountQuickMatchListRes {
  WsAccountQuickMatchListRes({
    this.matchIdList,
  });

  @JsonKey(name: 'matchIdList')
  final String? matchIdList;

  factory WsAccountQuickMatchListRes.fromJson(Map<String, dynamic> json) => _$WsAccountQuickMatchListResFromJson(json);
  Map<String, dynamic> toJson() => _$WsAccountQuickMatchListResToJson(this);
}
