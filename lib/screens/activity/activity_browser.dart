import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frechat/screens/activity/activity_browser_view_model.dart';
import 'package:frechat/screens/activity/activity_notification.dart';
import 'package:frechat/screens/activity/add/activity_add_post.dart';
import 'package:frechat/screens/activity/tab/recommend/activity_recommend_tab.dart';
import 'package:frechat/screens/activity/tab/subscribe/activity_subscribe_tab.dart';
import 'package:frechat/system/base_view_model.dart';
import 'package:frechat/system/constant/enum.dart';
import 'package:frechat/system/global/shared_preferance.dart';
import 'package:frechat/system/providers.dart';
import 'package:frechat/system/repository/response_code.dart';
import 'package:frechat/system/util/dialog_util.dart';
import 'package:frechat/system/util/real_person_name_auth_util.dart';
import 'package:frechat/widgets/constant_value.dart';
import 'package:frechat/widgets/shared/img_util.dart';
import 'package:frechat/widgets/shared/main_scaffold.dart';
import 'package:frechat/widgets/shared/tab_bar/custom_indicator.dart';
import 'package:frechat/widgets/shared/tab_bar/main_tab_bar.dart';
import 'package:frechat/widgets/theme/app_box_decoration_theme.dart';
import 'package:frechat/widgets/theme/app_color_theme.dart';
import 'package:frechat/widgets/theme/app_image_theme.dart';
import 'package:frechat/widgets/theme/app_linear_gradient_theme.dart';
import 'package:frechat/widgets/theme/app_text_theme.dart';
import 'package:frechat/widgets/theme/uidefine.dart';
import 'package:flutter_screenutil/src/size_extension.dart';

import '../../widgets/theme/app_theme.dart';

/// Home 的 4 個 tab 其中之一:
/// 使用者動態瀏覽器頁
class ActivityBrowser extends ConsumerStatefulWidget {
  const ActivityBrowser({super.key});

  @override
  ConsumerState<ActivityBrowser> createState() => _ActivityBrowserState();
}

class _ActivityBrowserState extends ConsumerState<ActivityBrowser> with TickerProviderStateMixin {
  @override
  bool get wantKeepAlive => false;

  late ActivityBrowserViewModel viewModel;
  late AppTheme _theme;
  late AppTextTheme _appTextTheme;
  late AppColorTheme _appColorTheme;
  late AppImageTheme _appImageTheme;
  late AppBoxDecorationTheme _appBoxDecorationTheme;

  /// 顯示認證彈窗
  void _showRealPersonDialog(){
    DialogUtil.popupRealPersonDialog(theme:_theme,context: context, description: '您还未通过真人认证与实名认证，认证完毕后方可发布贴文');
  }

  @override
  void initState() {
    viewModel = ActivityBrowserViewModel(setState: setState, ref: ref, tickerProvider: this);
    viewModel.init();
    super.initState();
  }
  @override
  void deactivate(){
    print('deactivate');
    super.deactivate();
  }

  @override
  void dispose() {
    viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _theme = ref.watch(userInfoProvider).theme ?? AppTheme(themeType: AppThemeType.original);
    _appTextTheme = _theme.getAppTextTheme;
    _appColorTheme = _theme.getAppColorTheme;
    _appImageTheme = _theme.getAppImageTheme;
    _appBoxDecorationTheme = _theme.getAppBoxDecorationTheme;
    return MainScaffold(
      needSingleScroll: false,
      padding: EdgeInsets.only(top: UIDefine.getStatusBarHeight()),
      floatingActionButton: _addPostButton(),
      backgroundColor: _appColorTheme.baseBackgroundColor,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      child: Column(
        children: [
          _headerWidget(),
          _bodyWidget(),
        ],
      ),
    );
  }
  /// 頂部
  Widget _headerWidget(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _headerTabBar(),
        _headerNotificationButton()
      ],
    );
  }
  /// 頂部  - TabBar 頁籤
  Widget _headerTabBar() {
    return MainTabBar(controller: viewModel.tabController, tabList: viewModel.tabList).tabBar(
      padding: EdgeInsets.zero,
      dividerColor: Colors.transparent,
      tabAlignment: TabAlignment.start,
      isScrollable: true,
      indicator: CustomIndicator(color: _appColorTheme.tabBarIndicatorColor,indicatorWidth: 10.w),
      selectTextStyle: _appTextTheme.zoomTabBarSelectTextStyle,
      unSelectTextStyle: _appTextTheme.zoomTabBarUnSelectTextStyle,
    );
  }
  /// 頂部  - 通知按鈕
  Widget _headerNotificationButton() {

    return Consumer(builder: (context, ref, _){
      num activityUnreadCount = ref.watch(userInfoProvider).activityUnreadCount ?? 0;

      return InkWell(
        onTap: () {
          BaseViewModel.pushPage(context, const ActivityNotification());
        },
        child: Padding(
          padding: EdgeInsets.only(right: WidgetValue.horizontalPadding),
          child: ImgUtil.buildFromImgPath(activityUnreadCount == 0
              ? _appImageTheme.iconActivityNotification
              : _appImageTheme.iconActivityNotificationUnread,
              size: 24.w
          ),
        ),
      );
    });
  }
  ///內容
  Widget _bodyWidget(){
    return Expanded(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: WidgetValue.verticalPadding),
        child: _contentTabBarView(),
      ),
    );
  }
  ///內容 - TabView（推薦/關注）
  Widget _contentTabBarView() {

    return TabBarView(
      controller: viewModel.tabController,
      children: [
        ActivityRecommendTab(),
        ActivitySubscribeTab(tabController: viewModel.tabController),
      ],
    );
  }
  ///發布按鈕
  Widget _addPostButton() {
    return InkWell(
      onTap: () => viewModel.onTapPostButton(
        context,
        onShowRealPersonDialog: () => _showRealPersonDialog(),
        onPushToAddPostPage: () => BaseViewModel.pushPage(context, const ActivityAddPost()).then((value) => setState((){}))
      ),
      child: Container(
        width: 64.w, height: 64.w,
        decoration: _appBoxDecorationTheme.activityPostButtonBoxDecoration,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            ImgUtil.buildFromImgPath(_appImageTheme.iconActivityPostButton,size: 24.w),
            Text('发布', style: _appTextTheme.activityPostButtonTextStyle)
          ],
        ),
      ),
    );
  }
}
