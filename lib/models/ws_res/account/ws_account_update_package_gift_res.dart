
import 'package:flutter/cupertino.dart';
import 'package:json_annotation/json_annotation.dart';

part 'ws_account_update_package_gift_res.g.dart';

@JsonSerializable()
class WsAccountUpdatePackageGiftRes {
  WsAccountUpdatePackageGiftRes();

  factory WsAccountUpdatePackageGiftRes.fromJson(Map<String, dynamic> json) =>
      _$WsAccountUpdatePackageGiftResFromJson(json);
  Map<String, dynamic> toJson() => _$WsAccountUpdatePackageGiftResToJson(this);
}