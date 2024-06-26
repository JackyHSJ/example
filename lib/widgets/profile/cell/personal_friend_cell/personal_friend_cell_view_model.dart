


import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frechat/models/certification_model.dart';
import 'package:frechat/models/ws_req/account/ws_account_follow_req.dart';
import 'package:frechat/models/ws_req/member/ws_member_info_req.dart';
import 'package:frechat/models/ws_req/notification/ws_notification_search_info_with_type_req.dart';
import 'package:frechat/models/ws_req/notification/ws_notification_search_list_req.dart';
import 'package:frechat/models/ws_req/notification/ws_notification_strike_up_req.dart';
import 'package:frechat/models/ws_req/visitor/ws_visitor_list_req.dart';
import 'package:frechat/models/ws_res/account/ws_account_follow_res.dart';
import 'package:frechat/models/ws_res/greet/ws_greet_module_list_res.dart';
import 'package:frechat/models/ws_res/member/ws_member_info_res.dart';
import 'package:frechat/models/ws_res/notification/ws_notification_search_info_with_type_res.dart';
import 'package:frechat/models/ws_res/notification/ws_notification_search_list_res.dart';
import 'package:frechat/models/ws_res/notification/ws_notification_strike_up_res.dart';
import 'package:frechat/models/ws_res/visitor/ws_visitor_list_res.dart';
import 'package:frechat/screens/chatroom/chatroom.dart';
import 'package:frechat/screens/chatroom/chatroom_viewmodel.dart';
import 'package:frechat/screens/user_info_view/user_info_view.dart';
import 'package:frechat/system/base_view_model.dart';
import 'package:frechat/system/call_back_function.dart';
import 'package:frechat/system/constant/enum.dart';
import 'package:frechat/system/database/model/chat_user_model.dart';
import 'package:frechat/system/provider/chat_user_model_provider.dart';
import 'package:frechat/system/provider/user_info_provider.dart';
import 'package:frechat/system/providers.dart';
import 'package:frechat/system/repository/response_code.dart';
import 'package:frechat/system/util/convert_util.dart';
import 'package:frechat/system/util/dialog_util.dart';
import 'package:frechat/system/util/real_person_name_auth_util.dart';
import 'package:frechat/system/util/recharge_util.dart';
import 'package:frechat/system/task_manager/task_manager.dart';
import 'package:frechat/widgets/shared/bottom_sheet/recharge/recharge_bottom_sheet.dart';
import 'package:frechat/widgets/shared/dialog/recharge_dialog.dart';
import 'package:frechat/widgets/theme/app_theme.dart';

class PersonalFriendCellViewModel {

  ViewChange setState;
  WidgetRef ref;
  BuildContext context;

  PersonalFriendCellViewModel({
    required this.ref,
    required this.setState,
    required this.context,
  });

  bool isFollow = true;



  Future<SearchListInfo?> getSearchListInfo({required num roomId}) async {
    String? resultCodeCheck;
    final WsNotificationSearchListReq reqBody = WsNotificationSearchListReq.create(page: '1', roomId: roomId);
    final res = await ref.read(notificationWsProvider).wsNotificationSearchList(reqBody,
        onConnectSuccess: (succMsg) => resultCodeCheck = succMsg,
        onConnectFail: (errMsg) => BaseViewModel.showToast(context, ResponseCode.map[errMsg]!)
    );
    if(resultCodeCheck == ResponseCode.CODE_SUCCESS) {
      return res.list?.first;
    }
    return null;
  }

  // 關注或取消 API
  void followFunction(num id) async {
    String resultCodeCheck = '';
    final WsAccountFollowReq reqBody = WsAccountFollowReq.create(isFollow: !isFollow, friendId: id);
    final WsAccountFollowRes res = await ref.read(accountWsProvider).wsAccountFollow(reqBody,
        onConnectSuccess: (succMsg) => resultCodeCheck = succMsg,
        onConnectFail: (errMsg) => resultCodeCheck = errMsg
    );

    if (resultCodeCheck == ResponseCode.CODE_SUCCESS) {
      isFollow = !isFollow;
    } else {
      if (context.mounted) {
        BaseViewModel.showToast(context, ResponseCode.map[resultCodeCheck]!);
      }
    }
    setState(() {});
  }

