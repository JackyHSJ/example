import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frechat/models/certification_model.dart';
import 'package:frechat/models/ws_req/notification/ws_notification_search_list_req.dart';
import 'package:frechat/models/ws_res/greet/ws_greet_module_list_res.dart';
import 'package:frechat/models/ws_res/notification/ws_notification_search_list_res.dart';
import 'package:frechat/screens/chatroom/chatroom.dart';
import 'package:frechat/screens/chatroom/chatroom_viewmodel.dart';
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
import 'package:frechat/system/util/recharge_util.dart';
import 'package:frechat/system/task_manager/task_manager.dart';
import 'package:frechat/widgets/shared/bottom_sheet/recharge/recharge_bottom_sheet.dart';
import 'package:frechat/widgets/shared/dialog/recharge_dialog.dart';
import 'package:frechat/widgets/theme/app_theme.dart';

class StrikeUpListMemberCardViewModel{

  StrikeUpListMemberCardViewModel({required this.setState, required this.ref, required this.taskManager});
  ViewChange setState;
  WidgetRef ref;
  TaskManager taskManager;

  init() {}

  dispose() {}

  ///查詢消息清單(取得亲密度)API 4-1
  Future<SearchListInfo?> getSearchListInfoByRoomID(num roomID) async {
    String resultCodeCheck = '';
    String errorMsgCheck = '';
    final req =
    WsNotificationSearchListReq.create(page: '1', roomId: roomID, type: 0);
    try {
      WsNotificationSearchListRes res = await ref
          .read(notificationWsProvider)
          .wsNotificationSearchList(req,
          onConnectSuccess: (succMsg) => resultCodeCheck = succMsg,
          onConnectFail: (errMsg) => errorMsgCheck = errMsg);
      if (resultCodeCheck == '000') {
        ref.read(userUtilProvider.notifier).loadNotificationListInfo(res);
        if (res.list != null) {
          if (res.list!.isNotEmpty) {
            return res.list![0];
          }
        }
      } else {
        // ignore: avoid_print
        print('wsNotificationSearchList 失敗:$errorMsgCheck');
      }
    } catch (e) {
      // ignore: avoid_print
      print(e.toString());
    }

    return null;
  }

  /// 是否已搭訕/心動
  Future<bool> isAlreadyStrikeUp({required String userName}) async {
    final bool isAlreadyStrikeUp = await ref.read(strikeUpProvider).isAlreadyStrikeUp(userName: userName);
    return isAlreadyStrikeUp;
  }

  /// 開啟聊天室
  Future<SearchListInfo?> openChatRoom({required String userName}) async {
    final List<ChatUserModel> chatUserModelList = ref.watch(chatUserModelNotifierProvider);
    final ChatUserModel currentChatUserModel = chatUserModelList.firstWhere((info) {
      return info.userName == userName;
    });
    SearchListInfo? updateSearchListInfo = ConvertUtil.transferChatUserModelToSearchListInfo(currentChatUserModel);
    return updateSearchListInfo;
  }

  /// 搭訕/心動
  Future<void> strikeUp({required String userName}) async {
    final BuildContext currentContext = BaseViewModel.getGlobalContext();
    /// 乾你娘Benson留地雷
    if(ref.context.mounted == false) {
      return ;
    }
    ref.read(strikeUpProvider).strikeUp(
        userName: userName,
        onSuccess: (searchListInfo) async {
          final isGirl = ref.read(userInfoProvider).memberInfo?.gender == 0;
          if (isGirl) {
            await _sendCommonPhrases(currentContext, searchListInfo: searchListInfo);
          } else {
            await _sendPickUpPhrases(currentContext, searchListInfo: searchListInfo);
          }
          if (currentContext.mounted) {
            final String label = isGirl ? '心动' : '搭讪';
            final String name = searchListInfo?.remark ?? searchListInfo?.roomName ?? '';
            BaseViewModel.showToast(currentContext, '您已$label $name！');
          }
          // setState((){});
        },
        onFail: (msg) {

          // 儲值不足彈窗
          if (msg ==  ResponseCode.CODE_COIN_BALANCE_NOT_ENOUGH){
            _showRechargeDialog();
          }

          // 真人、實名彈窗
          if(msg == ResponseCode.CODE_REAL_PERSON_VERIFICATION_UNDER_REVIEW || msg == ResponseCode.CODE_REAL_NAME_UNDER_REVIEW){
            _showRealPersonDialog();
          }
        });

    taskManager.processQueue();
  }

