// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ws_base_res.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WsBaseRes _$WsBaseResFromJson(Map<String, dynamic> json) => WsBaseRes(
      resultCode: json['resultCode'] as String?,
      resultMsg: json['resultMsg'] as String?,
      resultMap: json['resultMap'] as dynamic,
      f: json['f'] as String?,
      rId: json['rId'] as String?
    );

Map<String, dynamic> _$WsBaseResToJson(WsBaseRes instance) => <String, dynamic>{
      'resultCode': instance.resultCode,
      'resultMsg': instance.resultMsg,
      'resultMap': instance.resultMap,
      'f': instance.f,
      'rId': instance.rId
    };
