import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frechat/screens/cat/ai/ai_chat_room.dart';
import 'package:frechat/screens/strike_up_list/strike_up_list_online_tab.dart';
import 'package:frechat/screens/strike_up_list/strike_up_list_recommend_tab.dart';
import 'package:frechat/screens/strike_up_list/frechat/frechat_strike_up_list_view_model.dart';
import 'package:frechat/screens/strike_up_list/strike_up_list_search_tab.dart';
import 'package:frechat/screens/strike_up_list/strike_up_list_view_model.dart';
import 'package:frechat/system/base_view_model.dart';
import 'package:frechat/system/constant/enum.dart';
import 'package:frechat/system/database/model/chat_message_model.dart';
import 'package:frechat/system/database/model/chat_user_model.dart';
import 'package:frechat/system/provider/user_info_provider.dart';
import 'package:frechat/widgets/banner_view/dismissible_banner_view_icon.dart';
import 'package:frechat/widgets/constant_value.dart';
import 'package:frechat/widgets/shared/img_util.dart';
import 'package:frechat/widgets/shared/main_scaffold.dart';
import 'package:frechat/widgets/shared/main_swiper.dart';
import 'package:frechat/widgets/shared/tab_bar/custom_indicator.dart';
import 'package:frechat/widgets/shared/tab_bar/main_tab_bar.dart';
import 'package:frechat/widgets/strike_up_list/drift/strike_up_list_msg_capsule_drift.dart';
import 'package:frechat/widgets/strike_up_list/frechat/frechat_dismissible_banner_view_icon.dart';
import 'package:frechat/widgets/strike_up_list/frechat/frechat_strike_up_list_mate_components.dart';
import 'package:frechat/widgets/strike_up_list/frechat/frechat_strike_up_list_msg_capsule_drift.dart';
import 'package:frechat/widgets/strike_up_list/frechat/frechat_strike_up_list_online_tab.dart';
import 'package:frechat/widgets/strike_up_list/frechat/frechat_strike_up_list_recommend_tab.dart';
import 'package:frechat/widgets/strike_up_list/frechat/frechat_strike_up_list_search_tab.dart';
import 'package:frechat/widgets/theme/app_box_decoration_theme.dart';
import 'package:frechat/widgets/theme/app_color_theme.dart';
import 'package:frechat/widgets/theme/app_image_theme.dart';
import 'package:frechat/widgets/theme/app_linear_gradient_theme.dart';
import 'package:frechat/widgets/theme/app_text_theme.dart';
import 'package:frechat/widgets/theme/original/app_colors.dart';
import 'package:frechat/widgets/theme/app_theme.dart';
import 'package:frechat/widgets/theme/original/app_images.dart';
import 'package:frechat/widgets/theme/uidefine.dart';
import '../../../models/ws_res/member/ws_member_info_res.dart';
import '../../../system/providers.dart';
import '../../../widgets/strike_up_list/strike_up_list_marquee.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:focus_detector/focus_detector.dart';
import 'package:frechat/widgets/shared/tab_bar/main_tab_bar.dart';

class FrechatStrikeUpList extends ConsumerStatefulWidget {
  const FrechatStrikeUpList({
    super.key,
  });

  @override
  ConsumerState<FrechatStrikeUpList> createState() => _FrechatStrikeUpListState();
}

class _FrechatStrikeUpListState extends ConsumerState<FrechatStrikeUpList> with SingleTickerProviderStateMixin {

  late FrechatStrikeUpListViewModel viewModel;
  late AppTheme theme;
  late AppColorTheme appColorTheme;
  late AppTextTheme appTextTheme;
  late AppImageTheme appImageTheme;
  late AppLinearGradientTheme appLinearGradientTheme;
  late AppBoxDecorationTheme appBoxDecorationTheme;
  late TabController _tabController;
  late ScrollController _recommendScrollController;
  late ScrollController _onlineScrollController;
  num myGender = 0;


