// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'greet_module_edit_req.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GreetModuleEditReq _$GreetModuleEditReqFromJson(Map<String, dynamic> json) =>
    GreetModuleEditReq(
      tId: json['tId'] as String,
      id: json['id'] as num?,
      greetingPic: json['greetingPic'] as File?,
      greetingAudio: json['greetingAudio'] as File?,
      greetingText: json['greetingText'] as String?,
      greetingAudioLength: json['greetingAudioLength'] as num?,
    );

Map<String, dynamic> _$GreetModuleEditReqToJson(GreetModuleEditReq instance) =>
    <String, dynamic>{
      'tId': instance.tId,
      'id': instance.id,
      'greetingPic': instance.greetingPic,
      'greetingAudio': instance.greetingAudio,
      'greetingText': instance.greetingText,
      'greetingAudioLength': instance.greetingAudioLength,
    };
