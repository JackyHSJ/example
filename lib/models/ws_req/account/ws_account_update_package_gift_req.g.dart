// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ws_account_update_package_gift_req.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WsAccountUpdatePackageGiftReq _$WsAccountUpdatePackageGiftReqFromJson(Map<String, dynamic> json) =>
    WsAccountUpdatePackageGiftReq(
        giftId: json['giftId'] as num?,
        qty: json['qty'] as num?,
        isPositive: json['isPositive'] as bool?,
    );

Map<String, dynamic> _$WsAccountUpdatePackageGiftReqToJson(WsAccountUpdatePackageGiftReq instance) =>
    <String, dynamic>{
        'giftId': instance.giftId,
        'qty': instance.qty,
        'isPositive': instance.isPositive,
    };
