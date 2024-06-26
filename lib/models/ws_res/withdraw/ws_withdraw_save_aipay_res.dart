import 'package:json_annotation/json_annotation.dart';

part 'ws_withdraw_save_aipay_res.g.dart';

@JsonSerializable()
class WsWithdrawSaveAiPayRes {
  WsWithdrawSaveAiPayRes({
    this.resultCode,
    this.resultMsg,
  });

  @JsonKey(name: 'resultCode')
  String? resultCode;

  @JsonKey(name: 'resultMsg')
  String? resultMsg;

  factory WsWithdrawSaveAiPayRes.fromJson(Map<String, dynamic> json) =>
      _$WsWithdrawSaveAiPayResFromJson(json);
  Map<String, dynamic> toJson() => _$WsWithdrawSaveAiPayResToJson(this);
}