import 'package:encrypt/encrypt.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../../system/comm/comm_def.dart';
import '../../../system/util/aes_util.dart';

part 'ws_account_call_charge_req.g.dart';

@JsonSerializable()
class WsAccountCallChargeReq {
  WsAccountCallChargeReq({
    required this.roomId,
    required this.chatType,
    required this.channel,
  });

  factory WsAccountCallChargeReq.create({
    required num chatType,
    required String channel,
    required num roomId,
  }) {
    return WsAccountCallChargeReq(
      roomId: roomId,
      chatType: chatType,
      channel: channel,
    );
  }

  /// 0:閒置 1:語聊 2:視訊
  @JsonKey(name: 'chatType')
  num chatType;

  @JsonKey(name: 'channel')
  String channel;

  /// 房間id
  @JsonKey(name: 'roomId')
  num roomId;

  factory WsAccountCallChargeReq.fromJson(Map<String, dynamic> json) =>
      _$WsAccountCallChargeReqFromJson(json);
  Map<String, dynamic> toJson() => _$WsAccountCallChargeReqToJson(this);

  Map<String, String> toBody() =>
      toJson().map((key, value) => value == null ? MapEntry(key, 'null') : MapEntry(key, value));

}
