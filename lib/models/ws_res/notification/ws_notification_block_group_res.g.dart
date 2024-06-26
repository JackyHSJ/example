// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ws_notification_block_group_res.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WsNotificationBlockGroupRes _$WsNotificationBlockGroupResFromJson(Map<String, dynamic> json) => WsNotificationBlockGroupRes(
  pageNumber: json['pageNumber'] as num?,
  totalPages: json['totalPages'] as num?,
  fullListSize: json['fullListSize'] as num?,
  pageSize: json['pageSize'] as num?,
  list: (json['list'] == null) ? [] : (json['list'] as List).map((block) => BlockListInfo.fromJson(block)).toList(),
);

Map<String, dynamic> _$WsNotificationBlockGroupResToJson(WsNotificationBlockGroupRes instance) => <String, dynamic>{
  'pageNumber': instance.pageNumber,
  'totalPages': instance.totalPages,
  'fullListSize': instance.fullListSize,
  'pageSize': instance.pageSize,
  'list': instance.list,
};

BlockListInfo _$BlockListInfoFromJson(Map<String, dynamic> json) => BlockListInfo(
  filePath: json['filePath'] as String?,
  friendId: json['friendId'] as num?,
  nickName: json['nickName'] as String?,
  age: json['age'] as num?,
  gender: json['gender'] as num?,
  selfIntroduction: json['selfIntroduction'] as String?,
  userName: json['userName'] as String?,
);

Map<String, dynamic> _$BlockListInfoToJson(BlockListInfo instance) => <String, dynamic>{
  'filePath': instance.filePath,
  'friendId': instance.friendId,
  'nickName': instance.nickName,
  'age': instance.age,
  'gender': instance.gender,
  'selfIntroduction': instance.selfIntroduction,
  'userName': instance.userName,
};
