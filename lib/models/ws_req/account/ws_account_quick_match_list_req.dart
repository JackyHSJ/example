
import 'package:json_annotation/json_annotation.dart';

part 'ws_account_quick_match_list_req.g.dart';

@JsonSerializable()
class WsAccountQuickMatchListReq {
  WsAccountQuickMatchListReq({
    this.page,
    this.type,
  });

  factory WsAccountQuickMatchListReq.create({
    num? page,
    String? type,
  }) {
    return WsAccountQuickMatchListReq(
      page: page,
      type: type,
    );
  }

  /// 第幾頁(預設每page 為1000筆)
  @JsonKey(name: 'page')
  num? page;

  /// 檢核類型1為語音,2為視頻,不填就不檢核,如果為男性視頻金額需大於500,語音需要大於200
  @JsonKey(name: 'type')
  String? type;

  factory WsAccountQuickMatchListReq.fromJson(Map<String, dynamic> json) =>
      _$WsAccountQuickMatchListReqFromJson(json);
  Map<String, dynamic> toJson() => _$WsAccountQuickMatchListReqToJson(this);

  Map<String, String> toBody() =>
      toJson().map((key, value) => value == null ? MapEntry(key, 'null') : MapEntry(key, value));
}
