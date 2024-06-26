// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ws_account_call_verification_res.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WsAccountCallVerificationRes _$WsAccountCallVerificationResFromJson(Map<String, dynamic> json) => WsAccountCallVerificationRes(
    chatStatus: json['chatStatus'] as num?,
    cost: json['cost'] as num?,
    remainCoins: json['remainCoins'] as num?,
    call: CallVerificationInfo.fromJson(json['call']), // json['call'] as num?,
    remainTimes: json['remainTimes'] as num?,
);

Map<String, dynamic> _$WsAccountCallVerificationResToJson(WsAccountCallVerificationRes instance) => <String, dynamic>{
    'chatStatus': instance.chatStatus,
    'cost': instance.cost,
    'remainCoins': instance.remainCoins,
    'call': instance.call,
    'remainTimes': instance.remainTimes,
};

CallVerificationInfo _$CallVerificationInfoFromJson(Map<String, dynamic> json) => CallVerificationInfo(
    uid: json['uid'] as String?,
    answerUid: json['answerUid'] as String?,
    rtcToken: json['rtcToken'] as String?,
    appId: json['appId'] as String?,
    channel: json['channel'] as String?,
);

Map<String, dynamic> _$CallVerificationInfoToJson(CallVerificationInfo instance) => <String, dynamic>{
    'uid': instance.uid,
    'answerUid': instance.answerUid,
    'rtcToken': instance.rtcToken,
    'appId': instance.appId,
    'channel': instance.channel,
};
