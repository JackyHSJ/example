// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ws_contact_search_list_res.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WsContactSearchListRes _$WsContactSearchListResFromJson(Map<String, dynamic> json) =>
    WsContactSearchListRes(
      pageNumber: json['pageNumber'] as num?,
      totalPages: json['totalPages'] as num?,
      fullListSize: json['fullListSize'] as num?,
      pageSize: json['pageSize'] as num?,
      count: json['count'] as num?,
      list: (json['list'] as List).map((info) => ContactListInfo.fromJson(info)).toList(),
    );

Map<String, dynamic> _$WsContactSearchListResToJson(WsContactSearchListRes instance) => 
    <String, dynamic>{
      'pageNumber': instance.pageNumber,
      'totalPages': instance.totalPages,
      'fullListSize': instance.fullListSize,
      'pageSize': instance.pageSize,
      'count': instance.count,
      'list': instance.list,
};

ContactListInfo _$ContactListInfoFromJson(Map<String, dynamic> json) =>
    ContactListInfo(
      avatarPath: json['avatarPath'] as String?,
      nickName: json['nickName'] as String?,
      userName: json['userName'] as String?,
      regTime: json['regTime'] as num?,
      age: json['age'] as num?,
      realPersonAuth: json['realPersonAuth'] as num?,
      selfIntroduction: json['selfIntroduction'] as String?,
      hometown: json['hometown'] as String?,
      height: json['height'] as num?,
      weight: json['weight'] as num?,
      occupation: json['occupation'] as String?,
      gender: json['gender'] as num?,
      realNameAuth: json['realNameAuth'] as num?,
    );

Map<String, dynamic> _$ContactListInfoToJson(ContactListInfo instance) =>
    <String, dynamic>{
      'avatarPath': instance.avatarPath,
      'nickName': instance.nickName,
      'userName': instance.userName,
      'regTime': instance.regTime,
      'age': instance.age,
      'realPersonAuth': instance.realPersonAuth,
      'selfIntroduction': instance.selfIntroduction,
      'hometown': instance.hometown,
      'height': instance.height,
      'weight': instance.weight,
      'occupation': instance.occupation,
      'gender': instance.gender,
      'realNameAuth': instance.realNameAuth,
};