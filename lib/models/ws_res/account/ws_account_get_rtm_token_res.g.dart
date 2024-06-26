// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ws_account_get_rtm_token_res.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WsAccountGetRTMTokenRes _$WsAccountGetRTMTokenResFromJson(Map<String, dynamic> json) => WsAccountGetRTMTokenRes(
  uid: json['uid'] as String?,
  rtcToken: json['rtcToken'] as String?,
  appId: json['appId'] as String?,
);

Map<String, dynamic> _$WsAccountGetRTMTokenResToJson(WsAccountGetRTMTokenRes instance) => <String, dynamic>{
  'uid' : instance.uid,
  'rtcToken' : instance.rtcToken,
  'appId' : instance.appId,
};
