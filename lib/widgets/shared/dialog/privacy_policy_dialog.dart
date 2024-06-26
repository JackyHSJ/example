
import 'dart:io';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frechat/system/app_config/app_config.dart';
import 'package:frechat/system/assets_path/assets_txt_path.dart';
import 'package:frechat/system/base_view_model.dart';
import 'package:frechat/system/constant/enum.dart';
import 'package:frechat/system/global/shared_preferance.dart';
import 'package:frechat/system/providers.dart';
import 'package:frechat/widgets/constant_value.dart';
import 'package:frechat/widgets/shared/buttons/common_button.dart';
import 'package:frechat/widgets/shared/dialog/comm_dialog.dart';
import 'package:frechat/widgets/textfromasset/textfromasset_widget.dart';
import 'package:frechat/widgets/theme/app_theme.dart';
import 'package:frechat/widgets/theme/app_txt_theme.dart';

import '../../theme/original/app_colors.dart';

class PrivacyPolicyDialog extends ConsumerStatefulWidget {

  final Function() onConfirm;

  const PrivacyPolicyDialog({
    super.key,
    required this.onConfirm
  });


  @override
  PrivacyPolicyDialogState createState() => PrivacyPolicyDialogState();
}

class PrivacyPolicyDialogState extends ConsumerState<PrivacyPolicyDialog> {

  late AppTheme _theme;
  late AppTxtTheme _appTxtTheme;

  @override
  Widget build(BuildContext context) {
    final String appName = AppConfig.appName;
    return Consumer(builder: (context, ref, _){
      _theme = ref.watch(userInfoProvider).theme ?? AppTheme(themeType: AppThemeType.original);
      _appTxtTheme = _theme.getAppTxtTheme;

      final LinearGradient primaryLinearGradient = _theme.getAppLinearGradientTheme.buttonPrimaryColor;
      final TextStyle primaryTextStyle = _theme.getAppTextTheme.buttonPrimaryTextStyle;
      final LinearGradient secondLinearGradient = _theme.getAppLinearGradientTheme.buttonSecondaryColor;
      final TextStyle secondTextStyle = _theme.getAppTextTheme.buttonSecondaryTextStyle;

      return AlertDialog(
        surfaceTintColor: Colors.transparent,
        backgroundColor: AppColors.whiteBackGround,
        insetPadding: EdgeInsets.symmetric(horizontal: WidgetValue.horizontalPadding),
        title: Text('欢迎使用$appName', style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 18), textAlign: TextAlign.center,),
        contentPadding: EdgeInsets.symmetric(horizontal: WidgetValue.horizontalPadding, vertical: WidgetValue.verticalPadding / 2),
        content: welcomeContent(),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        actionsPadding: EdgeInsets.symmetric(horizontal: WidgetValue.horizontalPadding, vertical: WidgetValue.verticalPadding * 2),
        actions: [
          Row(
            children: [
              Expanded(child: _buildBtn(
                linearGradient: secondLinearGradient,
                textStyle: secondTextStyle,
                title: '不同意',
                onTap: () => cancelDialog()
              )),
              Expanded(child: _buildBtn(
                linearGradient: primaryLinearGradient,
                textStyle: primaryTextStyle,
                title: '同意',
                onTap: () => widget.onConfirm()
              )),
            ],
          )
        ],
      );
    });
  }

  _buildBtn({
    required LinearGradient linearGradient,
    required TextStyle textStyle,
    required String title,
    required Function() onTap
  }) {
    return CommonButton(
      onTap: onTap,
      btnType: CommonButtonType.text,
      cornerType: CommonButtonCornerType.round,
      isEnabledTapLimitTimer: false,
      text: title,
      textStyle: textStyle,
      colorBegin: linearGradient.colors[0],
      colorEnd: linearGradient.colors[1],
      colorAlignmentBegin: linearGradient.begin,
      colorAlignmentEnd: linearGradient.end,
    );
  }

  Widget welcomeContent() {
    final String appName = AppConfig.appName;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
            '感谢您使用本APP！', style: TextStyle(
            color: AppColors.textFormBlack,
            fontWeight: FontWeight.w400,
            fontSize: 14.sp
        )),
        RichText(
          text: TextSpan(
            children: <TextSpan>[
              TextSpan(text: '我们严格依据最新的法规及监管政策要求，不会对外出售、分享或出租您的个人资料，仅根据您的授权提供产品以及相关服务，并向我方员工或可信的第三方关联机构提供相关必要资料。',style: TextStyle(
                  color: AppColors.textFormBlack,
                  fontWeight: FontWeight.w400,
                  fontSize: 14.sp
              )),
              TextSpan(
                  text: '《$appName服务协议》',
                  style: TextStyle(
                      color: AppColors.mainBlue,
                      fontWeight: FontWeight.w500,
                      fontSize: 14.sp
                  ),
                  recognizer: TapGestureRecognizer()..onTap =() {
                    openTextFromAssetWidget(_appTxtTheme.userAgreement, '$appName用户服务协议');
                  }),
              TextSpan(
                  text: '以及', style: TextStyle(
                  color: AppColors.textFormBlack,
                  fontWeight: FontWeight.w400,
                  fontSize: 14.sp
              )),
              TextSpan(
                  text: '《$appName隐私协议》',
                  style: TextStyle(
                      color: AppColors.mainBlue,
                      fontWeight: FontWeight.w500,
                      fontSize: 14.sp
                  ),
                  recognizer: TapGestureRecognizer()..onTap =(){
                    openTextFromAssetWidget(_appTxtTheme.privacyAgreement, '$appName隐私政策');
                  }),
              TextSpan(
                  text: '，在确认充分理解并同意后使用本APP。点击同意即代表您已阅读，如果您不同意将无法正常使用本App。',
                  style: TextStyle(
                      color: AppColors.textFormBlack,
                      fontWeight: FontWeight.w400,
                      fontSize: 14.sp
                  )
              ),
            ],
          ),
        )
      ],
    );
  }

  void openTextFromAssetWidget(String filePath, String title) {
    BaseViewModel.pushPage(context, TextFromAssetWidget(title: title, filePath: filePath));
  }

  void cancelDialog(){

    CommDialog(context).build(
      theme: _theme,
      title: '提示',
      contentDes: '若不同意协议将退出App',
      leftBtnTitle: '不同意',
      rightBtnTitle: '取消',
      leftAction: () => exit(0),
      rightAction: () => BaseViewModel.popPage(context),
    );
  }
}