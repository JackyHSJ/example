import 'dart:io';
import 'package:dio/dio.dart';
import 'package:frechat/system/util/form_data_util.dart';
import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';
part 'zim_message_sent_result_extended_data.g.dart';

@JsonSerializable()
class ZimMessageSentResultExtendedData {
  ZimMessageSentResultExtendedData({
    this.errorType,
    this.errorCode,
    this.message,
  });


  // 0:其他錯誤 1:Shumei
  @JsonKey(name: 'errorType')
  num? errorType;

  @JsonKey(name: 'errorCode')
  num? errorCode;

  @JsonKey(name: 'message')
  String? message;


  factory ZimMessageSentResultExtendedData.fromJson(Map<String, dynamic> json) => _$ZimMessageSentResultExtendedDataFromJson(json);
  Map<String, dynamic> toJson() => _$ZimMessageSentResultExtendedDataToJson(this);
}
