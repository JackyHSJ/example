import 'package:json_annotation/json_annotation.dart';
part 'ws_account_call_verification_req.g.dart';

@JsonSerializable()
class WsAccountCallVerificationReq {
  WsAccountCallVerificationReq({
    required this.freUserId,
    required this.chatType,
    required this.roomId
  });

  factory WsAccountCallVerificationReq.create({
    required num chatType,
    required num freUserId,
    required num roomId
  }) {
    return WsAccountCallVerificationReq(
      freUserId: freUserId,
      chatType: chatType,
      roomId: roomId
    );
  }

  /// 0:閒置 1:語聊 2:視訊
  @JsonKey(name: 'chatType')
  num chatType;

  /// 撥打userId
  @JsonKey(name: 'freUserId')
  num freUserId;

  /// 房間id
  @JsonKey(name: 'roomId')
  num roomId;

  factory WsAccountCallVerificationReq.fromJson(Map<String, dynamic> json) =>
      _$WsAccountCallVerificationReqFromJson(json);
  Map<String, dynamic> toJson() => _$WsAccountCallVerificationReqToJson(this);

  Map<String, String> toBody() =>
      toJson().map((key, value) => value == null ? MapEntry(key, 'null') : MapEntry(key, value));
}
