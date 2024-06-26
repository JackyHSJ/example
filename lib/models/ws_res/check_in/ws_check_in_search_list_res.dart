import 'package:json_annotation/json_annotation.dart';

part 'ws_check_in_search_list_res.g.dart';

@JsonSerializable()
class WsCheckInSearchListRes {
  WsCheckInSearchListRes({
    this.list,
    this.todayCount,
    this.continuousNum,
  });

  /// list
  @JsonKey(name: 'list')
  List<CheckInListInfo>? list;

  /// "今天"所在天數, 如值為3, 則"今天"為day:3
  @JsonKey(name: 'todayCount')
  num? todayCount;

  /// 連續签到天數
  @JsonKey(name: 'continuousNum')
  num? continuousNum;

  factory WsCheckInSearchListRes.fromJson(Map<String, dynamic> json) => _$WsCheckInSearchListResFromJson(json);
  Map<String, dynamic> toJson() => _$WsCheckInSearchListResToJson(this);
}

class CheckInListInfo {
  CheckInListInfo({
    this.day,
    this.giftId,
    this.giftName,
    this.gold,
    this.punchInFlag,
    this.giftUrl,
  });

  /// 範圍1~7, 代表第幾天签到狀況
  @JsonKey(name: 'day')
  num? day;

  /// 禮物 pk
  @JsonKey(name: 'giftId')
  num? giftId;

  /// 禮物名稱
  @JsonKey(name: 'giftName')
  String? giftName;

  /// 獲得金币數
  @JsonKey(name: 'gold')
  num? gold;

  /// 是否签到 0:未签到 1:已签到
  @JsonKey(name: 'punchInFlag')
  num? punchInFlag;

  ///giftUrl
  @JsonKey(name: 'giftUrl')
  String? giftUrl;

  factory CheckInListInfo.fromJson(Map<String, dynamic> json) => _$CheckInListInfoFromJson(json);
  Map<String, dynamic> toJson() => _$CheckInListInfoToJson(this);
}
