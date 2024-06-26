// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ws_account_get_rtc_token_res.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WsAccountGetRTCTokenRes _$WsAccountGetRTCTokenResFromJson(Map<String, dynamic> json) => WsAccountGetRTCTokenRes(
    answer: GetRTCAnswerInfo.fromJson(json['answer']),
);

Map<String, dynamic> _$WsAccountGetRTCTokenResToJson(WsAccountGetRTCTokenRes instance) => <String, dynamic>{
  'answer': instance.answer,
};

GetRTCAnswerInfo _$GetRTCAnswerInfoFromJson(Map<String, dynamic> json) => GetRTCAnswerInfo(
  uid: json['uid'] as String?,
  rtcToken: json['rtcToken'] as String?,
  appId: json['appId'] as String?,
  channel: json['channel'] as String?,
);

Map<String, dynamic> _$GetRTCAnswerInfoToJson(GetRTCAnswerInfo instance) => <String, dynamic>{
  'uid': instance.uid,
  'rtcToken': instance.rtcToken,
  'appId': instance.appId,
  'channel': instance.channel,
};
