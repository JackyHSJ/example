// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ws_account_follow_and_fans_list_res.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WsAccountFollowAndFansListRes _$WsAccountFollowAndFansListResFromJson(Map<String, dynamic> json) => WsAccountFollowAndFansListRes(
  pageNumber: json['pageNumber'] as num?,
  totalPages: json['totalPages'] as num?,
  fullListSize: json['fullListSize'] as num?,
  pageSize: json['pageSize'] as num?,
  list: (json['list'] as List).map((info) => AccountListInfo.fromJson(info)).toList(),
);

Map<String, dynamic> _$WsAccountFollowAndFansListResToJson(WsAccountFollowAndFansListRes instance) => <String, dynamic>{
  'pageNumber': instance.pageNumber,
  'totalPages': instance.totalPages,
  'fullListSize': instance.fullListSize,
  'pageSize': instance.pageSize,
  'list': instance.list,
};

AccountListInfo _$AccountListInfoFromJson(Map<String, dynamic> json) => AccountListInfo(
  occupation: json['occupation'] as String?,
  gender: json['gender'] as num?,
  nickName: json['nickName'] as String?,
  weight: json['weight'] as num?,
  height: json['height'] as num?,
  id: json['id'] as num?,
  age: json['age'] as num?,
  location: json['location'] as String?,
  selfIntroduction: json['selfIntroduction'] as String?,
  roomId: json['roomId'] as num?,
  avatar: json['avatar'] as String?,
  realNameAuth: json['realNameAuth'] as num?,
  realPersonAuth: json['realPersonAuth'] as num?,
  userName: json['userName'] as String?,
);

Map<String, dynamic> _$AccountListInfoToJson(AccountListInfo instance) => <String, dynamic>{
  'occupation': instance.occupation,
  'gender': instance.gender,
  'nickName': instance.nickName,
  'weight': instance.weight,
  'height': instance.height,
  'id': instance.id,
  'age': instance.age,
  'location': instance.location,
  'selfIntroduction': instance.selfIntroduction,
  'roomId': instance.roomId,
  'avatar': instance.avatar,
  'realNameAuth': instance.realNameAuth,
  'realPersonAuth': instance.realPersonAuth,
  'userName': instance.userName,
};
