import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frechat/models/ws_res/activity/ws_activity_hot_topic_list_res.dart';
import 'package:frechat/models/ws_res/activity/ws_activity_search_info_res.dart';
import 'package:frechat/screens/activity/activity_post_detail.dart';
import 'package:frechat/screens/activity/activity_topics_view_model.dart';
import 'package:frechat/system/base_view_model.dart';
import 'package:frechat/system/constant/enum.dart';
import 'package:frechat/system/providers.dart';
import 'package:frechat/widgets/activity/cell/activity_post_cell.dart';
import 'package:frechat/widgets/constant_value.dart';
import 'package:frechat/widgets/shared/app_bar.dart';
import 'package:frechat/widgets/shared/divider.dart';
import 'package:frechat/widgets/shared/img_util.dart';
import 'package:frechat/widgets/shared/list/main_list.dart';
import 'package:frechat/widgets/shared/main_scaffold.dart';
import 'package:frechat/widgets/strike_up_list/top_bottom_pull_loader.dart';
import 'package:frechat/widgets/theme/app_box_decoration_theme.dart';
import 'package:frechat/widgets/theme/app_color_theme.dart';
import 'package:frechat/widgets/theme/app_text_theme.dart';
import 'package:frechat/widgets/theme/original/app_colors.dart';
import 'package:frechat/widgets/theme/app_image_theme.dart';
import 'package:frechat/widgets/theme/app_theme.dart';
import 'package:frechat/widgets/theme/uidefine.dart';
class ActivityTopics extends ConsumerStatefulWidget {
  const ActivityTopics({super.key,required this.hotTopicListInfo});
  final HotTopicListInfo hotTopicListInfo;


  @override
  ConsumerState<ActivityTopics> createState() => _ActivityTopicsState();
}

class _ActivityTopicsState extends ConsumerState<ActivityTopics> {

  HotTopicListInfo get hotTopicListInfo  => widget.hotTopicListInfo;

  late ActivityTopicsViewModel viewModel;
  late AppTheme _theme;
  late AppImageTheme _appImageTheme;
  late AppColorTheme _appColorTheme;
  late AppBoxDecorationTheme _appBoxDecorationTheme;
  late AppTextTheme _appTextTheme;


  @override
  void initState() {
    viewModel = ActivityTopicsViewModel(setState: setState, ref: ref);
    viewModel.init( hotTopicListInfo.topicId ?? 0);
    super.initState();
  }

  @override
  void dispose(){
    viewModel.dispose();
    super.dispose();

  }

  @override
  Widget build(BuildContext context) {
    _theme = ref.watch(userInfoProvider).theme ?? AppTheme(themeType: AppThemeType.original);
    _appImageTheme = _theme.getAppImageTheme;
    _appColorTheme = _theme.getAppColorTheme;
    _appBoxDecorationTheme = _theme.getAppBoxDecorationTheme;
    _appTextTheme = _theme.getAppTextTheme;


    return MainScaffold(
      isFullScreen: true,
      needSingleScroll: false,
      padding: EdgeInsets.zero,
      backgroundColor: _appColorTheme.baseBackgroundColor,
      appBar: _appBar(),
      child: _contentWidget(),
    );
  }

  MainAppBar _appBar(){
    String title = hotTopicListInfo.topicTitle ??'话题';
    return MainAppBar(
      theme: _theme,
      backgroundColor:Colors.transparent,
      title: title,
      leading: IconButton(
        icon: ImgUtil.buildFromImgPath(_appImageTheme.iconBack, size: 24.w),
        onPressed: () => BaseViewModel.popPage(context),
      ),
    );

  }

  Widget _contentWidget(){
    return Container(
        decoration:_appBoxDecorationTheme.activityTopicsAppBarBoxDecoration,
      child: Column(
        children: [
          _topicsTitle(),
          _topicsPostListContent(),
        ],
      ),
    );
  }

  Widget _topicsTitle(){
    final double appbarHeight = UIDefine.getAppBarHeight() + UIDefine.getStatusBarHeight();
    String content = hotTopicListInfo.topicContent ??'';
    return Container(
      margin: EdgeInsets.only(top: appbarHeight),
      padding: EdgeInsets.symmetric(vertical: 8.h,horizontal: 24.w),
      child: Text(content, style: _appTextTheme.activityTopicSubtitleTextStyle,),
    );
  }

  Widget _topicsPostListContent(){

    return Expanded(
      child: Container(
        color: _appColorTheme.baseBackgroundColor,
        child: TopBottomPullLoader(
          onRefresh: () => viewModel.activityPostRefresh(),
          onFetchMore: () => viewModel.activityPostFetchMore(),
          refreshIcon: Image.asset(_appImageTheme.pullLoaderRefreshIcon, width: 36.w, height: 36.w),
          fetchMoreIcon: Image.asset(_appImageTheme.pullLoaderFetchMoreIcon, width: 36.w, height: 36.w),
          loadingIcon: Image.asset(_appImageTheme.pullLoaderLoadingIcon, width: 36.w, height: 36.w),
          child: _topicsPostList(),
        ),
      ),
    );
  }

  Widget _topicsPostList(){
    return Consumer(builder: (context, ref, _) {
      final List<ActivityPostInfo> postInfolist = viewModel.topiscPostlist;
      final List<dynamic> likeList = ref.read(userInfoProvider).activityAllLikePostIdList ?? [];
      return CustomList.separatedList(
          separator: MainDivider(weight: 1, color:  _appColorTheme.activityPostCellSeparatorLineColor, height: WidgetValue.verticalPadding * 3),
          childrenNum:postInfolist.length,
          children: (context, index) {
            return ActivityPostCell(
              postInfo: postInfolist[index],
              likeList: likeList,
              onTap: () {
                BaseViewModel.pushPage(context, ActivityPostDetail(postInfo: postInfolist[index]));
              },
              onTapMessageButton: () {
                BaseViewModel.pushPage(context, ActivityPostDetail(postInfo: postInfolist[index]));
              },
            );
          }
      );
    });

  }

}
