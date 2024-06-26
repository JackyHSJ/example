

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ws_contact_search_friend_benefit_res.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WsContactSearchFriendBenefitRes _$WsContactSearchFriendBenefitResFromJson(Map<String, dynamic> json) =>
    WsContactSearchFriendBenefitRes(
          pageNumber: json['pageNumber'] as num?,
          totalPages: json['totalPages'] as num?,
          fullListSize: json['fullListSize'] as num?,
          pageSize: json['pageSize'] as num?,
          list: (json['list'] as List).map((info) => ContactFriendListInfo.fromJson(info)).toList(),
    );

Map<String, dynamic> _$WsContactSearchFriendBenefitResToJson(WsContactSearchFriendBenefitRes instance) =>
    <String, dynamic>{
          'pageNumber': instance.pageNumber,
          'totalPages': instance.totalPages,
          'fullListSize': instance.fullListSize,
          'pageSize': instance.pageSize,
          'list': instance.list,
    };

ContactFriendListInfo _$ContactFriendListInfoFromJson(Map<String, dynamic> json) =>
    ContactFriendListInfo(
          afterBalance: json['afterBalance'] as num?,
          amount: json['amount'] as num?,
          beforeBalance: json['beforeBalance'] as num?,
          createTime: json['createTime'] as num?,
          currency: json['currency'] as num?,
          freUserId: json['freUserId'] as num?,
          fundHistoryId: json['fundHistoryId'] as num?,
          fundHistoryJson: FundHistoryJsonInfo.fromJson(json['fundHistoryJson']),
          phoneNumber: json['phoneNumber'] as String?,
          type: json['type'] as num?,
          interactFreUserId: json['interactFreUserId'] as num?,
          interactFreUserName: json['interactFreUserName'] as String?,
          avatar: json['avatar'] as String?,
          age: json['age'] as num?,
          gender: json['gender'] as num?,
          realPersonAuth: json['realPersonAuth'] as num?,
          realNameAuth: json['realNameAuth'] as num?,
    );

Map<String, dynamic> _$ContactFriendListInfoToJson(ContactFriendListInfo instance) =>
    <String, dynamic>{
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
          'avatar': instance.avatar,
          'age': instance.age,
          'gender': instance.gender,
          'realPersonAuth': instance.realPersonAuth,
          'realNameAuth': instance.realNameAuth,
    };
