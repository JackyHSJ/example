import 'package:json_annotation/json_annotation.dart';

part 'ws_detail_search_list_income_req.g.dart';

@JsonSerializable()
class WsDetailSearchListIncomeReq {
  WsDetailSearchListIncomeReq({
    this.startTime,
    this.endTime,
    this.page,
    this.size,
  });
  factory WsDetailSearchListIncomeReq.create({
    String? startTime,
    String? endTime,
    String? page,
    num? size,
  }) {
    return WsDetailSearchListIncomeReq(
      startTime: startTime,
      endTime: endTime,
      page: page,
      size: size,
    );
  }

  /// 收支範圍-開始時間
  @JsonKey(name: 'startTime')
  String? startTime;

  /// 收支範圍-結束時間
  @JsonKey(name: 'endTime')
  String? endTime;

  /// 查詢頁數
  @JsonKey(name: 'page')
  String? page;

  /// 一頁顯示之資料筆數
  @JsonKey(name: 'size')
  num? size;

  factory WsDetailSearchListIncomeReq.fromJson(Map<String, dynamic> json) =>
      _$WsDetailSearchListIncomeReqFromJson(json);
  Map<String, dynamic> toJson() => _$WsDetailSearchListIncomeReqToJson(this);

  Map<String, String> toBody() =>
      toJson().map((key, value) => value == null ? MapEntry(key, 'null') : MapEntry(key, value));
}
