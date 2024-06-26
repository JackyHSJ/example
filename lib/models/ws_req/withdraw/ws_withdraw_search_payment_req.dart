import 'package:json_annotation/json_annotation.dart';

part 'ws_withdraw_search_payment_req.g.dart';

@JsonSerializable()
class WsWithdrawSearchPaymentReq {
  WsWithdrawSearchPaymentReq();
  factory WsWithdrawSearchPaymentReq.create() {
    return WsWithdrawSearchPaymentReq();
  }

  factory WsWithdrawSearchPaymentReq.fromJson(Map<String, dynamic> json) =>
      _$WsWithdrawSearchPaymentReqFromJson(json);
  Map<String, dynamic> toJson() => _$WsWithdrawSearchPaymentReqToJson(this);

  Map<String, String> toBody() =>
      toJson().map((key, value) => value == null ? MapEntry(key, 'null') : MapEntry(key, value));
}
