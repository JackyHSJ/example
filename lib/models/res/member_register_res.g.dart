// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'member_register_res.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MemberRegisterRes _$MemberRegisterMapFromJson(Map<String, dynamic> json) =>
    MemberRegisterRes(
      userName: json['userName'] as String?,
      nickName: json['nickName'] as String?,
      tId: json['tId'] as String?,
      userId: json['userId'] as num?,
      benefit: json['benefit'] == null ? RegisterBenefit() : RegisterBenefit.fromJson(json['benefit']),
      riskDescription: json['riskDescription'] as String?,
    );

Map<String, dynamic> _$MemberRegisterResToJson(MemberRegisterRes instance) =>
    <String, dynamic>{
      'userName': instance.userName,
      'nickName': instance.nickName,
      'tId': instance.tId,
      'userId': instance.userId,
      'benefit': instance.benefit,
      'riskDescription': instance.riskDescription,
    };

RegisterBenefit _$RegisterBenefitMapFromJson(Map<String, dynamic> json) =>
    RegisterBenefit(
      maleFreeWordPerDay: json['maleFreeWordPerDay'] as String?,
      maleFreeWordPerDayToFemale: json['maleFreeWordPerDayToFemale'] as String?,
      freeVideoPerMinute: json['freeVideoPerMinute'] as String?,
      maleCoin: json['maleCoin'] as String?,
      femaleCoin: json['femaleCoin'] as String?,
      malePresent: json['malePresent'] as String?,
      femalePresent: json['femalePresent'] as String?,
      giftId: json['giftId'] as String?,
      giftUrl: json['giftUrl'] as String?,
      fileName: json['fileName'] as String?,
      giftName: json['giftName'] as String?,
    );

Map<String, dynamic> _$RegisterBenefitResToJson(RegisterBenefit instance) =>
    <String, dynamic>{
      'maleFreeWordPerDay': instance.maleFreeWordPerDay,
      'maleFreeWordPerDayToFemale': instance.maleFreeWordPerDayToFemale,
      'freeVideoPerMinute': instance.freeVideoPerMinute,
      'maleCoin': instance.maleCoin,
      'femaleCoin': instance.femaleCoin,
      'malePresent': instance.malePresent,
      'femalePresent': instance.femalePresent,
      'giftId': instance.giftId,
      'giftUrl': instance.giftUrl,
      'fileName': instance.fileName,
      'giftName': instance.giftName,
    };
