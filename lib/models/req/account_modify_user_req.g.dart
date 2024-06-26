// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_modify_user_req.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MemberModifyUserReq _$MemberModifyUserReqFromJson(Map<String, dynamic> json) =>
    MemberModifyUserReq(
        tId: json['tId'] as String,
        hometown: json['hometown'] as String?,
        occupation: json['occupation'] as String?,
        annualIncome: json['annualIncome'] as String?,
        education: json['education'] as String?,
        age: json['age'] as int?,
        maritalStatus: json['maritalStatus'] as int?,
        weight: json['weight'] as num?,
        height: json['height'] as num?,
        selfIntroduction: json['selfIntroduction'] as String?,
        avatarImg: json['avatarImg'] as File?,
        realPersonImg: json['realPersonImg'] as File?,
        albumImgs: json['albumImgs'] as List<File>?,
        audio: json['audio'] as File?,
        greetingImg: json['greetingImg'] as File?,
        greetingAac: json['greetingAac'] as File?,
        greetingTxt: json['greetingTxt'] as File?,
        nickName: json['nickName'] as String?,
        tag: json['tag'] as List<String>?,
        location: json['location'] as String?,
        tvStatus: json['tvStatus'] as num?,
    );

Map<String, dynamic> _$MemberModifyUserReqToJson(MemberModifyUserReq instance) =>
    <String, dynamic>{
      'tId': instance.tId,
      'hometown': instance.hometown,
      'occupation': instance.occupation,
      'annualIncome': instance.annualIncome,
      'education': instance.education,
      'age': instance.age,
      'maritalStatus': instance.maritalStatus,
      'weight': instance.weight,
      'height': instance.height,
      'selfIntroduction': instance.selfIntroduction,
      'avatarImg': instance.avatarImg,
      'realPersonImg': instance.realPersonImg,
      'albumImgs': instance.albumImgs,
      'audio': instance.audio,
      'greetingImg': instance.greetingImg,
      'greetingAac': instance.greetingAac,
      'greetingTxt': instance.greetingTxt,
      'nickName': instance.nickName,
      'tag': instance.tag,
      'location': instance.location,
      'tvStatus': instance.tvStatus,
    };
