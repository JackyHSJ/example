import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';
import 'package:frechat/models/ws_res/activity/ws_activity_hot_topic_list_res.dart';
import 'package:frechat/models/ws_res/activity/ws_activity_search_info_res.dart';
import 'package:frechat/screens/activity/activity_topics.dart';
import 'package:frechat/screens/profile/edit/personal_edit_view_model.dart';
import 'package:frechat/system/base_view_model.dart';
import 'package:frechat/system/constant/enum.dart';
import 'package:frechat/system/providers.dart';
import 'package:frechat/system/repository/http_setting.dart';
import 'package:frechat/system/util/cache_network_image_util.dart';
import 'package:frechat/widgets/activity/cell/activity_video_player.dart';
import 'package:frechat/widgets/constant_value.dart';
import 'package:frechat/widgets/shared/aspect_ratio_video.dart';
import 'package:frechat/widgets/shared/img_util.dart';
import 'package:frechat/widgets/theme/app_box_decoration_theme.dart';
import 'package:frechat/widgets/theme/app_image_theme.dart';
import 'package:frechat/widgets/theme/app_text_theme.dart';
import 'package:frechat/widgets/theme/app_theme.dart';
import 'package:frechat/widgets/theme/original/app_colors.dart';

class ActivityHotTopicsCell extends ConsumerStatefulWidget {
  const ActivityHotTopicsCell({super.key,required this.postInfo});
  final ActivityPostInfo postInfo;

  @override
  ConsumerState<ActivityHotTopicsCell> createState() => _ActivityHotTopicsCellState();
}

class _ActivityHotTopicsCellState extends ConsumerState<ActivityHotTopicsCell> {
  ActivityPostInfo get postInfo => widget.postInfo;
  late AppTheme _theme;
  late AppBoxDecorationTheme _appBoxDecorationTheme;
  late AppTextTheme _appTextTheme;
  late AppImageTheme _appImageTheme;


  @override
  Widget build(BuildContext context) {
    _theme = ref.watch(userInfoProvider).theme ?? AppTheme(themeType: AppThemeType.original);
    _appBoxDecorationTheme = _theme.getAppBoxDecorationTheme;
    _appTextTheme = _theme.getAppTextTheme;
    _appImageTheme = _theme.getAppImageTheme;

    return  Container(
      decoration: _appBoxDecorationTheme.activityHotTopicsPostBoxDecoration,
      padding: EdgeInsets.symmetric(vertical:8.h,horizontal: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _imageContent(),
          _describeContent(),
          _nextButton()
        ],
      ),
    );
  }

  /// 熱門項目附檔
  Widget _imageContent(){
    String imgString = postInfo.contentUrl ?? '';
    List<String> urlList = imgString.split(',');
    String url = HttpSetting.baseImagePath + urlList[0];
    return postInfo.type ==0
        ?_imageContentPhoto(url)
        :_imageContentVideo(url);

  }
  /// 熱門項目附檔 - 圖片檔
  Widget _imageContentPhoto(String url) {
    return CachedNetworkImageUtil.load(url, radius: 10.w,size: 100.w);
  }
  /// 熱門項目附檔 - 影片檔
  Widget _imageContentVideo(String url) {
    return AspectRatioVideo(
      filePath: url,
      source: VideoSource.network,
      borderRadius: 12,
      width: 100.w,
      height: 100.w,
      showPlayBtn: true,
      playBtnSize: 24,
      enablePreview: true,
    );
  }

  /// 熱門項目文字內容
  Widget _describeContent(){

    String topicTitle = postInfo.topicTitle ??'';
    return Container(
      width: 155.w,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          Text('# $topicTitle',
              style: _appTextTheme.activityPostTopicTagTextStyle),
          Text(
            postInfo.content ??'',
            maxLines: 5,
            overflow: TextOverflow.ellipsis,
            style: _appTextTheme.activityHotTopicPostContentTextStyle,
          )
        ],
      ),
    );
  }

  /// 熱門項目前往按鈕
  Widget _nextButton() {
    return ImgUtil.buildFromImgPath(_appImageTheme.iconActivityArrowForward, size: 24.w);
  }
}
