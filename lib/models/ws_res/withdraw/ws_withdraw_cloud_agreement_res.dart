import 'package:json_annotation/json_annotation.dart';

part 'ws_withdraw_cloud_agreement_res.g.dart';

@JsonSerializable()
class WsWithdrawCloudAgreementRes {
  WsWithdrawCloudAgreementRes({
    this.url,
  });

  factory WsWithdrawCloudAgreementRes.create({
    String? url,
  }) {
    return WsWithdrawCloudAgreementRes(
      url: url,
    );
  }

  /// 協議書 url
  @JsonKey(name: 'url')
  String? url;

  factory WsWithdrawCloudAgreementRes.fromJson(Map<String, dynamic> json) =>
      _$WsWithdrawCloudAgreementResFromJson(json);
  Map<String, dynamic> toJson() => _$WsWithdrawCloudAgreementResToJson(this);
}