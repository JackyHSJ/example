import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frechat/screens/profile/personal_profile.dart';
import 'package:frechat/screens/profile/setting/teen/forget/personal_setting_teen_forget.dart';
import 'package:frechat/screens/profile/setting/teen/personal_setting_teen_view_model.dart';
import 'package:frechat/system/base_view_model.dart';
import 'package:frechat/system/constant/enum.dart';
import 'package:frechat/system/providers.dart';
import 'package:frechat/system/repository/response_code.dart';
import 'package:frechat/widgets/constant_value.dart';
import 'package:frechat/widgets/shared/app_bar.dart';
import 'package:frechat/widgets/shared/dialog/base_dialog.dart';
import 'package:frechat/widgets/shared/dialog/comm_dialog.dart';
import 'package:frechat/widgets/shared/dialog/profile/personal_teen_confirm_password_dialog.dart';
import 'package:frechat/widgets/shared/dialog/profile/personal_teen_password_dialog.dart';
import 'package:frechat/widgets/shared/img_util.dart';
import 'package:frechat/widgets/shared/loading_animation.dart';
import 'package:frechat/widgets/shared/main_scaffold.dart';
import 'package:frechat/widgets/shared/main_textfield.dart';
import 'package:frechat/widgets/theme/app_color_theme.dart';
import 'package:frechat/widgets/theme/app_image_theme.dart';
import 'package:frechat/widgets/theme/app_linear_gradient_theme.dart';
import 'package:frechat/widgets/theme/app_text_theme.dart';
import 'package:frechat/widgets/theme/app_theme.dart';

import '../../../../widgets/theme/original/app_colors.dart';
import '../../../../widgets/theme/uidefine.dart';


class PersonalSettingTeen extends ConsumerStatefulWidget {
  const PersonalSettingTeen({super.key});

  @override
  ConsumerState<PersonalSettingTeen> createState() => _PersonalSettingTeenState();
}

class _PersonalSettingTeenState extends ConsumerState<PersonalSettingTeen> {
  late AppTheme _theme;
  late AppColorTheme _appColorTheme;
  late AppImageTheme _appImageTheme;
  late AppLinearGradientTheme _appLinearGradientTheme;
  late AppTextTheme _appTextTheme;

  @override
  void initState() {
    PersonalSettingTeenViewModel.init();
    PersonalSettingTeenViewModel.getTeenStatus(context: context, ref: ref, setState: setState);
    super.initState();
  }

  @override
  void dispose() {
    PersonalSettingTeenViewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double paddingHeight = UIDefine.getAppBarHeight() + UIDefine.getStatusBarHeight();
    _theme = ref.watch(userInfoProvider).theme ?? AppTheme(themeType: AppThemeType.original);
    _appColorTheme = _theme.getAppColorTheme;
    _appImageTheme = _theme.getAppImageTheme;
    _appLinearGradientTheme = _theme.getAppLinearGradientTheme;
    _appTextTheme = _theme.getAppTextTheme;

    return MainScaffold(
      isFullScreen: true,
      needSingleScroll: false,
      padding: EdgeInsets.only(top: paddingHeight, bottom: WidgetValue.bottomPadding, left: WidgetValue.horizontalPadding, right: WidgetValue.horizontalPadding),
      appBar: MainAppBar(
        theme: _theme,
        backgroundColor: _appColorTheme.appBarBackgroundColor,
        title: '青少年模式',
        leading: _buildLeadingBtn(),
      ),
      backgroundColor: _appColorTheme.appBarBackgroundColor,
      child: PersonalSettingTeenViewModel.isLoading ? LoadingAnimation.discreteCircle(color: _appColorTheme.primaryColor)
       : _buildWIllPop(),
    );
  }


  Widget? _buildLeadingBtn() {
    final bool isTeenMode = PersonalSettingTeenViewModel.isTeenMode;
    if (isTeenMode) {
      return const SizedBox();
    }
    return IconButton(
      icon: ImgUtil.buildFromImgPath(_appImageTheme.iconBack, size: 24.w),
      onPressed: () => BaseViewModel.popPage(context),
    );
  }

  _buildWIllPop() {
    final bool isTeenMode = PersonalSettingTeenViewModel.isTeenMode;
    return (isTeenMode) ? WillPopScope(
      onWillPop: () async {
        return !ModalRoute.of(context)!.canPop;
      },
      child: _buildMainWidget(),
    ) : _buildMainWidget();
  }

