import 'package:frechat/system/util/aes_util.dart';
import 'package:json_annotation/json_annotation.dart';

part 'ws_member_real_name_auth_req.g.dart';

@JsonSerializable()
class WsMemberRealNameAuthReq {
  WsMemberRealNameAuthReq({
    required this.data
  });

  factory WsMemberRealNameAuthReq.create({
    required String env,
    required String realName,
    required String idCardNumber,
  }) {
    String rawData ='${env}_${realName}_$idCardNumber';
    final String dataAscii = AesUtil.encode(rawData: rawData);
    return WsMemberRealNameAuthReq(data: dataAscii);
  }

  /// AES加密 MEMBERKEY
  /// 使用者資料 AES加密 用_區隔: 環境_真实姓名_身分证号
  @JsonKey(name: 'data')
  String data;

  factory WsMemberRealNameAuthReq.fromJson(Map<String, dynamic> json) =>
      _$WsMemberRealNameAuthReqFromJson(json);
  Map<String, dynamic> toJson() => _$WsMemberRealNameAuthReqToJson(this);

  Map<String, String> toBody() =>
      toJson().map((key, value) => value == null ? MapEntry(key, 'null') : MapEntry(key, value));
}
