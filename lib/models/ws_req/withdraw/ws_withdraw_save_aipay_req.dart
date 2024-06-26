import 'package:json_annotation/json_annotation.dart';

part 'ws_withdraw_save_aipay_req.g.dart';

@JsonSerializable()
class WsWithdrawSaveAiPayReq {
  WsWithdrawSaveAiPayReq({
    this.account,
    this.function,
    this.type,
    this.status,
  });
  factory WsWithdrawSaveAiPayReq.create({
    String? account,
    String? function,
    String? type,
    String? status,
  }) {
    return WsWithdrawSaveAiPayReq(
      account: account,
      function: function,
      type: type,
      status: status,
    );
  }

  /// 提现账户。
  @JsonKey(name: 'account')
  String? account;

  /// 決定是儲存還是修改 (save/update)
  @JsonKey(name: 'function')
  String? function;

  /// 提现类型。
  @JsonKey(name: 'type')
  String? type;

  /// 类型(0:未使用,1:使用中) (非必填，預設為0)
  @JsonKey(name: 'status')
  String? status;

  factory WsWithdrawSaveAiPayReq.fromJson(Map<String, dynamic> json) => _$WsWithdrawSaveAiPayReqFromJson(json);
  Map<String, dynamic> toJson() => _$WsWithdrawSaveAiPayReqToJson(this);

  // API 不帶參數的屬性不傳出
  Map<String, dynamic> toBody() {
    Map<String, dynamic> json = toJson();
    json.removeWhere((key, value) => value == null);
    return json;
  }
}
