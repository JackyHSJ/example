// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ws_withdraw_search_payment_res.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WsWithdrawSearchPaymentRes _$WsWithdrawSearchPaymentResFromJson(Map<String, dynamic> json) => WsWithdrawSearchPaymentRes(
    idCard: json['idCard'], realName: json['realName'], list: (json['list'] as List?)?.map((info) => WithdrawPaymentListInfo.fromJson(info)).toList());

Map<String, dynamic> _$WsWithdrawSearchPaymentResToJson(WsWithdrawSearchPaymentRes instance) => <String, dynamic>{
      'realName': instance.realName,
      'idCard': instance.idCard,
      'list': instance.list,
    };

WithdrawPaymentListInfo _$WithdrawPaymentListInfoFromJson(Map<String, dynamic> json) => WithdrawPaymentListInfo(
      account: json['account'] as String?,
      createTime: json['createTime'] as num?,
      type: json['type'] as num?,
      updateTime: json['updateTime'] as num?,
      userId: json['userId'] as num?,
      withdrawalAccountId: json['withdrawalAccountId'] as num?,
      status: json['status'] as num?,
    );

Map<String, dynamic> _$WithdrawPaymentListInfoToJson(WithdrawPaymentListInfo instance) => <String, dynamic>{
      'account': instance.account,
      'createTime': instance.createTime,
      'type': instance.type,
      'updateTime': instance.updateTime,
      'userId': instance.userId,
      'withdrawalAccountId': instance.withdrawalAccountId,
      'status': instance.status,
    };
