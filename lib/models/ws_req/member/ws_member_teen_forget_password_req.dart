import 'package:frechat/system/util/aes_util.dart';
import 'package:json_annotation/json_annotation.dart';

part 'ws_member_teen_forget_password_req.g.dart';

@JsonSerializable()
class WsMemberTeenForgetPasswordReq {
  WsMemberTeenForgetPasswordReq({
    required this.data
  });

  factory WsMemberTeenForgetPasswordReq.create({
    required String env,
    required String phoneNumber,
    /// 一鍵登入Token或简讯验证码
    required String tokenOrSms,
  }) {
    String rawData ='${env}_${phoneNumber}_$tokenOrSms';
    final String dataAscii = AesUtil.encode(rawData: rawData);
    return WsMemberTeenForgetPasswordReq(data: dataAscii);
  }

  /// AES加密 MEMBERKEY
  /// 使用者資料 AES加密 用_區隔: 環境_手機號_一鍵登入Token或简讯验证码
  @JsonKey(name: 'data')
  String data;

  factory WsMemberTeenForgetPasswordReq.fromJson(Map<String, dynamic> json) =>
      _$WsMemberTeenForgetPasswordReqFromJson(json);
  Map<String, dynamic> toJson() => _$WsMemberTeenForgetPasswordReqToJson(this);

  Map<String, String> toBody() =>
      toJson().map((key, value) => value == null ? MapEntry(key, 'null') : MapEntry(key, value));
}
