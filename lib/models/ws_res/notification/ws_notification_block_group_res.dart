
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frechat/models/ws_res/notification/ws_notification_search_list_res.dart';
import 'package:json_annotation/json_annotation.dart';

part 'ws_notification_block_group_res.g.dart';

@JsonSerializable()
class WsNotificationBlockGroupRes {
  WsNotificationBlockGroupRes({
    this.pageNumber,
    this.totalPages,
    this.fullListSize,
    this.pageSize,
    this.list,
  });

  /// 當前頁數
  @JsonKey(name: 'pageNumber')
  final num? pageNumber;

  /// 總頁數
  @JsonKey(name: 'totalPages')
  final num? totalPages;

  /// 總筆數
  @JsonKey(name: 'fullListSize')
  final num? fullListSize;

  /// 每頁筆數
  @JsonKey(name: 'pageSize')
  final num? pageSize;

  /// 每頁筆數
  @JsonKey(name: 'list')
  final List<BlockListInfo>? list;

  factory WsNotificationBlockGroupRes.fromJson(Map<String, dynamic> json) =>
      _$WsNotificationBlockGroupResFromJson(json);

  Map<String, dynamic> toJson() => _$WsNotificationBlockGroupResToJson(this);
}

@JsonSerializable()
class BlockListInfo {
  BlockListInfo({
    this.filePath,
    this.friendId,
    this.nickName,
    this.age,
    this.gender,
    this.selfIntroduction,
    this.userName
  });

  /// 頭像路徑
  @JsonKey(name: 'filePath')
  final String? filePath;

  /// 被黑名單的好友id
  @JsonKey(name: 'friendId')
  final num? friendId;

  /// 暱稱
  @JsonKey(name: 'nickName')
  final String? nickName;

  @JsonKey(name: 'age')
  final num? age;

  /// 性别(0:女生,1:男生)
  @JsonKey(name: 'gender')
  final num? gender;

  /// 自我介绍
  @JsonKey(name: 'selfIntroduction')
  final String? selfIntroduction;

  /// 暱稱
  @JsonKey(name: 'userName')
  final String? userName;

  factory BlockListInfo.fromJson(Map<String, dynamic> json) =>
      _$BlockListInfoFromJson(json);

  Map<String, dynamic> toJson() => _$BlockListInfoToJson(this);
}