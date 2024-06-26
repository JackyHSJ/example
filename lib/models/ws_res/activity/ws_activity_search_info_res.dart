import 'package:frechat/models/ws_req/activity/ws_activity_search_info_req.dart';
import 'package:frechat/models/ws_res/activity/ws_activity_hot_topic_list_res.dart';
import 'package:json_annotation/json_annotation.dart';

part 'ws_activity_search_info_res.g.dart';

@JsonSerializable()
class WsActivitySearchInfoRes {
  WsActivitySearchInfoRes({
    this.likeList,
    this.pageNumber,
    this.totalPages,
    this.fullListSize,
    this.list,
    this.hotTopicList,
    this.type,
  });

  @JsonKey(name: 'likeList')
  List<dynamic>? likeList;

  @JsonKey(name: 'pageNumber')
  num? pageNumber;

  @JsonKey(name: 'totalPages')
  num? totalPages;

  @JsonKey(name: 'pageSize')
  num? pageSize;

  @JsonKey(name: 'fullListSize')
  num? fullListSize;

  @JsonKey(name: 'list')
  List<ActivityPostInfo>? list;

  @JsonKey(name: 'hotTopicList')
  List<HotTopicListInfo>? hotTopicList;

  @JsonKey(name: 'type')
  WsActivitySearchInfoType? type;

  factory WsActivitySearchInfoRes.fromJson(Map<String, dynamic> json) =>
      _$WsActivitySearchInfoResFromJson(json);
  Map<String, dynamic> toJson() => _$WsActivitySearchInfoResToJson(this);
}

@JsonSerializable()
class ActivityPostInfo {
  ActivityPostInfo({
    this.gender,
    this.userLocation,
    this.userName,
    this.likesCount,
    this.contentUrl,
    this.topicId,
    this.replyCount,
    this.createTime,
    this.nickName,
    this.id,
    this.age,
    this.status,
    this.content,
    this.avatar,
    this.type,
    this.userId,
    this.topicTitle,
    this.contentLocalUrl,
  });

  /// 使用者的性別。0：男性，1：女性，2：其他
  @JsonKey(name: 'gender')
  num? gender;

  /// 使用者的地理位置，使用 geohash 格式
  @JsonKey(name: 'userLocation')
  String? userLocation;

  /// 使用者的唯一用戶名
  @JsonKey(name: 'userName')
  String? userName;

  /// 使用者發布的內容
  @JsonKey(name: 'content')
  String? content;

  /// 內容獲得的讚數
  @JsonKey(name: 'likesCount')
  num? likesCount;

  /// 附加內容的 圖片/影片 URL
  @JsonKey(name: 'contentUrl')
  String? contentUrl;

  /// 相關主題的 ID
  @JsonKey(name: 'topicId')
  num? topicId;

  /// 內容收到的回复數量
  @JsonKey(name: 'replyCount')
  num? replyCount;

  /// 內容創建的時間戳
  @JsonKey(name: 'createTime')
  num? createTime;

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

  @JsonKey(name: 'avatar')
  String? avatar;

  /// 文章類型。0: 圖片動態 1:影片動態
  @JsonKey(name: 'type')
  num? type;

  @JsonKey(name: 'userId')
  num? userId;

  /// 相關主題的名稱
  @JsonKey(name: 'topicTitle')
  String? topicTitle;


  /// 附加內容的 圖片/影片 URL(此參數僅App使用，後端不會回傳此參數)
  @JsonKey(name: 'contentLocalUrl')
  String? contentLocalUrl;

  factory ActivityPostInfo.fromJson(Map<String, dynamic> json) =>
      _$ActivityPostInfoFromJson(json);
  Map<String, dynamic> toJson() => _$ActivityPostInfoToJson(this);
}
