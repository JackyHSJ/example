import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frechat/screens/profile/setting/teen/forget/personal_setting_teen_forget_view_model.dart';
import 'package:frechat/system/constant/enum.dart';
import 'package:frechat/system/jiguang_mob_auth/jiguang_mob_auth.dart';
import 'package:frechat/system/providers.dart';
import 'package:frechat/widgets/constant_value.dart';
import 'package:frechat/widgets/shared/app_bar.dart';
import 'package:frechat/widgets/shared/img_util.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frechat/widgets/shared/main_scaffold.dart';
import 'package:frechat/widgets/theme/app_color_theme.dart';
import 'package:frechat/widgets/theme/app_image_theme.dart';
import 'package:frechat/widgets/theme/app_linear_gradient_theme.dart';
import 'package:frechat/widgets/theme/app_text_theme.dart';
import 'package:frechat/widgets/theme/app_theme.dart';

import '../../../../../system/base_view_model.dart';
import '../../../../../widgets/shared/main_textfield.dart';
import '../../../../../widgets/theme/original/app_colors.dart';
import '../../../../../widgets/theme/uidefine.dart';


class PersonalSettingTeenForget extends ConsumerStatefulWidget {
  const PersonalSettingTeenForget({super.key});

  @override
  ConsumerState<PersonalSettingTeenForget> createState() => _PersonalSettingTeenForgetState();
}

class _PersonalSettingTeenForgetState extends ConsumerState<PersonalSettingTeenForget> {

  late PersonalSettingTeenForgetViewModel viewModel;
  late AppTheme _theme;
  late AppImageTheme _appImageTheme;
  late AppColorTheme _appColorTheme;
  late AppTextTheme _appTextTheme;
  late AppLinearGradientTheme _appLinearGradientTheme;

  @override
  void initState() {
    viewModel = PersonalSettingTeenForgetViewModel(ref: ref, context: context, setState: setState);
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

    _theme = ref.watch(userInfoProvider).theme ?? AppTheme(themeType: AppThemeType.original);
    _appImageTheme = _theme.getAppImageTheme;
    _appColorTheme = _theme.getAppColorTheme;
    _appTextTheme = _theme.getAppTextTheme;
    _appLinearGradientTheme = _theme.getAppLinearGradientTheme;

    final double paddingHeight = UIDefine.getAppBarHeight() + UIDefine.getStatusBarHeight();
    return MainScaffold(
      isFullScreen: true,
      needSingleScroll: false,
      padding: EdgeInsets.only(top: paddingHeight, bottom: WidgetValue.bottomPadding, left: WidgetValue.horizontalPadding, right: WidgetValue.horizontalPadding),
      // appBar: MainAppBar(theme:_theme,title: '忘记密码', leading: SizedBox(), actions: [_buildCancelBtn()]),
      appBar: _buildAppbar(),
      backgroundColor: _appColorTheme.baseBackgroundColor,
      child: Column(
        children: [
          SizedBox(height: WidgetValue.topPadding),
          _buildPhoneTextField(),
          _buildVerifyTextField(),
          SizedBox(height: WidgetValue.verticalPadding * 2),
          _buildConfirmBtn(),
        ],
      ),
    );
  }

  Widget _buildAppbar(){
    return MainAppBar(
      theme: _theme,
      title: '忘记密码',
      leading: const SizedBox(),
      actions: [
        Padding(
          padding: EdgeInsets.only(right: 16),
          child: InkWell(
            onTap: () => BaseViewModel.popPage(context),
            child: ImgUtil.buildFromImgPath(_appImageTheme.bottomSheetCancelBtnIcon, size: 24),
          ),
        )
      ],
    );
  }

  _buildCancelBtn() {
    return InkWell(
      onTap: () => BaseViewModel.popPage(context),
      child: Padding(
          padding: EdgeInsets.only(right: 10.w),
          child: ImgUtil.buildFromImgPath(_appImageTheme.iconClose, size: 24.w, fit: BoxFit.scaleDown)
      ),
    );
  }

  _buildPhoneTextField() {
    return MainTextField(
      hintText: '请输入您的手机号',
      controller: viewModel.phoneTextController,
      radius: 10,
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp('[0-9]')), // 只允许数字输入
      ],
      fontSize: 16,
      fontWeight: FontWeight.w500,
      keyboardType: TextInputType.number,
      errorText: viewModel.phoneTextErrorMsg,
    );
  }

  _buildVerifyTextField() {
    final bool isCountDown = viewModel.smsCountDown != viewModel.countDownTimeMax;
    final String title = (isCountDown) ? '後重新获取验证码' : '获取验证码';

    return MainTextField(
      hintText: '填写验证码',
      controller: viewModel.verifyTextController,
      radius: 10,
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp('[0-9]')), // 只允许数字输入
      ],
      fontSize: 16,
      fontWeight: FontWeight.w500,
      keyboardType: TextInputType.number,
      errorText: viewModel.verifyTextErrorMsg,
      suffixIcon: TextButton(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildSMSCountDown(isCountDown),
              _buildBtnText(title)
            ],
          ),
          onPressed: () => viewModel.getSms()
      ),
    );
  }

  _buildBtnText(String title) {
    return Text(title, style: TextStyle(color: AppColors.mainPink, fontWeight: FontWeight.w600));
  }

  _buildSMSCountDown(bool isEnable) {
    return Offstage(
      offstage: !isEnable,
      child: Text('${viewModel.smsCountDown}s', style: TextStyle(color: AppColors.mainPink, fontWeight: FontWeight.w600)),
    );
  }

  _buildConfirmBtn () {
    return InkWell(
      onTap: () => viewModel.teenForgetPassword(),
      child: Container(
          height: WidgetValue.mainComponentHeight,
          margin: EdgeInsets.symmetric(horizontal: WidgetValue.horizontalPadding * 3),
          alignment: Alignment.center,
          decoration: BoxDecoration(
              gradient: _appLinearGradientTheme.buttonSecondaryColor,
              borderRadius: BorderRadius.circular(WidgetValue.btnRadius * 2)
          ),
          child: Text('关闭青少年模式', style: _appTextTheme.buttonSecondaryTextStyle)
      ),
    );
  }
}