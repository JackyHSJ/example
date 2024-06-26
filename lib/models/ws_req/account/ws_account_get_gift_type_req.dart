import 'package:json_annotation/json_annotation.dart';

part 'ws_account_get_gift_type_req.g.dart';

@JsonSerializable()
class WsAccountGetGiftTypeReq {
  // WsAccountGetGiftTypeReq({
  //   // this.refresh,
  // });
  WsAccountGetGiftTypeReq();

  factory WsAccountGetGiftTypeReq.create({
    bool? refresh
  }) {
    return WsAccountGetGiftTypeReq(
        // refresh: refresh
    );
  }

  // /// 是否刷新 (非必填,除非需要刷新緩存才要放true)
  // @JsonKey(name: 'refresh')
  // final bool? refresh;

  factory WsAccountGetGiftTypeReq.fromJson(Map<String, dynamic> json) =>
      _$WsAccountGetGiftTypeReqFromJson(json);
  Map<String, dynamic> toJson() => _$WsAccountGetGiftTypeReqToJson(this);

  Map<String, String> toBody() =>
      toJson().map((key, value) => value == null ? MapEntry(key, 'null') : MapEntry(key, value));
}
