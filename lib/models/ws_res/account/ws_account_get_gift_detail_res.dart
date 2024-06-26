
import 'package:flutter/cupertino.dart';
import 'package:json_annotation/json_annotation.dart';

part 'ws_account_get_gift_detail_res.g.dart';

@JsonSerializable()
class WsAccountGetGiftDetailRes {
  WsAccountGetGiftDetailRes({
    this.giftList
  });

  @JsonKey(name: 'giftList')
  final List<GiftListInfo>? giftList;

  factory WsAccountGetGiftDetailRes.fromJson(Map<String, dynamic> json) =>
      _$WsAccountGetGiftDetailResFromJson(json);
  Map<String, dynamic> toJson() => _$WsAccountGetGiftDetailResToJson(this);
}

@JsonSerializable()
class GiftListInfo {
  GiftListInfo({
    this.giftSideImageUrl,
    this.coins,
    this.giftName,
    this.giftBannerUrl,
    this.categoryName,
    this.giftImageUrl,
    this.activity_link,
    this.giftId,
    this.giftSendAmount,
    this.giftImageId,
    this.giftSideImageWidth,
    this.giftSideImageHeight,
    this.categoryId,
    this.seq,
    this.giftBannerId,
    this.giftSideImageId,
    this.svgaFileId,
    this.svgaUrl,
    this.giftType,
  });

  /// 禮物側面圖像的URL："gift/2/giftSideImage1690886301.png"
  @JsonKey(name: 'giftSideImageUrl')
  final String? giftSideImageUrl;

  /// 硬幣數：23.0
  @JsonKey(name: 'coins')
  final num? coins;

  /// 禮物名稱："測試99"
  @JsonKey(name: 'giftName')
  final String? giftName;

  /// 禮物橫幅圖像的URL："gift/3/giftBanner1690886301.png"
  @JsonKey(name: 'giftBannerUrl')
  final String? giftBannerUrl;

  /// 分類名稱："限時專場"
  @JsonKey(name: 'categoryName')
  final String? categoryName;

  /// 禮物圖像的URL："gift/1/giftImage1690886535.jpg"
  @JsonKey(name: 'giftImageUrl')
  final String? giftImageUrl;

  /// 活動連結：""
  @JsonKey(name: 'activity_link')
  final String? activity_link;

  /// 禮物 ID：99
  @JsonKey(name: 'giftId')
  final num? giftId;

  /// 禮物送出數量：0  @JsonKey(name: 'giftSendAmount')
  @JsonKey(name: 'giftSendAmount')
  final num? giftSendAmount;

  /// 禮物側面圖像 ID：1645
  @JsonKey(name: 'giftSideImageId')
  final num? giftSideImageId;

  /// 禮物圖像 ID：1653
  @JsonKey(name: 'giftSideImageUrl')
  final num? giftImageId;

  /// 禮物側面圖像寬度：5.0
  @JsonKey(name: 'giftSideImageWidth')
  final num? giftSideImageWidth;

  /// 禮物側面圖像高度：5.0
  @JsonKey(name: 'giftSideImageHeight')
  final num? giftSideImageHeight;

  /// 分類 ID：3
  @JsonKey(name: 'categoryId')
  final num? categoryId;

  /// 序號：0
  @JsonKey(name: 'seq')
  final num? seq;

  /// 禮物橫幅圖像 ID：1646
  @JsonKey(name: 'giftBannerId')
  final num? giftBannerId;

  ///
  @JsonKey(name: 'svgaFileId')
  final num? svgaFileId;

  ///
  @JsonKey(name: 'svgaUrl')
  final String? svgaUrl;

  /// 禮物的來源  0:一般 ， 1:背包
  @JsonKey(name: 'giftType')
  final num? giftType;

  factory GiftListInfo.fromJson(Map<String, dynamic> json) =>
      _$GiftListInfoFromJson(json);
  Map<String, dynamic> toJson() => _$GiftListInfoToJson(this);
}