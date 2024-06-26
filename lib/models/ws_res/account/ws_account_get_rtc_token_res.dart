
import 'package:flutter/cupertino.dart';
import 'package:json_annotation/json_annotation.dart';

part 'ws_account_get_rtc_token_res.g.dart';

@JsonSerializable()
class WsAccountGetRTCTokenRes {
  WsAccountGetRTCTokenRes({
    this.answer,
  });

  @JsonKey(name: 'answer')
  final GetRTCAnswerInfo? answer;

  factory WsAccountGetRTCTokenRes.fromJson(Map<String, dynamic> json) =>
      _$WsAccountGetRTCTokenResFromJson(json);
  Map<String, dynamic> toJson() => _$WsAccountGetRTCTokenResToJson(this);
}

@JsonSerializable()
class GetRTCAnswerInfo {
  GetRTCAnswerInfo({
    this.uid,
    this.rtcToken,
    this.appId,
    this.channel,
  });

  @JsonKey(name: 'uid')
  final String? uid;

  @JsonKey(name: 'rtcToken')
  final String? rtcToken;

  @JsonKey(name: 'appId')
  final String? appId;

  @JsonKey(name: 'channel')
  final String? channel;

  factory GetRTCAnswerInfo.fromJson(Map<String, dynamic> json) =>
      _$GetRTCAnswerInfoFromJson(json);
  Map<String, dynamic> toJson() => _$GetRTCAnswerInfoToJson(this);
}


