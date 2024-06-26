// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ws_agent_member_list_res.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WsAgentMemberListRes _$WsAgentMemberListResFromJson(Map<String, dynamic> json) =>
    WsAgentMemberListRes(
      list: json['list'] == null ? [] : (json['list'] as List).map((info) => AgentMemberInfo.fromJson(info)).toList()
    );

Map<String, dynamic> _$WsAgentMemberListResToJson(WsAgentMemberListRes instance) => 
    <String, dynamic>{
      'list': instance.list
    };

AgentMemberInfo _$AgentMemberInfoFromJson(Map<String, dynamic> json) =>
    AgentMemberInfo(
          id: json['id'] as num?,
          totalAmount: json['totalAmount'] as num?,
          onlineDuration: json['onlineDuration'] as num?,
          pickup: json['pickup'] as num?,
          backPackGiftAmount: json['backPackGiftAmount'] as num?,
          totalAmountWithReward: json['totalAmountWithReward'] as num?,
          nickName: json['nickName'] as String?,
          userName: json['userName'] as String?,
          regTime: json['regTime'] as num?,
          lastLoginTime: json['lastLoginTime'] as num?,
          messageAmount: json['messageAmount'] as num?,
          voiceAmount: json['voiceAmount'] as num?,
          giftAmount: json['giftAmount'] as num?,
          videoAmount: json['videoAmount'] as num?,
          pickupAmount: json['pickupAmount'] as num?,
          avatar: json['avatar'] as String?,
          agentLevel: json['agentLevel'] as num?,
          gender: json['gender'] as num?,
          agentUserId: json['agentUserId'] as num?,
          parent: json['parent'] as num?,
          type: json['type'] as num?,
          feedDonateAmount: json['feedDonateAmount'] as num?
    );

Map<String, dynamic> _$AgentMemberInfoToJson(AgentMemberInfo instance) =>
    <String, dynamic>{
          'id': instance.id,
          'totalAmount': instance.totalAmount,
          'onlineDuration': instance.onlineDuration,
          'pickup': instance.pickup,
          'backPackGiftAmount': instance.backPackGiftAmount,
          'totalAmountWithReward': instance.totalAmountWithReward,
          'nickName': instance.nickName,
          'userName': instance.userName,
          'regTime': instance.regTime,
          'lastLoginTime': instance.lastLoginTime,
          'messageAmount': instance.messageAmount,
          'voiceAmount': instance.voiceAmount,
          'giftAmount': instance.giftAmount,
          'videoAmount': instance.videoAmount,
          'pickupAmount': instance.pickupAmount,
          'avatar': instance.avatar,
          'agentLevel': instance.agentLevel,
          'gender': instance.gender,
          'agentUserId': instance.agentUserId,
          'parent': instance.parent,
          'type': instance.type,
          'feedDonateAmount': instance.feedDonateAmount
    };