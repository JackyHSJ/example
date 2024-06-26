import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frechat/models/ws_req/contact/ws_contact_invite_friend_req.dart';
import 'package:frechat/models/ws_req/contact/ws_contact_search_form_req.dart';
import 'package:frechat/models/ws_req/contact/ws_contact_search_list_req.dart';
import 'package:frechat/models/ws_res/contact/ws_contact_invite_friend_res.dart';
import 'package:frechat/models/ws_res/contact/ws_contact_search_form_res.dart';
import 'package:frechat/models/ws_res/contact/ws_contact_search_list_res.dart';
import 'package:frechat/system/base_view_model.dart';
import 'package:frechat/system/call_back_function.dart';
import 'package:frechat/system/provider/user_info_provider.dart';
import 'package:frechat/system/providers.dart';
import 'package:frechat/system/repository/response_code.dart';

class PersonalContactViewModel {

  WidgetRef ref;
  ViewChange setState;
  BuildContext context;

  PersonalContactViewModel({
    required this.ref,
    required this.setState,
    required this.context
  });

  num todayRevenue = 0;
  num lastWeekRevenue = 0;
  num thisWeekRevenue = 0;
  WsContactSearchListRes? contactSearchListRes;
  List<ContactListInfo> contactList = [];
  bool isNoMoreData = false;
  String page ='1';
  List<String> ruleData = []; // 規則
  num income = 0; // 收益分成比例
  num deposit = 0; // 充值分成比例

  init() async {
    await getIncomeAndDeposit();
    ruleDataInit();
    contactSearchListRes = ref.read(userInfoProvider).contactSearchList;
    contactList = ((contactSearchListRes != null)? contactSearchListRes?.list : []) ?? [];

    WsContactSearchFormRes? contactSearchForm = ref.read(userInfoProvider).contactSearchForm;
    if(contactList.length == 10){
      int intValue = int.parse(page);
      intValue++;
      page = intValue.toString();
    }
    searchContactList();
    wsContactSearchForm();
    // if(contactList.length == contactSearchListRes!.fullListSize){
    //   isNoMoreData = true;
    // }else{
    //   searchContactList();
    // }

    todayRevenue = (contactSearchForm!=null)? contactSearchForm.todayRevenue ?? 0 : 0;
    lastWeekRevenue = (contactSearchForm!=null)? contactSearchForm.lastWeekRevenue ?? 0 : 0;
    thisWeekRevenue = (contactSearchForm!=null)? contactSearchForm.thisWeekRevenue ?? 0 : 0;
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
      });
    } else {
      if (context.mounted) BaseViewModel.showToast(context, ResponseCode.map[resultCodeCheck]!);
    }
  }



  Future<void> searchContactList() async {
    String resultCodeCheck = '';
    final reqBody = WsContactSearchListReq.create(page: page, size: '10');
    final res = await ref.read(contactWsProvider).wsContactSearchList(reqBody,
        onConnectSuccess: (succMsg) => resultCodeCheck = succMsg,
        onConnectFail: (errMsg) => resultCodeCheck = errMsg
    );

    if (resultCodeCheck == ResponseCode.CODE_SUCCESS) {
      if(contactList.length == res.fullListSize){
        isNoMoreData = true;
      }else{
        if(contactList.length == 10){
          contactList.addAll(res.list!);
        }else{
          contactList = res.list!;
        }
        int intValue = int.parse(page);
        intValue++;
        page = intValue.toString();
      }
      final WsContactSearchListRes searchList = WsContactSearchListRes(
        pageNumber: contactSearchListRes?.pageNumber,
        totalPages: contactSearchListRes?.totalPages,
        fullListSize: contactSearchListRes?.fullListSize,
        pageSize: contactSearchListRes?.pageSize,
        count: contactSearchListRes?.count,
        list: contactList,
      );
      ref.read(userUtilProvider.notifier).loadContactSearchList(searchList);

      setState((){});
    } else {
      BaseViewModel.showToast(context, ResponseCode.map[resultCodeCheck]!);
    }
  }

  Future<void> wsContactSearchForm() async {
    String resultCodeCheck = '';

    final WsContactSearchFormReq reqBody = WsContactSearchFormReq.create();
    final WsContactSearchFormRes res = await ref.read(contactWsProvider).wsContactSearchForm(reqBody,
        onConnectSuccess: (succMsg) => resultCodeCheck = succMsg,
        onConnectFail: (errMsg) => resultCodeCheck = errMsg
    );

    if (resultCodeCheck == ResponseCode.CODE_SUCCESS) {
      todayRevenue = res.todayRevenue!;
      lastWeekRevenue = res.lastWeekRevenue!;
      thisWeekRevenue = res.thisWeekRevenue!;
      ref.read(userUtilProvider.notifier).loadContactSearchForm(res);
    } else {
      BaseViewModel.showToast(context, ResponseCode.map[resultCodeCheck]!);
    }

  }
}
