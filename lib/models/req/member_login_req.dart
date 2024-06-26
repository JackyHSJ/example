import 'package:encrypt/encrypt.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../system/comm/comm_def.dart';
import '../../system/util/aes_util.dart';

part 'member_login_req.g.dart';

@JsonSerializable()
class MemberLoginReq {
  MemberLoginReq({
    this.data,
    required this.tdata,
    this.type,
    this.express,
    this.appId,
    this.location,
    this.osType,
    this.resp3rd,
    this.token1,
    this.token2,
    required this.tokenType,
    required this.merchant,
    required this.version
  });

  factory MemberLoginReq.create({
    required String env,
    required String phoneNumber,
    required String phoneToken,
    required String deviceModel,
    required String currentVersion,
    required String systemVersion,
    required String tdata,
    required String merchant,
    required String tokenType,
    required String version,
    String? appId,
    String? location,
    num? type,
    bool? express,
    int? osType,
    String? resp3rd,
    String? token1,
    String? token2,

  }) {
    String rawData =
        '${env}_${phoneNumber}_${phoneToken}_${deviceModel}_${currentVersion}_$systemVersion';
    final String dataAscii = AesUtil.encode(rawData: rawData);
    return MemberLoginReq(
      data: dataAscii,
      tdata: tdata, type: type, express: express,
      appId: appId, location: location, osType: osType,
      resp3rd: resp3rd, merchant: merchant, token1: token1, token2: token2,tokenType: tokenType, version: version
    );
  }

  //使用者資料 AES 加密 用_區隔:
  //環境_手機號_一鍵登入Token_设备型号_当前版本号_系统版本
  //AES 加密 MEMBERKEY
  @JsonKey(name: 'data')
  String? data;

  // app 版本 id
  @JsonKey(name: 'appId')
  String? appId;

  // expres开关若true DEV环境下免验第三方验登录)(预设:false)
  @JsonKey(name: 'express')
  bool? express;

  // 1: 一鍵登入 2:簡訊驗證碼
  @JsonKey(name: 'type')
  num? type;

  // 所在地区
  @JsonKey(name: 'location')
  String? location;

  // 環境@tId 每次重開app,若手機存有tId,傳tdata登入,取得新的token(tId)
  @JsonKey(name: 'tdata')
  String tdata;

  // 環境@tId 每次重開app,若手機存有tId,傳tdata登入,取得新的token(tId)
  @JsonKey(name: 'osType')
  int? osType;

  // 一键登录三方回傳字串
  @JsonKey(name: 'resp3rd')
  String? resp3rd;

  // 商城
  @JsonKey(name: 'merchant')
  String merchant;

  // 一键登录TokenType(2:网易), 极光走原来的模式,可以传1或者不传该参数
  @JsonKey(name: 'tokenType')
  String tokenType;

  // 网易:token
  @JsonKey(name: 'token1')
  String? token1;

  // 网易:accessToken
  @JsonKey(name: 'token2')
  String? token2;

  // Version
  @JsonKey(name: 'version')
  String version;

  factory MemberLoginReq.fromJson(Map<String, dynamic> json) =>
      _$MemberLoginReqFromJson(json);
  Map<String, dynamic> toJson() => _$MemberLoginReqToJson(this);

  // API 不帶參數的屬性不傳出
  Map<String, dynamic> toBody() {
    Map<String, dynamic> json = toJson();
    json.removeWhere((key, value) => value == null);
    return json;
  }
}
