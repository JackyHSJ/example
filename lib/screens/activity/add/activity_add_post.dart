

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frechat/models/ws_res/activity/ws_activity_hot_topic_list_res.dart';
import 'package:frechat/screens/activity/add/activity_add_post_view_model.dart';
import 'package:frechat/screens/image_links_viewer.dart';
import 'package:frechat/system/assets_path/assets_images_path.dart';
import 'package:frechat/system/base_view_model.dart';
import 'package:frechat/system/call_back_function.dart';
import 'package:frechat/system/constant/enum.dart';
import 'package:frechat/system/global/shared_preferance.dart';
import 'package:frechat/widgets/shared/aspect_ratio_video.dart';
import 'package:frechat/widgets/shared/dialog/check_dialog.dart';
import 'package:frechat/widgets/shared/dialog/hero_dialog.dart';
import 'package:frechat/system/providers.dart';
import 'package:frechat/system/util/permission_util.dart';
import 'package:frechat/widgets/activity/cell/activity_video_player.dart';
import 'package:frechat/widgets/constant_value.dart';
import 'package:frechat/widgets/shared/app_bar.dart';
import 'package:frechat/widgets/shared/bottom_sheet/common_bottom_sheet.dart';
import 'package:frechat/widgets/shared/buttons/common_button.dart';
import 'package:frechat/widgets/shared/dialog/activity/activity_add_post_tag_dialog.dart';
import 'package:frechat/widgets/shared/dialog/base_dialog.dart';
import 'package:frechat/widgets/shared/dialog/comm_dialog.dart';
import 'package:frechat/widgets/shared/img_util.dart';
import 'package:frechat/widgets/shared/list/main_list.dart';
import 'package:frechat/widgets/shared/loading_animation.dart';
import 'package:frechat/widgets/shared/main_scaffold.dart';
import 'package:frechat/widgets/shared/main_textfield.dart';
import 'package:frechat/widgets/theme/app_box_decoration_theme.dart';
import 'package:frechat/widgets/theme/app_color_theme.dart';
import 'package:frechat/widgets/theme/app_image_theme.dart';
import 'package:frechat/widgets/theme/app_linear_gradient_theme.dart';
import 'package:frechat/widgets/theme/app_text_theme.dart';
import 'package:frechat/widgets/theme/app_theme.dart';
import 'package:frechat/widgets/theme/original/app_colors.dart';
import 'package:frechat/widgets/theme/uidefine.dart';
import 'package:permission_handler/permission_handler.dart';


//
// 發佈動態
//

class ActivityAddPost extends ConsumerStatefulWidget {
  const ActivityAddPost({super.key});

  @override
  ConsumerState<ActivityAddPost> createState() => _ActivityAddPostState();
}

