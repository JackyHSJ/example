
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frechat/models/ws_req/activity/ws_activity_search_info_req.dart';
import 'package:frechat/models/ws_res/account/ws_account_follow_and_fans_list_res.dart';
import 'package:frechat/models/ws_res/activity/ws_activity_search_info_res.dart';
import 'package:frechat/screens/activity/activity_browser_view_model.dart';
import 'package:frechat/screens/activity/activity_post_detail.dart';
import 'package:frechat/screens/activity/add/activity_add_post.dart';
import 'package:frechat/screens/activity/tab/subscribe/activity_subscribe_tab_view_model.dart';
import 'package:frechat/screens/profile/setting/privacy_setting/privacy_setting_page.dart';
import 'package:frechat/system/base_view_model.dart';
import 'package:frechat/system/constant/enum.dart';
import 'package:frechat/system/providers.dart';
import 'package:frechat/widgets/activity/cell/activity_post_cell.dart';
import 'package:frechat/widgets/constant_value.dart';
import 'package:frechat/widgets/shared/divider.dart';
import 'package:frechat/widgets/shared/img_util.dart';
import 'package:frechat/widgets/shared/list/main_list.dart';
import 'package:frechat/widgets/shared/main_scaffold.dart';
import 'package:frechat/widgets/strike_up_list/top_bottom_pull_loader.dart';
import 'package:frechat/widgets/theme/app_box_decoration_theme.dart';
import 'package:frechat/widgets/theme/app_color_theme.dart';
import 'package:frechat/widgets/theme/app_image_theme.dart';
import 'package:frechat/widgets/theme/app_text_theme.dart';
import 'package:frechat/widgets/theme/original/app_colors.dart';
import 'package:frechat/widgets/theme/app_linear_gradient_theme.dart';
import 'package:frechat/widgets/theme/app_theme.dart';

class ActivitySubscribeTab extends ConsumerStatefulWidget {
  const ActivitySubscribeTab({super.key,required this.tabController});
  final TabController tabController;

  @override
  ConsumerState<ActivitySubscribeTab> createState() => _ActivitySubscribeTabState();
}

