
import 'package:flutter/cupertino.dart';
import 'package:json_annotation/json_annotation.dart';

part 'ws_account_on_tv_res.g.dart';

@JsonSerializable()
class WsAccountOnTVRes {
  WsAccountOnTVRes({
    this.giftName,
    this.amount,
    this.duration,
    this.fromUserNickName,
    this.toUserNickName,
    this.charmLevel,
    this.fromUserAvatar,
    this.toUserAvatar,
    this.fromUserGender,
    this.toUserGender,
  });

  /// 禮物名稱
  @JsonKey(name: 'giftName')
  String? giftName;

  /// 禮物數量
  @JsonKey(name: 'amount')
  num? amount;

  /// 鎖定時間(秒)
  @JsonKey(name: 'duration')
  num? duration;

  /// 贈禮用戶
  @JsonKey(name: 'fromUserNickName')
  String? fromUserNickName;

  /// 收禮用戶
  @JsonKey(name: 'toUserNickName')
  String? toUserNickName;

  /// 魅力值等級(1,2,3,4...)
  @JsonKey(name: 'charmLevel')
  num? charmLevel;

  /// 送礼者头像
  @JsonKey(name: 'fromUserAvatar')
  String? fromUserAvatar;

  /// 接收礼物者头像
  @JsonKey(name: 'toUserAvatar')
  String? toUserAvatar;

  /// 送礼者性别
  @JsonKey(name: 'fromUserGender')
  int? fromUserGender;

  /// 接收礼物者性别
  @JsonKey(name: 'toUserGender')
  int? toUserGender;

  factory WsAccountOnTVRes.fromJson(Map<String, dynamic> json) =>
      _$WsAccountOnTVResFromJson(json);
  Map<String, dynamic> toJson() => _$WsAccountOnTVResToJson(this);
}