
import 'package:frechat/models/ws_res/agent/ws_agent_member_list_res.dart';
import 'package:frechat/system/constant/enum.dart';

class AgentTagModel {
  static AgentTagType getType({
    required num myUserId,
    required AgentMemberInfo info
  }) {
    /// 一級視角
    if(info.agentLevel == null && info.agentUserId == myUserId && info.parent == myUserId){
      // 推广人脉 16-4
      return AgentTagType.agentContact;
    }
    if(info.agentLevel == 2 && info.parent == myUserId){
      // 二级推广员 16-3
      return AgentTagType.level2Agent;
    }

    /// 一級推广人脉 普通好友
    if(info.agentLevel == null){
      return AgentTagType.normalFriend;
    }
    if(info.agentLevel == 2 ){
      return AgentTagType.level2Agent;
    }

    /// 二級視角
    if(info.agentLevel == null && info.agentUserId == myUserId && info.parent == myUserId){
      // 二级推广人脉  16-4
      return AgentTagType.level2AgentContact;
    }
    if(info.agentLevel == null && info.agentUserId != myUserId && info.parent != myUserId){
      // 二级好友人脉 16-3
      return AgentTagType.level2FriendContact;
    }

    return AgentTagType.normalFriend;
  }
}

/// 一級視角
/// if(agentLevel==null && agentUserId==userId ){
/// 推广人脉}
/// if(agentLevel==2 ){
/// 二级推广员}
///
/// 二級視角
/// if(agentLevel==null && agentUserId==userId ){
/// 二级推广人脉}
/// if(agentLevel==null && agentUserId!=userId){
/// 二级好友人脉}