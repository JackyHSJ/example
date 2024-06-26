import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frechat/models/deep_link_model.dart';
import 'package:frechat/models/user_info_model.dart';
import 'package:frechat/models/ws_req/contact/ws_contact_search_list_req.dart';
import 'package:frechat/models/ws_res/contact/ws_contact_search_list_res.dart';
import 'package:frechat/system/base_view_model.dart';
import 'package:frechat/system/call_back_function.dart';
import 'package:frechat/system/constant/enum.dart';
import 'package:frechat/system/provider/user_info_provider.dart';
import 'package:frechat/system/providers.dart';
import 'package:frechat/system/repository/http_setting.dart';
import 'package:frechat/system/repository/response_code.dart';
import 'package:frechat/system/util/share_util.dart';

import '../../../models/ws_req/contact/ws_contact_invite_friend_req.dart';
import '../../../models/ws_res/contact/ws_contact_invite_friend_res.dart';

class PersonalInviteFriendViewModel {

  WidgetRef ref;
  ViewChange setState;
  BuildContext context;

  PersonalInviteFriendViewModel({
    required this.ref,
    required this.setState,
    required this.context
  });

  bool isLoading = true;
  String inviteCode = ''; // 邀请碼
  num income = 0; // 收益分成比例
  num deposit = 0; // 充值分成比例
  List<String> ruleData = []; // 規則
  String agentName = '';

  init(InviteFriendType type) async {
    if (type == InviteFriendType.agent) {
      inviteCode = ref.read(userInfoProvider).memberInfo?.agentName ?? '';
    } else if (type == InviteFriendType.contact) {
      inviteCode = ref.read(userInfoProvider).memberInfo?.userName ?? '';
    }
    agentName = ref.read(userInfoProvider).memberInfo?.agentName ?? '';
    await getIncomeAndDeposit();
    ruleDataInit();

    setState(() {});
  }

  void ruleDataInit(){
    ruleData = [
      '1. 邀请的好友每次充值，可获得充值后所消耗的金币的积分返利(百分比依照官方公告为主)。',
      '2. 邀请的好友每次获得收益，可获得每次收益的积分返利(百分比依照官方公告为主)。',
      '3. 邀请的奖励由系统自动发放。',
      '4. 若发现用户在邀请好友过程中，存在违反法律法规、平台规范的行为（包括但不限于：同个用户记使用非法工具分享、下载\'安装\' 注册、登录多账号损害平台合法权益的行为），一经发现，平台有权取消全部奖励、取消活动资格、暂停活动等处理方式，并保留追究其相关法律责任。',
      '5. 邀请好友链接的有效注册时间为24小时。',
      '6. 本活动长期有效，平台对本次活动拥有最终解释权，活动与Apple Inc无关。',
      '7. 举例：',
      '若你邀请的好友充值10000元，消耗了其中的1000金币，您得$deposit%(依照官方公告比例)的收益${1000 * deposit / 100}积分(消耗金币*充值返利比例)',
      '若你邀请的好友获得10000元收益，你得$income%(依照官方公告比例)的收益${10000 * income / 100}积分(收益*收益返利比例)'
    ];
  }

  Future<void> getIncomeAndDeposit() async {
    String resultCodeCheck = '';

    final WsContactInviteFriendReq reqBody = WsContactInviteFriendReq.create();

    final WsContactInviteFriendRes res = await ref.read(contactWsProvider).wsContactInviteFriend(reqBody,
        onConnectSuccess: (succMsg) => resultCodeCheck = succMsg,
        onConnectFail: (errMsg) => resultCodeCheck = errMsg
    );

    if (resultCodeCheck == ResponseCode.CODE_SUCCESS) {
      setState(() {
        income = res.income ?? 0;
        deposit = res.deposit ?? 0;
        isLoading = false;
      });
    } else {
      if (context.mounted) BaseViewModel.showToast(context, ResponseCode.map[resultCodeCheck]!);
    }
  }
}
