
import 'package:flutter/cupertino.dart';
import 'package:frechat/widgets/theme/original/app_colors.dart';
import 'package:json_annotation/json_annotation.dart';

part 'ws_notification_search_intimacy_level_info_res.g.dart';

@JsonSerializable()
class WsNotificationSearchIntimacyLevelInfoRes {
  WsNotificationSearchIntimacyLevelInfoRes({
    this.newUserProtect,
    this.list,
  });

  /// 新用戶保護機制 1000|2|1 表示親密點數1000點內，強制使用魅力等級二收費額度
  /// 第 3 個表示開關，0 -> 關閉, 1 -> 開啟
  @JsonKey(name: 'newUserProtect')
  final String? newUserProtect;

  @JsonKey(name: 'list')
  final List<IntimacyLevelInfo>? list;

  factory WsNotificationSearchIntimacyLevelInfoRes.fromJson(Map<String, dynamic> json) =>
      _$WsNotificationSearchIntimacyLevelInfoResFromJson(json);
  Map<String, dynamic> toJson() => _$WsNotificationSearchIntimacyLevelInfoResToJson(this);

  String getCohesionImagePath(num cohesionPoints) {
    String img = '';
    _getValue(cohesionPoints,
      onLevel0: () => img = 'assets/images/icon_intimacy_level0.png',
      onLevel1: () => img = 'assets/images/icon_intimacy_level1.png',
      onLevel2: () => img = 'assets/images/icon_intimacy_level2.png',
      onLevel3: () => img = 'assets/images/icon_intimacy_level3.png',
      onLevel4: () => img = 'assets/images/icon_intimacy_level4.png',
      onLevel5: () => img = 'assets/images/icon_intimacy_level5.png',
      onLevel6: () => img = 'assets/images/icon_intimacy_level6.png',
      onLevel7: () => img = 'assets/images/icon_intimacy_level7.png',
      onLevel8: () => img = 'assets/images/icon_intimacy_level8.png',
    );
    return img;
  }

  Color getCohesionColor(num cohesionPoints) {
    Color color = const Color(0x00000000);
    _getValue(cohesionPoints,
      onLevel0: () => color = AppColors.cohesionLevelColor[0],
      onLevel1: () => color = AppColors.cohesionLevelColor[1],
      onLevel2: () => color = AppColors.cohesionLevelColor[2],
      onLevel3: () => color = AppColors.cohesionLevelColor[3],
      onLevel4: () => color = AppColors.cohesionLevelColor[4],
      onLevel5: () => color = AppColors.cohesionLevelColor[5],
      onLevel6: () => color = AppColors.cohesionLevelColor[6],
      onLevel7: () => color = AppColors.cohesionLevelColor[7],
      onLevel8: () => color = AppColors.cohesionLevelColor[8],
    );
    return color;
  }

  String getNextRelationShip(num cohesionPoints) {
    String title = '';
    _getValue(cohesionPoints,
      onLevel0: () => title = '【相识】',
      onLevel1: () => title = '【初识】',
      onLevel2: () => title = '【朋友】',
      onLevel3: () => title = '【暧昧】',
      onLevel4: () => title = '【约会】',
      onLevel5: () => title = '【告白】',
      onLevel6: () => title = '【宠爱】',
      onLevel7: () => title = '【见证】',
      onLevel8: () => title = '【】',
    );
    return title;
  }

  num getNowIntimacy(num cohesionPoints) {
    num nowIntimacy = 0;
    _getValue(cohesionPoints,
      onLevel0: () => nowIntimacy = 0,
      onLevel1: () => nowIntimacy = 1,
      onLevel2: () => nowIntimacy = 2,
      onLevel3: () => nowIntimacy = 3,
      onLevel4: () => nowIntimacy = 4,
      onLevel5: () => nowIntimacy = 5,
      onLevel6: () => nowIntimacy = 6,
      onLevel7: () => nowIntimacy = 7,
      onLevel8: () => nowIntimacy = 8,
    );
    return nowIntimacy;
  }

  //取得目前亲密度狀態
  void _getValue(num cohesionPoints, {
    required Function() onLevel0,
    required Function() onLevel1,
    required Function() onLevel2,
    required Function() onLevel3,
    required Function() onLevel4,
    required Function() onLevel5,
    required Function() onLevel6,
    required Function() onLevel7,
    required Function() onLevel8,
  }) {
    final List<num> pointList = list?.map((info) => info.points ?? 0).toList() ?? [];
    
    if (cohesionPoints < pointList[1]) {
      onLevel0();
    } else if (pointList[1] <= cohesionPoints && cohesionPoints < pointList[2]) {
      onLevel1();
    } else if (pointList[2] <= cohesionPoints && cohesionPoints < pointList[3]) {
      onLevel2();
    } else if (pointList[3] <= cohesionPoints && cohesionPoints < pointList[4]) {
      onLevel3();
    } else if (pointList[4] <= cohesionPoints && cohesionPoints < pointList[5]) {
      onLevel4();
    } else if (pointList[5] <= cohesionPoints && cohesionPoints < pointList[6]) {
      onLevel5();
    } else if (pointList[6] <= cohesionPoints && cohesionPoints < pointList[7]) {
      onLevel6();
    } else if (pointList[7] <= cohesionPoints && cohesionPoints < pointList[8]) {
      onLevel7();
    }else{
      onLevel8();
    }
  }
}

class IntimacyLevelInfo {
  IntimacyLevelInfo({
    this.cohesionLevel,
    this.cohesionName,
    this.points,
    this.updateTime,
    this.award,
    this.updateUser,
  });

  /// 亲密等級(排序)
  @JsonKey(name: 'cohesionLevel')
  final num? cohesionLevel;

  /// 亲密等級名稱
  @JsonKey(name: 'cohesionName')
  final String? cohesionName;

  /// 亲密點數
  @JsonKey(name: 'points')
  final num? points;

  /// 最後更新時間(unix timestamp)
  @JsonKey(name: 'updateTime')
  final num? updateTime;

  /// 升級獎勵 days|mins|type days:獎勵天數 mins:獎勵分鐘數 type: 0=語音 1=視頻
  @JsonKey(name: 'award')
  final String? award;

  /// 最後更新用戶
  @JsonKey(name: 'updateUser')
  final String? updateUser;

  factory IntimacyLevelInfo.fromJson(Map<String, dynamic> json) =>
      _$IntimacyLevelInfoFromJson(json);
  Map<String, dynamic> toJson() => _$IntimacyLevelInfoToJson(this);
}