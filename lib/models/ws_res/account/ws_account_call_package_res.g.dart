// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ws_account_call_package_res.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WsAccountCallPackageRes _$WsAccountCallPackageResFromJson(Map<String, dynamic> json) => WsAccountCallPackageRes(
    freBackPackList: (json['freBackPackList'] as List).map((info) => FreBackPackListInfo.fromJson(info)).toList()
);

Map<String, dynamic> _$WsAccountCallPackageResToJson(WsAccountCallPackageRes instance) => <String, dynamic>{
  'freBackPackList': instance.freBackPackList
};

FreBackPackListInfo _$FreBackPackListInfoFromJson(Map<String, dynamic> json) => FreBackPackListInfo(
  id: json['id'] as num?,
  codeName: json['codeName'] as String?,
  createTime: json['createTime'] as num?,
  status: json['status'] as num?,
  quantity: json['quantity'] as num?,
  giftSideImageUrl: json['giftSideImageUrl'] as String?,
  coins: json['coins'] as num?,
  giftName: json['giftName'] as String?,
  codeMapId: json['codeMapId'] as num?,
  giftBannerUrl: json['giftBannerUrl'] as String?,
  userId: json['userId'] as num?,
  giftImageUrl: json['giftImageUrl'] as String?,
  receiveTime: json['receiveTime'] as num?,
  giftId: json['giftId'] as num?,
  giftSendAmount: json['giftSendAmount'] as num?,
  svgaUrl: json['svgaUrl'] as String?,
  giftSideImageId: json['giftSideImageId'] as num?,
  backPackId: json['backPackId'] as num?,
  giftImageId: json['giftImageId'] as num?,
  giftSideImageHeight: json['giftSideImageHeight'] as num?,
  activityLink: json['activityLink'] as String?,
  giftSideImageWidth: json['giftSideImageWidth'] as num?,
  receiveType: json['receiveType'] as num?,
  seq: json['seq'] as num?,
  giftBannerId: json['giftBannerId'] as num?,
  svgaFileId: json['svgaFileId'] as num?,
);

Map<String, dynamic> _$FreBackPackListInfoToJson(FreBackPackListInfo instance) => <String, dynamic>{
  'id': instance.id,
  'codeName': instance.codeName,
  'createTime': instance.createTime,
  'status': instance.status,
  'quantity': instance.quantity,
  'giftSideImageUrl': instance.giftSideImageUrl,
  'coins': instance.coins,
  'giftName': instance.giftName,
  'codeMapId': instance.codeMapId,
  'giftBannerUrl': instance.giftBannerUrl,
  'userId': instance.userId,
  'giftImageUrl': instance.giftImageUrl,
  'receiveTime': instance.receiveTime,
  'giftId': instance.giftId,
  'giftSendAmount': instance.giftSendAmount,
  'svgaUrl': instance.svgaUrl,
  'giftSideImageId': instance.giftSideImageId,
  'backPackId': instance.backPackId,
  'giftImageId': instance.giftImageId,
  'giftSideImageHeight': instance.giftSideImageHeight,
  'activityLink': instance.activityLink,
  'giftSideImageWidth': instance.giftSideImageWidth,
  'receiveType': instance.receiveType,
  'seq': instance.seq,
  'giftBannerId': instance.giftBannerId,
  'svgaFileId': instance.svgaFileId,
};