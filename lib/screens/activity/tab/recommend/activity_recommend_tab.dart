
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';
import 'package:frechat/models/ws_req/activity/ws_activity_search_info_req.dart';
import 'package:frechat/models/ws_res/activity/ws_activity_search_info_res.dart';
import 'package:frechat/screens/activity/activity_browser_view_model.dart';
import 'package:frechat/screens/activity/activity_post_detail.dart';
import 'package:frechat/screens/activity/add/activity_add_post.dart';
import 'package:frechat/screens/activity/tab/recommend/activity_recommend_tab_view_model.dart';
import 'package:frechat/screens/profile/setting/privacy_setting/privacy_setting_page.dart';
import 'package:frechat/system/base_view_model.dart';
import 'package:frechat/system/database/model/chat_block_model.dart';
import 'package:frechat/system/global.dart';
import 'package:frechat/system/provider/chat_block_model_provider.dart';
import 'package:frechat/system/providers.dart';
import 'package:frechat/widgets/activity/activity_topics_banner.dart';
import 'package:frechat/widgets/activity/cell/activity_post_cell.dart';
import 'package:frechat/widgets/constant_value.dart';
import 'package:frechat/widgets/shared/divider.dart';
import 'package:frechat/widgets/shared/gradient_component.dart';
import 'package:frechat/widgets/shared/img_util.dart';
import 'package:frechat/widgets/shared/list/grid_list.dart';
import 'package:frechat/widgets/shared/list/main_list.dart';
import 'package:frechat/widgets/shared/main_scaffold.dart';
import 'package:frechat/widgets/shared/main_swiper.dart';
import 'package:frechat/widgets/strike_up_list/top_bottom_pull_loader.dart';
import 'package:frechat/widgets/theme/app_box_decoration_theme.dart';
import 'package:frechat/widgets/theme/app_color_theme.dart';
import 'package:frechat/widgets/theme/app_image_theme.dart';
import 'package:frechat/widgets/theme/app_text_theme.dart';
import 'package:frechat/widgets/theme/original/app_colors.dart';
import 'package:frechat/widgets/theme/app_linear_gradient_theme.dart';
import 'package:frechat/widgets/theme/app_theme.dart';

import '../../../../system/constant/enum.dart';

class ActivityRecommendTab extends ConsumerStatefulWidget {
  const ActivityRecommendTab({super.key});

  @override
  ConsumerState<ActivityRecommendTab> createState() => _ActivityRecommendTabState();
}

class _ActivityRecommendTabState extends ConsumerState<ActivityRecommendTab> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  late ActivityRecommendTabViewModel viewModel;
  late AppTheme _theme;
  late AppTextTheme _appTextTheme;
  late AppLinearGradientTheme _appLinearGradientTheme;
  late AppImageTheme _appImageTheme;
  late AppColorTheme _appColorTheme;

  void _onTapActivityCell({required ActivityPostInfo postInfo,required List<dynamic> likeList}){

    if(postInfo.status ==0){
      BaseViewModel.showToast(context, '动态审核中，无法使用此功能');
      return;
    }
    BaseViewModel.pushPage(context, ActivityPostDetail(postInfo: postInfo));
  }

  @override
  void initState() {
    viewModel = ActivityRecommendTabViewModel(setState: setState, ref: ref);
    viewModel.init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _theme = ref.watch(userInfoProvider).theme ?? AppTheme(themeType: AppThemeType.original);
    _appTextTheme = _theme.getAppTextTheme;
    _appImageTheme = _theme.getAppImageTheme;
    _appColorTheme = _theme.getAppColorTheme;
    _appLinearGradientTheme = _theme.getAppLinearGradientTheme;

    bool  isClosePersonalizedRecommendations = ref.watch(userInfoProvider).isClosePersonalizedRecommendations ?? false;
    if (isClosePersonalizedRecommendations) {
      return goToOpenPersonalizedRecommendations();
    }
    return TopBottomPullLoader(
      onRefresh: () => viewModel.activityPostRefresh(),
      onFetchMore: () => viewModel.activityPostFetchMore(),
      refreshIcon: Image.asset(_appImageTheme.pullLoaderRefreshIcon, width: 36.w, height: 36.w),
      fetchMoreIcon: Image.asset(_appImageTheme.pullLoaderFetchMoreIcon, width: 36.w, height: 36.w),
      loadingIcon: Image.asset(_appImageTheme.pullLoaderLoadingIcon, width: 36.w, height: 36.w),
      child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
        double parentHeight = constraints.maxHeight + 5.h;
        return SingleChildScrollView(
          child: Container(
            constraints: BoxConstraints(minHeight: parentHeight),
            child: _tabContent(),
          ),
        );
      }),
    );
  }

  /// 推薦頁內容
  Widget _tabContent(){
    return Consumer(builder: (context, ref, _) {
      final List<ActivityPostInfo> allList = viewModel.getAllActivityPostInfoList();
      final List<dynamic> likeList = ref.watch(userInfoProvider).activityAllLikePostIdList ?? [];
      List<ActivityPostInfo> hotTopicsList = ref.watch(userInfoProvider).activitySearchInfoHotTopics?.list ?? [];
      return Visibility(
        visible: (allList.isNotEmpty || hotTopicsList.isNotEmpty),
        replacement: _emptyWidget(),
        child: Column(
          children: [
            // _topicsBanner(),
            _postList(postInfolist: allList, likeList: likeList),
          ],
        ),);
    });
  }

  /// 推薦頁內容 - 熱門話題
  Widget _topicsBanner(){
    return ActivityTopicsBanner(viewModel: viewModel,);
  }

  /// 推薦頁內容 - 貼文列表
  Widget _postList({required List<ActivityPostInfo> postInfolist,required List<dynamic> likeList}) {
    return Visibility(
      visible: postInfolist.isNotEmpty,
      replacement: _emptyWidget(),
      child: CustomList.separatedList(
          separator: MainDivider(weight: 1, color: _appColorTheme.activityPostCellSeparatorLineColor, height: WidgetValue.verticalPadding * 3),
          childrenNum: postInfolist.length,
          physics: const NeverScrollableScrollPhysics(),
          children: (context, index) {
            return ActivityPostCell(
              postInfo: postInfolist[index],
              likeList: likeList,
              onTap: () =>  _onTapActivityCell(postInfo: postInfolist[index], likeList: likeList),
              onTapMessageButton: () =>  _onTapActivityCell(postInfo: postInfolist[index], likeList: likeList),
            );
          },
      ),
    );
  }

  /// 推薦頁內容 - 無貼文內容
  Widget _emptyWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ImgUtil.buildFromImgPath(_appImageTheme.imageActivityEmpty, size: 150.w),
          Text('暂无动态', style: _appTextTheme.labelPrimarySubtitleTextStyle),
          SizedBox(height: WidgetValue.verticalPadding),
          Text('暂时还没有推荐动态', style:_appTextTheme.labelPrimaryContentTextStyle),
          SizedBox(height: WidgetValue.verticalPadding * 2),
        ],
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