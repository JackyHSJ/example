import 'package:json_annotation/json_annotation.dart';

part 'ws_withdraw_member_income_req.g.dart';

@JsonSerializable()
class WsWithdrawMemberIncomeReq {
  WsWithdrawMemberIncomeReq();
  factory WsWithdrawMemberIncomeReq.create() {
    return WsWithdrawMemberIncomeReq();
  }

  factory WsWithdrawMemberIncomeReq.fromJson(Map<String, dynamic> json) =>
      _$WsWithdrawMemberIncomeReqFromJson(json);
  Map<String, dynamic> toJson() => _$WsWithdrawMemberIncomeReqToJson(this);

  Map<String, String> toBody() =>
      toJson().map((key, value) => value == null ? MapEntry(key, 'null') : MapEntry(key, value));
}
