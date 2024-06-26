import 'package:json_annotation/json_annotation.dart';

part 'ws_activity_search_info_req.g.dart';

@JsonSerializable()
class WsActivitySearchInfoReq {
  WsActivitySearchInfoReq({
    required this.type,
    this.sort,
    this.dir,
    this.page,
    this.size,
    required this.condition,
    this.userId,
    this.topicId,
    this.gender,
    this.userName,
    this.pageNumber,
    this.id,
    this.searchTime,
  });
  factory WsActivitySearchInfoReq.create({
    required String type,
    String? sort,
    String? dir,
    String? page,
    String? size,
    required String condition,
    num? userId,
    String? topicId,
    num? gender,
    String? userName,
    num? pageNumber,
    num? id,
    num? searchTime,
  }) {
    return WsActivitySearchInfoReq(
      type: type,
      sort: sort,
      dir: dir,
      page: page,
      size: size,
      condition: condition,
      userId: userId,
      topicId: topicId,
      gender:gender,
      userName: userName,
      pageNumber: pageNumber,
      id: id,
      searchTime:searchTime,
    );
  }

  /// 0:同城 1:推薦 2:關注 3.本人 4:熱門貼文
  @JsonKey(name: 'type')
  String type;

  /// 排序欄位
  @JsonKey(name: 'sort')
  String? sort;

  /// 排序類型
  @JsonKey(name: 'dir')
  String? dir;

  /// 頁數(沒使用)
  @JsonKey(name: 'page')
  String? page;

  /// 當頁總筆數
  @JsonKey(name: 'size')
  String? size;

  /// 0: 往回找 1: 往後找
  @JsonKey(name: 'condition')
  String condition;

  /// 查詢其他人的動態牆
  @JsonKey(name: 'userId')
  num? userId;

  /// topicId
  @JsonKey(name: 'topicId')
  String? topicId;

  /// 查詢指定性別的貼文（沒給就全性別）
  @JsonKey(name: 'gender')
  num? gender;

  /// 指定對方的 userName
  @JsonKey(name: 'userName')
  String? userName;

  /// 查詢頁數
  @JsonKey(name: 'pageNumber')
  num? pageNumber;

  /// 貼文 id
  @JsonKey(name: 'id')
  num? id;

  /// 查訊時間
  @JsonKey(name: 'searchTime')
  num? searchTime;

  factory WsActivitySearchInfoReq.fromJson(Map<String, dynamic> json) =>
      _$WsActivitySearchInfoReqFromJson(json);
  Map<String, dynamic> toJson() => _$WsActivitySearchInfoReqToJson(this);

  // API 不帶參數的屬性不傳出
  Map<String, dynamic> toBody() {
    Map<String, dynamic> json = toJson();
    json.removeWhere((key, value) => value == null);
    return json;
  }
}

/// city(0):同城 / recommend(1):推薦 / subscribe(2):關注 / personal(3):本人 / HotTopics(4):熱門 / Topics(5):話題 / PostInfo(6):單篇貼文
enum WsActivitySearchInfoType{
  city,
  recommend,
  subscribe,
  personal,
  hotTopics,
  topics,
  postInfo,
}
