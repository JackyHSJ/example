import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frechat/models/ws_res/activity/ws_activity_search_info_res.dart';
import 'package:frechat/screens/activity/activity_post_detail_reply_list.dart';
import 'package:frechat/screens/activity/activity_post_detail_view_model.dart';
import 'package:frechat/system/constant/enum.dart';
import 'package:frechat/widgets/activity/activity_post_util.dart';
import 'package:frechat/system/assets_path/assets_images_path.dart';
import 'package:frechat/system/base_view_model.dart';
import 'package:frechat/system/providers.dart';
import 'package:frechat/system/repository/http_setting.dart';
import 'package:frechat/system/util/avatar_util.dart';
import 'package:frechat/system/util/convert_util.dart';
import 'package:frechat/widgets/activity/cell/activity_post_cell.dart';
import 'package:frechat/widgets/constant_value.dart';
import 'package:frechat/widgets/shared/app_bar.dart';
import 'package:frechat/widgets/shared/divider.dart';
import 'package:frechat/widgets/shared/img_util.dart';
import 'package:frechat/widgets/shared/main_scaffold.dart';
import 'package:frechat/widgets/theme/app_box_decoration_theme.dart';
import 'package:frechat/widgets/theme/app_color_theme.dart';
import 'package:frechat/widgets/theme/app_image_theme.dart';
import 'package:frechat/widgets/theme/app_linear_gradient_theme.dart';
import 'package:frechat/widgets/theme/app_text_theme.dart';
import 'package:frechat/widgets/theme/app_theme.dart';
import 'package:frechat/widgets/theme/original/app_colors.dart';
import 'package:frechat/widgets/theme/uidefine.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ActivityPostDetail extends ConsumerStatefulWidget {

  final ActivityPostInfo postInfo; // 貼文資訊
  const ActivityPostDetail({
    super.key,
    required this.postInfo,
  });

  @override
  ConsumerState<ActivityPostDetail> createState() => _ActivityPostDetail1State();
}

class _ActivityPostDetail1State extends ConsumerState<ActivityPostDetail> {

  late ActivityPostDetailViewModel viewModel; // viewModel
  num get feedsId => widget.postInfo.id ?? 0; // 貼文 id
  // num get replyCount => widget.postInfo.replyCount ?? 0; // 留言數（含第一、二層）
  final ScrollController _controller = ScrollController();
  late AppTheme _theme;
  late AppTextTheme _appTextTheme;
  late AppImageTheme _appImageTheme;
  late AppColorTheme _appColorTheme;
  late AppBoxDecorationTheme _appBoxDecorationTheme;

  @override
  void initState() {
    super.initState();
    viewModel = ActivityPostDetailViewModel(setState: setState, ref: ref, context: context);
    viewModel.init(feedsId);
    scrollerInit();
  }

  @override
  void dispose() {
    viewModel.dispose();
    _controller?.dispose();
    super.dispose();
  }

  void scrollerInit() {
    _controller.addListener(() {
      if (_controller.position.atEdge) {
        bool isTop = _controller.position.pixels == 0;
        if (!isTop) {
          if (viewModel.noMoreReply) return;
          setState(() {
            viewModel.isLoading = true;
          });
          viewModel.replyPage += 1;
          viewModel.getMainReplyList(widget.postInfo.id ?? 0);
        }
      }
    });
  }



