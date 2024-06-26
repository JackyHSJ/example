// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ws_deposit_number_option_res.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WsDepositNumberOptionRes _$WsDepositNumberOptionResFromJson(Map<String, dynamic> json) =>
    WsDepositNumberOptionRes(
      list: json['list'] == null
          ? []
          : (json['list'] as List).map((info) => DepositOptionListInfo.fromJson(info)).toList()
    );

Map<String, dynamic> _$WsDepositNumberOptionResToJson(WsDepositNumberOptionRes instance) => 
    <String, dynamic>{};

DepositOptionListInfo _$DepositOptionListInfoResFromJson(Map<String, dynamic> json) =>
    DepositOptionListInfo(
      amount: json['amount'] as num?,
      appConfigId: json['appConfigId'] as num?,
      appleId: json['appleId'] as String?,
      createTime: json['createTime'] as num?,
      depositCoinsConfigId: json['depositCoinsConfigId'] as num?,
      vipCoins: json['vipCoins'] as num?,
      seq: json['seq'] as num?,
      coins: json['coins'] as num?,
      type: json['type'] as num?,
      fistType: json['fistType'] as num?,
    );

Map<String, dynamic> _$DepositOptionListInfoToJson(DepositOptionListInfo instance) =>
    <String, dynamic>{
      'amount': instance.amount,
      'appConfigId': instance.appConfigId,
      'appleId': instance.appleId,
      'createTime': instance.createTime,
      'depositCoinsConfigId': instance.depositCoinsConfigId,
      'vipCoins': instance.vipCoins,
      'seq': instance.seq,
      'coins': instance.coins,
      'type': instance.type,
      'fistType': instance.fistType,
    };