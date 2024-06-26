import 'package:json_annotation/json_annotation.dart';

part 'ws_contact_search_list_req.g.dart';

@JsonSerializable()
class WsContactSearchListReq {
  WsContactSearchListReq({
    this.querykeyword,
    this.sort,
    this.dir,
    this.page,
    this.size,
  });
  factory WsContactSearchListReq.create({
    String? querykeyword,
    String? sort,
    String? dir,
    String? page,
    String? size,
  }) {
    return WsContactSearchListReq(
        querykeyword: querykeyword,
        sort: sort,
        dir: dir,
        page: page,
        size: size,
    );
  }

  /// 關鍵字查詢
  @JsonKey(name: 'querykeyword')
  String? querykeyword;

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

  factory WsContactSearchListReq.fromJson(Map<String, dynamic> json) =>
      _$WsContactSearchListReqFromJson(json);
  Map<String, dynamic> toJson() => _$WsContactSearchListReqToJson(this);

  Map<String, String> toBody() =>
      toJson().map((key, value) => value == null ? MapEntry(key, 'null') : MapEntry(key, value));
}
