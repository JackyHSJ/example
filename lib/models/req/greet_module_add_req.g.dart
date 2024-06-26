// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'greet_module_add_req.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GreetModuleAddReq _$GreetModuleAddReqFromJson(Map<String, dynamic> json) =>
    GreetModuleAddReq(
      tId: json['tId'] as String,
      modelName: json['modelName'] as String?,
      greetingPic: json['greetingPic'] as File?,
      greetingAudio: json['greetingAudio'] as File?,
      greetingText: json['greetingText'] as String?,
      greetingAudioLength: json['greetingAudioLength'] as num?,
    );

Map<String, dynamic> _$GreetModuleAddReqToJson(GreetModuleAddReq instance) =>
    <String, dynamic>{
      'tId': instance.tId,
      'modelName': instance.modelName,
      'greetingPic': instance.greetingPic,
      'greetingAudio': instance.greetingAudio,
      'greetingText': instance.greetingText,
      'greetingAudioLength': instance.greetingAudioLength,
    };
