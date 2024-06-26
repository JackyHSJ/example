// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'base_res.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BaseRes _$BaseResFromJson(Map<String, dynamic> json) => BaseRes(
      resultCode: json['resultCode'] as String,
      msg: json['msg'] as String?,
      resultMap: json['resultMap'] as dynamic,
      resultMsg: json['resultMsg'] as dynamic,
      f: json['f'] as String?,
      uuId: json['uuId'] as String?,
      createTime: json['createTime'] as num?,
      content: json['content'] as String?,
      contentType: json['contentType'] as dynamic,
    );

Map<String, dynamic> _$BaseResToJson(BaseRes instance) => <String, dynamic>{
      'resultCode': instance.resultCode,
      'msg': instance.msg,
      'resultMap': instance.resultMap,
      'resultMsg': instance.resultMsg,
      'f': instance.f,
      'uuId': instance.uuId,
      'createTime': instance.createTime,
      'content': instance.content,
      'contentType': instance.contentType,
    };
