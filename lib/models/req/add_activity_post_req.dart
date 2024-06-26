import 'dart:io';
import 'package:dio/dio.dart';
import 'package:frechat/system/util/form_data_util.dart';
import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';
part 'add_activity_post_req.g.dart';

@JsonSerializable()
class AddActivityPostReq {
  AddActivityPostReq({
    required this.tId,
    this.files,
    this.type,
    this.content,
    this.userLocation,
    this.topicId,
  });

  factory AddActivityPostReq.create({
    required String tId,
    List<File>? files,
    String? type,
    String? content,
    String? userLocation,
    num? topicId,
  }) {
    return AddActivityPostReq(
      tId: tId,
      files: files,
      type: type,
      content: content,
      userLocation: userLocation,
      topicId: topicId,
    );
  }

  @JsonKey(name: 'tId')
  String tId;

  // 附圖
  @JsonKey(name: 'files')
  List<File>? files;

  // 动态類型 0: 图片动态 1:影片动态
  @JsonKey(name: 'type')
  String? type;

  // 文章的信息或描述
  @JsonKey(name: 'content')
  String? content;

  // 位置
  @JsonKey(name: 'userLocation')
  String? userLocation;

  // 文章相关的话题标签
  @JsonKey(name: 'topicId')
  num? topicId;
  

  factory AddActivityPostReq.fromJson(Map<String, dynamic> json) =>
      _$AddActivityPostReqFromJson(json);
  Map<String, dynamic> toJson() => _$AddActivityPostReqToJson(this);

  Future<FormData> toFormData() async {
    final FormData formData = await FormDataUtil.toFormData(toJson: toJson());
    return formData;
  }
}