  // Push 到個人資料頁
  Future<Map> getInfoAndGoUserInfoView(String userName, num roomId) async {
    String resulCodeCheck = '';
    String notificationSearchListResultCodeCheck = '';
    Map map = {};
    final WsMemberInfoReq reqBody = WsMemberInfoReq.create(userName: userName);

    final WsMemberInfoRes memberInfoRes = await ref.read(memberWsProvider).wsMemberInfo(reqBody,
        onConnectSuccess: (succMsg) => resulCodeCheck = succMsg,
        onConnectFail: (errMsg) => BaseViewModel.showToast(context, ResponseCode.map[errMsg]!)
    );

    if (resulCodeCheck == ResponseCode.CODE_SUCCESS){
      final reqBody = WsNotificationSearchListReq.create(page: '1',roomId: roomId);
      WsNotificationSearchListRes notificationSearchListRes = await ref.read(notificationWsProvider).wsNotificationSearchList(reqBody,
          onConnectSuccess: (succMsg) => notificationSearchListResultCodeCheck = succMsg,
          onConnectFail: (errMsg) => BaseViewModel.showToast(context, errMsg));
      if(notificationSearchListResultCodeCheck == ResponseCode.CODE_SUCCESS){
        map['memberInfoRes'] = memberInfoRes;
        map['notificationSearchListRes'] = notificationSearchListRes;
        return map;
      }else{
        return {};
      }
    }else{
      return {};
    }
  }

  // 搭訕/心動
  Future<void> strikeUp({required String userName}) async {
    final num gender = ref.read(userInfoProvider).memberInfo?.gender ?? 0;
    final num realPersonAuth = ref.read(userInfoProvider).memberInfo!.realPersonAuth ?? 0;
    final num realNameAuth = ref.read(userInfoProvider).memberInfo!.realNameAuth ?? 0;
    String authResult = await RealPersonNameAuthUtil.needBothAuth(gender, realPersonAuth, realNameAuth);
    /// 判斷是否有真人與實名認證
    if (authResult != ResponseCode.CODE_SUCCESS) {
      _showRealPersonDialog();
      return;
    }

    final BuildContext currentContext = BaseViewModel.getGlobalContext();
    await ref.read(strikeUpProvider).strikeUp(
        userName: userName,
        onSuccess: (searchListInfo) {
          final isGirl = ref.read(userInfoProvider).memberInfo?.gender == 0;
          if (isGirl) {
            _sendCommonPhrases(currentContext, searchListInfo: searchListInfo);
          } else {
            _sendPickUpPhrases(currentContext, searchListInfo: searchListInfo);
          }
          if (currentContext.mounted) {
            final String label = isGirl ? '心动' : '搭讪';
            final String name = searchListInfo?.remark ?? searchListInfo?.roomName ?? '';
            BaseViewModel.showToast(currentContext, '您已$label $name！');
            setState(() {});
          }
          // setState((){});
        },
        onFail: (msg) {
          if(msg ==  ResponseCode.CODE_COIN_BALANCE_NOT_ENOUGH){
            _showRechargeDialog();
          }
          if(msg == ResponseCode.CODE_REAL_PERSON_VERIFICATION_UNDER_REVIEW || msg == ResponseCode.CODE_REAL_NAME_UNDER_REVIEW){
            _showRealPersonDialog();
            BaseViewModel.showToast(currentContext, '${ResponseCode.map[msg]}');
          }
        });
  }


