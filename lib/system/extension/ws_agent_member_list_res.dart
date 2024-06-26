

import 'package:frechat/models/ws_res/agent/ws_agent_member_list_res.dart';

typedef AgentMemberInfoSelector = num Function(AgentMemberInfo item);

extension WsAgentMemberListResExtension on WsAgentMemberListRes {
  num getSumTotalAmount(AgentMemberInfoSelector selector) {
    num sum = 0;
    list?.forEach((info) {
      sum += selector(info);
    });
    return sum;
  }
}
