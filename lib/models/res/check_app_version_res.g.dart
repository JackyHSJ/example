// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'check_app_version_res.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CheckAppVersionRes _$CheckAppVersionResFromJson(Map<String, dynamic> json) =>
    CheckAppVersionRes(
      appVersion: json['appVersion'] !=null? json['appVersion']as String : '',
      downloadLink: json['downloadLink'] !=null?json['downloadLink'] as String:'',
      updateDescription: json['updateDescription'] !=null?json['updateDescription'] as String:'',
    );

Map<String, dynamic> _$CheckAppVersionResToJson(CheckAppVersionRes instance) =>
    <String, dynamic>{
      'appVersion': instance.appVersion,
      'downloadLink': instance.downloadLink,
      'updateDescription': instance.updateDescription,
    };
