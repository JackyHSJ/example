import 'dart:io';
import 'package:dio/dio.dart';
import 'package:frechat/system/util/form_data_util.dart';
import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';
part 'check_app_version_res.g.dart';

@JsonSerializable()
class CheckAppVersionRes{

  CheckAppVersionRes({

    required this.appVersion,
    required this.downloadLink,
    required this.updateDescription,

  });

  factory CheckAppVersionRes.create({
    required String appVersion,
    required String downloadLink,
    required String updateDescription,

  }) {
    return CheckAppVersionRes(
      appVersion: appVersion,
      downloadLink: downloadLink,
      updateDescription: updateDescription,
    );
  }

  @JsonKey(name: 'appVersion')
  String appVersion;

  @JsonKey(name: 'downloadLink')
  String downloadLink;

  @JsonKey(name: 'updateDescription')
  String updateDescription;

  factory CheckAppVersionRes.fromJson(Map<String, dynamic> json) =>
      _$CheckAppVersionResFromJson(json);
  Map<String, dynamic> toJson() => _$CheckAppVersionResToJson(this);

  Future<FormData> toFormData() async {
    final FormData formData = await FormDataUtil.toFormData(toJson: toJson());
    return formData;
  }


}