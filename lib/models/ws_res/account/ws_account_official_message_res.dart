
import 'package:json_annotation/json_annotation.dart';
part 'ws_account_official_message_res.g.dart';

@JsonSerializable()
class WsAccountOfficialMessageRes {
  WsAccountOfficialMessageRes({
    this.message,
    this.status,
    this.type,
    this.lockStatus,
    this.lockTime,
  });

  @JsonKey(name: 'message')
  final dynamic message;

  /// status:1=通過,2=未通過, 3=駁回
  @JsonKey(name: 'status')
  final num? status;

  /// type:審核類型 1:頭像 2:真人 3:相册
  /// 4:招呼語(照片、語音、文字) 7:暱稱
  /// 10:聲音展示;
  @JsonKey(name: 'type')
  final num? type;

  /// lockStatus:1=短期 2:永久
  @JsonKey(name: 'lockStatus')
  final num? lockStatus;

  @JsonKey(name: 'lockTime')
  final num? lockTime;

  factory WsAccountOfficialMessageRes.fromJson(Map<String, dynamic> json) =>
      _$WsAccountOfficialMessageResFromJson(json);
  Map<String, dynamic> toJson() => _$WsAccountOfficialMessageResToJson(this);
}

@JsonSerializable()
class OfficialMessageInfo {
  OfficialMessageInfo({
    this.coins,
    this.points,
    this.duration,
    this.chatType,
    this.type,
    this.caller,
    this.answer,
  });

  @JsonKey(name: 'points')
  final num? points;

  @JsonKey(name: 'coins')
  final num? coins;

  @JsonKey(name: 'duration')
  final num? duration;

  /// chatType:1=語聊 2=視訊
  @JsonKey(name: 'chatType')
  final num? chatType;

  /// 接通狀態 0=接聽後掛斷 1=未接通撥方掛斷 2=未接通接方掛斷
  @JsonKey(name: 'type')
  num? type;

  @JsonKey(name: 'caller')
  final String? caller;

  @JsonKey(name: 'answer')
  final String? answer;

  factory OfficialMessageInfo.fromJson(Map<String, dynamic> json) =>
      _$OfficialMessageInfoFromJson(json);
  Map<String, dynamic> toJson() => _$OfficialMessageInfoToJson(this);
}

