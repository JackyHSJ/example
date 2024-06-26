
import 'package:json_annotation/json_annotation.dart';

part 'ws_notification_strike_up_res.g.dart';

@JsonSerializable()
class WsNotificationStrikeUpRes {
  WsNotificationStrikeUpRes({
    this.chatRoom,
    this.remainCoins
  });

  @JsonKey(name: 'chatRoom')
  final ChatRoomInfo? chatRoom;

  @JsonKey(name: 'remainCoins')
  final num? remainCoins;

  factory WsNotificationStrikeUpRes.fromJson(Map<String, dynamic> json) =>
      _$WsNotificationStrikeUpResFromJson(json);

  Map<String, dynamic> toJson() => _$WsNotificationStrikeUpResToJson(this);
}

@JsonSerializable()
class ChatRoomInfo {
  ChatRoomInfo({
    this.notificationFlag,
    this.roomIcon,
    this.roomId,
    this.roomName,
    this.userCount,
    this.userId,
    this.userName,
    this.cohesionLevel,
    this.points,
    this.remark,
    this.isOnline,
  });

  @JsonKey(name: 'notificationFlag')
  final num? notificationFlag;

  /// 頭像(client端判斷後顯示對方的)
  @JsonKey(name: 'roomIcon')
  final String? roomIcon;

  /// Room Id
  @JsonKey(name: 'roomId')
  final num? roomId;

  /// 房間名稱(client端判斷後顯示對方的)
  @JsonKey(name: 'roomName')
  final String? roomName;

  /// 群內用戶數
  @JsonKey(name: 'userCount')
  final num? userCount;

  @JsonKey(name: 'userName')
  final String? userName;

  @JsonKey(name: 'userId')
  final num? userId;

  /// 亲密等級
  @JsonKey(name: 'cohesionLevel')
  final num? cohesionLevel;

  /// 亲密值
  @JsonKey(name: 'points')
  final num? points;

  @JsonKey(name: 'remark')
  final String? remark;

  /// 是否在線
  @JsonKey(name: 'isOnline')
  final num? isOnline;

  factory ChatRoomInfo.fromJson(Map<String, dynamic> json) =>
      _$ChatRoomInfoFromJson(json);
  Map<String, dynamic> toJson() => _$ChatRoomInfoToJson(this);
}