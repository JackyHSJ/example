import 'package:frechat/system/util/aes_util.dart';
import 'package:json_annotation/json_annotation.dart';

part 'ws_member_disable_teen_req.g.dart';

@JsonSerializable()
class WsMemberDisableTeenReq {
  WsMemberDisableTeenReq({
    required this.data
  });

  factory WsMemberDisableTeenReq.create({
    required String env,
    required String phoneNumber,
    required String password,
  }) {
    String rawData ='${env}_${phoneNumber}_$password';
    final String dataAscii = AesUtil.encode(rawData: rawData);
    return WsMemberDisableTeenReq(data: dataAscii);
  }

  /// AES加密 MEMBERKEY
  /// 使用者資料 AES加密 用_區隔: 環境_手機號_密碼
  @JsonKey(name: 'data')
  String data;

  factory WsMemberDisableTeenReq.fromJson(Map<String, dynamic> json) =>
      _$WsMemberDisableTeenReqFromJson(json);
  Map<String, dynamic> toJson() => _$WsMemberDisableTeenReqToJson(this);

  Map<String, String> toBody() =>
      toJson().map((key, value) => value == null ? MapEntry(key, 'null') : MapEntry(key, value));
}
