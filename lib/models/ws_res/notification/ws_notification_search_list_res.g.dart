// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ws_notification_search_list_res.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WsNotificationSearchListRes _$WsNotificationSearchListResFromJson(
        Map<String, dynamic> json) =>
    WsNotificationSearchListRes(
        pageNumber: json['pageNumber'] as num?,
        totalPages: json['totalPages'] as num?,
        fullListSize: json['fullListSize'] as num?,
        pageSize: json['pageSize'] as num?,
        list: (json['list'] as List)
            .map((info) => SearchListInfo.fromJson(info))
            .toList());

Map<String, dynamic> _$WsNotificationSearchListResToJson(
        WsNotificationSearchListRes instance) =>
    <String, dynamic>{
      'pageNumber': instance.pageNumber,
      'totalPages': instance.totalPages,
      'fullListSize': instance.fullListSize,
      'pageSize': instance.pageSize,
      'list': instance.list,
    };

SearchListInfo _$ListInfoFromJson(Map<String, dynamic> json) => SearchListInfo(
      roomId: json['roomId'] as num?,
      roomName: json['roomName'] as String?,
      roomIcon: json['roomIcon'] as String?,
      userCount: json['userCount'] as num?,
      notificationFlag: json['notificationFlag'] as num?,
      cohesionLevel: json['cohesionLevel'] as num?,
      points: json['points'] as num?,
      isOnline: json['isOnline'] as num?,
      userName: json['userName'] as String?,
      userId: json['userId'] as num?,
      remark: json['remark'] as String?,
    sendStatus:json['sendStatus'] as num?
    );

Map<String, dynamic> _$ListInfoToJson(SearchListInfo instance) =>
    <String, dynamic>{
      'roomId': instance.roomId,
      'roomName': instance.roomName,
      'roomIcon': instance.roomIcon,
      'userCount': instance.userCount,
      'notificationFlag': instance.notificationFlag,
      'cohesionLevel': instance.cohesionLevel,
      'points': instance.points,
      'isOnline': instance.isOnline,
      'userName': instance.userName,
      'userId': instance.userId,
      'remark': instance.remark,
      'sendStatus':instance.sendStatus,
    };
