import 'package:json_annotation/json_annotation.dart';

part 'ws_member_fate_recommend_req.g.dart';

@JsonSerializable()
class WsMemberFateRecommendReq {
  WsMemberFateRecommendReq({
    this.page,
    this.topListPage,
    // this.onlineOnly,
    this.orderSeq,
    this.totalPages,
  });

  factory WsMemberFateRecommendReq.create({
    num? page,
    num? topListPage,
    // bool? onlineOnly,
    num? orderSeq,
    num? totalPages,
  }) {
    return WsMemberFateRecommendReq(
      page: page,
      topListPage: topListPage,
      // onlineOnly: onlineOnly,
      orderSeq: orderSeq,
      totalPages: totalPages
    );
  }

  /// 查詢頁數
  @JsonKey(name: 'page')
  num? page;

  /// 新註冊會員查詢頁數
  @JsonKey(name: 'topListPage')
  num? topListPage;

  // /// 是否只查詢在線用戶
  // @JsonKey(name: 'onlineOnly')
  // bool? onlineOnly;

  /// 排序
  /// http://redmine.zyg.com.tw/issues/2226
  @JsonKey(name: 'orderSeq')
  num? orderSeq;

  //
  @JsonKey(name: 'totalPages')
  num? totalPages;


  factory WsMemberFateRecommendReq.fromJson(Map<String, dynamic> json) =>
      _$WsMemberFateRecommendReqFromJson(json);
  Map<String, dynamic> toJson() => _$WsMemberFateRecommendReqToJson(this);

  Map<String, String> toBody() =>
      toJson().map((key, value) => value == null ? MapEntry(key, 'null') : MapEntry(key, value));
}