class _ActivitySubscribeTabState extends ConsumerState<ActivitySubscribeTab> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  TabController get tabController => widget.tabController;
  late ActivitySubscribeTabViewModel viewModel;
  late AppTheme _theme;
  late AppTextTheme _appTextTheme;
  late AppLinearGradientTheme _appLinearGradientTheme;
  late AppImageTheme _appImageTheme;
  late AppColorTheme _appColorTheme;

  @override
  void initState() {
    viewModel = ActivitySubscribeTabViewModel(setState: setState, ref: ref,tabController: tabController);
    viewModel.init();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    _theme = ref.watch(userInfoProvider).theme ?? AppTheme(themeType: AppThemeType.original);
    _appTextTheme = _theme.getAppTextTheme;
    _appImageTheme = _theme.getAppImageTheme;
    _appLinearGradientTheme = _theme.getAppLinearGradientTheme;
    _appColorTheme = _theme.getAppColorTheme;

    bool isClosePersonalizedRecommendations = ref.watch(userInfoProvider).isClosePersonalizedRecommendations ?? false;
    if (isClosePersonalizedRecommendations) {
      return goToOpenPersonalizedRecommendations();
    }
    return TopBottomPullLoader(
        onRefresh: () => viewModel.activityPostRefresh(),
        onFetchMore: () => viewModel.activityPostFetchMore(),
        refreshIcon: Image.asset(_appImageTheme.pullLoaderRefreshIcon, width: 36.w, height: 36.w),
        fetchMoreIcon: Image.asset(_appImageTheme.pullLoaderFetchMoreIcon, width: 36.w, height: 36.w),
        loadingIcon: Image.asset(_appImageTheme.pullLoaderLoadingIcon, width: 36.w, height: 36.w),
        child:LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              double parentHeight = constraints.maxHeight + 5.h;
              return SingleChildScrollView(
                child: Container(
                  constraints: BoxConstraints(minHeight: parentHeight),
                  child: _tabContent(),
                ),
              );
            })
    );
  }

  /// 關注頁內容
  Widget _tabContent(){
    return Consumer(builder: (context, ref, _){
      final WsAccountFollowAndFansListRes follow = ref.watch(userInfoProvider).followList ?? WsAccountFollowAndFansListRes();
      List<AccountListInfo>? followList = follow.list ?? [];
      final List<ActivityPostInfo> postInfolist = ref.watch(userInfoProvider).activitySearchInfoSubscribe?.list ?? [];
      final List<dynamic> likeList = ref.watch(userInfoProvider).activityAllLikePostIdList ?? [];
      return (followList.isEmpty || postInfolist.isEmpty)
          ? _emptyWidget()
          : _postList(postInfolist: postInfolist,likeList: likeList);
    });
  }

  /// 關注頁內容 - 貼文列表
  Widget _postList({required List<ActivityPostInfo> postInfolist,required List<dynamic> likeList}) {
    return CustomList.separatedList(
        separator: MainDivider(weight: 1, color:  _appColorTheme.activityPostCellSeparatorLineColor, height: WidgetValue.verticalPadding * 3),
        childrenNum:postInfolist.length,
        physics: const NeverScrollableScrollPhysics(),
        children: (context, index) {

          return ActivityPostCell(
            postInfo: postInfolist[index],
            likeList: likeList,
            onTap: () =>  BaseViewModel.pushPage(context, ActivityPostDetail(postInfo: postInfolist[index])),
            onTapMessageButton: () =>  BaseViewModel.pushPage(context, ActivityPostDetail(postInfo: postInfolist[index])),
          );
        }
    );
  }

  /// 關注頁內容 - 無貼文內容
  Widget _emptyWidget() {
    return Center(
      child:Column(
        children: [
          ImgUtil.buildFromImgPath(_appImageTheme.imageActivityEmpty, size: 150.w),
          Text('暂无动态', style: _appTextTheme.activityEmptyTitleTextStyle),
          SizedBox(height: WidgetValue.verticalPadding),
          Text('暂时还没有推荐动态', style:_appTextTheme.activityEmptySubtitleTextStyle),
          SizedBox(height: WidgetValue.verticalPadding * 2),
          _emptyMoreButton()
        ],
      ),
    );
  }

  /// 無貼文內容 - 查看更多按鈕
  Widget _emptyMoreButton() {
    return InkWell(
      onTap: () {
        viewModel.switchTabPage(index: 0);
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: WidgetValue.verticalPadding, horizontal: WidgetValue.horizontalPadding),
        decoration: BoxDecoration(
            gradient: _appLinearGradientTheme.buttonPrimaryColor,
            borderRadius: BorderRadius.circular(WidgetValue.btnRadius / 2)
        ),
        child: Text('查看更多', style: _appTextTheme.buttonPrimaryTextStyle),
      ),
    );
  }

  ///若无开启个性化推荐显示按钮可跳转隐私设置
  Widget goToOpenPersonalizedRecommendations(){
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ImgUtil.buildFromImgPath(_appImageTheme.disabledPersonalizedSettingImage, size: 150.w),
        Text('开启个性化推荐', style: _appTextTheme.labelPrimarySubtitleTextStyle),
        SizedBox(height: WidgetValue.verticalPadding),
        Text('开启个性化推荐后可启动推荐列表',style: _appTextTheme.labelPrimaryContentTextStyle),
        SizedBox(height: WidgetValue.verticalPadding * 2),
        heartbeatButton()
      ],
    );
  }

  ///立即前往按钮
  Widget heartbeatButton() {
    return InkWell(
      child: Container(
        margin: EdgeInsets.only(top: 12.h),
        alignment: Alignment(0, 0),
        height: 50.h,
        width: 150.w,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient:  LinearGradient(
            colors: [
              _appLinearGradientTheme.buttonPrimaryColor.colors[0],
              _appLinearGradientTheme.buttonPrimaryColor.colors[1],
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Text('立即开启',style: _appTextTheme.buttonPrimaryTextStyle),
      ),
      onTap: (){
        BaseViewModel.pushPage(context, const PrivacySettingPage());
      },
    );
  }

}