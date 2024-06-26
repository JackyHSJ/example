

import 'package:frechat/models/ws_res/agent/ws_agent_member_list_res.dart';


extension AgentMemberInfoExtension on AgentMemberInfo {
  AgentMemberInfo toAgentMemberInfo() {
    final AgentMemberInfo agentMemberInfo = AgentMemberInfo(
      id: id,
      totalAmount: totalAmount,
      onlineDuration: onlineDuration,
      pickup: pickup,
      backPackGiftAmount: backPackGiftAmount,
      totalAmountWithReward: totalAmountWithReward,
      nickName: nickName,
      userName: userName,
      regTime: regTime,
      lastLoginTime: lastLoginTime,
      messageAmount: messageAmount,
      voiceAmount: voiceAmount,
      giftAmount: giftAmount,
      videoAmount: videoAmount,
      pickupAmount: pickupAmount,
      avatar: avatar,
      agentLevel: agentLevel,
      gender: gender,
      agentUserId: agentUserId,
      feedDonateAmount: feedDonateAmount,
    );
    return agentMemberInfo;
  }
}