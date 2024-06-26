import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frechat/screens/profile/agent/benefit/personal_agent_benefit.dart';
import 'package:frechat/screens/profile/agent/link/personal_agent_link.dart';
import 'package:frechat/screens/profile/agent/member_list/personal_agent_member_list.dart';
import 'package:frechat/screens/profile/agent/personal_agent_view_model.dart';
import 'package:frechat/screens/profile/agent/promotion/personal_agent_promotion.dart';
import 'package:frechat/system/base_view_model.dart';
import 'package:frechat/system/constant/enum.dart';
import 'package:frechat/system/providers.dart';
import 'package:frechat/widgets/shared/app_bar.dart';
import 'package:frechat/widgets/shared/img_util.dart';
import 'package:frechat/widgets/shared/tab_bar/main_tab_bar.dart';
import 'package:frechat/widgets/theme/app_box_decoration_theme.dart';
import 'package:frechat/widgets/theme/app_color_theme.dart';
import 'package:frechat/widgets/theme/app_image_theme.dart';
import 'package:frechat/widgets/theme/app_text_theme.dart';
import 'package:frechat/widgets/theme/app_theme.dart';
import 'package:frechat/widgets/theme/uidefine.dart';
import '../../../widgets/constant_value.dart';
import '../../../widgets/shared/main_scaffold.dart';
import '../../../widgets/shared/tab_bar/custom_indicator.dart';

class PersonalAgent extends ConsumerStatefulWidget {
  const PersonalAgent({super.key});

  @override
  ConsumerState<PersonalAgent> createState() => _PersonalAgentState();
}

class _PersonalAgentState extends ConsumerState<PersonalAgent> with TickerProviderStateMixin{
  late PersonalAgentViewModel viewModel;
  OverlayEntry? overlayEntry;
  late AppTheme _theme;
  late AppTextTheme _appTextTheme;
  late AppImageTheme _appImageTheme;
  late AppColorTheme _appColorTheme;
  late AppBoxDecorationTheme _appBoxDecorationTheme;


  void showButtonToast(BuildContext context, String message) {
    double asd = MediaQuery.of(context).padding.top;
    overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: asd + 45,
        right: 10,
        child: Material(
          color: Colors.transparent,
          child: Container(
            width: 200,
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Color.fromRGBO(0,0,0,0.5),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              message,
              style: const TextStyle(color: Color.fromRGBO(255,255,255,1),fontWeight: FontWeight.w400,fontSize: 12),
            ),
          ),
        ),
      ),
    );
    setState(() {});

    Overlay.of(context).insert(overlayEntry!);

    // 定时器，控制Toast的显示时间
    Future.delayed(const Duration(seconds: 3), () {
      overlayEntry!.remove();
      overlayEntry = null;
    });
  }
  @override
  void initState() {
    viewModel = PersonalAgentViewModel(tickerProvider: this, ref: ref, setState: setState);
    viewModel.init(context);
    super.initState();
  }

  @override
  void dispose() {
    if(overlayEntry != null){
      overlayEntry!.remove();
      overlayEntry = null;
    }
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
    return WillPopScope(
      child: MainScaffold(
        isFullScreen: true,
        needSingleScroll: false,
        padding: EdgeInsets.only(top: paddingHeight, bottom: UIDefine.getNavigationBarHeight()),
        appBar:_buildAppBar(),
        backgroundColor: _appColorTheme.appBarBackgroundColor,
        child: Column(
          children: [
            _buildTabBar(),
            Expanded(child: _buildTabBarView())
          ],
        ),
      ),
      onWillPop: () async {
        if(overlayEntry != null){
          overlayEntry!.remove();
          overlayEntry = null;
        }
        BaseViewModel.popPage(context);
        return true;
      },
    );
  }

  MainAppBar _buildAppBar(){
    return MainAppBar(
        theme: _theme,
        title: '推广中心',
        backgroundColor: Colors.transparent,
        leading: IconButton(
            icon: ImgUtil.buildFromImgPath(_appImageTheme.iconBack, size: 24),
            onPressed: () {
              FocusManager.instance.primaryFocus?.unfocus(); // 收起鍵盤
              BaseViewModel.popPage(context);
            }
        ),
        actions: [_buildHelpBtn()]);
  }

  Widget _buildHelpBtn() {
    return InkWell(
      child: Padding(
        padding: EdgeInsets.only(right: WidgetValue.horizontalPadding),
        child: ImgUtil.buildFromImgPath(_appImageTheme.iconProfileAgentHelp, size: 24),
      ),
      onTap: (){
        if(overlayEntry != null){
          overlayEntry!.remove();
          overlayEntry = null;
        }
        showButtonToast(context,'推广数据为计算所有经由推广邀请码邀请的下一级推广人数"提示；人脉数据为计算所有因下一级推广人数而带进来之总人数');
      },
    );
  }

  Widget _buildTabBar() {
    return MainTabBar(
        controller: viewModel.tabController, tabList: viewModel.tabList)
        .tabBar(
      padding: EdgeInsets.zero,
      dividerColor: Colors.transparent,
      tabAlignment: TabAlignment.center,
      isScrollable: true,
      indicator: CustomIndicator(color: _appColorTheme.tabBarIndicatorColor, indicatorWidth: 16.w),
      selectTextStyle: _appTextTheme.tabBarSelectTextStyle,
      unSelectTextStyle: _appTextTheme.tabBarUnSelectTextStyle,
    );
  }

  Widget _buildTabBarView() {
    List<Widget> agentList = [
      const PersonalAgentPromotion(),
      const PersonalAgentMemberList(),
      const PersonalAgentLink()
    ];
    return TabBarView(
      controller: viewModel.tabController,
      // children: list,
      children: agentList
    );
  }
}
