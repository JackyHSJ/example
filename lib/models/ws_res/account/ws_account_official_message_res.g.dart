// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ws_account_official_message_res.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WsAccountOfficialMessageRes _$WsAccountOfficialMessageResFromJson(Map<String, dynamic> json) => WsAccountOfficialMessageRes(
  message: json['message'] as dynamic,
  status: json['status'] as num?,
  type: json['type'] as num?,
  lockStatus: json['lockStatus'] as num?,
  lockTime: json['lockTime'] as num?,
);

Map<String, dynamic> _$WsAccountOfficialMessageResToJson(WsAccountOfficialMessageRes instance) => <String, dynamic>{
  'message': instance.message,
  'status': instance.status,
  'type': instance.type,
  'lockStatus': instance.lockStatus,
  'lockTime': instance.lockTime,
};

OfficialMessageInfo _$OfficialMessageInfoFromJson(Map<String, dynamic> json) => OfficialMessageInfo(
  coins: json['coins'] as num?,
  points: json['points'] as num?,
  duration: json['duration'] as num?,
  chatType: json['chatType'] as num?,
  type: json['type'] as num?,
  caller: json['caller'] as String?,
  answer: json['answer'] as String?,
);

Map<String, dynamic> _$OfficialMessageInfoToJson(OfficialMessageInfo instance) => <String, dynamic>{
  'coins': instance.coins,
  'points': instance.points,
  'duration': instance.duration,
  'chatType': instance.chatType,
  'type': instance.type,
  'caller': instance.caller,
  'answer': instance.answer,
};
