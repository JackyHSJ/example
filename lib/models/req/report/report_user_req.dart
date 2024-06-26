import 'dart:io';

import 'package:dio/dio.dart';
import 'package:frechat/system/util/form_data_util.dart';
import 'package:json_annotation/json_annotation.dart';
part 'report_user_req.g.dart';

@JsonSerializable()
class ReportUserReq {
  ReportUserReq({
    required this.tId,
    this.files,
    required this.type,
    required this.remark,
    this.userId,
    required this.reportSettingId,
    this.feedsId,
    this.feedReplyId
  });

  factory ReportUserReq.create({
    required String tId,
    List<File>? files,
    required num type,
    required String remark,
    num? userId,
    required num reportSettingId,
    num? feedsId,
    num? feedReplyId,
  }) {
    return ReportUserReq(
      tId: tId,
      files: files,
      type: type,
      remark: remark,
      userId: userId,
      reportSettingId: reportSettingId,
      feedsId: feedsId,
      feedReplyId: feedReplyId
    );
  }

  // token
  @JsonKey(name: 'tId')
  String tId;

  // 附圖
  @JsonKey(name: 'files')
  List<File>? files;

  // 0:全部 1:用戶 2:動態
  @JsonKey(name: 'type')
  num type;

  // 備註
  @JsonKey(name: 'remark')
  String? remark;

  // 被檢舉人用戶id
  @JsonKey(name: 'userId')
  num? userId;

  // 舉報類型id
  @JsonKey(name: 'reportSettingId')
  num reportSettingId;

  // 動態-貼文id
  @JsonKey(name: 'feedsId')
  num? feedsId;

  // 動態-留言id
  @JsonKey(name: 'feedReplyId')
  num? feedReplyId;

  factory ReportUserReq.fromJson(Map<String, dynamic> json) =>
      _$ReportUserReqFromJson(json);
  Map<String, dynamic> toJson() => _$ReportUserReqToJson(this);

  Future<FormData> toFormData() async {
    final FormData formData = await FormDataUtil.toFormData(toJson: toJson());
    return formData;
  }
}
