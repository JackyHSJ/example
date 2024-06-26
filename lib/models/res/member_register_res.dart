import 'package:frechat/models/res/base_res.dart';
import 'package:frechat/system/deeplink/openinstall/openinstall_handler.dart';
import 'package:json_annotation/json_annotation.dart';

part 'member_register_res.g.dart';

@JsonSerializable()
class MemberRegisterRes {
  MemberRegisterRes({
    this.userName,
    this.nickName,
    this.tId,
    this.userId,
    this.benefit,
    this.riskDescription,
  });

  @JsonKey(name: 'userName')
  final String? userName;

  @JsonKey(name: 'userId')
  final num? userId;

  @JsonKey(name: 'nickName')
  final String? nickName;

  @JsonKey(name: 'tId')
  final String? tId;

  @JsonKey(name: 'benefit')
  final RegisterBenefit? benefit;

  @JsonKey(name: 'riskDescription')
  final String? riskDescription;

  factory MemberRegisterRes.fromJson(Map<String, dynamic> json) =>
      _$MemberRegisterMapFromJson(json);
  Map<String, dynamic> toJson() => _$MemberRegisterResToJson(this);
}

@JsonSerializable()
class RegisterBenefit {
  RegisterBenefit({
    this.maleFreeWordPerDay,
    this.maleFreeWordPerDayToFemale,
    this.freeVideoPerMinute,
    this.maleCoin,
    this.femaleCoin,
    this.malePresent,
    this.femalePresent,
    this.giftId,
    this.giftUrl,
    this.fileName,
    this.giftName,
  });

  @JsonKey(name: 'maleFreeWordPerDay')
  final String? maleFreeWordPerDay;

  @JsonKey(name: 'maleFreeWordPerDayToFemale')
  final String? maleFreeWordPerDayToFemale;

  @JsonKey(name: 'freeVideoPerMinute')
  final String? freeVideoPerMinute;

  @JsonKey(name: 'maleCoin')
  final String? maleCoin;

  @JsonKey(name: 'femaleCoin')
  final String? femaleCoin;

  @JsonKey(name: 'malePresent')
  final String? malePresent;

  @JsonKey(name: 'femalePresent')
  final String? femalePresent;

  @JsonKey(name: 'giftId')
  final String? giftId;

  @JsonKey(name: 'giftUrl')
  final String? giftUrl;

  @JsonKey(name: 'fileName')
  final String? fileName;

  @JsonKey(name: 'giftName')
  final String? giftName;

  factory RegisterBenefit.fromJson(Map<String, dynamic> json) =>
      _$RegisterBenefitMapFromJson(json);
  Map<String, dynamic> toJson() => _$RegisterBenefitResToJson(this);
}
