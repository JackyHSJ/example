// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ws_account_get_gift_detail_res.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WsAccountGetGiftDetailRes _$WsAccountGetGiftDetailResFromJson(
        Map<String, dynamic> json) =>
    WsAccountGetGiftDetailRes(
        giftList: (json['giftList'] != null)
            ? (json['giftList'] as List)
                .map((info) => GiftListInfo.fromJson(info))
                .toList()
            : []);

Map<String, dynamic> _$WsAccountGetGiftDetailResToJson(
        WsAccountGetGiftDetailRes instance) =>
    <String, dynamic>{'giftList': instance.giftList};

GiftListInfo _$GiftListInfoFromJson(Map<String, dynamic> json) => GiftListInfo(
      giftSideImageUrl: json['giftSideImageUrl'] as String?,
      coins: json['coins'] as num?,
      giftName: json['giftName'] as String?,
      giftBannerUrl: json['giftBannerUrl'] as String?,
      categoryName: json['categoryName'] as String?,
      giftImageUrl: json['giftImageUrl'] as String?,
      activity_link: json['activity_link'] as String?,
      giftId: json['giftId'] as num?,
      giftSendAmount: json['giftSendAmount'] as num?,
      giftImageId: json['giftImageId'] as num?,
      giftSideImageWidth: json['giftSideImageWidth'] as num?,
      giftSideImageHeight: json['giftSideImageHeight'] as num?,
      categoryId: json['categoryId'] as num?,
      seq: json['seq'] as num?,
      giftBannerId: json['giftBannerId'] as num?,
      giftSideImageId: json['giftSideImageId'] as num?,
      svgaFileId: json['svgaFileId'] as num?,
      svgaUrl: json['svgaUrl'] as String?,
      giftType: json['giftType'] as num?,
    );

Map<String, dynamic> _$GiftListInfoToJson(GiftListInfo instance) =>
    <String, dynamic>{
      'giftSideImageUrl': instance.giftSideImageUrl,
      'coins': instance.coins,
      'giftName': instance.giftName,
      'giftBannerUrl': instance.giftBannerUrl,
      'categoryName': instance.categoryName,
      'giftImageUrl': instance.giftImageUrl,
      'activity_link': instance.activity_link,
      'giftId': instance.giftId,
      'giftSendAmount': instance.giftSendAmount,
      'giftImageId': instance.giftImageId,
      'giftSideImageWidth': instance.giftSideImageWidth,
      'giftSideImageHeight': instance.giftSideImageHeight,
      'categoryId': instance.categoryId,
      'seq': instance.seq,
      'giftBannerId': instance.giftBannerId,
      'giftSideImageId': instance.giftSideImageId,
      'svgaUrl': instance.svgaUrl,
      'svgaFileId': instance.svgaFileId,
       'giftType':instance.giftType,
    };
