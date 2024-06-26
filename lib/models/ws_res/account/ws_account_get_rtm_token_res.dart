
import 'package:flutter/cupertino.dart';
import 'package:json_annotation/json_annotation.dart';

part 'ws_account_get_rtm_token_res.g.dart';

@JsonSerializable()
class WsAccountGetRTMTokenRes {
  WsAccountGetRTMTokenRes({
    this.uid,
    this.rtcToken,
    this.appId,
  });

  @JsonKey(name: 'uid')
  final String? uid;

  @JsonKey(name: 'rtcToken')
  final String? rtcToken;

  @JsonKey(name: 'appId')
  final String? appId;

  factory WsAccountGetRTMTokenRes.fromJson(Map<String, dynamic> json) =>
      _$WsAccountGetRTMTokenResFromJson(json);
  Map<String, dynamic> toJson() => _$WsAccountGetRTMTokenResToJson(this);
}