import 'package:frechat/system/constant/enum.dart';
import 'package:json_annotation/json_annotation.dart';

part 'ws_agent_member_list_req.g.dart';

@JsonSerializable()
class WsAgentMemberListReq {
  WsAgentMemberListReq({
    this.sort,
    this.dir,
    this.page,
    this.size,
    this.profit,
    this.startDate,
    this.endDate,
    this.userName,
    this.userId,
    this.mode,
  });

  factory WsAgentMemberListReq.create({
    String? sort,
    String? dir,
    String? page,
    num? size,
    String? profit,
    String? startDate,
    String? endDate,
    String? userName,
    String? userId,
    AgentMemberListMode? agentMemberListMode,
  }) {
    String? getAgentMemberListModeString(AgentMemberListMode? mode) {
      switch (mode) {
        case AgentMemberListMode.friends:
          return 'friends';
        case AgentMemberListMode.primaryPromotor:
          return 'primaryPromotor';
        case AgentMemberListMode.agent:
          return 'agent';
        case AgentMemberListMode.secondaryAgent:
          return 'secondaryAgent';
        default:
          return null;
      }
    }

    final String? mode = getAgentMemberListModeString(agentMemberListMode);
    return WsAgentMemberListReq(
      sort: sort,
      dir: dir,
      page: page,
      size: size,
      profit: profit,
      startDate: startDate,
      endDate: endDate,
      userName: userName,
      userId: userId,
      mode: mode
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

  /// 使用ID查詢 (非必填預設為全部)
  @JsonKey(name: 'userName')
  String? userName;

  /// 使用userId尋找其中某一個成員的下線名單，(非必填預設為登入者)
  @JsonKey(name: 'userId')
  String? userId;

  /// 是否為好友(
  /// "friends": 一級好友成員列表
  /// "primaryPromotor": 一級推廣人脈
  /// "agent": 二級推廣
  /// null: 同時查詢二級規廣跟一級推廣人脈
  @JsonKey(name: 'mode')
  String? mode;

  factory WsAgentMemberListReq.fromJson(Map<String, dynamic> json) =>
      _$WsAgentMemberListReqFromJson(json);
  Map<String, dynamic> toJson() => _$WsAgentMemberListReqToJson(this);

  // API 不帶參數的屬性不傳出
  Map<String, dynamic> toBody() {
    Map<String, dynamic> json = toJson();
    json.removeWhere((key, value) => value == null);
    return json;
  }
}
