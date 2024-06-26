import 'dart:io';

import 'package:dio/dio.dart';
import 'package:frechat/system/util/form_data_util.dart';
import 'package:json_annotation/json_annotation.dart';
part 'send_sms_req.g.dart';

@JsonSerializable()
class SendSmsReq {
  SendSmsReq({
    required this.phonenumber,
    required this.appId,
  });

  factory SendSmsReq.create({
    required String phonenumber,
    required String appId,
  }) {
    return SendSmsReq(
      phonenumber: phonenumber,
      appId: appId,
    );
  }

  @JsonKey(name: 'phonenumber')
  String phonenumber;

  @JsonKey(name: 'appId')
  String appId;

  factory SendSmsReq.fromJson(Map<String, dynamic> json) =>
      _$SendSmsReqFromJson(json);
  Map<String, dynamic> toJson() => _$SendSmsReqToJson(this);

  Map<String, String> toBody() =>
      toJson().map((key, value) => value == null ? MapEntry(key, 'null') : MapEntry(key, value));
}
