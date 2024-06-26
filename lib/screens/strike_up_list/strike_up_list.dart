
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frechat/screens/cat/ai/ai_chat_room.dart';
import 'package:frechat/screens/strike_up_list/strike_up_list_online_tab.dart';
import 'package:frechat/screens/strike_up_list/strike_up_list_recommend_tab.dart';
import 'package:frechat/screens/strike_up_list/strike_up_list_search_tab.dart';
import 'package:frechat/screens/strike_up_list/strike_up_list_view_model.dart';
import 'package:frechat/system/base_view_model.dart';
import 'package:frechat/system/constant/enum.dart';
import 'package:frechat/system/database/model/chat_message_model.dart';
import 'package:frechat/system/database/model/chat_user_model.dart';
import 'package:frechat/system/provider/user_info_provider.dart';
import 'package:frechat/widgets/banner_view/dismissible_banner_view_icon.dart';
import 'package:frechat/widgets/shared/main_swiper.dart';
import 'package:frechat/widgets/shared/tab_bar/custom_indicator.dart';
import 'package:frechat/widgets/shared/tab_bar/main_tab_bar.dart';
import 'package:frechat/widgets/strike_up_list/drift/strike_up_list_msg_capsule_drift.dart';
import 'package:frechat/widgets/theme/app_box_decoration_theme.dart';
import 'package:frechat/widgets/theme/app_color_theme.dart';
import 'package:frechat/widgets/theme/app_text_theme.dart';
import 'package:frechat/widgets/theme/original/app_colors.dart';
import 'package:frechat/widgets/theme/app_theme.dart';
import '../../models/ws_res/member/ws_member_info_res.dart';
import '../../system/providers.dart';
import '../../widgets/strike_up_list/strike_up_list_marquee.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:focus_detector/focus_detector.dart';


/// Home 的 4 個 tab 其中之一:
/// 搭訕列表頁
class StrikeUpList extends ConsumerStatefulWidget {
  const StrikeUpList({
    super.key,
  });

  @override
  ConsumerState<StrikeUpList> createState() => _StrikeUpListState();
}

class _StrikeUpListState extends ConsumerState<StrikeUpList> with SingleTickerProviderStateMixin {

  late StrikeUpListViewModel viewModel;
  late TabController _tabController;
  late ScrollController _recommendScrollController;
  late ScrollController _onlineScrollController;

  // 審核開關
  bool showTvWallType = false; // 4. 電視牆
  bool showMateType = false; // 5. 速配
  bool showActivityType = false; // 8. 活動播送
  num myGender = 0;

  late AppTheme _theme;
  late AppColorTheme _appColorTheme;
  late AppTextTheme _appTextTheme;
  late AppBoxDecorationTheme _appBoxDecorationTheme;

  /// 取得SliverAppBar高度（速配+電視牆）
  /// TODO: 改寫能自適應高度的Sliver
  double _getSliverAppBarHeight(){
    double height;
    double mateHeight = 102.h;
    double tvWallHeight = 74.h;
    switch(_theme.themeType){
      case AppThemeType.original:
        mateHeight = 120.h;
        break;
      case AppThemeType.yueyuan:
        mateHeight = 100.h;
        break;
      case AppThemeType.dogVersion:
        mateHeight = 158.h;
        tvWallHeight = 84.h;
        break;
      case AppThemeType.catVersion:
        mateHeight = 158.h;
        tvWallHeight = 84.h;
        break;
      default:
        break;
    }
    if(showMateType && showTvWallType) {
      //顯示速配與上電視
      height = mateHeight + tvWallHeight;
    }else if(!showMateType && showTvWallType){
      //顯示上電視
      height = tvWallHeight;
    }else if(showMateType && !showTvWallType){
      //顯示速配
      height = mateHeight;
    }else{
      height = 0;
    }
    return height;
  }

