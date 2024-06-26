import 'package:encrypt/encrypt.dart';
import 'package:json_annotation/json_annotation.dart';

part 'ws_setting_charge_req.g.dart';

@JsonSerializable()
class WsSettingChargeReq {
  WsSettingChargeReq({
    this.messageCharge,
    this.voiceCharge,
    this.streamCharge,
  });
  factory WsSettingChargeReq.create({
    num? messageCharge,
    num? voiceCharge,
    num? streamCharge,
  }) {
    return WsSettingChargeReq(
      messageCharge: messageCharge,
      voiceCharge: voiceCharge,
      streamCharge: streamCharge,
    );
  }

  /// 消息价格
  @JsonKey(name: 'messageCharge')
  num? messageCharge;

  /// 语音价格
  @JsonKey(name: 'voiceCharge')
  num? voiceCharge;

  /// 语音价格
  @JsonKey(name: 'streamCharge')
  num? streamCharge;

  factory WsSettingChargeReq.fromJson(Map<String, dynamic> json) =>
      _$WsSettingChargeReqFromJson(json);
  Map<String, dynamic> toJson() => _$WsSettingChargeReqToJson(this);

  // API 不帶參數的屬性不傳出
  Map<String, dynamic> toBody() {
    Map<String, dynamic> json = toJson();
    json.removeWhere((key, value) => value == null);
    return json;
  }
}
