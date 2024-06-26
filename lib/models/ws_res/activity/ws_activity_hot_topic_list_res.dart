import 'package:json_annotation/json_annotation.dart';

part 'ws_activity_hot_topic_list_res.g.dart';

@JsonSerializable()
class WsActivityHotTopicListRes {
  WsActivityHotTopicListRes({
    this.list
  });

  @JsonKey(name: 'list')
  List<HotTopicListInfo>? list;

  factory WsActivityHotTopicListRes.fromJson(Map<String, dynamic> json) =>
      _$WsActivityHotTopicListResFromJson(json);
  Map<String, dynamic> toJson() => _$WsActivityHotTopicListResToJson(this);
}


@JsonSerializable()
class HotTopicListInfo {
  HotTopicListInfo({
    this.topicId,
    this.topicTitle,
    this.topicContent,
    this.topicSeq,
    this.topicStatus,
    this.createTime
  });

  /// 話題流水代碼
  @JsonKey(name: 'topicId')
  num? topicId;

  /// 話題標題
  @JsonKey(name: 'topicTitle')
  String? topicTitle;

  /// 話題描述
  @JsonKey(name: 'topicContent')
  String? topicContent;

  /// 話題排序
  @JsonKey(name: 'topicSeq')
  String? topicSeq;

  /// 話題狀態
  @JsonKey(name: 'topicStatus')
  num? topicStatus;

  /// createTime
  @JsonKey(name: 'createTime')
  num? createTime;

  factory HotTopicListInfo.fromJson(Map<String, dynamic> json) =>
      _$HotTopicListInfoFromJson(json);
  Map<String, dynamic> toJson() => _$HotTopicListInfoToJson(this);
}