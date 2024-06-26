import 'package:frechat/system/util/aes_util.dart';
import 'package:json_annotation/json_annotation.dart';

part 'ws_member_enable_teen_req.g.dart';

@JsonSerializable()
class WsMemberEnableTeenReq {
  WsMemberEnableTeenReq({
    required this.data
  });

  factory WsMemberEnableTeenReq.create({
    required String env,
    required String phoneNumber,
    required String password,
  }) {
    String rawData ='${env}_${phoneNumber}_$password';
    final String dataAscii = AesUtil.encode(rawData: rawData);
    return WsMemberEnableTeenReq(data: dataAscii);
  }

  /// AES加密 MEMBERKEY
  /// 使用者資料 AES加密 用_區隔: 環境_手機號_密碼
  @JsonKey(name: 'data')
  String data;

  factory WsMemberEnableTeenReq.fromJson(Map<String, dynamic> json) =>
      _$WsMemberEnableTeenReqFromJson(json);
  Map<String, dynamic> toJson() => _$WsMemberEnableTeenReqToJson(this);

  Map<String, String> toBody() =>
      toJson().map((key, value) => value == null ? MapEntry(key, 'null') : MapEntry(key, value));
}
