import 'package:json_annotation/json_annotation.dart';

part 'ws_agent_promoter_info_req.g.dart';

@JsonSerializable()
class WsAgentPromoterInfoReq {
  WsAgentPromoterInfoReq({
    this.sort,
    this.dir,
    this.page,
    this.size,
    this.startDate,
    this.endDate,
    this.userId,
  });
  factory WsAgentPromoterInfoReq.create({
    String? sort,
    String? dir,
    String? page,
    num? size,
    String? startDate,
    String? endDate,
    String? userId,
  }) {
    return WsAgentPromoterInfoReq(
      sort: sort,
      dir: dir,
      page: page,
      size: size,
      startDate: startDate,
      endDate: endDate,
      userId: userId,
    );
  }
  /// 排序欄位 (非必填預設為totalAmount)
  @JsonKey(name: 'sort')
  String? sort;

  /// 排序類型 (非必填預設為desc)
  @JsonKey(name: 'dir')
  String? dir;

  /// 頁數 (非必填預設為1)
  @JsonKey(name: 'page')
  String? page;

  /// 當頁總筆數 (非必填預設為20)
  @JsonKey(name: 'size')
  num? size;

  /// 起始日期 (非必填如果不填預設為31天前到今天)
  @JsonKey(name: 'startDate')
  String? startDate;

  /// 结束日期 (非必填如果不填預設為31天前到今天)
  @JsonKey(name: 'endDate')
  String? endDate;

  /// 使用者ID 使用userId尋找其中某一個成員的下線名單，(非必填預設為登入者)
  @JsonKey(name: 'userId')
  String? userId;

  factory WsAgentPromoterInfoReq.fromJson(Map<String, dynamic> json) =>
      _$WsAgentPromoterInfoReqFromJson(json);
  Map<String, dynamic> toJson() => _$WsAgentPromoterInfoReqToJson(this);

  // API 不帶參數的屬性不傳出
  Map<String, dynamic> toBody() {
    Map<String, dynamic> json = toJson();
    json.removeWhere((key, value) => value == null);
    return json;
  }
}
