// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ws_detail_search_list_coin_res.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WsDetailSearchListCoinRes _$WsDetailSearchListCoinResFromJson(Map<String, dynamic> json) => WsDetailSearchListCoinRes(
    pageNumber: json['pageNumber'] as num?,
    totalPages: json['totalPages'] as num?,
    fullListSize: json['fullListSize'] as num?,
    pageSize: json['pageSize'] as num?,
    list: (json['list'] as List).map((info) => DetailListInfo.fromJson(info)).toList());

Map<String, dynamic> _$WsDetailSearchListCoinResToJson(WsDetailSearchListCoinRes instance) => <String, dynamic>{
      'pageNumber': instance.pageNumber,
      'totalPages': instance.totalPages,
      'fullListSize': instance.fullListSize,
      'pageSize': instance.pageSize,
      'list': instance.list,
    };

DetailListInfo _$DetailListInfoFromJson(Map<String, dynamic> json) => DetailListInfo(
      afterBalance: json['afterBalance'] as num?,
      amount: json['amount'] as num?,
      beforeBalance: json['beforeBalance'] as num?,
      createTime: json['createTime'] as num?,
      currency: json['currency'] as num?,
      freUserId: json['freUserId'] as num?,
      fundHistoryId: json['fundHistoryId'] as num?,
      fundHistoryJson: (json['fundHistoryJson'] == null)?FundHistoryJsonInfo():FundHistoryJsonInfo.fromJson(json['fundHistoryJson']),
      phoneNumber: json['phoneNumber'] as String?,
      type: json['type'] as num?,
      interactFreUserId: json['interactFreUserId'] as num?,
      interactFreUserName: json['interactFreUserName'] as String?,
      age: json['age'] as num?,
      gender: json['gender'] as num?,
      realNameAuth: json['realNameAuth'] as num?,
      realPersonAuth: json['realPersonAuth'] as num?,
      avatar: json['avatar'] as String?,
);

Map<String, dynamic> _$DetailListInfoToJson(DetailListInfo instance) => <String, dynamic>{
      'afterBalance': instance.afterBalance,
      'amount': instance.amount,
      'beforeBalance': instance.beforeBalance,
      'createTime': instance.createTime,
      'currency': instance.currency,
      'freUserId': instance.freUserId,
      'fundHistoryId': instance.fundHistoryId,
      'fundHistoryJson': instance.fundHistoryJson,
      'phoneNumber': instance.phoneNumber,
      'type': instance.type,
      'interactFreUserId': instance.interactFreUserId,
      'interactFreUserName': instance.interactFreUserName,
      'age': instance.age,
      'gender': instance.gender,
      'realNameAuth': instance.realNameAuth,
      'realPersonAuth': instance.realPersonAuth,
      'avatar': instance.avatar,
};

FundHistoryJsonInfo _$FundHistoryJsonInfoFromJson(Map<String, dynamic> json) =>
    FundHistoryJsonInfo(interactFreUserId: json['interactFreUserId'] as String?, interactNickName: json['interactNickName'] as String?, giftId: json['giftId'] as num?, giftCoins: json['giftCoins'] as num?);

Map<String, dynamic> _$FundHistoryJsonInfoToJson(FundHistoryJsonInfo instance) =>
    <String, dynamic>{'interactFreUserId': instance.interactFreUserId, 'interactNickName': instance.interactNickName, 'giftId': instance.giftId, 'giftCoins': instance.giftCoins};
