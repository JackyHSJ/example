import 'package:json_annotation/json_annotation.dart';

part 'ws_notification_search_list_res.g.dart';

@JsonSerializable()
class WsNotificationSearchListRes {
  WsNotificationSearchListRes({
    this.pageNumber,
    this.totalPages,
    this.fullListSize,
    this.pageSize,
    this.list,
  });

  /// 當前頁數
  @JsonKey(name: 'pageNumber')
  final num? pageNumber;

  /// 總頁數
  @JsonKey(name: 'totalPages')
  final num? totalPages;

  /// 總筆數
  @JsonKey(name: 'fullListSize')
  final num? fullListSize;

  /// 每頁筆數
  @JsonKey(name: 'pageSize')
  final num? pageSize;

  /// 房間清單
  @JsonKey(name: 'list')
  final List<SearchListInfo>? list;

  factory WsNotificationSearchListRes.fromJson(Map<String, dynamic> json) =>
      _$WsNotificationSearchListResFromJson(json);
  Map<String, dynamic> toJson() => _$WsNotificationSearchListResToJson(this);
}

@JsonSerializable()
class SearchListInfo {
  SearchListInfo({
    this.roomId,
    this.roomName,
    this.roomIcon,
    this.userCount,
    this.notificationFlag,
    this.cohesionLevel,
    this.points,
    this.isOnline,
    this.userName,
    this.userId,
    this.remark,
    this.sendStatus,
  });

  /// 群組ID
  @JsonKey(name: 'roomId')
  final num? roomId;

  /// 群組名稱(若為私聊 值為 nickNameA|nickNameB)
  @JsonKey(name: 'roomName')
  final String? roomName;

  /// 群組圖像(若為私聊 值為 userIdA|userIdB)
  @JsonKey(name: 'roomIcon')
  final String? roomIcon;

  /// 房間人數
  @JsonKey(name: 'userCount')
  final num? userCount;

  /// push notification 通知狀態 0:關閉 1:開啟
  @JsonKey(name: 'notificationFlag')
  final num? notificationFlag;

  /// 亲密等級
  @JsonKey(name: 'cohesionLevel')
  final num? cohesionLevel;

  /// 亲密值
  @JsonKey(name: 'points')
  final num? points;

  /// 是否在線
  @JsonKey(name: 'isOnline')
  final num? isOnline;

  @JsonKey(name: 'userName')
  late final String? userName;

  @JsonKey(name: 'userId')
  final num? userId;

  /// 用戶註記(若為null則無key, 如有值則取代用戶暱稱)
  @JsonKey(name: 'remark')
  final String? remark;

  /// 訊息的狀態：0(傳送中)，1(傳送成功)，2(傳送失敗)
  final num? sendStatus;

  factory SearchListInfo.fromJson(Map<String, dynamic> json) =>
      _$ListInfoFromJson(json);
  Map<String, dynamic> toJson() => _$ListInfoToJson(this);
}
