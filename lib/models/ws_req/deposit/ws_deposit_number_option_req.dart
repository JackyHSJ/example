import 'package:json_annotation/json_annotation.dart';

part 'ws_deposit_number_option_req.g.dart';

@JsonSerializable()
class WsDepositNumberOptionReq {
  WsDepositNumberOptionReq();
  factory WsDepositNumberOptionReq.create() {
    return WsDepositNumberOptionReq();
  }

  factory WsDepositNumberOptionReq.fromJson(Map<String, dynamic> json) =>
      _$WsDepositNumberOptionReqFromJson(json);
  Map<String, dynamic> toJson() => _$WsDepositNumberOptionReqToJson(this);

  Map<String, String> toBody() =>
      toJson().map((key, value) => value == null ? MapEntry(key, 'null') : MapEntry(key, value));
}
