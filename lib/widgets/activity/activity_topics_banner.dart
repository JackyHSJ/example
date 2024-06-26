import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';
import 'package:frechat/models/ws_res/activity/ws_activity_hot_topic_list_res.dart';
import 'package:frechat/models/ws_res/activity/ws_activity_search_info_res.dart';
import 'package:frechat/screens/activity/activity_browser_view_model.dart';
import 'package:frechat/screens/activity/activity_hot_topics.dart';
import 'package:frechat/screens/activity/activity_topics.dart';
import 'package:frechat/screens/activity/tab/recommend/activity_recommend_tab_view_model.dart';
import 'package:frechat/system/base_view_model.dart';
import 'package:frechat/system/constant/enum.dart';
import 'package:frechat/system/providers.dart';
import 'package:frechat/system/util/cache_network_image_util.dart';
import 'package:frechat/widgets/activity/activity_hot_topics_cell.dart';
import 'package:frechat/widgets/constant_value.dart';
import 'package:frechat/widgets/shared/img_util.dart';
import 'package:frechat/widgets/shared/list/grid_list.dart';
import 'package:frechat/widgets/shared/main_swiper.dart';
import 'package:frechat/widgets/theme/app_box_decoration_theme.dart';
import 'package:frechat/widgets/theme/app_color_theme.dart';
import 'package:frechat/widgets/theme/app_image_theme.dart';
import 'package:frechat/widgets/theme/app_linear_gradient_theme.dart';
import 'package:frechat/widgets/theme/app_text_theme.dart';
import 'package:frechat/widgets/theme/app_theme.dart';
import 'package:frechat/widgets/theme/original/app_box_decoration.dart';
import 'package:frechat/widgets/theme/original/app_colors.dart';

class ActivityTopicsBanner extends ConsumerStatefulWidget {
  const ActivityTopicsBanner({super.key ,required this.viewModel});
  final ActivityRecommendTabViewModel viewModel;
  @override
  ConsumerState<ActivityTopicsBanner> createState() => _ActivityTopicsBannerState();
}

class _ActivityTopicsBannerState extends ConsumerState<ActivityTopicsBanner> {
  ActivityRecommendTabViewModel get viewModel => widget.viewModel;

  late List<ActivityPostInfo> _hotTopicsList;
  late List<HotTopicListInfo> _hotTopicListInfoList;

  late AppTheme _theme;
  late AppBoxDecorationTheme _appBoxDecorationTheme;
  late AppTextTheme _appTextTheme;
  late AppImageTheme _appImageTheme;
  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context,ref,_){
      _theme = ref.watch(userInfoProvider).theme ?? AppTheme(themeType: AppThemeType.original);
      _appBoxDecorationTheme = _theme.getAppBoxDecorationTheme;
      _appTextTheme = _theme.getAppTextTheme;
      _appImageTheme = _theme.getAppImageTheme;
      _hotTopicsList = viewModel.getHotTopicsList();
      _hotTopicListInfoList = viewModel.getHotTopicListInfoList();
      return Visibility(
        visible: _hotTopicsList.isNotEmpty,
        child: Container(
          decoration: _appBoxDecorationTheme.activityHotTopicsBannerBoxDecoration,
          margin: EdgeInsets.symmetric(horizontal: 16.w,vertical: 16.h),
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _titleWidget(),
              _topicsCarouselList(),
              _topicsTagItemList(),
            ],
          ),
        ),
      );
    });

  }

  /// 標題欄位
  Widget _titleWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _titleText(),
        _titleMoreButton()
      ],
    );
  }

  /// 標題欄位 - 標題文字
  Widget _titleText(){
    return Row(
      children: [
        Text('热门话题', style: _appTextTheme.activityHotTopicTitleTextStyle),
        Image.asset('assets/activity/icon_activity_hot_topic.png',width: 24.w,height: 24.w,),
      ],
    );
  }

  /// 標題欄位 - 更多按鈕
  Widget _titleMoreButton() {
    return InkWell(
      child: Row(
        children: [
          Text('更多', style: _appTextTheme.activityHotTopicMoreTextStyle),
          ImgUtil.buildFromImgPath(_appImageTheme.iconActivityArrowForward, size: 16.w),
        ],
      ),
      onTap: ()=> BaseViewModel.pushPage(context, ActivityHotTopics(hotTopicsPostList: _hotTopicsList,hotTopicListInfoList: _hotTopicListInfoList)),
    );
  }

  /// 熱門話題輪播
  Widget _topicsCarouselList() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.h),
      child: MainSwiper(
        swiperHeight: WidgetValue.bigTextFieldHeight,
        enablePagination: false,
        scrollDirection: Axis.horizontal,
        autoplay: true,
        itemCount: _hotTopicsList.length,
        scale: 1,
        viewportFraction: 1,
      ).build(itemBuilder: (context, index) {
        ActivityPostInfo postInfo =  _hotTopicsList[index];
        return InkWell(
          onTap: () {
            ///取得貼文的話題資訊
            HotTopicListInfo info = _hotTopicListInfoList.firstWhere((element) => element.topicId == postInfo.topicId);
            BaseViewModel.pushPage(context, ActivityTopics(hotTopicListInfo: info,));
          },
          child: ActivityHotTopicsCell(postInfo: postInfo),
        );
      }),
    );
  }

  /// 話題標籤清單
  Widget _topicsTagItemList() {
    List<Widget> itemList = [];
    /// 最多顯示 4 個話題
    int count = _hotTopicListInfoList.length <4 ?_hotTopicListInfoList.length : 4;
    for(int i = 0; i< count ;i++){
      HotTopicListInfo info = _hotTopicListInfoList[i];
      itemList.add(_topicsTagItem(info));
    }
    return MainGridView(
        childAspectRatio: 5,
        shrinkWrapEnable: true,
        crossAxisCount: 2,
        physics: const NeverScrollableScrollPhysics(),
        children: itemList
    );
  }

  /// 話題標籤清單 - 話題標籤
  Widget _topicsTagItem(HotTopicListInfo hotTopicListInfo) {
    String title = hotTopicListInfo.topicTitle ??'';
    return InkWell(
      onTap: ()=> BaseViewModel.pushPage(context, ActivityTopics(hotTopicListInfo: hotTopicListInfo,)),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        decoration:_appBoxDecorationTheme.activityHotTopicsTagBoxDecoration,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('# $title',
                overflow: TextOverflow.ellipsis,
                style: _appTextTheme.activityPostTopicTagTextStyle),
            ImgUtil.buildFromImgPath(_appImageTheme.iconActivityArrowForward, size: 24.w),
          ],
        ),
      ),
    );
  }

}
