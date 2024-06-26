
import 'package:flutter/cupertino.dart';
import 'package:json_annotation/json_annotation.dart';

part 'ws_account_shumei_violate_res.g.dart';

@JsonSerializable()
class WsAccountShumeiViolateRes {
  WsAccountShumeiViolateRes({
    this.resultCode,
    this.resultMsg,
  });

  /// 違反規定代碼
  @JsonKey(name: 'resultCode')
  String? resultCode;

  /// 違反規定內容
  @JsonKey(name: 'resultMsg')
  String? resultMsg;

  factory WsAccountShumeiViolateRes.fromJson(Map<String, dynamic> json) =>
      _$WsAccountShumeiViolateResFromJson(json);
  Map<String, dynamic> toJson() => _$WsAccountShumeiViolateResToJson(this);
}