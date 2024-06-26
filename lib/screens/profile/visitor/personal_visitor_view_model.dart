


import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frechat/models/certification_model.dart';
import 'package:frechat/models/ws_req/member/ws_member_info_req.dart';
import 'package:frechat/models/ws_req/notification/ws_notification_search_info_with_type_req.dart';
import 'package:frechat/models/ws_req/notification/ws_notification_strike_up_req.dart';
import 'package:frechat/models/ws_req/visitor/ws_visitor_list_req.dart';
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

List<String> visitorTexts = [
  'TA 刚刚访问了你哦！',
  'TA 有可能是你喜欢的类型哦！',
  '同城的 TA 刚刚访问了你呢！',
  '同城的 TA 今天访问你多次哦！',
  '有个 TA 访问你，快看看 TA 是谁',
  'TA对你有兴趣哦!',
  '有个TA默默的访问了你',
  'TA你可能会有兴趣哦!',
  'TA今天访问了你多次呢!',
  '快来认识TA吧!',
];

class PersonalVisitorViewModel {

  ViewChange setState;
  WidgetRef ref;
  BuildContext context;

  PersonalVisitorViewModel({
    required this.ref,
    required this.setState,
    required this.context,
  });

  ScrollController scrollController = ScrollController(); // scroll controller
  List<VisitorInfo> visitorList = []; // 訪客列表
  bool isNoMoreData = false; // 沒有更多
  Random random = Random(); // Random
  List<String> visitorTextList = []; // 訪客文字列表
  num page = 1; // 分頁
  bool isLoading = false; // loading 狀態
  late TaskManager taskManager;


  init() async {
    taskManager = TaskManager();
    _initVisitorList();
    _getVisitorList();
    _initScrollController();
  }

  dispose() {
    scrollController?.dispose();
  }

  _initVisitorList() {
    visitorList = removeDeleteAccountVisitorList(ref.read(userInfoProvider).visitorList?.list ?? []);
    List<String> textList = getRandomTextList(10);
    visitorTextList.addAll(textList);
    setState((){});
  }

  // scrollerController init
  _initScrollController() {
    scrollController.addListener(() {
      if (scrollController.position.atEdge) {
        bool isTop = scrollController.position.pixels == 0;
        if (!isTop) {
          if (isNoMoreData) return;
          setState(() {
            isLoading = true;
          });
          page += 1;
          _getVisitorList();
        }
      }
    });
  }

  // 是否搭訕過
  bool isStrikeUp({required String userName}) {
    final List<ChatUserModel> allChatUserModelList = ref.read(chatUserModelNotifierProvider);
    return allChatUserModelList.any((model) => model.userName == userName);

  }

  // 時間戳
  String getTimeDifferenceString(int timestamp) {
    // 获取当前时间的时间戳
    int currentTimestamp = DateTime.now().millisecondsSinceEpoch;
    // 计算时间差
    Duration difference = Duration(milliseconds: (currentTimestamp - timestamp).abs());
    if (difference.inDays > 0) {
      // 超过一天，返回相差几天
      return '${difference.inDays}天';
    } else if (difference.inHours > 0) {
      // 超过一小时，返回相差几小时
      return '${difference.inHours}小时';
    } else {
      // 不足一小时，返回相差几分钟
      return '${difference.inMinutes}分钟';
    }
  }

  // 隨機自我介紹 list
  List<String> getRandomTextList(int length) {
    List<String> textList = [];

    for (var i = 1; i <= length; i++) {
      int index = random.nextInt(visitorTexts.length);
      String randomText = visitorTexts[index];
      textList.add(randomText);
    }

    return textList;
  }

  // 取得訪客列表
  Future<void> _getVisitorList() async {
    String resultCodeCheck = '';

    final WsVisitorListReq reqBody = WsVisitorListReq.create(page: page.toString());
    final WsVisitorListRes res = await ref.read(visitorWsProvider).wsVisitorList(reqBody,
      onConnectSuccess: (succMsg) => resultCodeCheck = succMsg,
      onConnectFail: (errMsg) => resultCodeCheck = errMsg,
    );

    if (resultCodeCheck == ResponseCode.CODE_SUCCESS) {
      List<VisitorInfo> filterVisitorList = removeDeleteAccountVisitorList(res.list ?? []);
      res.list = filterVisitorList;

      if (page == 1) {
        ref.read(userUtilProvider.notifier).loadVisitorList(res);
        visitorList.clear();
        visitorList.addAll(filterVisitorList ?? []);
      } else {
        List<String> textList = getRandomTextList(10);
        visitorTextList.addAll(textList);
        visitorList.addAll(filterVisitorList ?? []);
        if (filterVisitorList.isEmpty) isNoMoreData = true;
      }
    } else {
      if (context.mounted) {
        BaseViewModel.showToast(context, ResponseCode.map[resultCodeCheck]!);
      }
    }

    await Future.delayed(const Duration(milliseconds: 100));
    isLoading = false;
    setState((){});
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

  // 移除註銷帳號
  List<VisitorInfo> removeDeleteAccountVisitorList(List<VisitorInfo> visitorList) {
    return visitorList = visitorList.where((info) => info.userName != null).toList();
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

  Future<WsMemberInfoRes> getInfoAndGoUserInfoView(String userName) async {
    final reqBody = WsMemberInfoReq.create(userName: userName);
    WsMemberInfoRes memberInfoRes = await ref.read(memberWsProvider).wsMemberInfo(reqBody,
        onConnectSuccess: (succMsg){},
        onConnectFail: (errMsg) {
          BaseViewModel.showToast(context, ResponseCode.map[errMsg]!);
        }
    );
    return memberInfoRes;
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