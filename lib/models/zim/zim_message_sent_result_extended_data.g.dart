// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'zim_message_sent_result_extended_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ZimMessageSentResultExtendedData _$ZimMessageSentResultExtendedDataFromJson(Map<String, dynamic> json) =>
    ZimMessageSentResultExtendedData(
          errorType: json['errorType'] as num?,
          errorCode: json['errorCode'] as num?,
          message: json['message'] as String?,
    );

Map<String, dynamic> _$ZimMessageSentResultExtendedDataToJson(ZimMessageSentResultExtendedData instance) =>
    <String, dynamic>{
      'errorType': instance.errorType,
      'errorCode': instance.errorCode,
      'message': instance.message,

    };
