import 'package:json_annotation/json_annotation.dart';

part 'ws_agent_second_member_list_req.g.dart';

@JsonSerializable()
class WsAgentSecondMemberListReq {
  WsAgentSecondMemberListReq({
    this.sort,
    this.dir,
    this.page,
    this.size,
    this.profit,
    this.startDate,
    this.endDate,
    this.userId,
    this.userName,
  });
  factory WsAgentSecondMemberListReq.create({
    String? sort,
    String? dir,
    String? page,
    num? size,
    String? profit,
    String? startDate,
    String? endDate,
    String? userId,
    String? userName,
  }) {
    return WsAgentSecondMemberListReq(
      sort: sort,
      dir: dir,
      page: page,
      size: size,
      profit: profit,
      startDate: startDate,
      endDate: endDate,
      userId: userId,
      userName: userName,
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

  /// 是否考虑盈利("T"為有收益的成員名單，沒有"T"為成員列表)
  @JsonKey(name: 'profit')
  String? profit;

  /// 起始日期 最大區間為31天，(非必填如果不填預設為31天前到今天)
  @JsonKey(name: 'startDate')
  String? startDate;

  /// 结束日期 最大區間為31天，(非必填如果不填預設為31天前到今天)
  @JsonKey(name: 'endDate')
  String? endDate;

  /// 使用userId尋找其中某一個成員的下線名單，(非必填預設為登入者)
  @JsonKey(name: 'userId')
  String? userId;

  @JsonKey(name: 'userName')
  String? userName;

  factory WsAgentSecondMemberListReq.fromJson(Map<String, dynamic> json) =>
      _$WsAgentSecondMemberListReqFromJson(json);
  Map<String, dynamic> toJson() => _$WsAgentSecondMemberListReqToJson(this);

  // API 不帶參數的屬性不傳出
  Map<String, dynamic> toBody() {
    Map<String, dynamic> json = toJson();
    json.removeWhere((key, value) => value == null);
    return json;
  }
}
