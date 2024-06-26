
import 'package:json_annotation/json_annotation.dart';
part 'ws_account_get_rtc_token_req.g.dart';

@JsonSerializable()
class WsAccountGetRTCTokenReq {
  WsAccountGetRTCTokenReq({
    required this.chatType,
    required this.roomId,
    required this.callUserId,
  });

  factory WsAccountGetRTCTokenReq.create({
    required num chatType,
    required num roomId,
    required num callUserId
  }) {
    return WsAccountGetRTCTokenReq(
      chatType: chatType,
      roomId: roomId,
      callUserId: callUserId
    );
  }

  @JsonKey(name: 'chatType')
  num chatType;

  @JsonKey(name: 'roomId')
  num roomId;

  @JsonKey(name: 'callUserId')
  num callUserId;

  factory WsAccountGetRTCTokenReq.fromJson(Map<String, dynamic> json) =>
      _$WsAccountGetRTCTokenReqFromJson(json);
  Map<String, dynamic> toJson() => _$WsAccountGetRTCTokenReqToJson(this);

  Map<String, String> toBody() =>
      toJson().map((key, value) => value == null ? MapEntry(key, 'null') : MapEntry(key, value));
}
