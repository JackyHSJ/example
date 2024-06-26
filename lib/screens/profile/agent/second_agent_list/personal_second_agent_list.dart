
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frechat/models/ws_res/agent/ws_agent_member_list_res.dart';

import 'package:frechat/screens/profile/agent/second_agent_list/agent_tab/personal_second_agent_tab.dart';
import 'package:frechat/screens/profile/agent/second_agent_list/friend_tab/personal_second_friend_tab.dart';
import 'package:frechat/screens/profile/agent/second_agent_list/personal_second_agent_list_view_model.dart';
import 'package:frechat/system/base_view_model.dart';
import 'package:frechat/system/constant/enum.dart';
import 'package:frechat/system/providers.dart';
import 'package:frechat/widgets/constant_value.dart';
import 'package:frechat/widgets/shared/app_bar.dart';
import 'package:frechat/widgets/shared/img_util.dart';
import 'package:frechat/widgets/shared/main_scaffold.dart';
import 'package:frechat/widgets/shared/tab_bar/main_tab_bar.dart';
import 'package:frechat/widgets/theme/app_box_decoration_theme.dart';
import 'package:frechat/widgets/theme/app_color_theme.dart';
import 'package:frechat/widgets/theme/app_image_theme.dart';
import 'package:frechat/widgets/theme/app_text_theme.dart';
import 'package:frechat/widgets/theme/app_theme.dart';
import 'package:frechat/widgets/theme/original/app_colors.dart';
import 'package:frechat/widgets/theme/uidefine.dart';

class PersonalSecondAgentList extends ConsumerStatefulWidget {
  const PersonalSecondAgentList({super.key, required this.agentMember});
  final AgentMemberInfo? agentMember;
  @override
  ConsumerState<PersonalSecondAgentList> createState() => _PersonalSecondAgentListState();
}

class _PersonalSecondAgentListState extends ConsumerState<PersonalSecondAgentList> with TickerProviderStateMixin{
  late PersonalSecondAgentListViewModel viewModel;
  AgentMemberInfo get agentMember => widget.agentMember ?? AgentMemberInfo();
  late AppTheme _theme;
  late AppTextTheme _appTextTheme;
  late AppImageTheme _appImageTheme;
  late AppColorTheme _appColorTheme;
  late AppBoxDecorationTheme _appBoxDecorationTheme;
  @override
  void initState() {
    viewModel = PersonalSecondAgentListViewModel(tickerProvider: this);
    viewModel.init(context);
    super.initState();
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
    _appImageTheme = _theme.getAppImageTheme;
    _appColorTheme = _theme.getAppColorTheme;
    _appBoxDecorationTheme = _theme.getAppBoxDecorationTheme;
    final double paddingHeight = UIDefine.getAppBarHeight() + UIDefine.getStatusBarHeight();
    return MainScaffold(
      isFullScreen: true,
      needSingleScroll: false,
      padding: EdgeInsets.only(top: paddingHeight, bottom: UIDefine.getNavigationBarHeight()),
      appBar: _buildAppBar(),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: WidgetValue.horizontalPadding),
        color: _appColorTheme.baseBackgroundColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTabBar(),
            Expanded(child: _buildTabBarView(),),
          ],
        ),
      )
    );
  }
  MainAppBar _buildAppBar(){
    return MainAppBar(
        theme: _theme,
        title: '二级推广',
        backgroundColor: _appColorTheme.baseBackgroundColor,
        leading: IconButton(
            icon: ImgUtil.buildFromImgPath(_appImageTheme.iconBack, size: 24),
            onPressed: () {
              FocusManager.instance.primaryFocus?.unfocus(); // 收起鍵盤
              BaseViewModel.popPage(context);
            }
        ),);
  }
  //TabBar
  Widget _buildTabBar() {
    return Container(
      decoration: _appBoxDecorationTheme.personalAgentTabbarBoxDecoration,
      child: MainTabBar(controller: viewModel.tabController, tabList: viewModel.tabTitles)
          .tabBar(
        padding: EdgeInsets.zero,
        dividerColor: Colors.transparent,
        tabAlignment: TabAlignment.fill,
        indicatorPadding: EdgeInsets.symmetric(vertical: 3.h),
        indicator: _appBoxDecorationTheme.personalAgentTabbarIndicatorBoxDecoration,
        selectTextStyle: _appTextTheme.personalAgentTabbarSelectTextStyle,
        unSelectTextStyle: _appTextTheme.personalAgentTabbarUnselectTextStyle,
      ),
    );
  }
  //Tab內容
  Widget _buildTabBarView() {
    return TabBarView(
        controller: viewModel.tabController,
        children: [
          PersonalSecondAgentTab(agentMember: agentMember),
          PersonalSecondFriendTab(agentMember: agentMember),
        ]
    );
  }
}
