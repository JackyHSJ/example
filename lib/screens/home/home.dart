import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:frechat/screens/activity/activity_browser.dart';
import 'package:frechat/screens/cat/cat_videos/cat_videos.dart';
import 'package:frechat/screens/home/home_view_model.dart';
import 'package:frechat/screens/meet/meet_page.dart';
import 'package:frechat/screens/message_tab/message_tab.dart';
import 'package:frechat/screens/profile/personal_profile.dart';
import 'package:frechat/screens/profile/setting/teen/personal_setting_teen.dart';
import 'package:frechat/screens/strike_up_list/strike_up_list.dart';
import 'package:frechat/screens/strike_up_list/frechat/frechat_strike_up_list.dart';
import 'package:frechat/screens/version_update_reminder/version_update_reminder.dart';
import 'package:frechat/system/base_view_model.dart';
import 'package:frechat/system/constant/enum.dart';

import 'package:frechat/system/global.dart';
import 'package:frechat/system/provider/user_info_provider.dart';
import 'package:frechat/system/providers.dart';
import 'package:frechat/system/widget_binding/app_lifecycle.dart';

import 'package:frechat/widgets/shared/img_util.dart';
import 'package:frechat/widgets/theme/app_box_decoration_theme.dart';
import 'package:frechat/widgets/theme/app_color_theme.dart';
import 'package:frechat/widgets/theme/app_image_theme.dart';
import 'package:frechat/widgets/theme/app_theme.dart';
import 'package:frechat/widgets/constant_value.dart';
import 'package:frechat/widgets/theme/uidefine.dart';

import 'package:frechat/models/ws_res/mission/ws_mission_search_status_res.dart';
import 'package:frechat/models/res/member_register_res.dart';
import 'package:page_transition/page_transition.dart';



/// 首頁，這就是你登入成功後後看到的那個頁面，有四個 tab
class Home extends ConsumerStatefulWidget {
  const Home({super.key, required this.showAdvertise, this.defIndex});

  final int? defIndex;
  final bool showAdvertise;

  @override
  ConsumerState<Home> createState() => _HomeState();
}

class _HomeState extends ConsumerState<Home> with AfterLayoutMixin, RouteAware, WidgetsBindingObserver {

  // Theme
  late AppTheme theme;
  late AppColorTheme appColorTheme;
  late AppImageTheme appImageTheme;
  late AppBoxDecorationTheme appBoxDecorationTheme;


  late HomeViewModel viewModel;

  // Tab
  int currentPageIndex = 0;
  String strikeUp = '';
  String activity = '';
  String video = '';
  String message = '';
  String profile = '';

  // Android
  List<Color> selectedColorsAndroid = [
    const Color(0xffFD73A5),
    const Color(0xff58CE80),
    const Color(0xff647DF6),
    const Color(0xffF5C370)
  ];

  List<Widget> _screensAndroid = [
    const StrikeUpList(),
    const ActivityBrowser(),
    const MessageTab(),
    const PersonalProfile(),
  ];

  // IOS
  List<Color> selectedColorsIOS = [
    const Color(0xffFD73A5),
    const Color(0xff58CE80),
    const Color(0xffab9ef2),
    const Color(0xff647DF6),
    const Color(0xffF5C370)
  ];

  List<Widget> _screensIOS = [
    const StrikeUpList(),
    const ActivityBrowser(),
    const CatVideos(),
    const MessageTab(),
    const PersonalProfile(),
  ];



