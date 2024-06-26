import 'package:json_annotation/json_annotation.dart';

part 'ws_account_get_gift_detail_req.g.dart';

@JsonSerializable()
class WsAccountGetGiftDetailReq {
  WsAccountGetGiftDetailReq({
    this.categoryId,
    // this.refresh,
    this.type,
  });

  factory WsAccountGetGiftDetailReq.create({
    num? categoryId,
    bool? refresh,
    num? type
  }) {
    return WsAccountGetGiftDetailReq(
        categoryId: categoryId,
        // refresh: refresh,
        type: type
    );
  }

  /// 是否刷新 (非必填,除非需要刷新緩存才要放true)
  @JsonKey(name: 'categoryId')
  final num? categoryId;

  // /// 是否刷新 (非必填,除非需要刷新緩存才要放true)
  // @JsonKey(name: 'refresh')
  // final bool? refresh;

  /// 0:用類別撈, 1:全撈
  @JsonKey(name: 'type')
  final num? type;

  factory WsAccountGetGiftDetailReq.fromJson(Map<String, dynamic> json) =>
      _$WsAccountGetGiftDetailReqFromJson(json);
  Map<String, dynamic> toJson() => _$WsAccountGetGiftDetailReqToJson(this);

  Map<String, String> toBody() =>
      toJson().map((key, value) => value == null ? MapEntry(key, 'null') : MapEntry(key, value));
}
