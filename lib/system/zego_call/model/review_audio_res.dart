
import 'package:json_annotation/json_annotation.dart';
part 'review_audio_res.g.dart';

@JsonSerializable()
class ReviewAudioRes {
  ReviewAudioRes({
    this.file_name,
    this.download_url,
    this.file_size,
    this.md5,
    this.reviewResult,
    this.audioTime,
  });

  @JsonKey(name: 'file_name')
  final String? file_name;

  @JsonKey(name: 'download_url')
  final String? download_url;

  @JsonKey(name: 'file_size')
  final String? file_size;

  @JsonKey(name: 'md5')
  final String? md5;

  @JsonKey(name: 'reviewResult')
  final bool? reviewResult;


  @JsonKey(name: 'audioTime')
  final num? audioTime;

  factory ReviewAudioRes.fromJson(Map<String, dynamic> json) =>
      _$ReviewAudioResFromJson(json);
  Map<String, dynamic> toJson() => _$ReviewAudioResToJson(this);
}