import 'dart:io';

import 'package:dio/dio.dart';
import 'package:frechat/system/util/form_data_util.dart';
import 'package:json_annotation/json_annotation.dart';
part 'upload_real_person_img_req.g.dart';

@JsonSerializable()
class UploadRealPersonImgReq {
  UploadRealPersonImgReq({
    required this.tId,
    required this.realPersonImg,
  });

  factory UploadRealPersonImgReq.create({
    required String tId,
    required File realPersonImg,
  }) {
    return UploadRealPersonImgReq(
      tId: tId,
      realPersonImg: realPersonImg,
    );
  }

  // token
  @JsonKey(name: 'tId')
  String tId;

  // 附圖
  @JsonKey(name: 'realPersonImg')
  File realPersonImg;

  factory UploadRealPersonImgReq.fromJson(Map<String, dynamic> json) =>
      _$UploadRealPersonImgReqFromJson(json);
  Map<String, dynamic> toJson() => _$UploadRealPersonImgReqToJson(this);

  Future<FormData> toFormData() async {
    final FormData formData = await FormDataUtil.toFormData(toJson: toJson());
    return formData;
  }
}
