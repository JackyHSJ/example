
import 'package:flutter/cupertino.dart';
import 'package:frechat/system/deeplink/openinstall/openinstall_handler.dart';
import 'package:json_annotation/json_annotation.dart';

part 'ws_hand_shake_res.g.dart';

@JsonSerializable()
class WsHandShakeRes {
  WsHandShakeRes({
    this.sysConfig,
    this.list,
    this.buttonConfig,
    this.myVisitorExpireTime,
    this.orderComputeCondition,
  });

  @JsonKey(name: 'sysConfig')
  final SysConfigInfo? sysConfig;

  @JsonKey(name: 'list')
  final HandShakeList? list;

  @JsonKey(name: 'buttonConfig')
  final ButtonConfigList? buttonConfig;

  @JsonKey(name: 'myVisitorExpireTime')
  final num? myVisitorExpireTime;

  @JsonKey(name: 'orderComputeCondition')
  final OrderComputeConditionInfo? orderComputeCondition;

  factory WsHandShakeRes.fromJson(Map<String, dynamic> json) =>
      _$WsHandShakeResFromJson(json);
  Map<String, dynamic> toJson() => _$WsHandShakeResToJson(this);
}

@JsonSerializable()
class SysConfigInfo {
  SysConfigInfo({
    this.fileUrl,
  });

  @JsonKey(name: 'fileUrl')
  final String? fileUrl;

  factory SysConfigInfo.fromJson(Map<String, dynamic> json) =>
      _$SysConfigInfoFromJson(json);
  Map<String, dynamic> toJson() => _$SysConfigInfoToJson(this);
}

@JsonSerializable()
class ButtonConfigList {
  ButtonConfigList({
    this.callType,
    this.officialType,
    this.intimacyType,
    this.tvWallType,
    this.mateType,
    this.withdrawType,
    this.type7,
    this.activityType,
    this.gmType,
    this.blockType,
  });
  /// 1:通话
  @JsonKey(name: '1')
  final num? callType;
  /// 2:官方消息
  @JsonKey(name: '2')
  final num? officialType;
  /// 3:亲密度
  @JsonKey(name: '3')
  final num? intimacyType;
  /// 4:电视墙
  @JsonKey(name: '4')
  final num? tvWallType;
  /// 5:速配
  @JsonKey(name: '5')
  final num? mateType;
  /// 6:提现
  @JsonKey(name: '6')
  final num? withdrawType;
  /// ??
  @JsonKey(name: '7')
  final num? type7;
  /// 8:活动播送
  @JsonKey(name: '8')
  final num? activityType;
  /// 9:超管(超级管理员)
  @JsonKey(name: '9')
  final num? gmType;
  /// 10:注冊即黑名单(消息屏蔽) 與 審核中
  @JsonKey(name: '10')
  final num? blockType;

  factory ButtonConfigList.fromJson(Map<String, dynamic> json) =>
      _$ButtonConfigListFromJson(json);
  Map<String, dynamic> toJson() => _$ButtonConfigListToJson(this);
}

@JsonSerializable()
class HandShakeList {
  HandShakeList({
    this.remark,
  });

  @JsonKey(name: 'remark')
  final String? remark;

  factory HandShakeList.fromJson(Map<String, dynamic> json) =>
      _$HandShakeListFromJson(json);
  Map<String, dynamic> toJson() => _$HandShakeListToJson(this);
}

@JsonSerializable()
class OrderComputeConditionInfo {
  OrderComputeConditionInfo({
    this.onlineDuration,
    this.regTimeLimit,
    this.pickupCount,
});

  @JsonKey(name: 'onlineDuration')
  final num? onlineDuration;

  @JsonKey(name: 'regTimeLimit')
  final num? regTimeLimit;

  @JsonKey(name: 'pickupCount')
  final num? pickupCount;

  factory OrderComputeConditionInfo.fromJson(Map<String, dynamic> json) =>
      _$OrderComputeConditionInfoFromJson(json);
  Map<String, dynamic> toJson() => _$OrderComputeConditionInfoToJson(this);
}