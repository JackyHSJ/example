
import 'package:json_annotation/json_annotation.dart';
part 'ws_account_end_call_req.g.dart';

@JsonSerializable()
class WsAccountEndCallReq {
  WsAccountEndCallReq({
    required this.roomId,
    required this.channel
  });

  factory WsAccountEndCallReq.create({
    required num roomId,
    required String channel
  }) {
    return WsAccountEndCallReq(
      roomId: roomId,
      channel: channel
    );
  }

  // 房間id
  @JsonKey(name: 'roomId')
  num roomId;

  @JsonKey(name: 'channel')
  String channel;

  factory WsAccountEndCallReq.fromJson(Map<String, dynamic> json) =>
      _$WsAccountEndCallReqFromJson(json);
  Map<String, dynamic> toJson() => _$WsAccountEndCallReqToJson(this);

  Map<String, String> toBody() =>
      toJson().map((key, value) => value == null ? MapEntry(key, 'null') : MapEntry(key, value));
}
