import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frechat/screens/profile/certification/real_name/personal_certification_real_name_view_model.dart';
import 'package:frechat/system/base_view_model.dart';
import 'package:frechat/system/constant/enum.dart';
import 'package:frechat/system/providers.dart';
import 'package:frechat/widgets/constant_value.dart';
import 'package:frechat/widgets/loading_dialog/loading_widget.dart';
import 'package:frechat/widgets/shared/app_bar.dart';
import 'package:frechat/widgets/shared/img_util.dart';
import 'package:frechat/widgets/shared/main_scaffold.dart';
import 'package:frechat/widgets/shared/main_textfield.dart';
import 'package:frechat/widgets/theme/app_color_theme.dart';
import 'package:frechat/widgets/theme/original/app_colors.dart';
import 'package:frechat/widgets/theme/app_image_theme.dart';
import 'package:frechat/widgets/theme/app_linear_gradient_theme.dart';
import 'package:frechat/widgets/theme/app_text_theme.dart';
import 'package:frechat/widgets/theme/app_theme.dart';
import 'package:frechat/widgets/theme/uidefine.dart';

class PersonalCertificationRealName extends ConsumerStatefulWidget {
  const PersonalCertificationRealName({super.key});

  @override
  ConsumerState<PersonalCertificationRealName> createState() =>
      _PersonalCertificationRealNameState();
}

class _PersonalCertificationRealNameState extends ConsumerState<PersonalCertificationRealName> {

  late PersonalCertificationRealNameViewModel viewModel;
  late AppTheme _theme;
  late AppColorTheme appColorTheme;
  late AppTextTheme appTextTheme;
  late AppLinearGradientTheme appLinearGradientTheme;
  late AppImageTheme appImageTheme;

  @override
  void initState() {
    viewModel = PersonalCertificationRealNameViewModel(setState: setState, ref: ref);
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
    appColorTheme = _theme.getAppColorTheme;
    appImageTheme = _theme.getAppImageTheme;
    appTextTheme = _theme.getAppTextTheme;
    appLinearGradientTheme = _theme.getAppLinearGradientTheme;

    return MainScaffold(
      isFullScreen: true,
      needSingleScroll: true,
      padding: EdgeInsets.only(
        top: paddingHeight,
        bottom: WidgetValue.bottomPadding,
        left: WidgetValue.horizontalPadding,
        right: WidgetValue.horizontalPadding,
      ),
      appBar: MainAppBar(
        theme: _theme,
        backgroundColor: appColorTheme.appBarBackgroundColor,
        title: '实名认证',
        leading: IconButton(
          icon: ImgUtil.buildFromImgPath(appImageTheme.iconBack, size: 24.w),
          onPressed: () => BaseViewModel.popPage(context),
        ),
      ),
      backgroundColor: appColorTheme.appBarBackgroundColor,
      child: Column(
        children: [
          const SizedBox(height: 8),
          _buildIcon(),
          const SizedBox(height: 12),
          _buildHint(),
          const SizedBox(height: 12),
          _buildRealNameTextField(),
          const SizedBox(height: 8),
          _buildIdTextField(),
          const SizedBox(height: 20),
          _buildAuthBtn()
        ],
      ),
    );
  }

  _buildIcon() {
    return ImgUtil.buildFromImgPath(appImageTheme.iconPersonalCertificationName, size: 72);
  }

  _buildHint() {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: WidgetValue.verticalPadding,
        horizontal: WidgetValue.horizontalPadding,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: appColorTheme.personalProcessCertificationHintBgColor
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ImgUtil.buildFromImgPath(appImageTheme.iconPersonalCertificationHint, size: 20),
          SizedBox(width: WidgetValue.separateHeight),
          Expanded(
            child: Text(
              '实名仅用验证您是否为真人用户，不会对信息做任何采集与保留，请放心认证',
              style: TextStyle(
                color: appColorTheme.personalProcessCertificationHintTextColor,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  _buildRealNameTextField() {
    return MainTextField(
      hintText: '请输入真实姓名',
      controller: viewModel.realNameTextController,
      backgroundColor: AppColors.textFieldWhitBackGround,
      radius: 10,
    );
  }

  _buildIdTextField() {
    return MainTextField(
      hintText: '请输入身份证号',
      controller: viewModel.idTextController,
      backgroundColor: AppColors.textFieldWhitBackGround,
      radius: 10,
    );
  }

  _buildAuthBtn() {
    return InkWell(
      onTap: () async {
        Loading.show(context, "认证中");
        try{
          bool result = await viewModel.sendRealNameAuth(context).timeout(const Duration(seconds: 5));
          if (mounted) {
            Loading.hide(context);
            //檢查成功的話才 pop 並回傳成功
            if (result) {
              Navigator.of(context).pop(true);
            }
          }
        }on TimeoutException catch(e){
          Loading.hide(context);
          BaseViewModel.showToast(context, '认证逾时');
        }catch(e){
          Loading.hide(context);
          BaseViewModel.showToast(context, '认证失败');
        }
      },
      child: Container(
        width: UIDefine.getWidth(),
        height: WidgetValue.mainComponentHeight,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(WidgetValue.btnRadius * 2),
            gradient: appLinearGradientTheme.buttonPrimaryColor),
        child: Text('马上认证',
            style: appTextTheme.buttonPrimaryTextStyle),
      ),
    );
  }
}
