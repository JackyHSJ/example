// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'upload_real_person_img_req.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UploadRealPersonImgReq _$UploadRealPersonImgReqFromJson(Map<String, dynamic> json) =>
    UploadRealPersonImgReq(
      tId: json['tId'] as String,
      realPersonImg: json['realPersonImg'] as File,
    );

Map<String, dynamic> _$UploadRealPersonImgReqToJson(UploadRealPersonImgReq instance) =>
    <String, dynamic>{
      'tId': instance.tId,
      'realPersonImg': instance.realPersonImg,
    };
