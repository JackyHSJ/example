import 'package:json_annotation/json_annotation.dart';

part 'ws_agent_reward_ratio_list_req.g.dart';

@JsonSerializable()
class WsAgentRewardRatioListReq {
  WsAgentRewardRatioListReq({
    this.queryDate,
  });

  factory WsAgentRewardRatioListReq.create({
    String? queryDate,
  }) {
    return WsAgentRewardRatioListReq(
      queryDate: queryDate,
    );
  }

  /// 設定日期
  @JsonKey(name: 'queryDate')
  String? queryDate;

  factory WsAgentRewardRatioListReq.fromJson(Map<String, dynamic> json) =>
      _$WsAgentRewardRatioListReqFromJson(json);
  Map<String, dynamic> toJson() => _$WsAgentRewardRatioListReqToJson(this);

  // API 不帶參數的屬性不傳出
  Map<String, dynamic> toBody() {
    Map<String, dynamic> json = toJson();
    json.removeWhere((key, value) => value == null);
    return json;
  }
}
