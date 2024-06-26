import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frechat/models/ws_req/activity/ws_activity_search_info_req.dart';
import 'package:frechat/models/ws_res/activity/ws_activity_search_info_res.dart';
import 'package:frechat/screens/activity/activity_post_detail.dart';
import 'package:frechat/screens/user_info_view/user_info_view.dart';
import 'package:frechat/screens/user_info_view/user_info_view_posts_view_model.dart';
import 'package:frechat/system/assets_path/assets_images_path.dart';
import 'package:frechat/system/base_view_model.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frechat/system/constant/enum.dart';
import 'package:frechat/system/provider/user_info_provider.dart';
import 'package:frechat/system/providers.dart';
import 'package:frechat/system/repository/http_setting.dart';
import 'package:frechat/system/repository/response_code.dart';
import 'package:frechat/system/util/cache_network_image_util.dart';
import 'package:frechat/widgets/activity/cell/activity_video_player.dart';
import 'package:frechat/widgets/constant_value.dart';
import 'package:frechat/widgets/shared/app_bar.dart';
import 'package:frechat/widgets/shared/img_util.dart';
import 'package:frechat/widgets/shared/main_scaffold.dart';
import 'package:frechat/widgets/shared/media_thumbnail.dart';
import 'package:frechat/widgets/shared/video_thumbnail_util.dart';
import 'package:frechat/widgets/strike_up_list/top_bottom_pull_loader.dart';
import 'package:frechat/widgets/theme/app_box_decoration_theme.dart';
import 'package:frechat/widgets/theme/app_color_theme.dart';
import 'package:frechat/widgets/theme/app_image_theme.dart';
import 'package:frechat/widgets/theme/app_text_theme.dart';
import 'package:frechat/widgets/theme/app_theme.dart';
import 'package:frechat/widgets/theme/original/app_colors.dart';
import 'package:frechat/widgets/theme/uidefine.dart';

class UserInfoViewPosts extends ConsumerStatefulWidget {

  final List<ActivityPostInfo> feedingList;
  final DisplayMode displayMode;

  const UserInfoViewPosts({
    super.key,
    required this.feedingList,
    required this.displayMode
  });

  @override
  ConsumerState<UserInfoViewPosts> createState() => _UserInfoViewPostsState();
}

class _UserInfoViewPostsState extends ConsumerState<UserInfoViewPosts> {

  late UserInfoViewPostsViewModel viewModel;
  List<ActivityPostInfo> get feedingList => widget.feedingList;
  DisplayMode get displayMode => widget.displayMode;
  late AppTheme _theme;

  @override
  void initState() {
    super.initState();
    viewModel = UserInfoViewPostsViewModel(ref: ref, setState: setState, context: context);
    viewModel.feedingList = [...feedingList];
    viewModel.displayMode = displayMode;
    viewModel.userName = feedingList?.first?.userName ?? '';
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double paddingHeight = UIDefine.getAppBarHeight() + UIDefine.getStatusBarHeight();
    final bool hasPost = viewModel.feedingList.isNotEmpty ? true : false;
    final AppTheme theme = ref.watch(userInfoProvider).theme ?? AppTheme(themeType: AppThemeType.original);
    final AppColorTheme appColorTheme = theme.getAppColorTheme;

    return MainScaffold(
      isFullScreen: true,
      needSingleScroll: false,
      padding: EdgeInsets.only(
        top: paddingHeight,
        bottom: WidgetValue.bottomPadding,
      ),
      backgroundColor: appColorTheme.appBarBackgroundColor,
      appBar: _buildMainAppbar(),
      child: hasPost ? _buildPostGallery() : const SizedBox(),
    );
  }

  // App Bar
  PreferredSizeWidget _buildMainAppbar() {
    _theme = ref.watch(userInfoProvider).theme ?? AppTheme(themeType: AppThemeType.original);
    final AppColorTheme appColorTheme = _theme.getAppColorTheme;
    final AppTextTheme appTextTheme = _theme.getAppTextTheme;
    final AppImageTheme appImageTheme = _theme.getAppImageTheme;

    return MainAppBar(
      theme: _theme,
      backgroundColor: appColorTheme.appBarBackgroundColor,
      title: '动态墙',
      titleWidget: Text(
        "动态墙",
        style: appTextTheme.appbarTextStyle,
      ),
      leading: IconButton(
        icon: ImgUtil.buildFromImgPath(appImageTheme.iconBack, size: 24.w),
        onPressed: () => BaseViewModel.popPage(context),
      ),
    );
  }

  Widget _buildPostGallery() {
    return TopBottomPullLoader(
      enableRefresh: false,
      onRefresh: () {},
      onFetchMore: () => viewModel.fetchMore(),
      child: CustomScrollView(
        slivers: [
          SliverGrid(
            gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 1,
              crossAxisSpacing: 1,
            ),
            delegate: SliverChildListDelegate(_memberPosts()),
          ),
        ],
      ),
    );
  }

  // 動態牆
  List<Widget> _memberPosts() {
    return List.generate(viewModel.feedingList.length, (index) => _memberPost(viewModel.feedingList[index]!));
  }

  // 單一貼文
  Widget _memberPost(ActivityPostInfo data) {

    final num type = data.type ?? 0;

    return InkWell(
      onTap: () => BaseViewModel.pushPage(context, ActivityPostDetail(postInfo: data)),
      child: type == 0 ? _memberPostPhoto(data) : _memberPostVideo(data),
    );
  }


  // 相片貼文
  Widget _memberPostPhoto(ActivityPostInfo data) {
    final String contentUrl = data.contentUrl ?? '';
    List<String> contentUrls = contentUrl.split(',');
    final String url = HttpSetting.baseImagePath + contentUrls.first;
    return Stack(
      children: [
        Container(
          color: AppColors.mainGrey,
          child: CachedNetworkImageUtil.load(url, radius: 0),
        ),
        contentUrls.length > 1 ? _photosIcon() : const SizedBox(),
      ],
    );
  }

  // 圖片 Icon
  Widget _photosIcon() {
    return Positioned(
      top: 4,
      right: 4,
      child: ImgUtil.buildFromImgPath(AssetsImagesPath.iconActivityPostTypePhoto, size: 24.w)
    );
  }

  // 影片貼文
  Widget _memberPostVideo(ActivityPostInfo data) {
    final String contentUrl = data.contentUrl ?? '';
    final String url = HttpSetting.baseImagePath + contentUrl;

    return Stack(
      children: [
        MediaThumbnail(
          width: double.infinity,
          height: double.infinity,
          videoUrl: url,
        ),
        _videoIcon()
      ],
    );
  }

  // 影片 Icon
  Widget _videoIcon() {
    return Positioned(
      top: 4,
      right: 4,
      child: ImgUtil.buildFromImgPath(AssetsImagesPath.iconActivityPostTypeVideo, size: 24.w)
    );
  }
}
