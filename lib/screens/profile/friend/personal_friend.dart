
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frechat/models/ws_res/account/ws_account_follow_and_fans_list_res.dart';
import 'package:frechat/screens/home/home.dart';
import 'package:frechat/screens/profile/friend/personal_friend_view_model.dart';
import 'package:frechat/system/base_view_model.dart';
import 'package:frechat/system/constant/enum.dart';
import 'package:frechat/system/providers.dart';
import 'package:frechat/widgets/constant_value.dart';
import 'package:frechat/widgets/profile/cell/personal_friend_cell/personal_friend_cell.dart';
import 'package:frechat/widgets/shared/app_bar.dart';
import 'package:frechat/widgets/shared/buttons/common_button.dart';
import 'package:frechat/widgets/shared/img_util.dart';
import 'package:frechat/widgets/shared/list/main_list.dart';
import 'package:frechat/widgets/shared/loading_animation.dart';
import 'package:frechat/widgets/shared/main_scaffold.dart';
import 'package:frechat/widgets/shared/tab_bar/main_tab_bar.dart';
import 'package:frechat/widgets/strike_up_list/top_bottom_pull_loader.dart';
import 'package:frechat/widgets/theme/app_color_theme.dart';
import 'package:frechat/widgets/theme/original/app_colors.dart';
import 'package:frechat/widgets/theme/app_image_theme.dart';
import 'package:frechat/widgets/theme/app_theme.dart';
import 'package:frechat/widgets/theme/uidefine.dart';


class PersonalFriend extends ConsumerStatefulWidget {
  const PersonalFriend({super.key,this.tabBarIndex});
  final int? tabBarIndex;

  @override
  ConsumerState<PersonalFriend> createState() => _PersonalFriendState();
}

class _PersonalFriendState extends ConsumerState<PersonalFriend> with TickerProviderStateMixin {
  late PersonalFriendViewModel viewModel;
  late AppTheme _theme;
  late AppImageTheme _appImageTheme;
  late AppColorTheme _appColorTheme;


  @override
  void initState() {
    viewModel = PersonalFriendViewModel(ref: ref, setState: setState, tickerProvider: this);
    viewModel.init(context,widget.tabBarIndex!);
    super.initState();
  }

  @override
  void dispose() {
    viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double paddingHeight = UIDefine.getAppBarHeight() + UIDefine.getStatusBarHeight();
    _theme = ref.watch(userInfoProvider).theme ?? AppTheme(themeType: AppThemeType.original);
    _appColorTheme = _theme.getAppColorTheme;
    _appImageTheme = _theme.getAppImageTheme;

    return MainScaffold(
      isFullScreen: true,
      needSingleScroll: false,
      padding: EdgeInsets.only(top: paddingHeight, bottom: UIDefine.getNavigationBarHeight(), left: WidgetValue.horizontalPadding, right: WidgetValue.horizontalPadding),
      appBar: MainAppBar(
        theme: _theme,
        backgroundColor: _appColorTheme.appBarBackgroundColor,
        title: '好友',
        leading: IconButton(
          icon: ImgUtil.buildFromImgPath(_appImageTheme.iconBack, size: 24.w),
          onPressed: () => BaseViewModel.popPage(context),
        ),
      ),
      backgroundColor: _appColorTheme.appBarBackgroundColor,
      child: Column(
        children: [
          _buildTabBar(),
          SizedBox(height: WidgetValue.verticalPadding),
          Expanded(child: _buildTabBarView())
        ],
      ),
    );
  }

  Widget _buildTabBar() {

    return Container(
      margin: EdgeInsets.symmetric(vertical: 16.h),
      height: WidgetValue.tabBarHeight,
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: _appColorTheme.tabBarBgColor,
        borderRadius: BorderRadius.circular(99),
      ),
      child: MainTabBar(controller: viewModel.tabController, tabList: viewModel.tabList).tabBar(
        padding: EdgeInsets.zero,
        selectTextStyle: TextStyle(color: _appColorTheme.tabBarSelectTextColor, fontWeight: FontWeight.w600),
        unSelectTextStyle: TextStyle(color: _appColorTheme.tabBarUnSelectTextColor, fontWeight: FontWeight.w600),
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: Colors.transparent,
        indicator: BoxDecoration(
          color: _appColorTheme.tabBarIndicatorBgColor,
          borderRadius:  BorderRadius.circular(99)
        ),
      ),
    );
  }

  Widget _buildTabBarView() {
    return TabBarView(
      controller: viewModel.tabController,
      children: [
        _buildFollow(),
        _buildFans()
      ],
    );
  }

  Widget _buildFollow() {
    return Consumer(builder: (context, ref, _){
      final WsAccountFollowAndFansListRes fallowInfo = ref.watch(userInfoProvider).followList ?? WsAccountFollowAndFansListRes();
      final bool isEmpty = fallowInfo.list?.isEmpty ?? true;
      return isEmpty ? _buildFollowEmpty() : TopBottomPullLoader(
        enableRefresh: false,
        onRefresh: viewModel.fallowOnRefresh,
        onFetchMore: () => viewModel.fallowOnFetchMore(context),
        child: CustomList.separatedList(
          separator: SizedBox(height: WidgetValue.verticalPadding), childrenNum: fallowInfo.list!.length,
          children: (context, index) {
            return PersonalFriendCell(model: fallowInfo.list![index],type: PersonalFreindType.follow);
          }
        ),
      );
    });
  }

  Widget _buildFollowEmpty() {
    return _buildEmpty(
      title: '您目前还没有关注的人',
      des: '快去关注人吧',
      enableBtn: true,
      pushPage: () => BaseViewModel.pushAndRemoveUntil(context, const Home(showAdvertise: false,))
    );
  }

  Widget _buildFans() {
    return Consumer(builder: (context, ref, _){
      final WsAccountFollowAndFansListRes fansInfo = ref.watch(userInfoProvider).fansList ?? WsAccountFollowAndFansListRes();
      final bool isEmpty = fansInfo.list?.isEmpty ?? true;
      return isEmpty ? _buildFansEmpty() : TopBottomPullLoader(
        enableRefresh: false,
        onRefresh: viewModel.fansOnRefresh,
        onFetchMore: () => viewModel.fansOnFetchMore(context),
        child: CustomList.separatedList(
            separator: SizedBox(height: WidgetValue.verticalPadding), childrenNum: fansInfo.list!.length,
            children: (context, index) {
              return PersonalFriendCell(model: fansInfo.list![index],type: PersonalFreindType.fans);
            }
        ),
      );
    });
  }

  Widget _buildFansEmpty() {
    return _buildEmpty(
        title: '您目前还没有粉丝',
        des: '等待人关注吧',
        enableBtn: true,
        pushPage: () => BaseViewModel.pushAndRemoveUntil(context, const Home(showAdvertise: false,))
    );
  }

  Widget _buildEmpty({
    required String title,
    required String des,
    bool enableBtn = false,
    String btnTitle = '去關注',
    Function()? pushPage
  }) {

    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ImgUtil.buildFromImgPath(_appImageTheme.friendEmptyBanner, size: 150.w),
        SizedBox(height:15.h),
        Text(title, style: TextStyle(color: _appColorTheme.friendEmptyPrimaryTextColor, fontSize: 14, fontWeight: FontWeight.w700)),
        SizedBox(height:2.h),
        Text(des, style: TextStyle(color: _appColorTheme.friendEmptySecondaryTextColor, fontSize: 12, fontWeight: FontWeight.w400)),
      ],
    );
  }
}