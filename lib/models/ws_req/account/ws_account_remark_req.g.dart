// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ws_account_remark_req.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WsAccountRemarkReq _$WsAccountRemarkReqFromJson(Map<String, dynamic> json) =>
    WsAccountRemarkReq(
      friendId: json['friendId'] as num?,
      remark: json['remark'] as String?
    );

Map<String, dynamic> _$WsAccountRemarkReqToJson(WsAccountRemarkReq instance) =>
    <String, dynamic>{
      'friendId': instance.friendId,
      'remark': instance.remark,
    };
