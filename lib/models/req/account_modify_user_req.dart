import 'dart:io';
import 'package:dio/dio.dart';
import 'package:frechat/system/util/form_data_util.dart';
import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';
part 'account_modify_user_req.g.dart';

@JsonSerializable()
class MemberModifyUserReq {
  MemberModifyUserReq({
    required this.tId,
    this.hometown,
    this.occupation,
    this.annualIncome,
    this.education,
    this.age,
    this.maritalStatus,
    this.weight,
    this.height,
    this.selfIntroduction,
    this.avatarImg,
    this.realPersonImg,
    this.albumImgs,
    this.audio,
    this.greetingImg,
    this.greetingAac,
    this.greetingTxt,
    this.nickName,
    this.tag,
    this.location,
    this.tvStatus,
  });

  factory MemberModifyUserReq.create({
    required String tId,
    String? hometown,
    String? occupation,
    String? annualIncome,
    String? education,
    int? age,
    int? maritalStatus,
    num? weight,
    num? height,
    String? selfIntroduction,
    File? avatarImg,
    File? realPersonImg,
    List<File>? albumImgs,
    File? audio,
    File? greetingImg,
    File? greetingAac,
    File? greetingTxt,
    String? nickName,
    List<String>? tag,
    String? location,
    num? tvStatus,
  }) {
    return MemberModifyUserReq(
        tId: tId,
        hometown: hometown,
        occupation: occupation,
        annualIncome: annualIncome,
        education: education,
        age: age,
        maritalStatus: maritalStatus,
        weight: weight,
        height: height,
        selfIntroduction: selfIntroduction,
        avatarImg: avatarImg,
        realPersonImg: realPersonImg,
        albumImgs: albumImgs,
        audio: audio,
        greetingImg: greetingImg,
        greetingAac: greetingAac,
        greetingTxt: greetingTxt,
        nickName: nickName,
        tag: tag,
        location: location,
        tvStatus: tvStatus
    );
  }

  // token
  @JsonKey(name: 'tId')
  String tId;

  // 家鄉
  @JsonKey(name: 'hometown')
  String? hometown;

  // 職業
  @JsonKey(name: 'occupation')
  String? occupation;

  // 年收入
  @JsonKey(name: 'annualIncome')
  String? annualIncome;

  @JsonKey(name: 'education')
  String? education;

  @JsonKey(name: 'age')
  int? age;

  // 婚姻狀況 0:單身 1:已婚
  @JsonKey(name: 'maritalStatus')
  int? maritalStatus;

  // 體重
  @JsonKey(name: 'weight')
  num? weight;

  // 身高
  @JsonKey(name: 'height')
  num? height;

  // 自我介绍
  @JsonKey(name: 'selfIntroduction')
  String? selfIntroduction;

  // 頭像
  @JsonKey(name: 'avatarImg')
  File? avatarImg;

  // 真人
  @JsonKey(name: 'realPersonImg')
  File? realPersonImg;

  // 相簿
  @JsonKey(name: 'albumImgs')
  List<File>? albumImgs;

  // 聲音展示
  @JsonKey(name: 'audio')
  File? audio;

  // 招呼語-圖片
  @JsonKey(name: 'greetingImg')
  File? greetingImg;

  // 招呼語-語音
  @JsonKey(name: 'greetingAac')
  File? greetingAac;

  // 招呼語-文字
  @JsonKey(name: 'greetingTxt')
  File? greetingTxt;

  // 暱稱
  @JsonKey(name: 'nickName')
  String? nickName;

  // 暱稱
  @JsonKey(name: 'tag')
  List<String>? tag;

  // 所在地区
  @JsonKey(name: 'location')
  String? location;

  // 送礼上电视是否匿名 1:匿名 2:不匿名 需求項目#B006
  @JsonKey(name: 'tvStatus')
  num? tvStatus;


  factory MemberModifyUserReq.fromJson(Map<String, dynamic> json) =>
      _$MemberModifyUserReqFromJson(json);
  Map<String, dynamic> toJson() => _$MemberModifyUserReqToJson(this);

  Future<FormData> toFormData() async {
    final FormData formData = await FormDataUtil.toFormData(toJson: toJson());
    return formData;
  }
}
