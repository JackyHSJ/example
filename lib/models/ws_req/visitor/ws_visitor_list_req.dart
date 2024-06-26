import 'package:json_annotation/json_annotation.dart';

part 'ws_visitor_list_req.g.dart';

@JsonSerializable()
class WsVisitorListReq {
  WsVisitorListReq({
    this.page
  });
  factory WsVisitorListReq.create({
    String? page
  }) {
    return WsVisitorListReq(
      page: page
    );
  }

  /// 頁數
  @JsonKey(name: 'page')
  String? page;

  factory WsVisitorListReq.fromJson(Map<String, dynamic> json) =>
      _$WsVisitorListReqFromJson(json);
  Map<String, dynamic> toJson() => _$WsVisitorListReqToJson(this);

  // API 不帶參數的屬性不傳出
  Map<String, dynamic> toBody() {
    Map<String, dynamic> json = toJson();
    json.removeWhere((key, value) => value == null);
    return json;
  }
}