  /// 真人認證彈窗
  void _showRealPersonDialog(){
    final currentContext = BaseViewModel.getGlobalContext();
    AppTheme theme = ref.read(userInfoProvider).theme ?? AppTheme(themeType: AppThemeType.original);

    DialogUtil.popupRealPersonDialog(theme:theme,context: currentContext, description: '您还未通过真人认证与实名认证，认证完毕后方可传送心动 / 搭讪');
  }

  /// 充值彈窗
  void _showRechargeDialog() {
    final AppTheme theme = ref.watch(userInfoProvider).theme ?? AppTheme(themeType: AppThemeType.original);
    // 充值次數
    final num rechargeCounts =  ref.read(userInfoProvider).memberPointCoin?.depositCount ?? 0;
    // 如果充值次數為 0
    if (rechargeCounts == 0) {
      RechargeUtil.showFirstTimeRechargeDialog('余额不足，请先充值'); // 開啟首充彈窗
    } else {
      RechargeUtil.showRechargeBottomSheet(theme: theme); // 開啟充值彈窗
    }
  }

  ///搭訕常用語
  Future<void> _sendPickUpPhrases(BuildContext context, {SearchListInfo? searchListInfo}) async {
    final ChatRoomViewModel viewModel = ChatRoomViewModel(ref: ref, setState: setState, context: context);
    final String data = await rootBundle.loadString('assets/txt/strike_up_list_pick_up_phrases.txt');
    final List<String> list = const LineSplitter().convert(data);
    final Random random = Random();
    // Api 3-1
    await viewModel.sendTextMessage(
      searchListInfo: searchListInfo,
      message: list[random.nextInt(list.length)],
      contentType: 3,
      isStrikeUp: true,);
    setState((){});
  }

  ///心動常用語(女性)
  Future<void> _sendCommonPhrases(BuildContext context, {SearchListInfo? searchListInfo}) async {
    /// 判斷是否有招呼與設置
    final List<GreetModuleInfo> greetList = ref.read(userInfoProvider).greetModuleList?.list ?? [];
    final ChatRoomViewModel viewModel = ChatRoomViewModel(ref: ref, setState: setState, context: context);

    // 取得正在使用的招呼語 List
    final List<GreetModuleInfo> girlGreet = greetList.where((greet) {
      final authType = CertificationModel.getGreetType(authNum: greet.status ?? 0);
      return CertificationType.using == authType;
    }).toList();

    /// 無設置招呼語
    if (girlGreet.isEmpty) {
      String data = await rootBundle.loadString('assets/txt/strike_up_list_common_phrases.txt');
      List<String> list = const LineSplitter().convert(data);
      Random random = Random();
      // Api 3-1
      await viewModel.sendTextMessage(
        searchListInfo: searchListInfo,
        message: list[random.nextInt(list.length)],
        isStrikeUp: true,
        contentType: 3,);
      setState((){});
      return;
    }

    /// 待補上
    if (girlGreet.first.greetingPic != null) {
      await viewModel.sendImageMessage(
        searchListInfo: searchListInfo,
        unRead: 1,
        isStrikeUp: true,
        imgUrl: girlGreet.first.greetingPic,
      );
    }

    if (girlGreet.first.greetingText != null) {
      await viewModel.sendTextMessage(
        searchListInfo: searchListInfo,
        message: girlGreet.first.greetingText,
        isStrikeUp: true,);
    }

    if (girlGreet.first.greetingAudio != null) {
      await viewModel.sendVoiceMessage(
        searchListInfo: searchListInfo,
        unRead: 1,
        isStrikeUp: true,
        audioUrl: girlGreet.first.greetingAudio?.filePath,
      );
    }

    setState((){});
  }

}