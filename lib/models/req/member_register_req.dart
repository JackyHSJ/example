import 'dart:io';

import 'package:dio/dio.dart';
import 'package:json_annotation/json_annotation.dart';
import '../../system/util/aes_util.dart';
import '../../system/util/form_data_util.dart';

part 'member_register_req.g.dart';

@JsonSerializable()
class MemberRegisterReq {
  MemberRegisterReq({
    required this.data,
    required this.avatarImg,
    this.appId,
    this.location,
    this.osType,
    this.token1,
    required this.merchant,
  });

  factory MemberRegisterReq.create(
    {
      required String env,
      required String phoneNumber,
      required String phoneToken,
      required String nickName,
      required String firstRegPackage,
      required String code,
      required String gender,
      required String age,
      required String deviceModel,
      required String currentVersion,
      required String systemVersion,
      required String merchant,
      File? avatarImg,
      String? token1,
    }) {
    final String rawData = '${env}_${phoneNumber}_${phoneToken}_${nickName}_${firstRegPackage}_${code}_${gender}_${age}_${deviceModel}_${currentVersion}_$systemVersion';
    final String dataAscii = AesUtil.encode(rawData: rawData);
    return MemberRegisterReq(data: dataAscii, avatarImg: avatarImg, merchant: merchant, token1: token1);
  }

  //使用者資料 AES 加密 用_區隔:
  //環境_手機號_一鍵登入Token_暱稱_首次注册包_ 邀请码_性别_年龄_设备型号_当前版本号_系统版本
  //env_phoneNumber_phoneToken_nickName_firstRegPackage_code_gender_age_deviceModel_currentVersion_systemVersion
  //AES 加密 MEMBERKEY
  @JsonKey(name: 'data')
  String data;

  //頭像圖檔
  @JsonKey(name: 'avatarImg')
  File? avatarImg;

  // 上架的 app id
  @JsonKey(name: 'appId')
  String? appId;

  // 所在地区
  @JsonKey(name: 'location')
  String? location;

  // 手机系统(0:苹果 1:安卓)
  @JsonKey(name: 'osType')
  num? osType;

  // 商城
  @JsonKey(name: 'merchant')
  String merchant;

  // 商城
  @JsonKey(name: 'merchant')
  String? token1;

  factory MemberRegisterReq.fromJson(Map<String, dynamic> json) =>
      _$MemberRegisterReqFromJson(json);
  Map<String, dynamic> toJson() => _$MemberRegisterReqToJson(this);

  Future<FormData> toFormData() async {
    final FormData formData = await FormDataUtil.toFormData(toJson: toJson());
    return formData;
  }
}
