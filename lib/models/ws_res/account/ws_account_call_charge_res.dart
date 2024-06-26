
import 'package:json_annotation/json_annotation.dart';
part 'ws_account_call_charge_res.g.dart';

@JsonSerializable()
class WsAccountCallChargeRes {
  WsAccountCallChargeRes({
    this.cost,
    this.remainCoins,
    this.remainTimes,
  });

  @JsonKey(name: 'cost')
  final num? cost;

  @JsonKey(name: 'remainCoins')
  final num? remainCoins;

  @JsonKey(name: 'remainTimes')
  final num? remainTimes;



  factory WsAccountCallChargeRes.fromJson(Map<String, dynamic> json) =>
      _$WsAccountCallChargeResFromJson(json);
  Map<String, dynamic> toJson() => _$WsAccountCallChargeResToJson(this);
}