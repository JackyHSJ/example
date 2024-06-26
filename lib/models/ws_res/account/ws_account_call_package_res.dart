
import 'package:flutter/cupertino.dart';
import 'package:json_annotation/json_annotation.dart';

part 'ws_account_call_package_res.g.dart';

// 3-93
@JsonSerializable()
class WsAccountCallPackageRes {
  WsAccountCallPackageRes({
    this.freBackPackList,
  });

  @JsonKey(name: 'freBackPackList')
  final List<FreBackPackListInfo>? freBackPackList;

  factory WsAccountCallPackageRes.fromJson(Map<String, dynamic> json) =>
      _$WsAccountCallPackageResFromJson(json);
  Map<String, dynamic> toJson() => _$WsAccountCallPackageResToJson(this);
}

@JsonSerializable()
class FreBackPackListInfo {
  FreBackPackListInfo({
    this.id,
    this.codeName,
    this.createTime,
    this.status,
    this.quantity,
    this.giftSideImageUrl,
    this.coins,
    this.giftName,
    this.codeMapId,
    this.giftBannerUrl,
    this.userId,
    this.giftImageUrl,
    this.receiveTime,
    this.giftId,
    this.giftSendAmount,
    this.svgaUrl,
    this.giftSideImageId,
    this.backPackId,
    this.giftImageId,
    this.giftSideImageHeight,
    this.activityLink,
    this.giftSideImageWidth,
    this.receiveType,
    this.seq,
    this.giftBannerId,
    this.svgaFileId,
  });

  /// 禮物的 ID
  @JsonKey(name: 'id')
  final num? id;

  /// 禮物的代碼名稱
  @JsonKey(name: 'codeName')
  final String? codeName;

  /// 禮物的創建時間（毫秒數）
  @JsonKey(name: 'createTime')
  final num? createTime;

  /// 禮物的狀態
  @JsonKey(name: 'status')
  final num? status;

  /// 數量：9
  @JsonKey(name: 'quantity')
  final num? quantity;

  /// 禮物側面圖像的URL："gift/2/giftSideImage1691158142.png"
  @JsonKey(name: 'giftSideImageUrl')
  final String? giftSideImageUrl;

  /// 硬幣數：11111.00
  @JsonKey(name: 'coins')
  final num? coins;

  /// 禮物名稱："有趣禮物12345888321312"
  @JsonKey(name: 'giftName')
  final String? giftName;

  /// 禮物類別 ID：4
  @JsonKey(name: 'codeMapId')
  final num? codeMapId;

  /// 禮物橫幅圖像的URL："gift/3/giftBanner1691158142.png"
  @JsonKey(name: 'giftBannerUrl')
  final String? giftBannerUrl;

  /// 用戶 ID：72
  @JsonKey(name: 'userId')
  final num? userId;

  /// 禮物圖像的URL："gift/1/giftImage1691158142.png"
  @JsonKey(name: 'giftImageUrl')
  final String? giftImageUrl;

  /// 接收時間：1691377650301
  @JsonKey(name: 'receiveTime')
  final num? receiveTime;

  /// 禮物 ID：105
  @JsonKey(name: 'giftId')
  final num? giftId;

  /// 禮物送出數量：11
  @JsonKey(name: 'giftSendAmount')
  final num? giftSendAmount;

  /// SVGA 圖像的URL："gift/4/giftSvga1691158143.svga"
  @JsonKey(name: 'svgaUrl')
  final String? svgaUrl;

  /// 禮物側面圖像 ID：1841
  @JsonKey(name: 'giftSideImageId')
  final num? giftSideImageId;

  /// 背包 ID：105
  @JsonKey(name: 'backPackId')
  final num? backPackId;

  /// 禮物圖像 ID：1840
  @JsonKey(name: 'giftImageId')
  final num? giftImageId;

  /// 禮物側面圖像寬度：2244.00
  @JsonKey(name: 'giftSideImageWidth')
  final num? giftSideImageWidth;

  /// 活動連結："url/xxx"
  @JsonKey(name: 'activityLink')
  final String? activityLink;

  /// 禮物側面圖像高度：14.00
  @JsonKey(name: 'giftSideImageHeight')
  final num? giftSideImageHeight;

  /// 接收類型：0
  @JsonKey(name: 'receiveType')
  final num? receiveType;

  /// 序號：0
  @JsonKey(name: 'seq')
  final num? seq;

  /// 禮物橫幅圖像 ID：1842
  @JsonKey(name: 'giftBannerId')
  final num? giftBannerId;

  /// SVGA 文件 ID：1843
  @JsonKey(name: 'svgaFileId')
  final num? svgaFileId;

  factory FreBackPackListInfo.fromJson(Map<String, dynamic> json) =>
      _$FreBackPackListInfoFromJson(json);
  Map<String, dynamic> toJson() => _$FreBackPackListInfoToJson(this);
}