import 'dart:io';

import 'package:dio/dio.dart';
import 'package:encrypt/encrypt.dart';
import 'package:frechat/system/util/form_data_util.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../system/comm/comm_def.dart';
import '../../system/util/aes_util.dart';

part 'greet_module_edit_req.g.dart';

@JsonSerializable()
class GreetModuleEditReq {
  GreetModuleEditReq({
    required this.tId,
    this.id,
    this.greetingPic,
    this.greetingAudio,
    this.greetingText,
    this.greetingAudioLength,
  });

  factory GreetModuleEditReq.create({
    required String tId,
    num? id,
    File? greetingPic,
    File? greetingAudio,
    String? greetingText,
    num? greetingAudioLength,
  }) {
    return GreetModuleEditReq(
      tId: tId,
      id: id,
      greetingPic: greetingPic,
      greetingAudio: greetingAudio,
      greetingText: greetingText,
      greetingAudioLength:greetingAudioLength,
    );
  }

  /// token
  @JsonKey(name: 'tId')
  String tId;

  /// 模板id
  @JsonKey(name: 'id')
  num? id;

  /// 招呼語-圖片
  @JsonKey(name: 'greetingPic')
  File? greetingPic;

  /// 招呼語-語音
  @JsonKey(name: 'greetingAudio')
  File? greetingAudio;

  /// 招呼語-文字
  @JsonKey(name: 'greetingText')
  String? greetingText;

  /// 招呼語-語音時長
  @JsonKey(name: 'greetingAudioLength')
  num? greetingAudioLength;

  factory GreetModuleEditReq.fromJson(Map<String, dynamic> json) =>
      _$GreetModuleEditReqFromJson(json);
  Map<String, dynamic> toJson() => _$GreetModuleEditReqToJson(this);

  Future<FormData> toFormData() async {
    final FormData formData = await FormDataUtil.toFormData(toJson: toJson());
    return formData;
  }
}
