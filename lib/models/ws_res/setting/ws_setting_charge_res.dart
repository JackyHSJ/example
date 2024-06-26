
import 'package:flutter/cupertino.dart';
import 'package:json_annotation/json_annotation.dart';

part 'ws_setting_charge_res.g.dart';

@JsonSerializable()
class WsSettingChargeRes {
  WsSettingChargeRes({
    this.charmLevel,
    this.maxMessageCharge,
    this.maxVoiceCharge,
    this.maxVideoCharge,
});

  @JsonKey(name: 'charmLevel')
  final num? charmLevel;

  @JsonKey(name: 'maxMessageCharge')
  final num? maxMessageCharge;

  @JsonKey(name: 'maxVoiceCharge')
  final num? maxVoiceCharge;

  @JsonKey(name: 'maxVideoCharge')
  final num? maxVideoCharge;

  factory WsSettingChargeRes.fromJson(Map<String, dynamic> json) =>
      _$WsSettingChargeResFromJson(json);
  Map<String, dynamic> toJson() => _$WsSettingChargeResToJson(this);
}