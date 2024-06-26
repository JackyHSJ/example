import 'package:json_annotation/json_annotation.dart';

part 'ws_activity_search_reply_info_res.g.dart';

@JsonSerializable()
class WsActivitySearchReplyInfoRes {
  WsActivitySearchReplyInfoRes({
    this.list
  });

  @JsonKey(name: 'list')
  List<ActivityReplyInfo>? list;

  factory WsActivitySearchReplyInfoRes.fromJson(Map<String, dynamic> json) =>
      _$WsActivitySearchReplyInfoResFromJson(json);
  Map<String, dynamic> toJson() => _$WsActivitySearchReplyInfoResToJson(this);
}

@JsonSerializable()
class ActivityReplyInfo {
  ActivityReplyInfo({
    this.gender,
    this.realPersonAuth,
    this.userName,
    this.likesCount,
    this.replyCount,
    this.nickName,
    this.id,
    this.age,
    this.status,
    this.content,
    this.createTime,
    this.avatar,
    this.replyId,
    this.userId
  });

  /// 使用者的性別。0：男性，1：女性，2：其他
  @JsonKey(name: 'gender')
  num? gender;

  /// 真人认证。0：否，1：是
  @JsonKey(name: 'realPersonAuth')
  num? realPersonAuth;

  /// 使用者的唯一用戶名
  @JsonKey(name: 'userName')
  String? userName;

  /// 使用者發布的內容
  @JsonKey(name: 'content')
  String? content;

  /// 內容獲得的讚數
  @JsonKey(name: 'likesCount')
  num? likesCount;

  /// 內容收到的回复數量
  @JsonKey(name: 'replyCount')
  num? replyCount;

  /// 使用者顯示的暱稱
  @JsonKey(name: 'nickName')
  String? nickName;

  /// 與內容相關聯的唯一 ID
  @JsonKey(name: 'id')
  num? id;

  /// 使用者的年齡
  @JsonKey(name: 'age')
  num? age;

  /// 內容的狀態。0：已删除，1：使用中
  @JsonKey(name: 'status')
  num? status;

  /// 內容創建的時間戳
  @JsonKey(name: 'createTime')
  num? createTime;

  /// 使用者头像
  @JsonKey(name: 'avatar')
  String? avatar;

  /// 留言 id
  @JsonKey(name: 'replyId')
  num? replyId;

  /// user id
  @JsonKey(name: 'userId')
  num? userId;

  factory ActivityReplyInfo.fromJson(Map<String, dynamic> json) =>
      _$ActivityReplyInfoFromJson(json);
  Map<String, dynamic> toJson() => _$ActivityReplyInfoToJson(this);
}
