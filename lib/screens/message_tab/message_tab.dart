import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frechat/models/ws_res/notification/ws_notification_search_list_res.dart';
import 'package:frechat/screens/chatroom/chatroom_viewmodel.dart';
import 'package:frechat/screens/message_tab/call_history_tab.dart';
import 'package:frechat/screens/message_tab/message_list_item.dart';
import 'package:frechat/screens/message_tab/cohesion_tab.dart';
import 'package:frechat/screens/message_tab/message_tab_viewmodel.dart';
import 'package:frechat/screens/profile/friend/personal_friend.dart';
import 'package:frechat/screens/profile/setting/iap/personal_setting_iap.dart';
import 'package:frechat/system/base_view_model.dart';
import 'package:frechat/system/constant/enum.dart';
import 'package:frechat/system/database/model/chat_block_model.dart';
import 'package:frechat/system/database/model/chat_user_model.dart';
import 'package:frechat/system/global.dart';
import 'package:frechat/system/provider/chat_block_model_provider.dart';
import 'package:frechat/system/provider/chat_message_model_provider.dart';
import 'package:frechat/system/provider/chat_user_model_provider.dart';
import 'package:frechat/system/provider/user_info_provider.dart';
import 'package:frechat/system/providers.dart';
import 'package:frechat/system/util/baidu_location_util.dart';
import 'package:frechat/system/zego_call/interal/zim/zim_service.dart';
import 'package:frechat/system/zego_call/zego_provider.dart';
import 'package:frechat/widgets/banner_view/banner_view.dart';
import 'package:frechat/widgets/customunderlinetabindicator.dart';
import 'package:frechat/widgets/shared/bottom_sheet/common_bottom_sheet.dart';
import 'package:frechat/widgets/shared/buttons/common_button.dart';
import 'package:frechat/widgets/shared/dialog/check_dialog.dart';
import 'package:frechat/widgets/shared/buttons/gradient_button.dart';
import 'package:frechat/widgets/shared/dialog/comm_dialog.dart';
import 'package:frechat/widgets/shared/img_util.dart';
import 'package:frechat/widgets/shared/main_scaffold.dart';
import 'package:frechat/widgets/shared/tab_bar/main_tab_bar.dart';
import 'package:frechat/widgets/strike_up_list/top_bottom_pull_loader.dart';
import 'package:frechat/widgets/theme/app_color_theme.dart';
import 'package:frechat/widgets/theme/original/app_colors.dart';
import 'package:frechat/widgets/theme/app_image_theme.dart';
import 'package:frechat/widgets/theme/app_linear_gradient_theme.dart';
import 'package:frechat/widgets/theme/app_text_theme.dart';
import 'package:frechat/widgets/theme/app_theme.dart';
import 'package:frechat/widgets/theme/uidefine.dart';
import 'package:zego_zpns/zego_zpns.dart';
import 'package:uuid/uuid.dart';
import 'package:focus_detector/focus_detector.dart';

/// Home 的 4 個 tab 其中之一:
/// 訊息列表
class MessageTab extends ConsumerStatefulWidget {
  const MessageTab({super.key, this.onJump});

  final Function(num)? onJump;
  @override
  ConsumerState<MessageTab> createState() => _MessageTabState();
}

class _MessageTabState extends ConsumerState<MessageTab> with SingleTickerProviderStateMixin {
  bool isLoading = true;
  List<Map<String, dynamic>> recentlyMessageList = [];
  List<SearchListInfo> searchListInfoList = [];
  late MessageTabViewModel viewModel;
  final ScrollController messageScrollController = ScrollController();
  final ScrollController cohesionScrollController = ScrollController();
  final ScrollController callHistToryScrollController = ScrollController();
  int tabIndex = 0;
  late AppTheme _theme;
  late AppColorTheme _appColorTheme;
  late AppTextTheme _appTextTheme;
  late AppImageTheme _appImageTheme;
  late AppLinearGradientTheme _appLinearGradientTheme;

  // 審核開關
  bool showCallType = false; // 1. 通話
  bool showIntimacyType = false; // 3. 亲密度
  bool showActivityType = false; // 8. 活動播送
  bool showOfficialType = false; // 2. 官方消息

  @override
  void initState() {
    int tabLength = 3;
    showCallType = ref.read(userInfoProvider).buttonConfigList?.callType == 1 ? true : false;
    showIntimacyType = ref.read(userInfoProvider).buttonConfigList?.intimacyType == 1 ? true : false;
    showActivityType = ref.read(userInfoProvider).buttonConfigList?.activityType == 1 ? true : false;
    showOfficialType = ref.read(userInfoProvider).buttonConfigList?.officialType == 1 ? true : false;

    if (!showCallType && showIntimacyType || showCallType && !showIntimacyType) {
      tabLength = 2;
    } else if (!showCallType && !showIntimacyType) {
      tabLength = 1;
    }

    viewModel = MessageTabViewModel(ref: ref, setState: setState, context: context);
    viewModel.init();
    viewModel.initTab(tickerProvider: this, tabLength: tabLength);
    ref.read(trackNavigatorProvider).initAnalyticsMsgTabListenerForTab();
    super.initState();
  }

