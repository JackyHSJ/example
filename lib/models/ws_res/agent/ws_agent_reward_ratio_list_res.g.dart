// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ws_agent_reward_ratio_list_res.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WsAgentRewardRatioListRes _$WsAgentRewardRatioListResFromJson(Map<String, dynamic> json) =>
    WsAgentRewardRatioListRes(
      list: json['list'] == null ? [] : (json['list'] as List).map((info) => AgentRewardRatioInfo.fromJson(info)).toList()
    );

Map<String, dynamic> _$WsAgentRewardRatioListResToJson(WsAgentRewardRatioListRes instance) =>
    <String, dynamic>{
      'list': instance.list
    };

AgentRewardRatioInfo _$AgentRewardRatioInfoFromJson(Map<String, dynamic> json) =>
    AgentRewardRatioInfo(
      createTime: json['createTime'] as num?,
      rewardCondition: json['rewardCondition'] as num?,
      rewardName: json['rewardName'] as String?,
      rewardRatio: json['rewardRatio'] as num?,
      saleRewardConfigId: json['saleRewardConfigId'] as num?,
      updateTime: json['updateTime'] as num?,
    );

Map<String, dynamic> _$AgentRewardRatioInfoToJson(AgentRewardRatioInfo instance) =>
    <String, dynamic>{
      'createTime': instance.createTime,
      'rewardCondition': instance.rewardCondition,
      'rewardName': instance.rewardName,
      'rewardRatio': instance.rewardRatio,
      'saleRewardConfigId': instance.saleRewardConfigId,
      'updateTime': instance.updateTime,
    };