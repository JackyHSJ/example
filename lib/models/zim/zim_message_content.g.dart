// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'zim_message_content.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ZimMessageContent _$ZimMessageContentFromJson(Map<String, dynamic> json) =>
    ZimMessageContent(
      uuid: json['uuid'] as String,
      type: json['type'] as num,
      giftId: json['giftId'] as String,
      giftCount: json['giftCount'] as String,
      giftUrl: json['giftUrl'] as String,
      giftName: json['giftName'] as String,
      content: json['content'] as String,
    );

Map<String, dynamic> _$ZimMessageContentToJson(ZimMessageContent instance) =>
    <String, dynamic>{
      'uuid': instance.uuid,
      'type': instance.type,
      'giftId': instance.giftId,
      'giftCount': instance.giftCount,
      'giftUrl': instance.giftUrl,
      'giftName': instance.giftName,
      'content': instance.content,
    };
