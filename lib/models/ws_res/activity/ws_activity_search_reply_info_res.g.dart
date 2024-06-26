// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ws_activity_search_reply_info_res.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WsActivitySearchReplyInfoRes _$WsActivitySearchReplyInfoResFromJson(Map<String, dynamic> json) =>
    WsActivitySearchReplyInfoRes(
      list: (json['list'] as List).map((info) => ActivityReplyInfo.fromJson(info)).toList()
    );

Map<String, dynamic> _$WsActivitySearchReplyInfoResToJson(WsActivitySearchReplyInfoRes instance) => 
    <String, dynamic>{
      'list': instance.list
    };

ActivityReplyInfo _$ActivityReplyInfoFromJson(Map<String, dynamic> json) =>
    ActivityReplyInfo(
      gender: json['gender'] as num?,
      realPersonAuth: json['realPersonAuth'] as num?,
      userName: json['userName'] as String?,
      likesCount: json['likesCount'] as num?,
      replyCount: json['replyCount'] as num?,
      nickName: json['nickName'] as String?,
      id: json['id'] as num?,
      age: json['age'] as num?,
      status: json['status'] as num?,
      createTime: json['createTime'] as num?,
      content: json['content'] as String?,
      avatar: json['avatar'] as String?,
      replyId: json['replyId'] as num?,
      userId: json['userId'] as num?,
    );

Map<String, dynamic> _$ActivityReplyInfoToJson(ActivityReplyInfo instance) =>
    <String, dynamic>{
      'gender': instance.gender,
      'realPersonAuth': instance.realPersonAuth,
      'userName': instance.userName,
      'likesCount': instance.likesCount,
      'replyCount': instance.replyCount,
      'nickName': instance.nickName,
      'id': instance.id,
      'age': instance.age,
      'status': instance.status,
      'content': instance.content,
      'createTime': instance.createTime,
      'avatar': instance.avatar,
      'replyId': instance.replyId,
      'userId': instance.userId,
    };