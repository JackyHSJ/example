
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:frechat/system/util/form_data_util.dart';
import 'package:json_annotation/json_annotation.dart';

part 'greet_module_add_req.g.dart';

@JsonSerializable()
class GreetModuleAddReq {
  GreetModuleAddReq({
    required this.tId,
    this.modelName,
    this.greetingPic,
    this.greetingAudio,
    this.greetingText,
    this.greetingAudioLength,
  });

  factory GreetModuleAddReq.create({
    required String tId,
    String? modelName,
    File? greetingPic,
    File? greetingAudio,
    String? greetingText,
    num? greetingAudioLength,
  }) {
    return GreetModuleAddReq(
      tId: tId,
      modelName: modelName,
      greetingPic: greetingPic,
      greetingAudio: greetingAudio,
      greetingText: greetingText,
      greetingAudioLength:greetingAudioLength,
    );
  }

  /// token
  @JsonKey(name: 'tId')
  String tId;

  /// 模板備註
  @JsonKey(name: 'modelName')
  String? modelName;

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

  factory GreetModuleAddReq.fromJson(Map<String, dynamic> json) =>
      _$GreetModuleAddReqFromJson(json);
  Map<String, dynamic> toJson() => _$GreetModuleAddReqToJson(this);

  Future<FormData> toFormData() async {
    final FormData formData = await FormDataUtil.toFormData(toJson: toJson());
    return formData;
  }
}
