import 'package:json_annotation/json_annotation.dart';

part 'ws_agent_reward_ratio_list_res.g.dart';

@JsonSerializable()
class WsAgentRewardRatioListRes {
  WsAgentRewardRatioListRes({
    this.list
  });

  @JsonKey(name: 'list')
  List<AgentRewardRatioInfo>? list;

  factory WsAgentRewardRatioListRes.fromJson(Map<String, dynamic> json) =>
      _$WsAgentRewardRatioListResFromJson(json);
  Map<String, dynamic> toJson() => _$WsAgentRewardRatioListResToJson(this);
}

@JsonSerializable()
class AgentRewardRatioInfo {
  AgentRewardRatioInfo({
    this.createTime,
    this.rewardCondition,
    this.rewardName,
    this.rewardRatio,
    this.saleRewardConfigId,
    this.updateTime,
  });

  /// 建立時間(unix timestamp)
  @JsonKey(name: 'createTime')
  num? createTime;

  /// 升級條件
  @JsonKey(name: 'rewardCondition')
  num? rewardCondition;

  /// 名稱
  @JsonKey(name: 'rewardName')
  String? rewardName;

  /// 收益比率
  @JsonKey(name: 'rewardRatio')
  num? rewardRatio;

  /// pk
  @JsonKey(name: 'saleRewardConfigId')
  num? saleRewardConfigId;

  /// 更新時間(unix timestamp)
  @JsonKey(name: 'updateTime')
  num? updateTime;

  factory AgentRewardRatioInfo.fromJson(Map<String, dynamic> json) =>
      _$AgentRewardRatioInfoFromJson(json);
  Map<String, dynamic> toJson() => _$AgentRewardRatioInfoToJson(this);
}
