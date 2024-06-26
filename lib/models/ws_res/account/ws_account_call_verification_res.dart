
import 'package:json_annotation/json_annotation.dart';
part 'ws_account_call_verification_res.g.dart';

@JsonSerializable()
class WsAccountCallVerificationRes {
  WsAccountCallVerificationRes({
    this.chatStatus,
    this.cost,
    this.remainCoins,
    this.call,
    this.remainTimes,
});

  @JsonKey(name: 'chatStatus')
  final num? chatStatus;

  @JsonKey(name: 'cost')
  final num? cost;

  @JsonKey(name: 'remainCoins')
  final num? remainCoins;

  @JsonKey(name: 'call')
  final CallVerificationInfo? call;

  @JsonKey(name: 'remainTimes')
  final num? remainTimes;

  factory WsAccountCallVerificationRes.fromJson(Map<String, dynamic> json) =>
      _$WsAccountCallVerificationResFromJson(json);
  Map<String, dynamic> toJson() => _$WsAccountCallVerificationResToJson(this);
}

class CallVerificationInfo{
  CallVerificationInfo({
    this.uid,
    this.answerUid,
    this.rtcToken,
    this.appId,
    this.channel,
});

  @JsonKey(name: 'uid')
  final String? uid;

  @JsonKey(name: 'answerUid')
  final String? answerUid;

  @JsonKey(name: 'rtcToken')
  final String? rtcToken;

  @JsonKey(name: 'appId')
  final String? appId;

  @JsonKey(name: 'channel')
  final String? channel;

  factory CallVerificationInfo.fromJson(Map<String, dynamic> json) =>
      _$CallVerificationInfoFromJson(json);
  Map<String, dynamic> toJson() => _$CallVerificationInfoToJson(this);
}