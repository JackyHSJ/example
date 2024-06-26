// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ws_activity_hot_topic_list_res.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WsActivityHotTopicListRes _$WsActivityHotTopicListResFromJson(Map<String, dynamic> json) =>
    WsActivityHotTopicListRes(
      list: (json['list'] as List).map((info) => HotTopicListInfo.fromJson(info)).toList()
    );

Map<String, dynamic> _$WsActivityHotTopicListResToJson(WsActivityHotTopicListRes instance) => 
    <String, dynamic>{
      'list': instance.list
    };


HotTopicListInfo _$HotTopicListInfoFromJson(Map<String, dynamic> json) =>
    HotTopicListInfo(
      topicId: json['topicId'] as num?,
      topicTitle: json['topicTitle'] as String?,
      topicContent: json['topicContent'] as String?,
      topicSeq: json['topicSeq'] as String?,
      topicStatus: json['topicStatus'] as num?,
      createTime: json['createTime'] as num?,
    );

Map<String, dynamic> _$HotTopicListInfoToJson(HotTopicListInfo instance) =>
    <String, dynamic>{
      'topicId': instance.topicId,
      'topicTitle': instance.topicTitle,
      'topicContent': instance.topicContent,
      'topicSeq': instance.topicSeq,
      'topicStatus': instance.topicStatus,
      'createTime': instance.createTime,
    };