import 'package:json_annotation/json_annotation.dart';

part 'ws_withdraw_cloud_agreement_req.g.dart';

@JsonSerializable()
class WsWithdrawCloudAgreementReq {
  WsWithdrawCloudAgreementReq();
  factory WsWithdrawCloudAgreementReq.create() {
    return WsWithdrawCloudAgreementReq( );
  }

  factory WsWithdrawCloudAgreementReq.fromJson(Map<String, dynamic> json) =>
      _$WsWithdrawCloudAgreementReqFromJson(json);
  Map<String, dynamic> toJson() => _$WsWithdrawCloudAgreementReqToJson(this);

  Map<String, String> toBody() =>
      toJson().map((key, value) => value == null ? MapEntry(key, 'null') : MapEntry(key, value));
}
