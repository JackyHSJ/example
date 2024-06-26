// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ws_base_req.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WsBaseReq _$WsBaseReqFromJson(Map<String, dynamic> json) =>
    WsBaseReq(
      f: json['f'] as String,
      tId: json['tId'] as String,
      msg: json['msg'] as dynamic,
      rId: json['rId'] as String?,
    );

Map<String, dynamic> _$WsBaseReqToJson(WsBaseReq instance) =>
    <String, dynamic>{
      'f': instance.f,
      'tId': instance.tId,
      'msg': instance.msg,
      'rId': instance.rId,
    };
