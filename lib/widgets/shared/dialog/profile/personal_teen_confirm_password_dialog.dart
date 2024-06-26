
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frechat/screens/profile/setting/teen/personal_setting_teen_view_model.dart';
import 'package:frechat/system/base_view_model.dart';
import 'package:frechat/system/constant/enum.dart';
import 'package:frechat/system/providers.dart';
import 'package:frechat/widgets/constant_value.dart';
import 'package:frechat/widgets/shared/img_util.dart';
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

class PersonalTeenConfirmPasswordDialog extends ConsumerStatefulWidget {

  EdgeInsets? insetPadding;
  final Function() onTap;


  PersonalTeenConfirmPasswordDialog({
    super.key,
    required this.onTap,
    this.insetPadding,
  });

  @override
  _PersonalTeenConfirmPasswordDialogState createState() => _PersonalTeenConfirmPasswordDialogState();
}

class _PersonalTeenConfirmPasswordDialogState extends ConsumerState<PersonalTeenConfirmPasswordDialog> {

  Function() get onTap => widget.onTap;
  EdgeInsets? get insetPadding => widget.insetPadding;
  late AppTheme _theme;
  late AppColorTheme _appColorTheme;
  late AppImageTheme _appImageTheme;
  late AppLinearGradientTheme _appLinearGradientTheme;
  late AppTextTheme _appTextTheme;
  late AppBoxDecorationTheme _appBoxDecoration;

  @override
  Widget build(BuildContext context) {

    _theme = ref.watch(userInfoProvider).theme ?? AppTheme(themeType: AppThemeType.original);
    _appColorTheme = _theme.getAppColorTheme;
    _appImageTheme = _theme.getAppImageTheme;
    _appLinearGradientTheme = _theme.getAppLinearGradientTheme;
    _appTextTheme = _theme.getAppTextTheme;
    _appBoxDecoration = _theme.getAppBoxDecorationTheme;

    return PersonalSettingTeenViewModel.isLoading ? LoadingAnimation.discreteCircle(color: _appColorTheme.primaryColor) : AlertDialog(
      backgroundColor: _appBoxDecoration.cellBoxDecoration.color,
      surfaceTintColor: Colors.transparent,
      insetPadding: insetPadding ?? EdgeInsets.symmetric(horizontal: WidgetValue.horizontalPadding),
      actionsPadding: const EdgeInsets.only(right: 16, bottom: 20, left: 16),
      titlePadding: const EdgeInsets.only(top: 20, right: 16, left: 16),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
      title: const Text('再次确认密码', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16), textAlign: TextAlign.center,),
      content: _buildContentWidget(),
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        Row(
          children: [
            Expanded(child: _buildCancelBtn()),
            SizedBox(width: WidgetValue.horizontalPadding,),
            Expanded(child: _buildNextBtn())
          ],
        )
      ],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
        side: BorderSide(
            width: _appBoxDecoration.cellBoxDecoration.border!.top.width,
            color: _appBoxDecoration.cellBoxDecoration.border!.top.color
        ),
      ),
    );
  }

  Widget _buildContentWidget() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 27),
        ImgUtil.buildFromImgPath(_appImageTheme.teenSettingInputImage, width: 139.25, height: 150),
        const SizedBox(height: 1),
        Text('再次确认密码', style: _appTextTheme.labelPrimaryTextStyle),
        const SizedBox(height: 4),
        Text('请输入四位数字密码', style: _appTextTheme.labelPrimaryTextStyle),
        const SizedBox(height: 8),
        _buildTextField(),
        const SizedBox(height: 20),
      ],
    );
  }


  _buildTextField() {
    return MainTextField(
      hintText: '请输入密码',
      controller: PersonalSettingTeenViewModel.confirmPasswordTextController,
      backgroundColor: AppColors.whiteBackGround,
      radius: 10,
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp('[0-9]')), // 只允许数字输入
      ],
      fontColor: const Color(0xff444648),
      fontSize: 20,
      fontWeight: FontWeight.w600,
      textAlign: TextAlign.center,
      keyboardType: TextInputType.number,
      maxLength: 4,
      contentPaddingLeft: 0,
      onChanged: (_) {
        setState(() {});
      },
    );
  }

  _buildCancelBtn() {
    return InkWell(
      onTap: () => BaseViewModel.popPage(context),
      child: Container(
        alignment: Alignment.center,
        width: UIDefine.getWidth(),
        height: 50, // WidgetValue.smallComponentHeight,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(WidgetValue.btnRadius * 2), gradient: _appLinearGradientTheme.buttonPrimaryColor),
        child: Text('取消', style: _appTextTheme.buttonPrimaryTextStyle),
      ),
    );
  }

  _buildNextBtn() {
    final TextEditingController password = PersonalSettingTeenViewModel.passwordTextController;
    final TextEditingController confirmPassword = PersonalSettingTeenViewModel.confirmPasswordTextController;
    final btnTextColor = (password.text == '') ? _appLinearGradientTheme.buttonSecondaryColor : _appLinearGradientTheme.buttonPrimaryColor;
    final btnTextStyle = (password.text == '') ?_appTextTheme.buttonSecondaryTextStyle : _appTextTheme.buttonPrimaryTextStyle;
    return InkWell(
      onTap: () {
        if(confirmPassword.text == '') {
          BaseViewModel.showToast(context, '输入密码不能为空哦');
          return;
        }
        if(confirmPassword.text.length < 4) {
          BaseViewModel.showToast(context, '输入密码长度不足哦');
          return;
        }

        if(confirmPassword.text != password.text) {
          BaseViewModel.showToast(context, '确认密码输入错误');
          return;
        }

        PersonalSettingTeenViewModel.enableTeen(ref: ref, context: context, setState: setState,
        onSuccess: () {
          BaseViewModel.popPage(context);
          /// 推頁
          onTap();
        });
      },
      child: Container(
        alignment: Alignment.center,
        width: UIDefine.getWidth(),
        height: 50, // WidgetValue.smallComponentHeight,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(WidgetValue.btnRadius * 2),
            gradient: btnTextColor
        ),
        child: Text('开启', style:btnTextStyle ),
      ),
    );
  }
}