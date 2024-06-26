
import 'package:flutter/cupertino.dart';
import 'package:json_annotation/json_annotation.dart';

part 'ws_account_remark_res.g.dart';

@JsonSerializable()
class WsAccountRemarkRes {
  WsAccountRemarkRes({
    this.remark,
    this.follow,
  });

  @JsonKey(name: 'remark')
  final String? remark;

  @JsonKey(name: 'follow')
  final bool? follow;
  
  factory WsAccountRemarkRes.fromJson(Map<String, dynamic> json) =>
      _$WsAccountRemarkResFromJson(json);
  Map<String, dynamic> toJson() => _$WsAccountRemarkResToJson(this);
}