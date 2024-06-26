import 'package:json_annotation/json_annotation.dart';

part 'ws_activity_add_reply_req.g.dart';

@JsonSerializable()
class WsActivityAddReplyReq {
  WsActivityAddReplyReq({
    this.content,
    this.feedReplyId,
    this.type,
    this.freFeedId,
    this.userLocation,
    // this.userName,
    // this.feedUserName,
    this.tagUserName

  });
  factory WsActivityAddReplyReq.create({
    String? content,
    String? userLocation,
    num? feedReplyId,
    num? type,
    num? freFeedId,
    // String? feedUserName,
    String? tagUserName,
  }) {
    return WsActivityAddReplyReq(
      content: content,
      feedReplyId: feedReplyId,
      freFeedId: freFeedId,
      type: type,
      userLocation: userLocation,
      // feedUserName: feedUserName,
      tagUserName: tagUserName
    );
  }

  /// 使用者發布的內容
  @JsonKey(name: 'content')
  String? content;

  /// 留言回復ID
  @JsonKey(name: 'feedReplyId')
  num? feedReplyId;

  /// 動態牆ID
  @JsonKey(name: 'freFeedId')
  num? freFeedId;

  /// 回复第一层还是第二层
  @JsonKey(name: 'type')
  num? type;

  /// 地點
  @JsonKey(name: 'userLocation')
  String? userLocation;

  // /// feedUserName
  // @JsonKey(name: 'feedUserName')
  // String? feedUserName;

  /// tagUserName
  @JsonKey(name: 'tagUserName')
  String? tagUserName;

  factory WsActivityAddReplyReq.fromJson(Map<String, dynamic> json) =>
      _$WsActivityAddReplyReqFromJson(json);
  Map<String, dynamic> toJson() => _$WsActivityAddReplyReqToJson(this);

  // API 不帶參數的屬性不傳出
  Map<String, dynamic> toBody() {
    Map<String, dynamic> json = toJson();
    json.removeWhere((key, value) => value == null);
    return json;
  }
}