  // 開啟聊天室
  Future openChatRoom({required String userName}) async {
    final BuildContext currentContext = BaseViewModel.getGlobalContext();
    final List<ChatUserModel> chatUserModelList = ref.watch(chatUserModelNotifierProvider);
    final ChatUserModel currentChatUserModel = chatUserModelList.firstWhere((info) {
      return info.userName == userName;
    });
    SearchListInfo? updateSearchListInfo = ConvertUtil.transferChatUserModelToSearchListInfo(currentChatUserModel);
    if (updateSearchListInfo != null) {
      BaseViewModel.pushPage(currentContext, ChatRoom(unRead: 0, searchListInfo: updateSearchListInfo,));
    }
  }

  // 充值彈窗
  void _showRechargeDialog() {
    // 充值次數
    final num rechargeCounts =  ref.read(userInfoProvider).memberPointCoin?.depositCount ?? 0;
    final AppTheme theme = ref.watch(userInfoProvider).theme ?? AppTheme(themeType: AppThemeType.original);

    // 如果充值次數為 0
    if (rechargeCounts == 0) {
      RechargeUtil.showFirstTimeRechargeDialog('余额不足，请先充值'); // 開啟首充彈窗
    } else {
      RechargeUtil.showRechargeBottomSheet(theme: theme); // 開啟充值彈窗
    }
  }

  // 真人認證彈窗
  void _showRealPersonDialog(){
    final currentContext = BaseViewModel.getGlobalContext();
    AppTheme theme = ref.read(userInfoProvider).theme ?? AppTheme(themeType: AppThemeType.original);

    DialogUtil.popupRealPersonDialog(theme:theme,context: currentContext, description: '您还未通过真人认证与实名认证，认证完毕后方可传送心动 / 搭讪');
  }

  // 心動常用語
  Future<void> _sendCommonPhrases(BuildContext context, {SearchListInfo? searchListInfo}) async {
    /// 判斷是否有招呼與設置
    final List<GreetModuleInfo> greetList = ref
        .read(userInfoProvider)
        .greetModuleList
        ?.list ?? [];
    final ChatRoomViewModel viewModel = ChatRoomViewModel(ref: ref, setState: setState, context: context);
    final girlGreet = greetList.where((greet) {
      final authType = CertificationModel.getGreetType(authNum: greet.status ?? 0);
      return CertificationType.using == authType;
    }).toList();

    /// 無設置招呼語
    if (girlGreet.isEmpty) {
      String data = await rootBundle
          .loadString('assets/txt/strike_up_list_common_phrases.txt');
      List<String> list = const LineSplitter().convert(data);
      Random random = Random();
      //Api 3-1
      viewModel.sendTextMessage(
          searchListInfo: searchListInfo,
          message: list[random.nextInt(list.length)],
          isStrikeUp: true,
          contentType: 3,);
      return;
    }

    /// 待補上
    if (girlGreet.first.greetingPic != null) {
      viewModel.sendImageMessage(
          searchListInfo: searchListInfo,
          unRead: 1,
          isStrikeUp: true,
          imgUrl: girlGreet.first.greetingPic);
    }

    if (girlGreet.first.greetingText != null) {
      viewModel.sendTextMessage(
          searchListInfo: searchListInfo,
          message: girlGreet.first.greetingText,
          isStrikeUp: true,);
    }

    if (girlGreet.first.greetingAudio != null) {
      viewModel.sendVoiceMessage(
          searchListInfo: searchListInfo,
          unRead: 1,
          isStrikeUp: true,
          audioUrl: girlGreet.first.greetingAudio?.filePath);
    }
  }

  // 搭訕常用語
  Future<void> _sendPickUpPhrases(BuildContext context, {SearchListInfo? searchListInfo}) async {
    final ChatRoomViewModel viewModel = ChatRoomViewModel(ref: ref, setState: setState, context: context);
    final String data = await rootBundle.loadString('assets/txt/strike_up_list_pick_up_phrases.txt');
    final List<String> list = const LineSplitter().convert(data);
    final Random random = Random();
    //Api 3-1
    await viewModel.sendTextMessage(
        searchListInfo: searchListInfo,
        message: list[random.nextInt(list.length)],
        contentType: 3,
        isStrikeUp: true,);
  }


}