  @override
  void initState() {
    super.initState();
    viewModel = StrikeUpListViewModel(ref: ref, setState: setState);
    viewModel.init();
    myGender = ref.read(userInfoProvider).memberInfo?.gender ?? 0 ;
    _recommendScrollController = ScrollController();
    _onlineScrollController = ScrollController();

    // 女性隱藏搜尋 tab
    if (myGender == 1) {
      _tabController = TabController(length: 3, vsync: this);
    } else {
      _tabController = TabController(length: 2, vsync: this);
    }

    // 審核開關
    showTvWallType = ref.read(userInfoProvider).buttonConfigList?.tvWallType == 1 ? true : false;
    showMateType = ref.read(userInfoProvider).buttonConfigList?.mateType == 1 ? true : false;
    showActivityType = ref.read(userInfoProvider).buttonConfigList?.activityType == 1 ? true : false;
  }

  @override
  void dispose() {
    _tabController?.dispose();
    _recommendScrollController?.dispose();
    _onlineScrollController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    _theme = ref.watch(userInfoProvider).theme ?? AppTheme(themeType: AppThemeType.original);
    _appColorTheme = _theme.getAppColorTheme;
    _appTextTheme = _theme.getAppTextTheme;
    _appBoxDecorationTheme = _theme.getAppBoxDecorationTheme;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: NestedScrollView(
          headerSliverBuilder: (context, value) {
            return [_appBar(), _tabBar(),];
          },
          body: _tabContent(),
        ),
        floatingActionButton: _floatingActionButton(),
        ), //
      );
  }

  /// Header - AppBar  (視頻速配 /語音速配 / 跑馬燈)
  Widget _appBar() {
    /// TODO: 改寫能自適應高度的Sliver
    return SliverAppBar(
      backgroundColor:  _appColorTheme.appBarBackgroundColor,
      expandedHeight: _getSliverAppBarHeight(),
      automaticallyImplyLeading: false, // 移除返回箭头
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        background: Container(
          color: _appColorTheme.appBarBackgroundColor,
          child: Column(
            children: [
              Visibility(visible: showMateType, child: _theme.getAppComponentsTheme.strikeUpListMateComponents),
              Visibility(visible: (showMateType && showTvWallType), child: SizedBox(height: 12.h)),
              Visibility(visible: showTvWallType, child: _marqueeBanner()),// 跑馬燈
            ],
          ),
        ),
      ),
    );
  }

  /// Header - 跑馬燈(如何上電視)
  Widget _marqueeBanner() {
    return const Flexible(
      child: StrikeUpListMarquee(),
    );
  }

  /// Header - TabBar(切換 推薦 /在線 / 搜尋)
  Widget _tabBar() {
    List<Tab> tabBarList = [
      const Tab(text: "推荐"),
      const Tab(text: "在线"),
    ];

    if (myGender == 1) tabBarList.add(const Tab(text: "搜寻"));


    return SliverPersistentHeader(
      pinned: true,
      delegate: _PinnedHeaderDelegate(
        child: Container(
          color: _appColorTheme.appBarBackgroundColor,
          height: 50,
          child: MainTabBar(controller: _tabController, tabList: tabBarList).tabBar(
            padding: EdgeInsets.zero,
            dividerColor: Colors.transparent,
            tabAlignment: TabAlignment.start,
            isScrollable: true,
            indicator: CustomIndicator(color: _appColorTheme.tabBarIndicatorColor,indicatorWidth: 10.w),
            selectTextStyle: _appTextTheme.zoomTabBarSelectTextStyle,
            unSelectTextStyle: _appTextTheme.zoomTabBarUnSelectTextStyle,
          ),
        ),
      ),
    );
  }

  /// Body - Tab內容(推薦 /在線 / 搜尋)
  Widget _tabContent(){


    List<Widget> tabBarContentList = [
      StrikeUpListRecommendTab(scrollController: _recommendScrollController), // 推薦列表
      StrikeUpListOnlineTab(scrollController: _onlineScrollController), // 在線列表
    ];

    if (myGender == 1) {
      // 搜尋列表
      tabBarContentList.add(const StrikeUpListSearchTab());
    }

    return Container(
      color: _appColorTheme.appBarBackgroundColor,
      child: TabBarView(
        controller: _tabController,
        children: tabBarContentList,
      ),
    );
  }

  /// 浮動按鈕
  Widget _floatingActionButton(){
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        // 每日顯示可關閉 Banner Icon
        Visibility(visible: showActivityType, child: _dailyDismissibleBannerIcon()),
        _unReadMsgSwiper(),
        Visibility(visible: (Platform.isIOS), child: _aiRoom(),),
      ],
    );
  }

  /// 浮動按鈕 - AI溝通師
  Widget _aiRoom(){
    return InkWell(
      child: Container(
        margin: EdgeInsets.only(top: 8.h),
        height: 40.h,
        width: 118.w,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            gradient: const LinearGradient(
              colors: [
                Color.fromRGBO(55, 175, 243, 1),
                Color.fromRGBO(205, 157, 251, 1),
              ],
              begin: Alignment.bottomLeft,
              end: Alignment.topRight,
            )
        ),
        child: Row(
          children: [
            Padding(padding: EdgeInsets.only(left: 4.w,right: 6.w),child: Image(
              width: 32.w,
              height: 32.w,
              image: const AssetImage('assets/cat/cat_ai_star.png'),
            )),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('A.I 沟通师',
                    style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        fontSize: 12.sp
                    )),
                Text('为您解惑一切',
                    style: TextStyle(
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                        fontSize: 12.sp
                    )),
              ],
            )
          ],
        ),
      ),
      onTap: () => BaseViewModel.pushPage(context, const AiChatRoom()),
    );
  }

  /// 浮動按鈕 - 顯示可關閉 Banner Icon
  Widget _dailyDismissibleBannerIcon() {
    WsMemberInfoRes? memberInfo = ref.read(userUtilProvider).memberInfo;
    if (memberInfo != null) {
      return const DismissibleBannerViewIcon(
        locatedPageFilter: 6,
        dismissible: true,
      );
    } else {
      return const SizedBox.shrink();
    }
  }

  /// 浮動按鈕 - 未讀訊息
  Widget _unReadMsgSwiper() {
    return Consumer(builder: (context, ref, _) {
      final List<ChatUserModel> chatUserList = viewModel.loadUnReadLastMsgList();
      return Visibility(
        maintainSize: true,
        maintainAnimation: true,
        maintainState: true,
        visible: (chatUserList.isNotEmpty),
        child: Container(
          decoration: _appBoxDecorationTheme.unReadMsgSwiperBoxDecoration,
          child: MainSwiper(
            swiperHeight: 40.h, swiperWidth: 118.w,
            scale: 1, viewportFraction: 1,
            enablePagination: false,
            autoplay: true,
            scrollDirection: Axis.vertical,
            // controller: viewModel.unReadMsgController!,
            itemCount: chatUserList.length,
          ).build(itemBuilder: (context, index) {
            String? name = chatUserList[index].userName;
            if(chatUserList[index].roomName != null){
              name = chatUserList[index].roomName;
              if(chatUserList[index].remark != null){
                name = chatUserList[index].remark;
              }
            }
            // final String pushTargetUserName = chatUserList[index].remark ??  chatUserList[index].roomName ?? chatUserList[index].userName;
            return InkWell(
              onTap: () => viewModel.pushToChatRoom(chatUserList[index]),
              child: StrikeUpListMsgCapsuleDrift(chatUserModel: chatUserList[index]),
            );
          }),
        ),
      );
    });
  }
}

class _PinnedHeaderDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;

  _PinnedHeaderDelegate({required this.child});

  @override
  double get minExtent => 50;

  @override
  double get maxExtent => 50;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      child: child,
    );
  }

  @override
  bool shouldRebuild(_PinnedHeaderDelegate oldDelegate) {
    return child != oldDelegate.child;
  }
}