class _ActivityAddPostState extends ConsumerState<ActivityAddPost> {
  late ActivityAddPostViewModel viewModel;
  late AppTheme _theme;
  late AppTextTheme _appTextTheme;
  late AppColorTheme _appColorTheme;
  late AppImageTheme _appImageTheme;
  late AppLinearGradientTheme _appLinearGradientTheme;
  @override
  void initState() {
    viewModel = ActivityAddPostViewModel(setState: setState, ref: ref, context: context);
    viewModel.init();

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
    _appTextTheme = _theme.getAppTextTheme;
    _appColorTheme = _theme.getAppColorTheme;
    _appImageTheme = _theme.getAppImageTheme;
    _appLinearGradientTheme = _theme.getAppLinearGradientTheme;
    return MainScaffold(
      enableBackGesture: false,
      padding: EdgeInsets.only(top: paddingHeight, left: WidgetValue.horizontalPadding, right: WidgetValue.horizontalPadding),
      appBar: _buildAppBar(),
        backgroundColor: _appColorTheme.baseBackgroundColor,
      child: Container(
        color: _appColorTheme.baseBackgroundColor,
        child: PopScope(
          canPop: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 12.h),
              _buildActivityContent(),
              _buildActivityImageOrVideo(),
              // _buildActivityTopic(),
              SizedBox(height: 84.h),
              _buildSendBtn(),
              SizedBox(height: 12.h),
            ],
          ),
        ),
      )
    );
  }

  // Appbar
  MainAppBar _buildAppBar() {
    return MainAppBar(
      theme: _theme,
      title: '发布动态',
      leading: IconButton(
          icon: ImgUtil.buildFromImgPath(_appImageTheme.iconBack, size: 24.w),
          onPressed: () {
            FocusManager.instance.primaryFocus?.unfocus(); // 收起鍵盤
            _buildCancelDialog();
          }),
    );
  }


  // 標題
  Widget _buildTitles(String title) {
    return Text(title, style: _appTextTheme.labelPrimaryTextStyle);
  }

  // Hint
  Widget _buildHint(String hint) {
    return Text(hint, style:_appTextTheme.labelSecondaryTextStyle);
  }

  // 動態內容
  Widget _buildActivityContent() {
    String contentLimit = '${viewModel.desCurrentLength} / ${viewModel.desMaxLength}';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            _buildTitles('和大家分享你在想什么'),
            const SizedBox(width: 6),
            _buildHint(contentLimit),
          ],
        ),
        const SizedBox(height: 8),
        _buildContentField(),
        const SizedBox(height: 20),
      ],
    );
  }

  // 圖片或影片內容
  Widget _buildActivityImageOrVideo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTitles('添加图片或视频'),
                const SizedBox(width: 6),
                _buildHint('*二择一'),
              ],
            ),
            _buildHelpBtn(),
          ],
        ),
        const SizedBox(height: 8),
        _buildFileArea(),
        const SizedBox(height: 20),
      ],
    );
  }

  // 熱門話題
  Widget _buildActivityTopic() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTitles('话题标签'),
        const SizedBox(width: 6),
        _buildHint('*选填'),
        const SizedBox(height: 8),
        _buildTagBtn(),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildFileArea() {
    final List<File> selectImg = viewModel.selectImgList;
    return selectImg.isEmpty
        ? _buildUnselectFile()
        : _buildSelectedFile(); // 已選取檔案的 Widget
  }

  // 已選取檔案的 Widget
  Widget _buildSelectedFile() {
    final int postType = viewModel.postType;
    final List<File> selectImg = viewModel.selectImgList;
    final int imgLength = selectImg.length < 5 ? selectImg.length + 1 : selectImg.length;

    // 影片
    if (postType == 1) {
      return AspectRatioVideo(
        filePath: selectImg.first.path,
        source: VideoSource.file,
        borderRadius: 12,
        showPlayBtn: true,
        showDuration: true,
        showRemoveBtn: true,
        playBtnSize: 24,
        removeFile: () => viewModel.cancelImg(0),
        page: 1,
      );
    }

    // 圖片
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(imgLength, (index) {
          try {
            return _buildSelectedImg(selectImg[index].path, index: index);
          } catch(e) {
            return _buildEmptyImg();
          }
        }),
      ),
    );
  }

  // 尚未選取檔案的 Widget
  Widget _buildUnselectFile() {
    return Row(
      children: [
      _buildUnselectCell(albumOrCameraBottomDialog, AssetsImagesPath.iconActivityPostImage),
        const SizedBox(width: 8),
      _buildUnselectCell(viewModel.selectVideo, AssetsImagesPath.iconActivityPostVideo),
      ],
    );
  }

  Widget _buildUnselectCell(Function onTap, String imagePath) {
    return Expanded(
      child: InkWell(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onTap: () => onTap(),
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border.all(
              width: 1,
              color: _appColorTheme.textFieldBorderColor,
            ),
            color: _appColorTheme.textFieldBackgroundColor,
            borderRadius: BorderRadius.circular(12),
          ),
          height: 112,
          child: Center(
            child: ImgUtil.buildFromImgPath(imagePath, size: 24.w),
          ),
        ),
      ),
    );
  }

  Widget _buildSelectedImg(String imgPath, {required int index}) {
    return Container(
      margin: const EdgeInsets.only(right: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
            width: 1,
            color: const Color(0xffEAEAEA)
        ),
        // color: Color(0xffFAFAFA)
      ),
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          InkWell(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onTap: () => viewModel.showBrowserImg(context, index: index),
            child: ImgUtil.buildFromImgPath(imgPath, size: 112, radius: WidgetValue.btnRadius / 2),
          ),
          _buildRemoveFileBtn(index)
        ],
      ),
    );
  }

  Widget _buildEmptyImg() {
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () {
        albumOrCameraBottomDialog();
      },
      child: Container(
        width: 112,
        height: 112,
        margin: const EdgeInsets.only(right: 4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            width: 1,
            color: const Color(0xffEAEAEA)
          ),
          color: const Color(0xffFAFAFA)
        ),
        child: Center(
          child: ImgUtil.buildFromImgPath(AssetsImagesPath.iconActivityPostImage, size: 24),
        )
      ),
    );
  }

  //
  _buildRemoveFileBtn(int index) {
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () => viewModel.cancelImg(index),
      child: SizedBox(
        width: 21,
        height: 21,
        child: Center(
          child: ImgUtil.buildFromImgPath(AssetsImagesPath.iconActivityPostCancel, size: 16),
        ),
      )
    );
  }

  _buildTagBtn() {
    String? topicTitle = viewModel.selectedTopic?.topicTitle;
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () => showAddPostDialog(),
      child: Container(
        height: WidgetValue.smallComponentHeight,
        alignment: Alignment.centerLeft,
        decoration: BoxDecoration(
          border: Border.all(width: 1, color: _appColorTheme.textFieldBorderColor),
          color: _appColorTheme.textFieldBackgroundColor,
          borderRadius: BorderRadius.circular(WidgetValue.btnRadius / 2)
        ),
        padding: EdgeInsets.symmetric(horizontal: WidgetValue.horizontalPadding),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(topicTitle == null ? '请选择话题标签' : '#$topicTitle', style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 16,
              color: topicTitle == null ?  const Color(0xffCFCFCF) : const Color(0xff444648))
            ),
            ImgUtil.buildFromImgPath(AssetsImagesPath.iconNext, size: 24)
          ],
        ),
      ),
    );
  }

  // 動態內容
  Widget _buildContentField() {
    return MainTextField(
      textFieldHeight: WidgetValue.bigTextFieldHeight,
      hintText: '请输入动态内容',
      hintColor: const Color(0xffCCCCCC),
      fontColor: _appColorTheme.textFieldFontColor,
      controller: viewModel.contentTextController,
      backgroundColor: _appColorTheme.textFieldBackgroundColor,
      borderColor:_appColorTheme.textFieldBorderColor,
      radius: 10,
      enableMultiLines: true,
      maxLength: viewModel.desMaxLength,
      contentPaddingTop: 16,
      contentPaddingBottom: 16,
      contentPaddingLeft: 12,
      contentPaddingRight: 12,
      onChanged: (text) {
        viewModel.desCurrentLength = text.length;
        viewModel.canSendHandler();
        setState(() {});
      },
    );
  }

  // Tooltip
  Widget _buildHelpBtn() {
    return Tooltip(
      message: viewModel.tipMsg,
      triggerMode: TooltipTriggerMode.tap,
      showDuration: const Duration(seconds: 999),
      textStyle: const TextStyle(
        fontSize: 12.0,
        fontWeight: FontWeight.w400,
        color: Colors.white
      ),
      child: ImgUtil.buildFromImgPath(AssetsImagesPath.iconActivityPostHint, size: 24),
    );
  }

  // 發佈按鈕
  Widget _buildSendBtn() {
    return CommonButton(
      btnType: CommonButtonType.text,
      cornerType: CommonButtonCornerType.round,
      colorBegin:_appLinearGradientTheme.buttonPrimaryColor.colors[0],
      colorEnd: _appLinearGradientTheme.buttonPrimaryColor.colors[1],
      onTap:() => _buildPostDialog(),
      isEnabledTapLimitTimer: true,
      text: '发布',
      textStyle:  _appTextTheme.buttonPrimaryTextStyle,
    );
  }

  //
  // Dialog
  //

  // 發佈彈窗
  void showAddPostDialog() {
    BaseDialog(context).showTransparentDialog(
      isDialogCancel: true,
      widget: ActivityAddPostTagDialog(
        topicList: viewModel.topicList,
        selectedTopic: viewModel.selectedTopic,
        onCancel: () {
          BaseViewModel.popPage(context);
        },
        onConfirm: (HotTopicListInfo? selectedTopic) {
          viewModel.selectedTopic = selectedTopic;
          setState(() {});
          BaseViewModel.popPage(context);
        }
      )
    );
  }

  // 選擇彈窗
  void albumOrCameraBottomDialog() {
    CommonBottomSheet.show(context,
      title: '添加',
      actions: [
        CommonBottomSheetAction(
          title: '开启相机',
          onTap: () {
            viewModel.takeImg(onShowFrequentlyDialog: () => _buildFrequentlyDialog());
            BaseViewModel.popPage(context);
          },
        ),
        CommonBottomSheetAction(
          title: '从相簿中选择',
          onTap: () {
            viewModel.selectImg();
            BaseViewModel.popPage(context);
          },
        ),
      ],
    );
  }

  Future<void> _buildFrequentlyDialog() async {
    await CheckDialog.show(context,
        appTheme: _theme,
        titleText: '操作过于频繁',
        messageText: '请稍候 5 秒',
        confirmButtonText: '确认');
  }


  // 取消彈窗
  void _buildCancelDialog() {

    CommDialog(context).build(
      theme: _theme,
      title: '取消发布动态？',
      contentDes: '您尚未编辑完成，离开后将不保存',
      leftBtnTitle: '离开',
      rightBtnTitle: '继续编辑',
      leftAction: () {
        BaseViewModel.popPage(context);
        BaseViewModel.popPage(context);
      },
      rightAction: () => BaseViewModel.popPage(context)
    );
  }

  // 發佈彈窗
  void _buildPostDialog()  {
    if (!viewModel.canSend) return;

    CommDialog(context).build(
      theme: _theme,
      title: '是否发布动态？',
      contentDes: '您尚未发布动态，离开后将不保存',
      leftBtnTitle: '离开',
      rightBtnTitle: '发布',
      leftAction: () {
        BaseViewModel.popPage(context);
      },
      rightAction: () {
        BaseViewModel.popPage(context);
        viewModel.addPost(context);
      },
    );
  }
}