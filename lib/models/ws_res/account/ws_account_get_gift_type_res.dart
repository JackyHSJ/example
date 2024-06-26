
import 'package:flutter/cupertino.dart';
import 'package:json_annotation/json_annotation.dart';

part 'ws_account_get_gift_type_res.g.dart';

@JsonSerializable()
class WsAccountGetGiftTypeRes {
  WsAccountGetGiftTypeRes({
    this.giftCategoryList
  });

  @JsonKey(name: 'giftCategoryList')
  final List<GiftCategoryInfo>? giftCategoryList;

  factory WsAccountGetGiftTypeRes.fromJson(Map<String, dynamic> json) =>
      _$WsAccountGetGiftTypeResFromJson(json);
  Map<String, dynamic> toJson() => _$WsAccountGetGiftTypeResToJson(this);
}


@JsonSerializable()
class GiftCategoryInfo {
  GiftCategoryInfo({
    this.id,
    this.codeName,
    this.keyName,
    this.createTime,
    this.status,
    this.seq,
  });

  @JsonKey(name: 'id')
  final num? id;

  /// 代碼名稱："禮物77"
  @JsonKey(name: 'codeName')
  final String? codeName;

  /// 鍵名："giftType"
  @JsonKey(name: 'keyName')
  final String? keyName;

  /// 創建時間（毫秒數）：1690514457737
  @JsonKey(name: 'createTime')
  final num? createTime;

  /// 狀態：0
  @JsonKey(name: 'status')
  final num? status;

  /// 序號：3
  @JsonKey(name: 'seq')
  final num? seq;

  factory GiftCategoryInfo.fromJson(Map<String, dynamic> json) =>
      _$GiftCategoryInfoFromJson(json);
  Map<String, dynamic> toJson() => _$GiftCategoryInfoToJson(this);
}