  @override
  Widget build(BuildContext context) {
    _theme = ref.watch(userInfoProvider).theme ?? AppTheme(themeType: AppThemeType.original);
    _appTextTheme = _theme.getAppTextTheme;
    _appImageTheme = _theme.getAppImageTheme;
    _appColorTheme = _theme.getAppColorTheme;
    _appBoxDecorationTheme = _theme.getAppBoxDecorationTheme;

    return MainScaffold(
      needSingleScroll: false,
      resizeToAvoidBottomInset: true,
      appBar: _buildAppBar(),
      padding: const EdgeInsets.only(top: 0),
      backgroundColor: _appColorTheme.appBarBackgroundColor,
      child: SafeArea(
        bottom: false,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          children: [
            _buildMainContent(),
            // _buildReplyInputCell(),
          ],
        ),
      ),
    );
  }

  Widget _buildMainContent() {
    return Consumer(builder: (context, ref, _) {
      final List<dynamic> likeList = ref.watch(userInfoProvider).activityAllLikePostIdList ?? [];
      return Expanded(
        child: SingleChildScrollView(
          controller: _controller,
          child: Column(
            children: [
              // 貼文
              ActivityPostCell(postInfo: widget.postInfo, likeList: likeList,onTap: (){},onTapMessageButton: (){},),
              // 留言
              // replyListView(),
            ],
          ),
        ),
      );
    });
  }

  // 留言列表
  Widget replyListView() {

    List<Widget> replyList = [
      Container(width: double.infinity, height: 8.h,),
      viewModel.isLoading == false && viewModel.replyList.isEmpty ? _buildNoReplyListCell() : _buildReplyList(),
      viewModel.isLoading ? _buildLoading() : Container(height: viewModel.noMoreReply ? 0 : 28.h,),
      viewModel.replyList.isNotEmpty && viewModel.noMoreReply ? _buildNoMoreReply() : const SizedBox(),
    ];

    return Column(
      children: replyList
    );

  }

  Widget _buildLoading() {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 8.h),
        child: SizedBox(
          width: 12.w,
          height: 12.h,
          child: const FittedBox(
            child: CircularProgressIndicator(),
          )
        ),
      )
    );
  }

  Widget _buildNoMoreReply() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20.h),
      alignment: Alignment.center,
      width: UIDefine.getWidth(),
      child: Text("没有更多留言",
        style: TextStyle(
          fontSize: 12.sp,
          color: const Color(0xffCFCFCF),
          fontWeight: FontWeight.w400
        ),
      )
    );
  }

  Widget _buildReplyList() {

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: viewModel.replyList.length,
      separatorBuilder: (BuildContext context, int index) => MainDivider(weight: 1, color: _appColorTheme.activityPostCellSeparatorLineColor, height: WidgetValue.verticalPadding * 3),
      itemBuilder: (context, index) {
        return ActivityPostDetailReplyList(
          postInfo: widget.postInfo,
          key: ValueKey(viewModel.replyList[index]),
          activityReplyInfo: viewModel.replyList[index],
          focusNode: viewModel.focusNode,
          richTextController: viewModel.richTextController,
          onClick: (num replyId){
            viewModel.feedReplyId = replyId.toInt();
            viewModel.replyType = 1; // 留言 type
          },
          tagNameCheck: (String tagUserName) {
            setState(() {
              viewModel.tagUserName = tagUserName;
            });
          }
        );
      }
    );
  }

  // 用於第一層都沒有留言的情況下
  Widget _buildNoReplyListCell() {
    return Container(
        padding: EdgeInsets.symmetric(vertical: 20.h),
        alignment: Alignment.center,
        width: UIDefine.getWidth(),
        color: const Color(0xffFAFAFA),
        child: Text('赶紧抢先来当第一个留言者',
          style: _appTextTheme.activityPostReplyHintTextStyle,
        )
    );
  }

  // Appbar
  Widget _buildAppBar() {
    final String userName = widget.postInfo.userName ?? '';
    final String nickName = widget.postInfo.nickName ?? '';
    final String displayName = ConvertUtil.displayName(userName, nickName, '');

    return MainAppBar(
      theme: _theme,
      title: displayName,
      backgroundColor: Colors.transparent,
      leading: IconButton(
          icon: ImgUtil.buildFromImgPath(_appImageTheme.iconBack, size: 24.w),
          onPressed: () {
            FocusManager.instance.primaryFocus?.unfocus(); // 收起鍵盤
            BaseViewModel.popPage(context);
          }
      ),
    );
  }

  //
  // 輸入框的部分
  //

  Widget _buildReplyInputCell() {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        decoration: _appBoxDecorationTheme.activityPostReplyInputBoxDecoration,
        child: SafeArea(
            top: false,
            left: false,
            right: false,
            child: Container(
              padding: EdgeInsets.only(top: 8.h, bottom: 12.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildReplyAvatar(),
                  SizedBox(width: 8.w),
                  _buildReplyTextField(),
                  SizedBox(width: 8.w),
                  _buildReplyPostBtn(),
                ],
              ),
            )
        )
    );
  }

  Widget _buildReplyAvatar() {
    String avatarPath = ref.read(userInfoProvider).memberInfo?.avatarPath ?? '';
    num gender = ref.read(userInfoProvider).memberInfo?.gender ?? 0;

    return avatarPath.isEmpty
        ? AvatarUtil.defaultAvatar(gender, size: 24.w, radius: 8)
        : AvatarUtil.userAvatar(HttpSetting.baseImagePath + avatarPath, size: 24.w, radius: 8);
  }

  Widget _buildReplyTextField() {
    return Expanded(child: Center(child: TextField(
      controller: viewModel.richTextController,
      focusNode: viewModel.focusNode,
      textAlignVertical: TextAlignVertical.center,
      maxLength: 100,
      decoration: InputDecoration(
        border: const OutlineInputBorder(
          borderSide: BorderSide.none,
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.transparent,
          ),
        ),
        contentPadding: EdgeInsets.zero,
        counterText: '',
        filled: true,
        hintStyle: _appTextTheme.activityPostReplyHintTextStyle,
        hintText: '回复',
        fillColor: _appColorTheme.activityPostInputBackgroundColor,
      ),
      onChanged: (text) {
        final String trimText = text.trim();
        if (trimText.isEmpty) {
          viewModel.tagUserName = null;
          // viewModel.canTag = false;
          viewModel.checkReply = false;
        } else {
          viewModel.checkReply = true;
        }
        viewModel.richTextController.patternMatchMap?.update(RegExp(r"^@[^\s]+\s?"), (value) {
          return viewModel.updateRegexPattern();
        });
        setState(() {});
      },
    )));
  }

  Widget _buildReplyPostBtn() {
    return InkWell(
      onTap: () {
        final String postUserName = widget.postInfo.userName ?? '';
        final String personalUserName = ref.read(userInfoProvider).memberInfo?.userName ?? '';
        final num feedsId = widget.postInfo.id ?? 0;
        final num status = widget.postInfo.status ?? 0;

        if (status == 0) {
          viewModel.focusNode.unfocus();
          BaseViewModel.showToast(context, '动态审核中，尚无法使用此功能');
          return;
        }

        viewModel.sendReplyMessage(feedsId, postUserName, personalUserName);
      },
      child: Container(
          width: 53.w,
          height: 32.h,
          decoration: (viewModel.checkReply)
              ?_appBoxDecorationTheme.activityPostReplyPostButtonBoxDecoration
              :_appBoxDecorationTheme.activityPostReplyPostButtonDisableBoxDecoration,
          child: Center(
            child: Text(
              "发布",
              style: (viewModel.checkReply)
                  ?_appTextTheme.activityPostReplyPostButtonTextStyle
                  :_appTextTheme.activityPostReplyPostButtonDisableTextStyle,
            ),
          )
      ),
    );
  }
}
