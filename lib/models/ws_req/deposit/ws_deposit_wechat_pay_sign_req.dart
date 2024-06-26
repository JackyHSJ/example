import 'package:json_annotation/json_annotation.dart';

part 'ws_deposit_wechat_pay_sign_req.g.dart';

@JsonSerializable()
class WsDepositWeChatPaySignReq {
  WsDepositWeChatPaySignReq({
    required this.prepayId,
    required this.timestamp,
    required this.nonceStr,
    required this.transactionId,
  });
  factory WsDepositWeChatPaySignReq.create({
    required String prepayId,
    required String timestamp,
    required String nonceStr,
    required String transactionId,
  }) {
    return WsDepositWeChatPaySignReq(
      prepayId: prepayId,
      timestamp: timestamp,
      nonceStr: nonceStr,
      transactionId: transactionId
    );
  }

  /// 微信支付交易會話ID
  @JsonKey(name: 'prepayId')
  String prepayId;

  /// 時間戳(請轉字串)
  @JsonKey(name: 'timestamp')
  String timestamp;

  /// 隨機字串符
  @JsonKey(name: 'nonceStr')
  String nonceStr;

  /// 我方訂單編號 (交易號)
  @JsonKey(name: 'transactionId')
  String transactionId;

  factory WsDepositWeChatPaySignReq.fromJson(Map<String, dynamic> json) =>
      _$WsDepositWeChatPaySignReqFromJson(json);
  Map<String, dynamic> toJson() => _$WsDepositWeChatPaySignReqToJson(this);

  Map<String, String> toBody() =>
      toJson().map((key, value) => value == null ? MapEntry(key, 'null') : MapEntry(key, value));
}