  @override
  void initState() {
    initTabBar();
    viewModel = HomeViewModel(ref: ref, setState: setState);
    viewModel.init(context);

    viewModel.initNaviBarPageController();
    viewModel.initNaviBarPageListener();

    /// app 背景監聽
    AppLifecycle.init(this);
    super.initState();
  }


  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    AppLifecycle.addListener(context, ref: ref, state: state);
  }

  @override
  void dispose() {
    viewModel.dispose();
    viewModel.disposeNaviBarPageController();

    /// app 背景監聽dispose
    AppLifecycle.dispose(this);
    super.dispose();
  }

  @override
  void afterFirstLayout(BuildContext context) async {
    if (widget.showAdvertise) {
      //第一次打開: ///RegisterGift -> RegisterBenefit -> 廣告頁, 注意這個不做等待
      showAdvertises();
    }

    /// 消息監聽類型都在裡面
    viewModel.afterFirstLayout(context);

    //You cannot do this in init.
    // ref.read(homeSelectTabIndexProvider.notifier).state = widget.defIndex ?? 0;
    ref.read(userUtilProvider.notifier).setDataToPrefs(currentPage: 0);

    /// 檢查App Version
    await viewModel.checkAppVersion(context);
    viewModel.pushVersionUpdateReminderPage();
    if(mounted && viewModel.isNeedUpdate){
      BaseViewModel.pushPage(
          context,
          pageTransitionType: PageTransitionType.bottomToTop,
          VersionUpdateReminder(
            isForceUpdate: viewModel.isForceUpdate,
            appVersion: viewModel.res?.appVersion ?? '',
            downloadLink: viewModel.res?.downloadLink,
            updateDescription: viewModel.res?.updateDescription,
          ));
    }

    /// 檢查是否為青少年模式
    bool isTeenMode = await viewModel.checkTeenMode(context);
    if(isTeenMode && mounted){
      BaseViewModel.pushPage(context, const PersonalSettingTeen());
    }
  }

  @override
  void didChangeDependencies() {
    UIDefine.initial(MediaQuery.of(context), Theme.of(context), ModalRoute.of(context));
    super.didChangeDependencies();
  }

  ///RegisterGift -> RegisterBenefit -> 廣告頁
  Future showAdvertises() async {
    //是否為首次註冊使用者?? 如果發現 Provider 狀態內有東西，才代表剛註冊完成。
    MemberRegisterRes? memberRegisterRes = ref.read(memberRegisterResProvider);
    if (memberRegisterRes != null) {
      log('[This is a newly registered member]: ${jsonEncode(memberRegisterRes.toJson())}');
    } else {
      log('[This is an exist member]');
    }
    ///彈窗順序『首次註冊禮物彈窗』->『新用戶禮物彈窗』->『青少年模式彈窗』->『廣告彈窗』
    viewModel.advertisesDialogQueue();
  }


  List<MissionStatusList> listMissions = [];

  void initTabBar() {
    theme = ref.read(userInfoProvider).theme ?? AppTheme(themeType: AppThemeType.original);
    appColorTheme = theme.getAppColorTheme;
    appImageTheme = theme.getAppImageTheme;
    appBoxDecorationTheme = theme.getAppBoxDecorationTheme;

    if (theme.themeType == AppThemeType.yueyuan) {
      _screensIOS = [const StrikeUpList(), const ActivityBrowser(), const MessageTab(), const PersonalProfile()];
      _screensAndroid = [const StrikeUpList(), const ActivityBrowser(), const MessageTab(), const PersonalProfile()];
      selectedColorsIOS = [
        appColorTheme.homeTabBarStrikeUpSelected,
        appColorTheme.homeTabBarVideoSelected,
        appColorTheme.homeTabBarMessageSelected,
        appColorTheme.homeTabBarProfileSelected,
      ];
      setState(() {});
      return;
    }

    if (theme.themeType == AppThemeType.dogVersion) {
      _screensIOS = [const StrikeUpList(), const CatVideos(), const MessageTab(), const PersonalProfile()];
      _screensAndroid = [const StrikeUpList(), const CatVideos(), const MessageTab(), const PersonalProfile()];
      selectedColorsIOS = [
        appColorTheme.homeTabBarStrikeUpSelected,
        appColorTheme.homeTabBarVideoSelected,
        appColorTheme.homeTabBarMessageSelected,
        appColorTheme.homeTabBarProfileSelected,
      ];
      setState(() {});
      return;
    }

    if (Platform.isIOS) {
      _screensIOS = [const FrechatStrikeUpList(), const ActivityBrowser(), const CatVideos(), const MessageTab(), const PersonalProfile()];
      selectedColorsIOS = [
        appColorTheme.homeTabBarStrikeUpSelected,
        appColorTheme.homeTabBarActivitySelected,
        appColorTheme.homeTabBarVideoSelected,
        appColorTheme.homeTabBarMessageSelected,
        appColorTheme.homeTabBarProfileSelected,
      ];
      setState(() {});
      return;
    }

    _screensAndroid = [const FrechatStrikeUpList(), const ActivityBrowser(), const MessageTab(), const PersonalProfile()];
    selectedColorsAndroid = [
      appColorTheme.homeTabBarStrikeUpSelected,
      appColorTheme.homeTabBarActivitySelected,
      appColorTheme.homeTabBarMessageSelected,
      appColorTheme.homeTabBarProfileSelected,
    ];
    setState(() {});
    return;
  }

  @override
  Widget build(BuildContext context) {

    return AnnotatedRegion(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
          body: PageView(
            controller: naviBarController,
            onPageChanged: (index) {
              currentPageIndex = index;
              setState(() {});
            },
            children: _getPageList(),
          ),
          /// 背景色
          backgroundColor: appColorTheme.baseBackgroundColor,

          /// 加上圓角、陰影
          bottomNavigationBar: Consumer(builder: (BuildContext context, WidgetRef ref, Widget? child) {

            // IOS YueYuan Version
            if (theme.themeType == AppThemeType.yueyuan) {
              strikeUp = currentPageIndex == 0 ? appImageTheme.iconStrikeUpSelected: appImageTheme.iconStrikeUpUnselect;
              activity = currentPageIndex == 1 ? appImageTheme.iconActivitySelected: appImageTheme.iconActivityUnselect;
              message = currentPageIndex == 2 ? appImageTheme.iconMessageSelected: appImageTheme.iconMessageUnselect;
              profile = currentPageIndex == 3 ? appImageTheme.iconProfileSelected: appImageTheme.iconProfileUnselect;
              return _naviBarRadius(
                  radiusNum: 20,
                  child: _buildNaviBarIOSYueYuanVersion()
              );
            }

            // IOS Dog Version
            if (theme.themeType == AppThemeType.dogVersion) {
              strikeUp = currentPageIndex == 0 ? appImageTheme.iconStrikeUpSelected: appImageTheme.iconStrikeUpUnselect;
              video = currentPageIndex == 1 ? appImageTheme.iconVideoSelected: appImageTheme.iconVideoUnselect;
              message = currentPageIndex == 2 ? appImageTheme.iconMessageSelected: appImageTheme.iconMessageUnselect;
              profile = currentPageIndex == 3 ? appImageTheme.iconProfileSelected: appImageTheme.iconProfileUnselect;
              return _naviBarRadius(
                radiusNum: 20,
                child: _buildNaviBarIOSDogVersion()
              );
            }

            // IOS
            if (Platform.isIOS) {
              strikeUp = currentPageIndex == 0 ? appImageTheme.iconStrikeUpSelected: appImageTheme.iconStrikeUpUnselect;
              activity = currentPageIndex == 1 ? appImageTheme.iconActivitySelected: appImageTheme.iconActivityUnselect;
              video = currentPageIndex == 2 ? appImageTheme.iconVideoSelected: appImageTheme.iconVideoUnselect;
              message = currentPageIndex == 3 ? appImageTheme.iconMessageSelected: appImageTheme.iconMessageUnselect;
              profile = currentPageIndex == 4 ? appImageTheme.iconProfileSelected: appImageTheme.iconProfileUnselect;
              return _naviBarRadius(
                radiusNum: 20,
                child: _buildNaviBarIOS()
              );
            }

            // Android
            strikeUp = currentPageIndex == 0 ? appImageTheme.iconStrikeUpSelected: appImageTheme.iconStrikeUpUnselect;
            activity = currentPageIndex == 1 ? appImageTheme.iconActivitySelected: appImageTheme.iconActivityUnselect;
            message = currentPageIndex == 2 ? appImageTheme.iconMessageSelected: appImageTheme.iconMessageUnselect;
            profile = currentPageIndex == 3 ? appImageTheme.iconProfileSelected: appImageTheme.iconProfileUnselect;
            return _naviBarRadius(
                radiusNum: 20,
                child: _buildNaviBarAndroid()
            );
          },
        ),
      ),
    );
  }

  //
  // Tab Start
  //

  // For Android tab
  _buildNaviBarAndroid() {
    return Consumer(builder: (BuildContext context, WidgetRef ref, Widget? child) {
      num totalUnRead = ref.watch(userInfoProvider).unreadMesg ?? 0;
      num activityUnreadCount = ref.watch(userInfoProvider).activityUnreadCount ?? 0;
      return BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        useLegacyColorScheme: false,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        unselectedItemColor: appColorTheme.homeTabBarUnSelect,
        selectedItemColor: selectedColorsAndroid[currentPageIndex],
        selectedFontSize: WidgetValue.navigationBarLabelHeight,
        selectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.w700,
        ),
        unselectedFontSize: WidgetValue.navigationBarLabelHeight,
        backgroundColor: appColorTheme.homeTabBarColor,
        items: [
          BottomNavigationBarItem(
            icon: ImgUtil.buildFromImgPath(strikeUp, size: 28),
            label: '缘分',
          ),
          BottomNavigationBarItem(
            icon: Stack(
              clipBehavior: Clip.none,
              children: [
                ImgUtil.buildFromImgPath(activity, size: 28),
                _buildUnreadPoint(activityUnreadCount),
              ],
            ),
            label: '动态',
          ),
          BottomNavigationBarItem(
            icon: Stack(
              clipBehavior: Clip.none,
              children: [
                ImgUtil.buildFromImgPath(message, size: 28),
                _buildUnreadMessages(totalUnRead),
              ],
            ),
            label: '消息',
          ),
          BottomNavigationBarItem(
            icon: ImgUtil.buildFromImgPath(profile, size: 28),
            label: '我的',
          ),
        ],
        currentIndex: currentPageIndex,
        onTap: _onItemTapped,
      );
    });

  }

  // For IOS Tab
  _buildNaviBarIOS() {
    return Consumer(builder: (BuildContext context, WidgetRef ref, Widget? child) {
      num totalUnRead = ref.watch(userInfoProvider).unreadMesg ?? 0;
      num activityUnreadCount = ref.watch(userInfoProvider).activityUnreadCount ?? 0;
      return BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        useLegacyColorScheme: false,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        unselectedItemColor: appColorTheme.homeTabBarUnSelect,
        selectedItemColor: selectedColorsIOS[currentPageIndex],
        selectedFontSize: WidgetValue.navigationBarLabelHeight,
        selectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.w700,
        ),
        unselectedFontSize: WidgetValue.navigationBarLabelHeight,
        backgroundColor: appColorTheme.homeTabBarColor,
        items: [
          BottomNavigationBarItem(
            icon: ImgUtil.buildFromImgPath(strikeUp, size: 28),
            label: '缘分',
          ),
          BottomNavigationBarItem(
            icon: Stack(
              clipBehavior: Clip.none,
              children: [
                ImgUtil.buildFromImgPath(activity, size: 28),
                _buildUnreadPoint(activityUnreadCount),
              ],
            ),
            label: '动态',
          ),
          BottomNavigationBarItem(
            icon: ImgUtil.buildFromImgPath(video, size: 28),
            label: '视频',
          ),
          BottomNavigationBarItem(
            icon: Stack(
              clipBehavior: Clip.none,
              children: [
                ImgUtil.buildFromImgPath(message, size: 28),
                _buildUnreadMessages(totalUnRead),
              ],
            ),
            label: '消息',
          ),
          BottomNavigationBarItem(
            icon: ImgUtil.buildFromImgPath(profile, size: 28),
            label: '我的',
          ),
        ],
        currentIndex: currentPageIndex,
        onTap: _onItemTapped,
      );
    });
  }

  // For IOS Tab Dog Version
  _buildNaviBarIOSDogVersion() {
    return Consumer(builder: (BuildContext context, WidgetRef ref, Widget? child) {
      num totalUnRead = ref.watch(userInfoProvider).unreadMesg ?? 0;
      return BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        useLegacyColorScheme: false,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        unselectedItemColor: appColorTheme.homeTabBarUnSelect,
        selectedItemColor: selectedColorsIOS[currentPageIndex],
        selectedFontSize: WidgetValue.navigationBarLabelHeight,
        selectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.w700,
        ),
        unselectedFontSize: WidgetValue.navigationBarLabelHeight,
        backgroundColor: appColorTheme.homeTabBarColor,
        items: [
          BottomNavigationBarItem(
            icon: ImgUtil.buildFromImgPath(strikeUp, size: 28),
            label: '散步',
          ),
          BottomNavigationBarItem(
            icon: ImgUtil.buildFromImgPath(video, size: 28),
            label: '视频',
          ),
          BottomNavigationBarItem(
            icon: Stack(
              clipBehavior: Clip.none,
              children: [
                ImgUtil.buildFromImgPath(message, size: 28),
                _buildUnreadMessages(totalUnRead),
              ],
            ),
            label: '训练',
          ),
          BottomNavigationBarItem(
            icon: ImgUtil.buildFromImgPath(profile, size: 28),
            label: '小窝',
          ),
        ],
        currentIndex: currentPageIndex,
        onTap: _onItemTapped,
      );
    });
  }

  // For IOS Tab YueYuan Version
  _buildNaviBarIOSYueYuanVersion() {
    return Consumer(builder: (BuildContext context, WidgetRef ref, Widget? child) {
      num totalUnRead = ref.watch(userInfoProvider).unreadMesg ?? 0;
      num activityUnreadCount = ref.watch(userInfoProvider).activityUnreadCount ?? 0;

      return BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        useLegacyColorScheme: false,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        unselectedItemColor: appColorTheme.homeTabBarUnSelect,
        selectedItemColor: selectedColorsIOS[currentPageIndex],
        selectedFontSize: WidgetValue.navigationBarLabelHeight,
        selectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.w700,
        ),
        unselectedFontSize: WidgetValue.navigationBarLabelHeight,
        backgroundColor: appColorTheme.homeTabBarColor,
        items: [
          BottomNavigationBarItem(
            icon: ImgUtil.buildFromImgPath(strikeUp, size: 28),
            label: '缘分',
          ),
          BottomNavigationBarItem(
            icon: Stack(
              clipBehavior: Clip.none,
              children: [
                ImgUtil.buildFromImgPath(activity, size: 28),
                _buildUnreadPoint(activityUnreadCount),
              ],
            ),
            label: '动态',
          ),
          BottomNavigationBarItem(
            icon: Stack(
              clipBehavior: Clip.none,
              children: [
                ImgUtil.buildFromImgPath(message, size: 28),
                _buildUnreadMessages(totalUnRead),
              ],
            ),
            label: '消息',
          ),
          BottomNavigationBarItem(
            icon: ImgUtil.buildFromImgPath(profile, size: 28),
            label: '我的',
          ),
        ],
        currentIndex: currentPageIndex,
        onTap: _onItemTapped,
      );
    });
  }

  //
  // Tab End
  //

  void _onItemTapped(int index) {
    naviBarController?.jumpToPage(index);
  }

  List<Widget> _getPageList() {
    if (Platform.isIOS) {
      return _screensIOS;
    } else {
      return _screensAndroid;
    }
  }

  _naviBarRadius({
    required double radiusNum,
    required Widget child
  }) {
    return Container(
      padding: Platform.isAndroid ? const EdgeInsets.only(bottom: 16) : const EdgeInsets.only(bottom: 0),
      decoration: BoxDecoration(
        color: appColorTheme.homeTabBarColor,
        boxShadow: const [
          BoxShadow(
            offset: Offset(0, -5),
            blurRadius: 10,
            color: Color(0x0D000000),
          ),
        ],
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(radiusNum),
          topRight: Radius.circular(radiusNum),
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(radiusNum),
          topRight: Radius.circular(radiusNum),
        ),
        child: child,
      ),
    );
  }

  // 未讀紅點
  Widget _buildUnreadPoint(num unread) {

    if (unread == 0) return const SizedBox();

    return Positioned(
      right: 0,
      top: 0,
      child: Container(
        width: 5.w,
        height: 5.w,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(99.0),
          color: const Color(0xffEC6193),
        ),
      ),
    );
  }

  // 未讀數量
  Widget _buildUnreadMessages(num unread) {
    if (unread == 0) return const SizedBox();
    String displayUnread = '';
    displayUnread = '$unread';
    if (unread > 99) displayUnread = '99+';

    return Positioned(
      left: 16,
      top: 0,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
        decoration: appBoxDecorationTheme.unReadMsgCountBoxDecoration,
        child: Center(
          child:  Text("$displayUnread", style: const TextStyle(
            fontSize: 8,
            fontWeight: FontWeight.w500,
            height: 1,
            color: Colors.white,
          )),
        )
      ),
    );
  }
}
