// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ws_notification_strike_up_res.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WsNotificationStrikeUpRes _$WsNotificationStrikeUpResFromJson(Map<String, dynamic> json) => WsNotificationStrikeUpRes(
  chatRoom: (json['chatRoom'] == null) ? ChatRoomInfo() : ChatRoomInfo.fromJson(json['chatRoom']),
  remainCoins: json['remainCoins'] as num?
);

Map<String, dynamic> _$WsNotificationStrikeUpResToJson(WsNotificationStrikeUpRes instance) => <String, dynamic>{
  'chatRoom': instance.chatRoom,
  'remainCoins': instance.remainCoins
};

ChatRoomInfo _$ChatRoomInfoFromJson(Map<String, dynamic> json) => ChatRoomInfo(
  notificationFlag: json['notificationFlag'] as num?,
  roomIcon: json['roomIcon'] as String?,
  roomId: json['roomId'] as num?,
  roomName: json['roomName'] as String?,
  userCount: json['userCount'] as num?,
  userId: json['userId'] as num?,
  userName: json['userName'] as String?,
  cohesionLevel: json['cohesionLevel'] as num?,
  points: json['points'] as num?,
  remark: json['remark'] as String?,
  isOnline: json['isOnline'] as num?,
);

Map<String, dynamic> _$ChatRoomInfoToJson(ChatRoomInfo instance) => <String, dynamic>{
  'notificationFlag': instance.notificationFlag,
  'roomIcon': instance.roomIcon,
  'roomId': instance.roomId,
  'roomName': instance.roomName,
  'userCount': instance.userCount,
  'userId': instance.userId,
  'userName': instance.userName,
  'cohesionLevel': instance.cohesionLevel,
  'points': instance.points,
  'remark': instance.remark,
  'isOnline': instance.isOnline,
};