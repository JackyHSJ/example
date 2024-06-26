import 'package:json_annotation/json_annotation.dart';

part 'ws_banner_info_req.g.dart';

@JsonSerializable()
class WsBannerInfoReq {

  WsBannerInfoReq({
    this.appId,
    this.osType,
  });

  factory WsBannerInfoReq.create({
    String? appId,
    num? osType,
  }) {
    return WsBannerInfoReq(
      appId: appId,
      osType: osType
    );
  }

  // appId
  @JsonKey(name: 'appId')
  String? appId;

  // 手机系统(0:苹果 1:安卓)
  @JsonKey(name: 'osType')
  num? osType;

  factory WsBannerInfoReq.fromJson(Map<String, dynamic> json) => _$WsBannerInfoReqFromJson(json);
  Map<String, dynamic> toJson() => _$WsBannerInfoReqToJson(this);

  // API 不帶參數的屬性不傳出
  Map<String, dynamic> toBody() {
    Map<String, dynamic> json = toJson();
    json.removeWhere((key, value) => value == null);
    return json;
  }
}
