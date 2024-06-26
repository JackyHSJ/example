import 'package:json_annotation/json_annotation.dart';

part 'ws_member_fate_online_req.g.dart';

@JsonSerializable()
class WsMemberFateOnlineReq {
  WsMemberFateOnlineReq({
    this.page,
    this.topListPage,
    this.orderSeq,
    this.totalPages,
  });

  factory WsMemberFateOnlineReq.create({
    num? page,
    num? topListPage,
    num? orderSeq,
    num? totalPages,
  }) {
    return WsMemberFateOnlineReq(
      page: page,
      topListPage: topListPage,
      orderSeq: orderSeq,
      totalPages: totalPages,
    );
  }

  /// 查詢頁數
  @JsonKey(name: 'page')
  num? page;

  /// 新註冊會員查詢頁數
  @JsonKey(name: 'topListPage')
  num? topListPage;

  /// 排序
  /// http://redmine.zyg.com.tw/issues/2226
  @JsonKey(name: 'orderSeq')
  num? orderSeq;

  //
  @JsonKey(name: 'totalPages')
  num? totalPages;

  factory WsMemberFateOnlineReq.fromJson(Map<String, dynamic> json) =>
      _$WsMemberFateOnlineReqFromJson(json);
  Map<String, dynamic> toJson() => _$WsMemberFateOnlineReqToJson(this);

  Map<String, String> toBody() =>
      toJson().map((key, value) => value == null ? MapEntry(key, 'null') : MapEntry(key, value));
}
