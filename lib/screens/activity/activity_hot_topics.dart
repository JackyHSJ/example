import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frechat/models/ws_res/activity/ws_activity_hot_topic_list_res.dart';
import 'package:frechat/models/ws_res/activity/ws_activity_search_info_res.dart';
import 'package:frechat/screens/activity/activity_browser_view_model.dart';
import 'package:frechat/screens/activity/activity_topics.dart';
import 'package:frechat/system/base_view_model.dart';
import 'package:frechat/system/constant/enum.dart';
import 'package:frechat/system/providers.dart';
import 'package:frechat/widgets/activity/activity_hot_topics_cell.dart';
import 'package:frechat/widgets/constant_value.dart';
import 'package:frechat/widgets/shared/app_bar.dart';
import 'package:frechat/widgets/shared/divider.dart';
import 'package:frechat/widgets/shared/img_util.dart';
import 'package:frechat/widgets/shared/list/main_list.dart';
import 'package:frechat/widgets/shared/main_scaffold.dart';
import 'package:frechat/widgets/strike_up_list/top_bottom_pull_loader.dart';
import 'package:frechat/widgets/theme/app_box_decoration_theme.dart';
import 'package:frechat/widgets/theme/app_text_theme.dart';
import 'package:frechat/widgets/theme/original/app_colors.dart';
import 'package:frechat/widgets/theme/app_image_theme.dart';
import 'package:frechat/widgets/theme/app_theme.dart';
import 'package:frechat/widgets/theme/uidefine.dart';
class ActivityHotTopics extends ConsumerStatefulWidget {
  const ActivityHotTopics({super.key,required this.hotTopicsPostList,required this.hotTopicListInfoList});
  final List<ActivityPostInfo> hotTopicsPostList;
  final List<HotTopicListInfo> hotTopicListInfoList;

  @override
  ConsumerState<ActivityHotTopics> createState() => _ActivityHotTopicsState();
}

class _ActivityHotTopicsState extends ConsumerState<ActivityHotTopics> {
  List<ActivityPostInfo> get _hotTopicsPostList => widget.hotTopicsPostList;
  List<HotTopicListInfo> get _hotTopicListInfoList => widget.hotTopicListInfoList;

  late Map<num, List<ActivityPostInfo>> _hotTopicsPostListCategoryMap;
  late AppTheme _theme;
  late AppBoxDecorationTheme _appBoxDecorationTheme;
  late AppTextTheme _appTextTheme;
  late AppImageTheme _appImageTheme;
  /// 載入熱門話類型貼文
  void _reloadHotTopicsListCategoryMap(){
    _hotTopicsPostListCategoryMap = {};
    for (ActivityPostInfo info in _hotTopicsPostList) {
      num topicId = info.topicId ?? 0;
      if(!_hotTopicsPostListCategoryMap.containsKey(topicId)){
        _hotTopicsPostListCategoryMap[topicId] = [];
      }
      _hotTopicsPostListCategoryMap[topicId]?.add(info);
    }
  }

  /// 取得熱門話類型中其中一則貼文顯示（依照發文數最新的顯示）
  List<ActivityPostInfo> _getHotTopicsCategoryPostList(){
    List<ActivityPostInfo> hotTopicsCategoryPostList = [];
    List allKeyList  = _hotTopicListInfoList.map((info) => info.topicId).toList();
    for(num id in allKeyList){
      List<ActivityPostInfo> categoryList =  _hotTopicsPostListCategoryMap[id] ??[];
      if(categoryList.isEmpty) continue;//避免空值
      ActivityPostInfo info = categoryList.reduce((currInfo, nextInfo) {
        num currLikeCount = currInfo.createTime??0;
        num nextLikeCount = nextInfo.createTime??0;
        return currLikeCount>=nextLikeCount ? currInfo :nextInfo;
      });
      hotTopicsCategoryPostList.add(info);
    }
    return hotTopicsCategoryPostList;
  }

  @override
  void initState() {
    _reloadHotTopicsListCategoryMap();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    _theme = ref.watch(userInfoProvider).theme ?? AppTheme(themeType: AppThemeType.original);
    _appBoxDecorationTheme = _theme.getAppBoxDecorationTheme;
    _appTextTheme = _theme.getAppTextTheme;
    _appImageTheme = _theme.getAppImageTheme;
    return MainScaffold(
      isFullScreen: true,
      needSingleScroll: false,
      padding: EdgeInsets.zero,
      appBar: _appBar(),
      child: _contentWidget(),
    );
  }

  MainAppBar _appBar(){
    return MainAppBar(
      theme: _theme,
      backgroundColor:Colors.transparent,
      title: '热门话题',
      leading: IconButton(
        icon: ImgUtil.buildFromImgPath(_appImageTheme.iconBack, size: 24.w),
        onPressed: () => BaseViewModel.popPage(context),
      ),
    );

  }

  Widget _contentWidget(){
    return Container(
      decoration:_appBoxDecorationTheme.activityHotTopicsBackgroundBoxDecoration,
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
    return Container(
      margin: EdgeInsets.only(top: appbarHeight),
      padding: EdgeInsets.symmetric(vertical: 8.h,horizontal: 24.w),
      child: Text('最新最热的话题，全在这里！', style:_appTextTheme.activityTopicSubtitleTextStyle),
    );
  }

  Widget _topicsPostListContent(){
    return Expanded(
      child: Container(
        margin: EdgeInsets.all(16.w),
        padding: EdgeInsets.symmetric(horizontal: 16.w,vertical: 16.h),
        decoration: _appBoxDecorationTheme.activityHotTopicsListContentBoxDecoration,
        child: TopBottomPullLoader(
          onRefresh: () {},
          onFetchMore: () {},
          refreshIcon: Image.asset(_appImageTheme.pullLoaderRefreshIcon, width: 36.w, height: 36.w),
          fetchMoreIcon: Image.asset(_appImageTheme.pullLoaderFetchMoreIcon, width: 36.w, height: 36.w),
          loadingIcon: Image.asset(_appImageTheme.pullLoaderLoadingIcon, width: 36.w, height: 36.w),
          child: _topicsPostList(),
        ),
      ),
    );
  }

  Widget _topicsPostList(){

    List<ActivityPostInfo> hotTopicsCategoryPostList = _getHotTopicsCategoryPostList();
    return CustomList.separatedList(
        separator: MainDivider(weight: 0, color: Colors.transparent),
        childrenNum:hotTopicsCategoryPostList.length,
        // physics: const NeverScrollableScrollPhysics(),
        children: (context, index) {
          ActivityPostInfo postInfo = hotTopicsCategoryPostList[index];
          return InkWell(
            child: ActivityHotTopicsCell(postInfo: postInfo),
            onTap: (){
              ///取得貼文的話題資訊
              HotTopicListInfo info = _hotTopicListInfoList.firstWhere((element) => element.topicId == postInfo.topicId);
              BaseViewModel.pushPage(context, ActivityTopics(hotTopicListInfo: info,));
            },
          );
        }
    );
  }
}
