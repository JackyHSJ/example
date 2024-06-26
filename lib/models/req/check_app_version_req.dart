import 'dart:io';
import 'package:dio/dio.dart';
import 'package:frechat/system/util/form_data_util.dart';
import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';
part 'check_app_version_req.g.dart';

@JsonSerializable()
class CheckAppVersionReq{

  CheckAppVersionReq({
    required this.tId,
  });

  factory CheckAppVersionReq.create({
    required String tId,
  }) {
    return CheckAppVersionReq(
      tId: tId,
    );
  }

  @JsonKey(name: 'tId')
  String tId;

  factory CheckAppVersionReq.fromJson(Map<String, dynamic> json) =>
      _$CheckAppVersionReqFromJson(json);
  Map<String, dynamic> toJson() => _$CheckAppVersionReqToJson(this);

  Future<FormData> toFormData() async {
    final FormData formData = await FormDataUtil.toFormData(toJson: toJson());
    return formData;
  }


}