  _buildMainWidget() {
    final bool isTeenMode = PersonalSettingTeenViewModel.isTeenMode;
    final String title = isTeenMode ? '青少年模式' : '青少年模式已关闭';
    final String des = isTeenMode ? '您已开启青少年模式，所有功能关闭中' : '开启青少年模式，防止青少年使用';
    final String btnTitle = isTeenMode ? '关闭青少年模式' : '开启青少年模式';
    final String imgPath = isTeenMode ?_appImageTheme.teenSettingOpenImage : _appImageTheme.teenSettingCloseImage;
    final bool isBtn = PersonalSettingTeenViewModel.isBtnOrFalseIsTextField;
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ImgUtil.buildFromImgPath(imgPath, size: 144),
        SizedBox(height: 13),
        Text(title, style: TextStyle(fontWeight: FontWeight.w700, fontSize: 22, color: _appColorTheme.teenBannerPrimaryTextColor)),
        SizedBox(height: 12),
        Text(des, style: TextStyle(fontWeight: FontWeight.w400, fontSize: 14, color: _appColorTheme.teenBannerSecondaryTextColor)),
        SizedBox(height: 22),
        isBtn ? _buildBtn(title: btnTitle) : _buildTextField(),
        SizedBox(height: WidgetValue.verticalPadding * 3),
        _buildForgetPassword()
      ],
    );
  }

  _buildForgetPassword() {
    final bool isTeenMode = PersonalSettingTeenViewModel.isTeenMode;
    final bool isBtn = PersonalSettingTeenViewModel.isBtnOrFalseIsTextField;
    final textColor = isBtn ? AppColors.mainPink : AppColors.textBlack;
    return Visibility(
      visible: isTeenMode,
      child: InkWell(
        onTap: () => BaseViewModel.pushPage(context, PersonalSettingTeenForget()),
        child: Text('忘记密码', style: TextStyle(
            color:  _appColorTheme.teenBannerSecondaryTextColor,
            decoration: TextDecoration.underline,
            decorationColor:  _appColorTheme.teenBannerSecondaryTextColor
        )),
      ),
    );
  }

  _buildTextField() {
    String? errorText = PersonalSettingTeenViewModel.errorText;
    return MainTextField(
      hintText: '请输入四位数字密码',
      controller: PersonalSettingTeenViewModel.closeTeenModePasswordTextController,
      fontColor: _appColorTheme.textFieldFontColor,
      radius: 10,
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp('[0-9]')), // 只允许数字输入
      ],
      fontSize: 16,
      fontWeight: FontWeight.w500,
      keyboardType: TextInputType.number,
      maxLength: 4,
      errorText: errorText,
      onChanged: (password) {
        if(password.length == 4) {
          PersonalSettingTeenViewModel.closeTeen(context: context, ref: ref, setState: setState, onFail: (errMsg){
            PersonalSettingTeenViewModel.errorText = '密码输入错误，请重新输入';
            setState(() {});
          });
        }
      },
    );
  }

  _buildBtn({
    required String title,
  }){
    final bool isTeenMode = PersonalSettingTeenViewModel.isTeenMode;
    return InkWell(
      onTap: () {
        PersonalSettingTeenViewModel.errorText = null;
        if(isTeenMode) {
          PersonalSettingTeenViewModel.isBtnOrFalseIsTextField = false;
        } else if (!isTeenMode) {
          _buildSettingPasswordDialog();
        }
        setState(() {});
      },
      child: Container(
        height: WidgetValue.mainComponentHeight,
        margin: EdgeInsets.symmetric(horizontal: WidgetValue.horizontalPadding * 3),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          gradient: _appLinearGradientTheme.buttonSecondaryColor,
          borderRadius: BorderRadius.circular(WidgetValue.btnRadius * 2)
        ),
        child: Text(title, style: _appTextTheme.buttonSecondaryTextStyle)
      ),
    );
  }

  _buildSettingPasswordDialog() {
    BaseDialog(context).showTransparentDialog(
      isDialogCancel: false,
      widget: PersonalTeenPasswordDialog(
        onTap: () => _buildSettingConfirmPasswordDialog()
      )
    );
  }

  _buildSettingConfirmPasswordDialog() {
    BaseDialog(context).showTransparentDialog(
      isDialogCancel: false,
      widget: PersonalTeenConfirmPasswordDialog(
        onTap: () {
          setState(() {});
          BaseViewModel.showToast(context, '已开启青少年模式');
        }
      )
    );
  }
}