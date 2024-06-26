

import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frechat/models/ws_res/activity/ws_activity_search_info_res.dart';
import 'package:frechat/screens/image_links_viewer.dart';
import 'package:frechat/screens/profile/edit/personal_edit_view_model.dart';
import 'package:frechat/system/constant/enum.dart';
import 'package:frechat/system/providers.dart';
import 'package:frechat/system/repository/http_setting.dart';
import 'package:frechat/system/util/cache_network_image_util.dart';
import 'package:frechat/system/util/date_format_util.dart';
import 'package:frechat/widgets/activity/cell/activity_video_player.dart';
import 'package:frechat/widgets/constant_value.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frechat/widgets/shared/aspect_ratio_image.dart';
import 'package:frechat/widgets/shared/aspect_ratio_video.dart';
import 'package:frechat/widgets/shared/expandable_text.dart';
import 'package:frechat/widgets/shared/img_util.dart';
import 'package:frechat/widgets/shared/main_swiper.dart';
import 'package:frechat/widgets/theme/app_box_decoration_theme.dart';
import 'package:frechat/widgets/theme/app_color_theme.dart';
import 'package:frechat/widgets/theme/app_image_theme.dart';
import 'package:frechat/widgets/theme/app_linear_gradient_theme.dart';
import 'package:frechat/widgets/theme/app_text_theme.dart';
import 'package:frechat/widgets/theme/app_theme.dart';
import 'package:frechat/widgets/theme/original/app_colors.dart';
import 'package:intl/intl.dart';

class ActivityPostCellContent extends ConsumerStatefulWidget {
  const ActivityPostCellContent({super.key, required this.postInfo});
  final ActivityPostInfo postInfo;
  @override
  ConsumerState<ActivityPostCellContent> createState() => _ActivityPostCellContentState();
}

class _ActivityPostCellContentState extends ConsumerState<ActivityPostCellContent> {
  ActivityPostInfo get postInfo => widget.postInfo;
  final double _horizontal = WidgetValue.horizontalPadding + WidgetValue.separateHeight;
  late AppTheme _theme;
  late AppTextTheme _appTextTheme;
  late AppLinearGradientTheme _appLinearGradientTheme;
  late AppColorTheme _appColorTheme;
  late AppImageTheme _appImageTheme;
  late AppBoxDecorationTheme _appBoxDecorationTheme;

