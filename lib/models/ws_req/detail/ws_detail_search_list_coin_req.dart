import 'package:json_annotation/json_annotation.dart';

part 'ws_detail_search_list_coin_req.g.dart';

@JsonSerializable()
class WsDetailSearchListCoinReq {
  WsDetailSearchListCoinReq({
    this.startTime,
    this.endTime,
    this.page,
    this.size,
  });
  factory WsDetailSearchListCoinReq.create({
    String? startTime,
    String? endTime,
    String? page,
    num? size,
  }) {
    return WsDetailSearchListCoinReq(
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

  factory WsDetailSearchListCoinReq.fromJson(Map<String, dynamic> json) =>
      _$WsDetailSearchListCoinReqFromJson(json);
  Map<String, dynamic> toJson() => _$WsDetailSearchListCoinReqToJson(this);

  Map<String, String> toBody() =>
      toJson().map((key, value) => value == null ? MapEntry(key, 'null') : MapEntry(key, value));
}
