// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ws_activity_search_info_res.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WsActivitySearchInfoRes _$WsActivitySearchInfoResFromJson(Map<String, dynamic> json) =>
    WsActivitySearchInfoRes(
      likeList: json['likeList'] as List<dynamic>?,
      pageNumber: json['pageNumber'] as num?,
      totalPages: json['totalPages'] as num?,
      fullListSize: json['fullListSize'] as num?,
      list: json['list'] == null ? [] : (json['list'] as List).map((info) => ActivityPostInfo.fromJson(info)).toList(),
      hotTopicList: json['hotTopicList'] == null ? [] : (json['hotTopicList'] as List).map((info) => HotTopicListInfo.fromJson(info)).toList(),
      type: json['type'] as WsActivitySearchInfoType?,

    );

Map<String, dynamic> _$WsActivitySearchInfoResToJson(WsActivitySearchInfoRes instance) => 
    <String, dynamic>{
      'likeList': instance.likeList,
      'pageNumber': instance.pageNumber,
      'totalPages': instance.totalPages,
      'fullListSize': instance.fullListSize,
      'list': instance.list,
       'hotTopicList':instance.hotTopicList,
       'type':instance.type,
    };

ActivityPostInfo _$ActivityPostInfoFromJson(Map<String, dynamic> json) =>
    ActivityPostInfo(
      gender: json['gender'] as num?,
      userLocation: json['userLocation'] as String?,
      userName: json['userName'] as String?,
      likesCount: json['likesCount'] as num?,
      contentUrl: json['contentUrl'] as String?,
      topicId: json['topicId'] as num?,
      replyCount: json['replyCount'] as num?,
      createTime: json['createTime'] as num?,
      nickName: json['nickName'] as String?,
      id: json['id'] as num?,
      age: json['age'] as num?,
      status: json['status'] as num?,
      content: json['content'] as String?,
      avatar: json['avatar'] as String?,
      type: json['type'] as num?,
      userId: json['userId'] as num?,
      topicTitle: json['topicTitle'] as String?,
      contentLocalUrl: json['contentLocalUrl'] as String?,

    );

Map<String, dynamic> _$ActivityPostInfoToJson(ActivityPostInfo instance) =>
    <String, dynamic>{
      'gender': instance.gender,
      'userLocation': instance.userLocation,
      'userName': instance.userName,
      'likesCount': instance.likesCount,
      'contentUrl': instance.contentUrl,
      'topicId': instance.topicId,
      'replyCount': instance.replyCount,
      'createTime': instance.createTime,
      'nickName': instance.nickName,
      'id': instance.id,
      'age': instance.age,
      'status': instance.status,
      'content': instance.content,
      'avatar': instance.avatar,
      'type': instance.type,
      'userId': instance.userId,
      'topicTitle':instance.topicTitle,
       'contentLocalUrl':instance.contentLocalUrl,
    };