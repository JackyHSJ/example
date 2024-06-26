// GENERATED CODE - DO NOT MODIFY BY HAND


part of 'ws_greet_module_list_res.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WsGreetModuleListRes _$WsGreetModuleListResFromJson(Map<String, dynamic> json) =>
    WsGreetModuleListRes(
      list: (json['list'] as List).map((info) => GreetModuleInfo.fromJson(info)).toList()
    );

Map<String, dynamic> _$WsGreetModuleListResToJson(WsGreetModuleListRes instance) =>
    <String, dynamic>{
        'list': instance.list
    };

GreetModuleInfo _$GreetModuleInfoFromJson(Map<String, dynamic> json) =>
    GreetModuleInfo(
        createTime: json['createTime'] as num?,
        updateTime: json['updateTime'] as num?,
        id: json['id'] as num?,
        modelName: json['modelName'] as String?,
        greetingText: json['greetingText'] as String?,
        greetingPic: json['greetingPic'] as String?,
        greetingAudio: json['greetingAudio'] as dynamic ,
        status: json['status'] as num?,
        userId: json['userId'] as num?,
    );

Map<String, dynamic> _$GreetModuleInfoToJson(GreetModuleInfo instance) =>
    <String, dynamic>{
        'createTime': instance.createTime,
        'updateTime': instance.updateTime,
        'id': instance.id,
        'modelName': instance.modelName,
        'greetingText': instance.greetingText,
        'greetingPic': instance.greetingPic,
        'greetingAudio': instance.greetingAudio,
        'status': instance.status,
        'userId': instance.userId,
    };

GreetModuleInfoAudio _$GreetModuleInfoAudioFromJson(Map<String, dynamic> json) =>
    GreetModuleInfoAudio(
            filePath: json['filePath'] as String?,
            length: json['length'] as num?,
    );

Map<String, dynamic> _$GreetModuleInfoAudioToJson(GreetModuleInfoAudio instance) =>
    <String, dynamic>{
            'filePath': instance.filePath,
            'length': instance.length,
    };
