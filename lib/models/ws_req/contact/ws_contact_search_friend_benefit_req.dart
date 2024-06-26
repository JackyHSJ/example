import 'package:json_annotation/json_annotation.dart';

part 'ws_contact_search_friend_benefit_req.g.dart';

@JsonSerializable()
class WsContactSearchFriendBenefitReq {
  WsContactSearchFriendBenefitReq({
    this.startTime,
    this.endTime,
    this.size,
    this.page,
  });
  factory WsContactSearchFriendBenefitReq.create({
    String? startTime,
    String? endTime,
    num? size,
    num? page
  }) {
    return WsContactSearchFriendBenefitReq(
      startTime: startTime,
      endTime: endTime,
      size: size,
      page: page
    );
  }

  /// 開始時間 yyyy-mm-dd 00:00:00 月初
  @JsonKey(name: 'startTime')
  String? startTime;

  /// 結束時間 yyyy-mm-dd 23:59:59 月底
  @JsonKey(name: 'endTime')
  String? endTime;

  /// 一頁顯示之資料筆數
  @JsonKey(name: 'size')
  num? size;

  /// 一頁顯示之資料筆數
  @JsonKey(name: 'page')
  num? page;

  factory WsContactSearchFriendBenefitReq.fromJson(Map<String, dynamic> json) =>
      _$WsContactSearchFriendBenefitReqFromJson(json);
  Map<String, dynamic> toJson() => _$WsContactSearchFriendBenefitReqToJson(this);

  Map<String, String> toBody() =>
      toJson().map((key, value) => value == null ? MapEntry(key, 'null') : MapEntry(key, value));
}
