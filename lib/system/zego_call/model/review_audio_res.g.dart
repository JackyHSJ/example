// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'review_audio_res.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReviewAudioRes _$ReviewAudioResFromJson(Map<String, dynamic> json) => ReviewAudioRes(
  file_name: json['file_name'] as String?,
  download_url: json['download_url'] as String?,
  file_size: json['file_size'] as String?,
  md5: json['md5'] as String?,
  audioTime: json['audioTime'] as num?,
  reviewResult: json['reviewResult'] as bool?,
);

Map<String, dynamic> _$ReviewAudioResToJson(ReviewAudioRes instance) => <String, dynamic>{
  'file_name': instance.file_name,
  'download_url': instance.download_url,
  'file_size': instance.file_size,
  'md5': instance.md5,
  'reviewResult': instance.reviewResult,
  'audioTime':instance.audioTime,
};
