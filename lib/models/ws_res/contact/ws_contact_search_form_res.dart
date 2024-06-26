import 'package:json_annotation/json_annotation.dart';

part 'ws_contact_search_form_res.g.dart';

@JsonSerializable()
class WsContactSearchFormRes {
  WsContactSearchFormRes({
    this.todayRevenue,
    this.lastWeekRevenue,
    this.thisWeekRevenue,
  });

  factory WsContactSearchFormRes.create({
    num? todayRevenue,
    num? lastWeekRevenue,
    num? thisWeekRevenue,
}) {
    return WsContactSearchFormRes(
      todayRevenue: todayRevenue,
      lastWeekRevenue: lastWeekRevenue,
      thisWeekRevenue: thisWeekRevenue,
    );
  }

  @JsonKey(name: 'todayRevenue')
  num? todayRevenue;

  @JsonKey(name: 'lastWeekRevenue')
  num? lastWeekRevenue;

  @JsonKey(name: 'thisWeekRevenue')
  num? thisWeekRevenue;

  factory WsContactSearchFormRes.fromJson(Map<String, dynamic> json) =>
      _$WsContactSearchFormResFromJson(json);
  Map<String, dynamic> toJson() => _$WsContactSearchFormResToJson(this);
}