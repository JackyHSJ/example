import 'package:json_annotation/json_annotation.dart';

part 'ws_activity_search_reply_info_req.g.dart';

@JsonSerializable()
class WsActivitySearchReplyInfoReq {
  WsActivitySearchReplyInfoReq({
    this.type,
    this.sort,
    this.dir,
    this.page,
    this.size,
    this.feedReplyId,
  });
  factory WsActivitySearchReplyInfoReq.create({
    String? type,
    String? sort,
    String? dir,
    String? page,
    String? size,
    num? feedReplyId,
  }) {
    return WsActivitySearchReplyInfoReq(
      type: type,
      sort: sort,
      dir: dir,
      page: page,
      size: size,
      feedReplyId: feedReplyId,
    );
  }

  /// 0:全部 1:用戶 2:動態
  @JsonKey(name: 'type')
  String? type;

  /// 排序欄位
  @JsonKey(name: 'sort')
  String? sort;

  /// 排序類型
  @JsonKey(name: 'dir')
  String? dir;

  /// 頁數
  @JsonKey(name: 'page')
  String? page;

  /// 當頁總筆數
  @JsonKey(name: 'size')
  String? size;

  /// 回文id
  @JsonKey(name: 'feedReplyId')
  num? feedReplyId;

  factory WsActivitySearchReplyInfoReq.fromJson(Map<String, dynamic> json) =>
      _$WsActivitySearchReplyInfoReqFromJson(json);
  Map<String, dynamic> toJson() => _$WsActivitySearchReplyInfoReqToJson(this);

  // API 不帶參數的屬性不傳出
  Map<String, dynamic> toBody() {
    Map<String, dynamic> json = toJson();
    json.removeWhere((key, value) => value == null);
    return json;
  }
}
