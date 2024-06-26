// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ws_account_get_gift_type_res.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WsAccountGetGiftTypeRes _$WsAccountGetGiftTypeResFromJson(Map<String, dynamic> json) => WsAccountGetGiftTypeRes(
    giftCategoryList: (json['giftCategoryList'] as List).map((info) => GiftCategoryInfo.fromJson(info)).toList()
);

Map<String, dynamic> _$WsAccountGetGiftTypeResToJson(WsAccountGetGiftTypeRes instance) => <String, dynamic>{
  'giftCategoryList': instance.giftCategoryList
};



GiftCategoryInfo _$GiftCategoryInfoFromJson(Map<String, dynamic> json) => GiftCategoryInfo(
  id: json['id'] as num?,
  codeName: json['codeName'] as String?,
  keyName: json['keyName'] as String?,
  createTime: json['createTime'] as num?,
  status: json['status'] as num?,
  seq: json['seq'] as num?,
);

Map<String, dynamic> _$GiftCategoryInfoToJson(GiftCategoryInfo instance) => <String, dynamic>{
  'id': instance.id,
  'codeName': instance.codeName,
  'keyName': instance.keyName,
  'createTime': instance.createTime,
  'status': instance.status,
  'seq': instance.seq,
};