  @override
  void initState() {
    viewModel = FrechatStrikeUpListViewModel(ref: ref, context: context, setState: setState);
    _recommendScrollController = ScrollController();
    _onlineScrollController = ScrollController();
    myGender = ref.read(userInfoProvider).memberInfo?.gender ?? 0 ;
    // 女性隱藏搜尋 tab
    if (myGender == 1) {
      _tabController = TabController(length: 3, vsync: this);
    } else {
      _tabController = TabController(length: 2, vsync: this);
    }
    super.initState();
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

    final double paddingHeight = UIDefine.getAppBarHeight() + UIDefine.getStatusBarHeight();
    theme = ref.watch(userInfoProvider).theme ?? AppTheme(themeType: AppThemeType.original);
    appColorTheme = theme.getAppColorTheme;
    appTextTheme = theme.getAppTextTheme;
    appImageTheme = theme.getAppImageTheme;
    appLinearGradientTheme = theme.getAppLinearGradientTheme;
    appBoxDecorationTheme = theme.getAppBoxDecorationTheme;


    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(AppImages.imgStrikeUpListBg), fit: BoxFit.cover, alignment: Alignment.topCenter),
        ),
        child: SafeArea(
          child: NestedScrollView(
            headerSliverBuilder: (context, value) {
              return [_buildMateBtn(), _buildTabBar()];
            },
            body: _buildTabBarView(),
          ),
        )

      ),
      floatingActionButton: _floatingActionButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked
    );
  }

  /// Header - AppBar  (視頻速配 /語音速配 / 跑馬燈)
  Widget _buildMateBtn() {
    /// TODO: 改寫能自適應高度的Sliver
    return const SliverAppBar(
      backgroundColor: Colors.transparent,
      expandedHeight: 96,
      automaticallyImplyLeading: false, // 移除返回箭头
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        background: FrechatStrikeUpListMateComponents(),
      ),
    );
  }

  /// 浮動按鈕
  Widget _floatingActionButton() {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Positioned(
          bottom: 15,
          right: -16,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // 每日顯示可關閉 Banner Icon
              Visibility(visible: true, child: _dailyDismissibleBannerIcon()),
              _unReadMsgSwiper(),
              Visibility(visible: (Platform.isIOS), child: _aiRoom(),),
              _buildTopIcon(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTabBar() {

    List<Tab> tabBarList = [
      const Tab(text: "推荐"),
      const Tab(text: "在线"),
    ];

    if (myGender == 1) tabBarList.add(const Tab(text: "搜寻"));

    return SliverPersistentHeader(
      pinned: true,
      delegate: _PinnedHeaderDelegate(
        bgColor: appColorTheme.appBarBackgroundColor,
        child: MainTabBar(controller: _tabController, tabList: tabBarList).tabBar(
          padding: EdgeInsets.zero,
          dividerColor: Colors.transparent,
          tabAlignment: TabAlignment.start,
          isScrollable: true,
          indicator: CustomIndicator(color: Color(0xff222222), indicatorWidth: 17),
          selectTextStyle: appTextTheme.zoomTabBarSelectTextStyle,
          unSelectTextStyle: appTextTheme.zoomTabBarUnSelectTextStyle,
        ),
      ),
    );
  }

  /// Body - Tab內容(推薦 /在線 / 搜尋)
  Widget _buildTabBarView(){

    List<Widget> tabBarContentList = [
      FrechatStrikeUpListRecommendTab(scrollController: _recommendScrollController), // 推薦列表
      FrechatStrikeUpListOnlineTab(scrollController: _onlineScrollController), // 在線列表
    ];

    if (myGender == 1) {
      // 搜尋列表
      tabBarContentList.add(const FrechatStrikeUpListSearchTab());
    }

    return Container(
      margin: EdgeInsets.only(top: 12.h),
      color: appColorTheme.appBarBackgroundColor,
      child: TabBarView(
        controller: _tabController,
        children: tabBarContentList,
      ),
    );
  }

  /// 浮動按鈕 - 顯示可關閉 Banner Icon
  Widget _dailyDismissibleBannerIcon() {
    WsMemberInfoRes? memberInfo = ref.read(userUtilProvider).memberInfo;
    if (memberInfo != null) {
      return const FrechatDismissibleBannerViewIcon(
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
          margin: EdgeInsets.only(top: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(99),
              topRight: Radius.circular(0),
              bottomRight: Radius.circular(0),
              bottomLeft: Radius.circular(99),
            ),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFFFE7676),
                Color(0xFFFFA09A),
              ],
              stops: [0.0, 1.0],
            ),
          ),
          child: MainSwiper(
            swiperHeight: 46, swiperWidth: 118.w,
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
              child: FrechatStrikeUpListMsgCapsuleDrift(chatUserModel: chatUserList[index]),
            );
          }),
        ),
      );
    });
  }

  /// 浮動按鈕 - AI溝通師
  Widget _aiRoom(){
    return InkWell(
      child: Container(
        margin: EdgeInsets.only(top: 8),
        padding: EdgeInsets.only(left: 10),
        height: 46,
        width: 125,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(99),
            topRight: Radius.circular(0),
            bottomRight: Radius.circular(0),
            bottomLeft: Radius.circular(99),
          ),
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFE96EFD),
              Color(0xFF86C7FF),
            ],
            stops: [0.0, 1.0],
          ),
        ),
        child: Row(
          // mainAxisAlignment: MainAxisAlignment,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 0, right: 0),
              child: ImgUtil.buildFromImgPath('assets/strike_up_list/frechat/icon_ai_star.png', size: 32),
            ),
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

  Widget _buildTopIcon() {
    return InkWell(
        child: Container(
          margin: const EdgeInsets.only(top: 8, right: 8),
          width: 32,
          height: 32,
          child: ImgUtil.buildFromImgPath('assets/icons/icon_top.png', size: 32),
        ),
        onTap: () {
          switch(_tabController.index) {
            case 0:
              _recommendScrollController.animateTo(0.0, duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
              break;
            case 1:
              _onlineScrollController.animateTo(0.0, duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
              break;
          }
        }
    );
  }
}



class _PinnedHeaderDelegate extends SliverPersistentHeaderDelegate {

  final Widget child;
  final Color bgColor;

  _PinnedHeaderDelegate({
    required this.child,
    required this.bgColor,
  });

  @override
  double get minExtent => 40;

  @override
  double get maxExtent => 40;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: bgColor,
      child: child
    );
  }

  @override
  bool shouldRebuild(_PinnedHeaderDelegate oldDelegate) {
    return child != oldDelegate.child;
  }
}
