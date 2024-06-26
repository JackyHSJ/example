import 'package:json_annotation/json_annotation.dart';

part 'upload_real_person_img_res.g.dart';

@JsonSerializable()
class UploadRealPersonImgRes {
  UploadRealPersonImgRes({
    this.updateTime,
    this.userid,
  });

  @JsonKey(name: 'updateTime')
  final num? updateTime;

  @JsonKey(name: 'userid')
  final num? userid;

  factory UploadRealPersonImgRes.fromJson(Map<String, dynamic> json) =>
      _$UploadRealPersonImgMapFromJson(json);
  Map<String, dynamic> toJson() => _$UploadRealPersonImgResToJson(this);
}
