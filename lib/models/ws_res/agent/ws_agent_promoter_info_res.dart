import 'package:json_annotation/json_annotation.dart';

part 'ws_agent_promoter_info_res.g.dart';

@JsonSerializable()
class WsAgentPromoterInfoRes {
  WsAgentPromoterInfoRes({
    this.todayIncome,
    this.todayPrimaryIncome,
    this.yesterdayIncome,
    this.weekIncome,
    this.monthIncome,
    this.memberCount,
    this.totalMemberCount,
    this.totalPromoterCount,
    this.promoterCount,
  });

  /// 今日收入/元
  @JsonKey(name: 'todayIncome')
  num? todayIncome;

  /// 今日上級收入/元 (只有2級推广)
  @JsonKey(name: 'todayPrimaryIncome')
  num? todayPrimaryIncome;

  /// 昨日收入/元
  @JsonKey(name: 'yesterdayIncome')
  num? yesterdayIncome;

  /// 本周收入/元
  @JsonKey(name: 'weekIncome')
  num? weekIncome;

  /// 本月收入/元
  @JsonKey(name: 'monthIncome')
  num? monthIncome;

  /// 人脈人數
  @JsonKey(name: 'memberCount')
  num? memberCount;

  /// 累計人脈
  @JsonKey(name: 'totalMemberCount')
  num? totalMemberCount;

  /// 昨日新增推廣
  @JsonKey(name: 'promoterCount')
  num? promoterCount;

  /// 累計推广
  @JsonKey(name: 'totalPromoterCount')
  num? totalPromoterCount;

  factory WsAgentPromoterInfoRes.fromJson(Map<String, dynamic> json) =>
      _$WsAgentPromoterInfoResFromJson(json);
  Map<String, dynamic> toJson() => _$WsAgentPromoterInfoResToJson(this);
}