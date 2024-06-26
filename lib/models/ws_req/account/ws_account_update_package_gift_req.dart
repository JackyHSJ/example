import 'package:json_annotation/json_annotation.dart';

part 'ws_account_update_package_gift_req.g.dart';

@JsonSerializable()
class WsAccountUpdatePackageGiftReq {
  WsAccountUpdatePackageGiftReq({
    this.giftId,
    this.qty,
    this.isPositive,
  });

  factory WsAccountUpdatePackageGiftReq.create({
    num? giftId,
    num? qty,
    bool? isPositive
  }) {
    return WsAccountUpdatePackageGiftReq(
        giftId: giftId,
        qty: qty,
        isPositive: isPositive
    );
  }

  /// 禮物ID
  @JsonKey(name: 'giftId')
  final num? giftId;

  /// 修改數量
  @JsonKey(name: 'qty')
  final num? qty;

  /// true/false 數量增加或是減少
  @JsonKey(name: 'isPositive')
  final bool? isPositive;

  factory WsAccountUpdatePackageGiftReq.fromJson(Map<String, dynamic> json) =>
      _$WsAccountUpdatePackageGiftReqFromJson(json);
  Map<String, dynamic> toJson() => _$WsAccountUpdatePackageGiftReqToJson(this);

  Map<String, String> toBody() =>
      toJson().map((key, value) => value == null ? MapEntry(key, 'null') : MapEntry(key, value));
}