  @override
  void deactivate() {
    viewModel.deactivate();
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    _theme = ref.watch(userInfoProvider).theme ?? AppTheme(themeType: AppThemeType.original);
    _appColorTheme = _theme.getAppColorTheme;
    _appTextTheme = _theme.getAppTextTheme;
    _appImageTheme = _theme.getAppImageTheme;
    _appLinearGradientTheme = _theme.getAppLinearGradientTheme;
    return SafeArea(
      child: Scaffold(
        body: Consumer(
        builder: (BuildContext context, WidgetRef ref, Widget? child) {
          /// chatUserModel & chatBlockModel只要內容有更新就會泫染畫面
          final chatUserModelList = ref.watch(chatUserModelNotifierProvider);
          final chatBlockModelList = ref.watch(chatBlockModelNotifierProvider);
          /// 判斷 最新訊息不為空 && 是否為blockUser
          final List<ChatUserModel> userModel = viewModel.filterChatUserModelList(chatUserModelList: chatUserModelList, chatBlockModelList: chatBlockModelList);
          return FocusDetector(
              onFocusGained: () => ref.read(userUtilProvider.notifier).setDataToPrefs(currentPage: 0),
              child: Container(
                color: _appColorTheme.appBarBackgroundColor,
                child: Column(
                  children: [
                    tab(chatUserModelList: chatUserModelList, chatBlockModelList: chatBlockModelList),
                    Visibility(visible: showActivityType, child: _bannerView()),
                    tabContent(userModel),
                  ],
                ),
              )
            );
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    viewModel.disposeTab();
    messageScrollController.dispose();
    cohesionScrollController.dispose();
    callHistToryScrollController.dispose();
  }

  //上方頁籤
  Widget tab({
    required List<ChatUserModel> chatUserModelList,
    required List<ChatBlockModel> chatBlockModelList
  }) {
    ///暫解
    //右上角选项
    List<Widget> btItems  = [
      CommonBottomSheetAction(
        title: '一键已读',
        titleStyle:  TextStyle(fontSize: 18.sp, color: _appColorTheme.intimacyRuleContentTitleTextColor, fontWeight: FontWeight.w400),
        onTap: () => viewModel.oneCLickRead(
          _theme, _appColorTheme, _appLinearGradientTheme, _appTextTheme,
          chatUserModelList: chatUserModelList,
          chatBlockModelList: chatBlockModelList,
        )
      ),
      CommonBottomSheetAction(
        title: '清除消息',
        titleStyle:  TextStyle(fontSize: 18.sp, color: _appColorTheme.intimacyRuleContentTitleTextColor, fontWeight: FontWeight.w400),
        onTap: () async{
          viewModel.clearMessage(_theme, _appColorTheme, _appLinearGradientTheme, _appTextTheme);
        },
      ),
    ];
    //上方Tab页签
    List<Tab> tabBarList = [
       const Tab(child: FittedBox(child: Text('消息'))),
      // 如果 showIntimacyType  為 true，則加入 亲密
      if (showIntimacyType)  const Tab(child: FittedBox(child: Text('亲密'))),
      // 如果 showCallType 為 true，則加入 通话
      if (showCallType)  const Tab(child: FittedBox(child: Text('通话'))),
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          width: 220.w,
          child: MainTabBar(controller: messageTabController!, tabList: tabBarList).tabBar(
            indicatorWeight: 0,
            isScrollable: true,
            indicator: CustomUnderlineTabIndicator(color: _appColorTheme.tabBarIndicatorColor),
            selectTextStyle: _appTextTheme.zoomTabBarSelectTextStyle,
            unSelectTextStyle: _appTextTheme.zoomTabBarUnSelectTextStyle,
            dividerColor: Colors.transparent,
            tabAlignment: TabAlignment.start
          ),
        ),

        Row(
          children: [
            InkWell(
              child: Container(
                margin: EdgeInsets.only(right: 12.w),
                child: Image(
                  width: 24.w,
                  height: 24.w,
                  color: _appColorTheme.messageTabActionColor,
                  image: const AssetImage('assets/images/icon_people.png'),
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          const PersonalFriend(tabBarIndex: 0)),
                );
              },
            ),
            InkWell(
              child: Container(
                margin: EdgeInsets.only(right: 10.w),
                child: Image(
                  width: 24.w,
                  height: 24.w,
                  color: _appColorTheme.messageTabActionColor,
                  image: const AssetImage('assets/images/icon_more.png'),
                ),
              ),
              onTap: () {
                CommonBottomSheet.show(context, actions: btItems);
              },
            ),
          ],
        )
      ],
    );
  }

  //廣告條
  _bannerView() {
    return Container(
      margin: EdgeInsets.only(top: 8.h, left: 16.w, right: 16.w, bottom: 8.h),
      child: const BannerView(
        padding: EdgeInsets.all(0.0),
        locatedPageFilter: 3,
        aspectRatio: 3.43,
      ),
    );
  }

  //頁籤內容
  Widget tabContent(List<ChatUserModel> userModel) {
    List<Widget> tabContentList = [
      messageTab(userModel), // 預設情況下都有的 tab
      // 如果 showIntimacyType  為 true，則加入 CohesionTab
      if (showIntimacyType) CohesionTab(tabController: messageTabController, scrollController: cohesionScrollController),
      // 如果 showCallType 為 true，則加入 CallHistToryTab
      if (showCallType) CallHistToryTab(scrollController: callHistToryScrollController),
    ];

    return Expanded(
      child: Stack(
        children: [
          TabBarView(
            controller: messageTabController,
            children: tabContentList,
          ),
          Positioned(
            right:16.w,
            bottom:40.h,
            child: InkWell(
              child: ImgUtil.buildFromImgPath('assets/images/icon_top.png', size: 32.w),
              onTap: () {
                switch(tabIndex) {
                  case 0:
                    messageScrollController.animateTo(0.0, duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
                    break;
                  case 1:
                    cohesionScrollController.animateTo(0.0, duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
                    break;
                  case 2:
                    callHistToryScrollController.animateTo(0.0, duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
                    break;
                }
              }
            ),
          )
        ],
      )
    );
  }

  //消息頁籤(第一頁籤)
  Widget messageTab(List<ChatUserModel> userModel) {
    List<ChatUserModel> userModelList = viewModel.sortChatUsers(userModel);
    return Column(
      children: [
        /// 淨網中心(暂为使用，不确定未来是否重启)
        // Container(
        //   margin: EdgeInsets.only(left: 16.w, right: 16.w, top: 8.h),
        //   clipBehavior: Clip.hardEdge,
        //   decoration: const BoxDecoration(
        //     borderRadius: BorderRadius.all(Radius.circular(10.0)),
        //   ),
        //   child: const Image(
        //     image: AssetImage('assets/images/message_banner.png'),
        //   ),
        // ),
        Expanded(child: (userModel.isNotEmpty) ? ListView.builder(
          // key: Key(const Uuid().v4()),
          shrinkWrap: true, // 让 ListView 根据内容自适应高度
          itemCount: userModelList.length,
          controller: messageScrollController,
          itemBuilder: (context, index) {
            ChatUserModel chatUserModel = userModelList[index];
            SearchListInfo? searchListInfo = viewModel.transferChatUserModelToSearchListInfo(chatUserModel);
            return MessageListItem(
              isSystem: (searchListInfo!.userName == 'java_system') ? true : false,
              searchListInfo: searchListInfo,
              recentlyMessage:chatUserModel.recentlyMessage,
              unRead: (chatUserModel.unRead??0).toInt(),
              isPinTop: chatUserModel.pinTop,
              points: chatUserModel.points,
              timeStamp: (chatUserModel.timeStamp??0).toInt(),
              sendStatus: chatUserModel.sendStatus ?? 1,
            );
          }) : emptyTabContent(MessageTabType.message))
      ],
    );
  }

  //空內容頁籤內容
  Widget emptyTabContent(MessageTabType type) {
    String contentTitle = "您目前暂无消息纪录";
    String contentSubtitle = "快去聊天吧";
    bool showButton = true;
    String image = _appImageTheme.imageMessageEmpty;
    if (type == MessageTabType.cohesion) {
      contentTitle = "亲密度等级≥2级的亲密关系会在这里显示哦~";
      contentSubtitle = '立即聊天，遇见亲密的Ta';
      showButton = true;
      image = 'assets/images/image_call_empty.png';
    } else if (type == MessageTabType.call) {
      contentTitle = '暂无通话纪录';
      contentSubtitle = '快去通话吧';
      showButton = false;
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image(
          width: 150.w,
          height: 150.w,
          image: AssetImage(image),
        ),
        Container(
          margin: EdgeInsets.only(top: 14.h),
          child: Text(
            contentTitle,
            style:  _appTextTheme.messageTabEmptyTitleTextStyle,
          ),
        ),
        Text(
          contentSubtitle,
          style: _appTextTheme.messageTabEmptySubTitleTextStyle,
        ),
        SizedBox(height: 24.h),
        (showButton)
            ? CommonButton(
                btnType: CommonButtonType.text,
                cornerType: CommonButtonCornerType.circle,
                isEnabledTapLimitTimer: false,
                width: 148.w,
                height: 44.h,
                text: '去聊天',
                textStyle: _appTextTheme.buttonPrimaryTextStyle,
                colorBegin: _appLinearGradientTheme.buttonPrimaryColor.colors[0],
                colorEnd: _appLinearGradientTheme.buttonPrimaryColor.colors[1],
                onTap: () {
                  if (type == MessageTabType.cohesion) {
                    messageTabController?.animateTo(0);
                  } else {
                    naviBarController?.jumpToPage(0);
                  }
                })
            : Container()
      ],
    );
  }
}
