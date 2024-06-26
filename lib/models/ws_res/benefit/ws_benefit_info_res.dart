import 'package:json_annotation/json_annotation.dart';

part 'ws_benefit_info_res.g.dart';

@JsonSerializable()
class WsBenefitInfoRes {
  WsBenefitInfoRes({
    this.todayIncome,
    this.lastWeekIncome,
    this.thisWeekIncome,
    this.withdrawalAmount,
});

  /// 本週收益
  @JsonKey(name: 'thisWeekIncome')
  num? thisWeekIncome;

  /// 上週收益
  @JsonKey(name: 'lastWeekIncome')
  num? lastWeekIncome;

  /// 今日收益
  @JsonKey(name: 'todayIncome')
  num? todayIncome;

  /// 審核中收益
  @JsonKey(name: 'withdrawalAmount')
  num? withdrawalAmount;

  factory WsBenefitInfoRes.fromJson(Map<String, dynamic> json) =>
      _$WsBenefitInfoResFromJson(json);
  Map<String, dynamic> toJson() => _$WsBenefitInfoResToJson(this);
}