// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ws_hand_shake_res.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WsHandShakeRes _$WsHandShakeResFromJson(Map<String, dynamic> json) => WsHandShakeRes(
  sysConfig: SysConfigInfo.fromJson(json['sysConfig']),
  list: (json['list'] == null) ? HandShakeList() : HandShakeList.fromJson(json['list']),
  buttonConfig: ButtonConfigList.fromJson(json['buttonConfig']),
  myVisitorExpireTime: json['myVisitorExpireTime'] as num?,
  orderComputeCondition: json['orderComputeCondition'] == null ? OrderComputeConditionInfo() : OrderComputeConditionInfo.fromJson(json['orderComputeCondition']),
);

Map<String, dynamic> _$WsHandShakeResToJson(WsHandShakeRes instance) => <String, dynamic>{
  'sysConfig': instance.sysConfig,
  'list': instance.list,
  'buttonConfig': instance.buttonConfig,
  'myVisitorExpireTime': instance.myVisitorExpireTime,
};

ButtonConfigList _$ButtonConfigListFromJson(Map<String, dynamic> json) => ButtonConfigList(
  callType: json['1'] as num?,
  officialType: json['2'] as num?,
  intimacyType: json['3'] as num?,
  tvWallType: json['4'] as num?,
  mateType: json['5'] as num?,
  withdrawType: json['6'] as num?,
  type7: json['7'] as num?,
  activityType: json['8'] as num?,
  gmType: json['9'] as num?,
  blockType: json['10'] as num?,
);

Map<String, dynamic> _$ButtonConfigListToJson(ButtonConfigList instance) => <String, dynamic>{
  '1': instance.callType,
  '2': instance.officialType,
  '3': instance.intimacyType,
  '4': instance.tvWallType,
  '5': instance.mateType,
  '6': instance.withdrawType,
  '7': instance.type7,
  '8': instance.activityType,
  '9': instance.gmType,
  '10': instance.blockType,
};

SysConfigInfo _$SysConfigInfoFromJson(Map<String, dynamic> json) => SysConfigInfo(
  fileUrl: json['fileUrl'] as String?,
);

Map<String, dynamic> _$SysConfigInfoToJson(SysConfigInfo instance) => <String, dynamic>{
  'fileUrl': instance.fileUrl,
};

HandShakeList _$HandShakeListFromJson(Map<String, dynamic> json) => HandShakeList(
  remark: json['remark'] as String?,
);

Map<String, dynamic> _$HandShakeListToJson(HandShakeList instance) => <String, dynamic>{
  'remark': instance.remark,
};

OrderComputeConditionInfo _$OrderComputeConditionInfoFromJson(Map<String, dynamic> json) => OrderComputeConditionInfo(
  onlineDuration: json['onlineDuration'] as num?,
  regTimeLimit: json['regTimeLimit'] as num?,
  pickupCount: json['pickupCount'] as num?,
);

Map<String, dynamic> _$OrderComputeConditionInfoToJson(OrderComputeConditionInfo instance) => <String, dynamic>{
  'onlineDuration': instance.onlineDuration,
  'regTimeLimit': instance.regTimeLimit,
  'pickupCount': instance.pickupCount,
};