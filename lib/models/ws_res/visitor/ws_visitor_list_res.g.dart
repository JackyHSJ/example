// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ws_visitor_list_res.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WsVisitorListRes _$WsVisitorListResFromJson(Map<String, dynamic> json) =>
    WsVisitorListRes(
        list: (json['list'] as List).map((info) => VisitorInfo.fromJson(info)).toList(),
        fullListSize: json['fullListSize'] as num?,
    );

Map<String, dynamic> _$WsVisitorListResToJson(WsVisitorListRes instance) =>
    <String, dynamic>{
      'list': instance.list,
      'fullListSize': instance.fullListSize
    };

VisitorInfo _$VisitorListFromJson(Map<String, dynamic> json) =>
    VisitorInfo(
      gender: json['gender'] as num?,
      realPersonAuth: json['realPersonAuth'] as num?,
      userName: json['userName'] as String?,
      nickName: json['nickName'] as String?,
      userId: json['userId'] as num?,
      age: json['age'] as num?,
      updateTime: json['updateTime'] as num?,
      avatar: json['avatar'] as String?,
    );

Map<String, dynamic> _$VisitorListToJson(VisitorInfo instance) =>
    <String, dynamic>{
      'gender': instance.gender,
      'realPersonAuth': instance.realPersonAuth,
      'userName': instance.userName,
      'nickName': instance.nickName,
      'userId': instance.userId,
      'age': instance.age,
      'createTime': instance.updateTime,
      'avatar': instance.avatar,
    };