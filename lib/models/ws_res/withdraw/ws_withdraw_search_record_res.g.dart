// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ws_withdraw_search_record_res.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WsWithdrawSearchRecordRes _$WsWithdrawSearchRecordResFromJson(Map<String, dynamic> json) =>
    WsWithdrawSearchRecordRes(
      pageNumber: json['pageNumber'] as num?,
      totalPages: json['totalPages'] as num?,
      fullListSize: json['fullListSize'] as num?,
      pageSize: json['pageSize'] as num?,
      list: (json['list'] as List).map((info) => WithdrawListInfo.fromJson(info)).toList()
    );

Map<String, dynamic> _$WsWithdrawSearchRecordResToJson(WsWithdrawSearchRecordRes instance) => 
    <String, dynamic>{
      'pageNumber': instance.pageNumber,
      'totalPages': instance.totalPages,
      'fullListSize': instance.fullListSize,
      'pageSize': instance.pageSize,
      'list': instance.list,
    };

WithdrawListInfo _$WithdrawListInfoFromJson(Map<String, dynamic> json) =>
    WithdrawListInfo(
          withdrawalId: json['withdrawalId'] as num?,
          transactionId: json['transactionId'] as String?,
          checkId: json['checkId'] as String?,
          point: json['point'] as num?,
          expectAmount: json['expectAmount'] as num?,
          serviceAmount: json['serviceAmount'] as num?,
          realAmount: json['realAmount'] as num?,
          status: json['status'] as num?,
          freUserId: json['freUserId'] as num?,
          nickName: json['nickName'] as String?,
          createTime: json['createTime'] as num?,
          updateTime: json['updateTime'] as num?,
          badAmount: json['badAmount'] as num?,
          remark: json['remark'] as String?,
    );

Map<String, dynamic> _$WithdrawListInfoToJson(WithdrawListInfo instance) =>
    <String, dynamic>{
          'withdrawalId': instance.withdrawalId,
          'transactionId': instance.transactionId,
          'checkId': instance.checkId,
          'point': instance.point,
          'expectAmount': instance.expectAmount,
          'serviceAmount': instance.serviceAmount,
          'realAmount': instance.realAmount,
          'status': instance.status,
          'freUserId': instance.freUserId,
          'nickName': instance.nickName,
          'createTime': instance.createTime,
          'updateTime': instance.updateTime,
          'badAmount': instance.badAmount,
          'remark': instance.remark,
    };