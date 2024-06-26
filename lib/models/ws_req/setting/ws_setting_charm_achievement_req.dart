import 'package:encrypt/encrypt.dart';
import 'package:json_annotation/json_annotation.dart';

part 'ws_setting_charm_achievement_req.g.dart';

@JsonSerializable()
class WsSettingChargeAchievementReq {
  WsSettingChargeAchievementReq();

  factory WsSettingChargeAchievementReq.create() {
    return WsSettingChargeAchievementReq();
  }

  factory WsSettingChargeAchievementReq.fromJson(Map<String, dynamic> json) =>
      _$WsChargeAchievementReqFromJson(json);
  Map<String, dynamic> toJson() => _$WsChargeAchievementReqToJson(this);

  // API 不帶參數的屬性不傳出
  Map<String, dynamic> toBody() {
    Map<String, dynamic> json = toJson();
    json.removeWhere((key, value) => value == null);
    return json;
  }
}
