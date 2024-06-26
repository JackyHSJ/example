// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'add_activity_post_req.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AddActivityPostReq _$AddActivityPostReqFromJson(Map<String, dynamic> json) =>
    AddActivityPostReq(
      tId: json['tId'] as String,
      files: json['files'] as List<File>?,
      type: json['type'] as String?,
      content: json['content'] as String?,
      userLocation: json['userLocation'] as String?,
      topicId: json['topicId'] as num?,
    );

Map<String, dynamic> _$AddActivityPostReqToJson(AddActivityPostReq instance) =>
    <String, dynamic>{
      'tId': instance.tId,
      'files': instance.files,
      'type': instance.type,
      'content': instance.content,
      'userLocation': instance.userLocation,
      'topicId': instance.topicId,
    };