  /// 將圖片路徑轉乘EditModel清單（主要是為了使用ImageLinksViewerArgs 組件）
  List<EditImgModel> _getEditModelImgList (List<String> list){
    List<EditImgModel> editImgList = [];
    for (String url in list) {
      String path = url;
      ImgType type = ImgType.filePath;
      if (widget.postInfo.status == 1) {
        path = HttpSetting.baseImagePath + url;
        type = ImgType.urlPath;
      }
      EditImgModel model = EditImgModel(path: path, type: type);
      editImgList.add(model);
    }
    return editImgList;

  }
  /// 取得貼文時間
  String _getPostTime(){
    final int postTime = postInfo.createTime?.toInt() ?? 0;
    final DateTime currentDateTime = DateTime.now();
    final DateTime postDateTime = DateTime.fromMillisecondsSinceEpoch(postTime);
    Duration difference = currentDateTime.difference(postDateTime);
    if (difference.inMinutes < 1) {
      return '1分钟前';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}分钟前';
    } else if (difference.inHours < 12) {
      return '${difference.inHours}小时前';
    } else if (difference.inHours < 24) {
      return DateFormatUtil.getDateWith12HourTimeFormat(postDateTime);
    } else if (difference.inHours < 48) {
      return '昨天 ${DateFormatUtil.getDateWith12HourTimeFormat(postDateTime)}';
    } else {
      return DateFormatUtil.getDateWith12HourFormat(postDateTime);
    }
  }

  @override
  Widget build(BuildContext context) {
    _theme = ref.watch(userInfoProvider).theme ?? AppTheme(themeType: AppThemeType.original);
    _appTextTheme = _theme.getAppTextTheme;
    _appColorTheme = _theme.getAppColorTheme;
    _appImageTheme = _theme.getAppImageTheme;
    _appBoxDecorationTheme = _theme.getAppBoxDecorationTheme;
    final String contentUrl = postInfo.contentUrl ?? '';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _postTextContent(),
        _postImageList(),
        // _postTagText(),
        _postTimeText(),
      ],
    );
  }

  /// 貼文內容
  Widget _postTextContent() {
    return Padding(
      padding: EdgeInsets.only(right: _horizontal,bottom: 8.h),
      child: ExpandableText(
        text: postInfo.content ?? '',
        maxLines: 3,
        style: _appTextTheme.activityPostContentTextStyle,
      ),
    );
  }

  /// 貼文影像列表
  Widget _postImageList(){
    String urlString = widget.postInfo.contentUrl ?? '';
    String localUrlString = widget.postInfo.contentLocalUrl ?? '';
    bool isLocalUrl = false;
    List<String> imgUrlList = [];
    if(localUrlString.isNotEmpty){
      isLocalUrl = true;
      imgUrlList = localUrlString.split(',');
    }else{
      isLocalUrl = false;
      imgUrlList = urlString.split(',');
    }

    bool imgUrlListLength = imgUrlList.length > 1;

    if (imgUrlListLength) {
      return _photoGridView(imgUrlList);
    }


    if (widget.postInfo.type == 0) {
      return _postImagePhotoItem(isLocalUrl: isLocalUrl, index: 0, list: imgUrlList);
    }

    return _postImageVideoItem(isLocalUrl: isLocalUrl, url:imgUrlList[0]);
  }

  /// 貼文影像列表 - 圖片項目
  Widget _postImagePhotoItem({required bool isLocalUrl,required int index,required List<String> list}){
    List<EditImgModel> modelList = _getEditModelImgList(list);
    EditImgModel model = modelList[index];
    Widget item ;
    if(isLocalUrl){
      // item =  ImgUtil.buildFromImgPath(model.path, radius: 12, fit: BoxFit.contain, background: Colors.black);
      item = AspectRatioImage(imagePath: model.path, fileType: FileType.file, fromPage: FromPage.activity);
    }else{
      item = AspectRatioImage(imagePath: model.path, fileType: FileType.network, fromPage: FromPage.activity);
      // item =  CachedNetworkImageUtil.load(model.path, radius: 12, fit: BoxFit.contain, background: Colors.black);
    }
    return InkWell(
      child: item,
      onTap: (){
        ImageLinksViewer.show(
          context,
          ImageLinksViewerArgs(
            imageLinks: modelList,
            initialPage: index,
          ),
        );
      },
    );
  }

  ///九宫格
  Widget _photoGridView(List<String> list){
    List<EditImgModel> modelList = _getEditModelImgList(list);
    List<Widget> photoWidgetList = [];
    List<ImageProvider> returnList = [];

    for(int i =0;i<modelList.length;i++){
      String path = modelList[i].path;
      photoWidgetList.add(InkWell(
        child: CachedNetworkImageUtil.load(path, fit: BoxFit.cover, background: Colors.black),
        onTap: (){
          ImageLinksViewer.show(
              context,
              ImageLinksViewerArgs(
                  imageLinks: returnList,
                  initialPage: i
              )
          );
        },
      ));
      returnList.add(CachedNetworkImageProvider(path));
    }

    return Padding(
      padding: EdgeInsets.only(right: 8.w),
      child: GridView(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisSpacing:10,
          crossAxisCount: 3,
          mainAxisSpacing: 10,
          childAspectRatio: 1.0
        ),
        children: photoWidgetList
      ),
    );
  }

  /// 貼文影像列表 - 影片項目
  Widget _postImageVideoItem({required bool isLocalUrl,required String url}){
    Widget item ;

    if (isLocalUrl) {
      item = AspectRatioVideo(
        filePath: url,
        source: VideoSource.file,
        borderRadius: 12,
        showPlayBtn: true,
      );
    } else {
      item = AspectRatioVideo(
        filePath: HttpSetting.baseImagePath + url,
        source: VideoSource.network,
        borderRadius: 12,
        showPlayBtn: true,
      );
    }
    return item;
  }

  ///貼文話題標籤
  Widget _postTagText(){
    String topicTitle =  postInfo.topicTitle??'';
    return Visibility(
        visible: topicTitle.isNotEmpty,
        child: Container(
          margin: EdgeInsets.only(bottom: 16.h),
          child: Text(
              '# $topicTitle',
            style:_appTextTheme.activityPostTopicTagTextStyle,
          ),
        ),);
  }

  ///貼文時間
  Widget _postTimeText() {
    String time = _getPostTime();
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.h),
      child: Text(
        time,
        style: _appTextTheme.activityPostDateTextStyle,
      ),
    );
  }
}