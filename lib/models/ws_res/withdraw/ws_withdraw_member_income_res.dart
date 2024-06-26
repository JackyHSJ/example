import 'package:json_annotation/json_annotation.dart';

part 'ws_withdraw_member_income_res.g.dart';

@JsonSerializable()
class WsWithdrawMemberIncomeRes {
  WsWithdrawMemberIncomeRes({
    this.list,
    this.firstWithdrawal,
    this.tip,
    this.dailyWithdrawPerDay,
    this.withdrawAmountPerDay,
  });

  /// 當前分頁數
  @JsonKey(name: 'list')
  List<WithdrawIncomeListInfo>? list;

  /// 服務費(用 % 來算)
  @JsonKey(name: 'tip')
  String? tip;

  /// 0:非首次提款 1:首次提款
  @JsonKey(name: 'firstWithdrawal')
  String? firstWithdrawal;

  /// 每日可提現金額
  @JsonKey(name: 'withdrawAmountPerDay')
  String? withdrawAmountPerDay;

  /// 每日可提現次數
  @JsonKey(name: 'dailyWithdrawPerDay')
  String? dailyWithdrawPerDay;

  factory WsWithdrawMemberIncomeRes.fromJson(Map<String, dynamic> json) =>
      _$WsWithdrawMemberIncomeResFromJson(json);
  Map<String, dynamic> toJson() => _$WsWithdrawMemberIncomeResToJson(this);
}

class WithdrawIncomeListInfo {
  WithdrawIncomeListInfo({
    this.pointRange,
    this.moneyRange,
    this.type,
    this.secondTransfer,
  });

  factory WithdrawIncomeListInfo.create({
    String? pointRange,
    String? moneyRange,
    String? type,
    String? secondTransfer,
  }) {
    return WithdrawIncomeListInfo(
      pointRange: pointRange,
      moneyRange: moneyRange,
      type: type,
      secondTransfer: secondTransfer,
    );
  }

  /// 積分
  @JsonKey(name: 'pointRange')
  String? pointRange;

  /// 金額
  @JsonKey(name: 'moneyRange')
  String? moneyRange;

  @JsonKey(name: 'type')
  String? type;

  @JsonKey(name: 'secondTransfer')
  String? secondTransfer;

  factory WithdrawIncomeListInfo.fromJson(Map<String, dynamic> json) =>
      _$WithdrawIncomeListInfoFromJson(json);
  Map<String, dynamic> toJson() => _$WithdrawIncomeListInfoToJson(this);
}