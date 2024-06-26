
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frechat/models/ws_req/activity/ws_activity_hot_topic_list_req.dart';
import 'package:frechat/models/ws_res/activity/ws_activity_hot_topic_list_res.dart';
import 'package:frechat/screens/profile/setting/teen/personal_setting_teen_view_model.dart';
import 'package:frechat/system/assets_path/assets_images_path.dart';
import 'package:frechat/system/base_view_model.dart';
import 'package:frechat/system/constant/enum.dart';
import 'package:frechat/system/providers.dart';
import 'package:frechat/system/repository/response_code.dart';
import 'package:frechat/widgets/constant_value.dart';
import 'package:frechat/widgets/shared/buttons/common_button.dart';
import 'package:frechat/widgets/shared/dialog/comm_dialog.dart';
import 'package:frechat/widgets/shared/img_util.dart';
import 'package:frechat/widgets/shared/list/main_list.dart';
import 'package:frechat/widgets/shared/loading_animation.dart';
import 'package:frechat/widgets/shared/main_textfield.dart';
import 'package:frechat/widgets/theme/app_box_decoration_theme.dart';
import 'package:frechat/widgets/theme/app_color_theme.dart';
import 'package:frechat/widgets/theme/app_image_theme.dart';
import 'package:frechat/widgets/theme/app_linear_gradient_theme.dart';
import 'package:frechat/widgets/theme/app_text_theme.dart';
import 'package:frechat/widgets/theme/app_theme.dart';
import 'package:frechat/widgets/theme/uidefine.dart';

import '../../../theme/original/app_colors.dart';

class ActivityAddPostTagDialog extends ConsumerStatefulWidget {

  final Function(HotTopicListInfo?) onConfirm;
  final Function()? onCancel;
  List<HotTopicListInfo?> topicList;
  HotTopicListInfo? selectedTopic;

  ActivityAddPostTagDialog({
    super.key,
    required this.topicList,
    required this.selectedTopic,
    required this.onConfirm,
    required this.onCancel,
  });

  @override
  _ActivityAddPostTagDialogState createState() => _ActivityAddPostTagDialogState();
}

class _ActivityAddPostTagDialogState extends ConsumerState<ActivityAddPostTagDialog> {

  HotTopicListInfo? selectedTopic;
  List<HotTopicListInfo?> get topicList => widget.topicList;
  Function()? get onCancel => widget.onCancel;
  Function(HotTopicListInfo selectedTopic)? get onConfirm => widget.onConfirm;

  late AppTheme _theme;
  late AppColorTheme _appColorTheme;
  late AppTextTheme _appTextTheme;
  late AppLinearGradientTheme _appLinearGradientTheme;
  late AppBoxDecorationTheme _appBoxDecorationTheme;
  late AppImageTheme _appImageTheme;

  @override
  void initState() {
    super.initState();
    selectedTopic = widget.selectedTopic;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _theme = ref.watch(userInfoProvider).theme ?? AppTheme(themeType: AppThemeType.original);
    _appColorTheme = _theme.getAppColorTheme;
    _appTextTheme = _theme.getAppTextTheme;
    _appLinearGradientTheme = _theme.getAppLinearGradientTheme;
    _appBoxDecorationTheme = _theme.getAppBoxDecorationTheme;
    _appImageTheme = _theme.getAppImageTheme;


    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal:16.w),
      child: Container(
        decoration:_appBoxDecorationTheme.dialogBoxDecoration,
        padding: EdgeInsets.symmetric(vertical: 20.h,horizontal: 16.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildTitle(),
            _buildHint(),
            _buildTopicList(),
            _buildActionButtons(),
          ],
        ),
      ),
    );

  }

  // 標題
  Widget _buildTitle() {
    return Text('选择一个话题标签', style: _appTextTheme.labelPrimaryTitleTextStyle, textAlign: TextAlign.center);
  }

  // 副標
  Widget _buildHint() {
    return  Text('让更多对相同话题感兴趣的人找到你', style: _appTextTheme.labelPrimaryTextStyle);
  }

  // 話題標籤列表
  Widget _buildTopicList() {

    if (topicList.isEmpty) {
      return _buildEmptyTopicWidget();
    }

    return Container(
      padding: EdgeInsets.symmetric(vertical: WidgetValue.verticalPadding * 2),
      height: UIDefine.getHeight() / 2,
      width: UIDefine.getWidth(),
      child: CustomList.separatedList(
        separator: const SizedBox(height: 4),
        childrenNum: topicList.length,
        children: (context, index) {
          return _buildTopicCell(topicList[index]!);
        }
      ),
    );
  }

  Widget _buildEmptyTopicWidget() {
    return SizedBox(
      width: 350.w,
      height: 356.h,
      child: Center(
        child: ImgUtil.buildFromImgPath('assets/activity/banner_empty_topic.png', width: 160.w, height: 179.w),
      ),
    );
  }

  // 話題標籤組件
  Widget _buildTopicCell(HotTopicListInfo tag) {
    final bool isSelect = selectedTopic?.topicId == tag.topicId;
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () {
        selectedTopic = tag;
        setState(() {});
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
        decoration: isSelect
            ? _appBoxDecorationTheme.cellSelectBoxDecoration
            : _appBoxDecorationTheme.cellBoxDecoration,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(child: Text(
              '#${tag.topicTitle}',
              style: _appTextTheme.labelPrimaryContentTextStyle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),),
            const SizedBox(width: 6),
            isSelect
                ? ImgUtil.buildFromImgPath(_appImageTheme.checkBoxTrueIcon, size: 24)
                : ImgUtil.buildFromImgPath(_appImageTheme.checkBoxFalseIcon, size: 24),
          ],
        ),
      )
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(child: _buildCancelBtn('取消', onTap: () => onCancel?.call())),
        SizedBox(width: WidgetValue.horizontalPadding,),
        Expanded(child: _buildConfirmBtn('确定', onTap: () => widget.onConfirm?.call(selectedTopic)))
      ],
    );
  }

  // 取消按鈕
  Widget _buildCancelBtn(String title, {
    required Function() onTap
  }) {
    return CommonButton(
        onTap: () => onTap(),
        btnType: CommonButtonType.text,
        cornerType: CommonButtonCornerType.round,
        isEnabledTapLimitTimer: false,
        text: title,
        textStyle:  _appTextTheme.dialogCancelButtonTextStyle,
        colorBegin:  _appLinearGradientTheme.dialogCancelButtonColor.colors[0],
        colorEnd: _appLinearGradientTheme.dialogCancelButtonColor.colors[1],
        colorAlignmentBegin: Alignment.topCenter,
        colorAlignmentEnd: Alignment.bottomCenter,
        broder: const Border()
    );
  }

  // 確認按鈕
  Widget _buildConfirmBtn(String title, {
    required Function() onTap
  }) {
    return CommonButton(
      onTap: () => onTap(),
      btnType: CommonButtonType.text,
      cornerType: CommonButtonCornerType.round,
      isEnabledTapLimitTimer: false,
      text: title,
      textStyle:  _appTextTheme.dialogConfirmButtonTextStyle,
      colorBegin:  _appLinearGradientTheme.dialogConfirmButtonColor.colors[0],
      colorEnd: _appLinearGradientTheme.dialogConfirmButtonColor.colors[1],
      colorAlignmentBegin: Alignment.topCenter,
      colorAlignmentEnd: Alignment.bottomCenter,
      broder: const Border()
    );
  }


}