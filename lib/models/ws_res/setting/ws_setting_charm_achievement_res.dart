import 'package:frechat/screens/profile/setting/iap/personal_setting_iap_view_model.dart';
import 'package:frechat/system/constant/enum.dart';
import 'package:json_annotation/json_annotation.dart';

part 'ws_setting_charm_achievement_res.g.dart';

@JsonSerializable()
class WsSettingCharmAchievementRes {
  WsSettingCharmAchievementRes({this.list, this.personalCharm});

  @JsonKey(name: 'list')
  final List<CharmAchievementInfo>? list;

  @JsonKey(name: 'personal_charm')
  final PersonalCharmInfo? personalCharm;

  factory WsSettingCharmAchievementRes.fromJson(Map<String, dynamic> json) =>
      _$WsSettingCharmAchievementResFromJson(json);
  Map<String, dynamic> toJson() => _$WsSettingCharmAchievementResToJson(this);

  num getLevel() {
    return personalCharm?.charmLevel ?? 0;
  }

  num getPoint({required num level}) {
    final info = list?[level.toInt()];
    final part = info!.levelCondition!.split('|');
    final num currentPoint = personalCharm?.charmPoints ?? 0;
    final num targetPoint = num.tryParse(part[1]) ?? 0;
    final point = targetPoint - currentPoint;
    final resultPoint = (point > 0) ? point : 0 ;
    return resultPoint;
  }

  List<CharmAchievementInfo> getSortList() {
    if (list == null) {
      return [];
    }
    list?.sort((a, b) => int.parse(a.charmLevel!).compareTo(int.parse(b.charmLevel!)));
    return list ?? [];
  }

  List<SettingIAPModel> getSettingIAPModel(SettingIapType type) {
    if(list == null) {
      return [];
    }

    list?.sort((a, b) => int.parse(a.charmLevel!).compareTo(int.parse(b.charmLevel!)));
    final List<SettingIAPModel> modelList = list?.map((info) {
      final num resCharmLevel = num.tryParse(info.charmLevel ?? '1') ?? 1;
      final num myCharmLevel = personalCharm?.charmLevel ?? 1;
      switch (type) {
        case SettingIapType.message:
          return SettingIAPModel(
              title: '${info.messageCharge} 金币 (魅力等级Lv${info.charmLevel}可选)', selectNum: info.messageCharge ?? 'error',
              needLock: resCharmLevel > myCharmLevel
          );
        case SettingIapType.voice:
          return SettingIAPModel(
              title: '${info.voiceCharge} 金币 (魅力等级Lv${info.charmLevel}可选)', selectNum: info.voiceCharge ?? 'error',
              needLock: resCharmLevel > myCharmLevel
          );
        case SettingIapType.video:
          return SettingIAPModel(
              title: '${info.streamCharge} 金币 (魅力等级Lv${info.charmLevel}可选)', selectNum: info.streamCharge ?? 'error',
              needLock: resCharmLevel > myCharmLevel
          );
      }
    }).toList() ?? [];

    return modelList;
  }
}

@JsonSerializable()
class CharmAchievementInfo {
  CharmAchievementInfo({
    this.levelCondition,
    this.streamCharge,
    this.messageCharge,
    this.voiceCharge,
    this.charmLevel,
  });

  @JsonKey(name: 'levelCondition')
  final String? levelCondition;

  @JsonKey(name: 'streamCharge')
  final String? streamCharge;

  @JsonKey(name: 'messageCharge')
  final String? messageCharge;
 
  @JsonKey(name: 'voiceCharge')
  final String? voiceCharge;

  @JsonKey(name: 'charmLevel')
  final String? charmLevel;

  factory CharmAchievementInfo.fromJson(Map<String, dynamic> json) =>
      _$CharmAchievementInfoFromJson(json);
  Map<String, dynamic> toJson() => _$CharmAchievementInfoToJson(this);
}

@JsonSerializable()
class PersonalCharmInfo {
  PersonalCharmInfo({
    this.charmLevelExpire,
    this.charmLevel,
    this.charmPoints,
    this.charmCharge,
  });

  @JsonKey(name: 'charm_level_expire')
  final num? charmLevelExpire;

  @JsonKey(name: 'charm_level')
  final num? charmLevel;

  @JsonKey(name: 'charm_points')
  final num? charmPoints;

  @JsonKey(name: 'charm_charge')
  final String? charmCharge;

  factory PersonalCharmInfo.fromJson(Map<String, dynamic> json) =>
      _$PersonalCharmInfoFromJson(json);
  Map<String, dynamic> toJson() => _$PersonalCharmInfoToJson(this);
}
