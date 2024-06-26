import 'package:json_annotation/json_annotation.dart';

part 'ws_withdraw_search_record_req.g.dart';

@JsonSerializable()
class WsWithdrawSearchRecordReq {
  WsWithdrawSearchRecordReq({
    required this.startTime,
    required this.endTime,
    this.page,
    this.size,
  });
  factory WsWithdrawSearchRecordReq.create({
    required String startTime,
    required String endTime,
    String? page,
    num? size,
  }) {
    return WsWithdrawSearchRecordReq(
      startTime: startTime,
      endTime: endTime,
      page: page,
      size: size,
    );
  }

  /// 查詢起始時間(必填)
  @JsonKey(name: 'startTime')
  String startTime;

  /// 查詢結束時間(必填)
  @JsonKey(name: 'endTime')
  String? endTime;

  /// 查詢頁數
  @JsonKey(name: 'page')
  String? page;

  /// 一頁顯示之資料筆數
  @JsonKey(name: 'size')
  num? size;

  factory WsWithdrawSearchRecordReq.fromJson(Map<String, dynamic> json) => _$WsWithdrawSearchRecordReqFromJson(json);
  Map<String, dynamic> toJson() => _$WsWithdrawSearchRecordReqToJson(this);

  Map<String, String> toBody() => toJson().map((key, value) => value == null ? MapEntry(key, 'null') : MapEntry(key, value));
}
