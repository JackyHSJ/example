// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ws_withdraw_save_aipay_req.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WsWithdrawSaveAiPayReq _$WsWithdrawSaveAiPayReqFromJson(Map<String, dynamic> json) =>
    WsWithdrawSaveAiPayReq(
      account: json['account'] as String?,
      function: json['function'] as String?,
      type: json['type'] as String?,
      status: json['status'] as String?,
    );

Map<String, dynamic> _$WsWithdrawSaveAiPayReqToJson(WsWithdrawSaveAiPayReq instance) =>
    <String, dynamic>{
      'account': instance.account,
      'function': instance.function,
      'type': instance.type,
      'status': instance.status,
    };