import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frechat/models/res/member_register_res.dart';
import 'package:frechat/system/base_view_model.dart';
import 'package:frechat/system/constant/enum.dart';
import 'package:frechat/system/providers.dart';
import 'package:frechat/widgets/constant_value.dart';
import 'package:frechat/widgets/shared/img_util.dart';
import 'package:frechat/widgets/theme/app_box_decoration_theme.dart';
import 'package:frechat/widgets/theme/app_color_theme.dart';
import 'package:frechat/widgets/theme/app_linear_gradient_theme.dart';
import 'package:frechat/widgets/theme/app_text_theme.dart';
import 'package:frechat/widgets/theme/app_theme.dart';
import 'package:frechat/widgets/theme/original/app_colors.dart';
import 'package:frechat/widgets/theme/uidefine.dart';

class NewMemberAwardDialog extends ConsumerStatefulWidget {
  RegisterBenefit? registerBenefit;
  final Function onClose;

  NewMemberAwardDialog({
    super.key,
    this.registerBenefit,
    required this.onClose,
  });

  @override
  ConsumerState<NewMemberAwardDialog> createState() => _newMemberAwardDialogState();
}

class _newMemberAwardDialogState extends ConsumerState<NewMemberAwardDialog> {

  RegisterBenefit? get registerBenefit => widget.registerBenefit;
  late AppTheme _theme;
  late AppColorTheme _appColorTheme;
  late AppTextTheme _appTextTheme;
  late AppLinearGradientTheme _appLinearGradientTheme;
  late AppBoxDecorationTheme _appBoxDecorationTheme;
  @override
  Widget build(BuildContext context) {

    _theme = ref.watch(userInfoProvider).theme ?? AppTheme(themeType: AppThemeType.original);
    _appColorTheme = _theme.getAppColorTheme;
    _appTextTheme = _theme.getAppTextTheme;
    _appLinearGradientTheme = _theme.getAppLinearGradientTheme;
    _appBoxDecorationTheme = _theme.getAppBoxDecorationTheme;
    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal:16.w),
      child: Container(
        decoration:_appBoxDecorationTheme.dialogBoxDecoration,
        padding: EdgeInsets.symmetric(vertical: 16.h,horizontal: 16.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildTitle(),
            _buildContentWidget(),
            _buildConfirmBtn(),
          ],
        ),
      ),
    );

    return AlertDialog(
      backgroundColor: AppColors.whiteBackGround,
      surfaceTintColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: WidgetValue.horizontalPadding),
      actionsPadding: const EdgeInsets.only(right: 16, bottom: 20, left: 16),
      titlePadding: const EdgeInsets.only(top: 20, right: 16, left: 16),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
      actionsAlignment: MainAxisAlignment.center,
      title: _buildTitle(),
      content: _buildContentWidget(),
      actions: [_buildConfirmBtn()],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(WidgetValue.btnRadius),
      ),
    );
  }

  Widget _buildTitle() {
    return  Text(
      '新用户奖励',
      style:_appTextTheme.dialogTitleTextStyle,
      textAlign: TextAlign.center,
    );
  }

  Widget _buildContentWidget() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 4),
        _buildSubTitle(),
        const SizedBox(height: 20),
        _buildContents(),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildSubTitle() {
    return  Text(
      '恭喜您已注册成功并获得奖励',
      style:_appTextTheme.dialogContentTextStyle,
      textAlign: TextAlign.center,
    );
  }

  Widget _buildContents() {
    final maleFreeWordPerDayToFemale = registerBenefit?.maleFreeWordPerDayToFemale ?? 0;
    final maleFreeWordPerDay = registerBenefit?.maleFreeWordPerDay ?? 0;
    final freeVideoPerMinute = registerBenefit?.freeVideoPerMinute ?? 0;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildFreeMessageContent('assets/common/icon_free_message.png', maleFreeWordPerDayToFemale.toString(), maleFreeWordPerDay.toString()),
        SizedBox(width: 8.w),
        _buildFreeVideoContent('assets/common/icon_free_video_call.png', freeVideoPerMinute.toString())

      ],
    );
  }

  Widget _buildFreeMessageContent(String imgUrl,String maleFreeWordPerDayToFemale,String maleFreeWordPerDay){
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: 148,
          height: 116,
          // padding: const EdgeInsets.only(top: 8, right: 12, bottom: 12, left: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.0),
            color:_appColorTheme.awardBgColor,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ImgUtil.buildFromImgPath(imgUrl, size: 60.w),
              SizedBox(height: 4.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('对 ', style:_appTextTheme.awardDefaultTextStyle),
                  Text(maleFreeWordPerDay, style:_appTextTheme.awardHighlightTextStyle),
                  Text(' 位用户', style:_appTextTheme.awardDefaultTextStyle),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('传送 ', style:_appTextTheme.awardDefaultTextStyle,),
                  Text(maleFreeWordPerDayToFemale, style:_appTextTheme.awardHighlightTextStyle,),
                  Text(' 则免费文字信息', style:_appTextTheme.awardDefaultTextStyle,),
                ],
              ),
            ],
          ),
        ),
        Positioned(left:-5,top:-5,child: tag())
      ],
    );
  }

  Widget _buildFreeVideoContent(String imgUrl,String freeVideoPerMinute,){
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: 148,
          height: 116,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.0),
            color: _appColorTheme.awardBgColor,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ImgUtil.buildFromImgPath(imgUrl, size: 60.w),
              SizedBox(height: 4.h),
              Text('免费视频通话', style:_appTextTheme.awardDefaultTextStyle,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(freeVideoPerMinute, style:_appTextTheme.awardHighlightTextStyle,),
                  Text(' 分钟', style:_appTextTheme.awardDefaultTextStyle),
                ],
              ),
            ],
          ),
        ),
        Positioned(
            left:-5,
            top :-5,
            child: tag())
      ],
    );
  }

  Widget tag(){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6,vertical: 2),
      decoration: _appBoxDecorationTheme.awardDailyTagBoxDecoration,
      child: Text("每日",style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: Colors.white
      )),
    );
  }

  Widget _buildConfirmBtn() {
    return InkWell(
      onTap: () async {
        if (context.mounted) BaseViewModel.popPage(context);
        widget.onClose.call();
      },
      child: Container(
        alignment: Alignment.center,
        width: UIDefine.getWidth(),
        height: 50,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(WidgetValue.btnRadius * 2),
            gradient:  _appLinearGradientTheme.buttonPrimaryColor),
        child:  Text('确定', style: _appTextTheme.buttonPrimaryTextStyle),
      ),
    );
  }
}
