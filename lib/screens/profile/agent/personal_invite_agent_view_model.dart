import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frechat/models/deep_link_model.dart';
import 'package:frechat/models/user_info_model.dart';
import 'package:frechat/models/ws_req/agent/ws_agent_reward_ratio_list_req.dart';
import 'package:frechat/models/ws_req/contact/ws_contact_search_list_req.dart';
import 'package:frechat/models/ws_res/agent/ws_agent_reward_ratio_list_res.dart';
import 'package:frechat/models/ws_res/contact/ws_contact_search_list_res.dart';
import 'package:frechat/system/base_view_model.dart';
import 'package:frechat/system/call_back_function.dart';
import 'package:frechat/system/constant/enum.dart';
import 'package:frechat/system/payment/wechat/wechat_manager.dart';
import 'package:frechat/system/provider/user_info_provider.dart';
import 'package:frechat/system/providers.dart';
import 'package:frechat/system/repository/http_setting.dart';
import 'package:frechat/system/repository/response_code.dart';
import 'package:frechat/system/util/date_format_util.dart';
import 'package:frechat/system/util/share_util.dart';

import '../../../models/ws_req/contact/ws_contact_invite_friend_req.dart';
import '../../../models/ws_res/contact/ws_contact_invite_friend_res.dart';

class PersonalInviteAgentViewModel {

  WidgetRef ref;
  ViewChange setState;
  BuildContext context;

  PersonalInviteAgentViewModel({
    required this.ref,
    required this.setState,
    required this.context
  });

  bool isLoading = true;
  String inviteCode = ''; // 邀請碼
  num income = 0; // 收益
  num deposit = 0; // 充值
  List<String> ruleData = []; // 規則
  String agentName = '';

  List<AgentRewardRatioInfo?> agentRewardRatioList = [];
  AgentRewardRatioInfo? currentAgentRewardRatioLevel;
  AgentRewardRatioInfo? nextAgentRewardRatioLevel;
  // AgentRewardRatioInfo? highestAgentRewardRatioLevel;

  init(InviteFriendType type) async {
    if (type == InviteFriendType.agent) {
      inviteCode = ref.read(userInfoProvider).memberInfo?.agentName ?? '';
      agentName = ref.read(userInfoProvider).memberInfo?.agentName ?? '';
    } else if (type == InviteFriendType.contact) {
      inviteCode = ref.read(userInfoProvider).memberInfo?.userName ?? '';
    }
    await getAgentRewardRatioList();
    ruleDataInit();


    setState(() {});
  }

  void ruleDataInit(){
    ruleData = [
      '1. 邀请的成员每次获得收益，可获得每次收益的积分返利(百分比依照官方公告为主)。',
      '2. 若发现用户在邀请成员过程中，存在违反法律法规、平台规范的行为（包括但不限于：同个用户记使用非法工具分享、下载\'安装\' 注册、登录多账号损害平台合法权益的行为），一经发现，平台有权取消全部奖励、取消活动资格、暂停活动等处理方式，并保留追究其相关法律责任。',
      '3. 本活动长期有效，平台对本次活动拥有最终解释权，活动与Apple Inc无关。',
      '4. 级别、团队总收益与返利说明(依据官方公告为主):',
    ];
  }

  // 16-6
  Future<void> getAgentRewardRatioList() async {
    String resultCodeCheck = '';

    // ken 說不用帶 queryDate
    // DateTime today = DateTime.now();
    // final String queryDate = DateFormatUtil.getDateWith24HourFormat(today); // YYYY-MM-DD

    final WsAgentRewardRatioListReq reqBody = WsAgentRewardRatioListReq.create();

    final WsAgentRewardRatioListRes res = await ref.read(agentWsProvider).wsAgentRewardRatioList(reqBody,
        onConnectSuccess: (succMsg) => resultCodeCheck = succMsg,
        onConnectFail: (errMsg) => resultCodeCheck = errMsg
    );

    if (resultCodeCheck == ResponseCode.CODE_SUCCESS) {
      // num totalBonus = res.totalBonus ?? 0;
      // num totalBonus = 101;

      num totalBonus = 0;
      final num? agentLevel = ref.read(userInfoProvider).memberInfo?.agentLevel;
      final num todayIncome = ref.read(userInfoProvider).agentPromoterInfo?.todayIncome ?? 0;
      final num todayPrimaryIncome = ref.read(userInfoProvider).agentPromoterInfo?.todayPrimaryIncome ?? 0;

      // http://redmine.zyg.com.tw/issues/1776
      if (agentLevel == 1) {
        totalBonus = todayIncome; // 一級帶 todayIncome
      } else if (agentLevel == 2) {
        totalBonus = todayPrimaryIncome; // 二級帶 todayPrimaryIncome
      }



      agentRewardRatioList = res.list!;

      try {
        nextAgentRewardRatioLevel = res.list?.firstWhere((item) => item!.rewardCondition! > totalBonus);
      } catch(e) {print(e.toString());}

      try {
        final int resultIndex = res.list?.indexWhere((item) => item.rewardCondition == totalBonus) ?? -1; // totalBonus 剛好等於 rewardCondition 的狀況
        if (resultIndex != -1) {
          currentAgentRewardRatioLevel =  res.list?[resultIndex];
        } else {
          currentAgentRewardRatioLevel =  res.list?.lastWhere((item) => item!.rewardCondition! < totalBonus);
        }
      } catch (e) {print(e.toString());}

      isLoading = false;
      ref.read(userUtilProvider.notifier).loadAgentRewardRatioList(res);
      setState(() {});
    } else {
      if (context.mounted) BaseViewModel.showToast(context, ResponseCode.map[resultCodeCheck]!);
    }
  }
}
