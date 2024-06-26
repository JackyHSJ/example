// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ws_member_fate_recommend_res.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WsMemberFateRecommendRes _$WsMemberFateRecommendResFromJson(Map<String, dynamic> json) =>
    WsMemberFateRecommendRes(
      pageNumber: json['pageNumber'] as num?,
      totalPages: json['totalPages'] as num?,
      fullListSize: json['fullListSize'] as num?,
      pageSize: json['pageSize'] as num?,
      list: (json['list'] as List).map((info) => FateListInfo.fromJson(info)).toList(),
      topList: (json['topList'] as List?)?.map((info) => FateListInfo.fromJson(info)).toList(),
      orderSeq: json['orderSeq'] as num?,
      topListPage: json['topListPage'] as num?
    );

Map<String, dynamic> _$WsMemberFateRecommendResToJson(WsMemberFateRecommendRes instance) =>
    <String, dynamic>{
      'pageNumber': instance.pageNumber,
      'totalPages': instance.totalPages,
      'fullListSize': instance.fullListSize,
      'pageSize': instance.pageSize,
      'list': instance.list,
      'topList': instance.topList,
      'orderSeq': instance.orderSeq,
      'topListPage': instance.topListPage,
    };

FateListInfo _$FateListInfoFromJson(Map<String, dynamic> json) =>
    FateListInfo(
          id: json['id'] as num?,
          age: json['age'] as num?,
          occupation: json['occupation'] as String?,
          nickName: json['nickName'] as String?,
          userName: json['userName'] as String?,
          weight: json['weight'] as num?,
          height: json['height'] as num?,
          selfIntroduction: json['selfIntroduction'] as String?,
          isOnline: json['isOnline'] as int?,
          roomId: json['roomId'] as int?,
          location: json['location'] as String?,
          realPersonAuth: json['realPersonAuth'] as num?,
          realNameAuth: json['realNameAuth'] as num?,
          avatar: json['avatar'] as String?,
          hometown: json['hometown'] as String?,
          gender: json['gender'] as num?

    );

Map<String, dynamic> _$FateListInfoToJson(FateListInfo instance) =>
    <String, dynamic>{
          'id': instance.id,
          'age': instance.age,
          'occupation': instance.occupation,
          'nickName': instance.nickName,
          'userName': instance.userName,
          'weight': instance.weight,
          'height': instance.height,
          'selfIntroduction': instance.selfIntroduction,
          'isOnline': instance.isOnline,
          'roomId': instance.roomId,
          'location': instance.location,
          'realPersonAuth': instance.realPersonAuth,
          'realNameAuth': instance.realNameAuth,
          'avatar': instance.avatar,
          'gender': instance.gender,
          'hometown': instance.hometown,

    };