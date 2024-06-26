// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ws_account_get_gift_detail_req.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WsAccountGetGiftDetailReq _$WsAccountGetGiftDetailReqFromJson(Map<String, dynamic> json) =>
    WsAccountGetGiftDetailReq(
      categoryId: json['categoryId'] as num?,
      // refresh: json['refresh'] as bool?,
      type: json['type'] as num?,
    );

Map<String, dynamic> _$WsAccountGetGiftDetailReqToJson(WsAccountGetGiftDetailReq instance) =>
    <String, dynamic>{
      'categoryId': instance.categoryId,
      // 'refresh': instance.refresh,
      'type': instance.type,
    };
