
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frechat/models/ws_res/deposit/ws_deposit_number_option_res.dart';
import 'package:frechat/system/app_config/app_config.dart';
import 'package:frechat/system/base_view_model.dart';
import 'package:frechat/system/constant/enum.dart';
import 'package:frechat/system/providers.dart';
import 'package:frechat/widgets/constant_value.dart';
import 'package:frechat/widgets/shared/img_util.dart';
import 'package:frechat/widgets/textfromasset/textfromasset_widget.dart';
import 'package:frechat/widgets/theme/app_box_decoration_theme.dart';
import 'package:frechat/widgets/theme/app_color_theme.dart';
import 'package:frechat/widgets/theme/app_image_theme.dart';
import 'package:frechat/widgets/theme/app_linear_gradient_theme.dart';
import 'package:frechat/widgets/theme/app_text_theme.dart';
import 'package:frechat/widgets/theme/app_theme.dart';
import 'package:frechat/widgets/theme/app_txt_theme.dart';
import 'package:frechat/widgets/theme/original/app_colors.dart';

class PersonalDepositDialog extends ConsumerStatefulWidget {

  DepositOptionListInfo? selectPhraseOption;

  PersonalDepositDialog({
    super.key,
    required this.selectPhraseOption,
  });

  @override
  ConsumerState<PersonalDepositDialog> createState() => _PersonalDepositDialogState();

}

class _PersonalDepositDialogState extends ConsumerState<PersonalDepositDialog> {

  // 充值金額
  DepositOptionListInfo? get selectPhraseOption => widget.selectPhraseOption;

  // 安卓充值平台
  num? androidPlatformCode;

  // 主題色
  late AppTheme _theme;
  late AppColorTheme _appColorTheme;
  late AppTextTheme _appTextTheme;
  late AppLinearGradientTheme _appLinearGradientTheme;
  late AppImageTheme _appImageTheme;
  late AppTxtTheme _appTxtTheme;
  late AppBoxDecorationTheme _appBoxDecorationTheme;

  @override
  void initState() {
    super.initState();
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
    _appImageTheme = _theme.getAppImageTheme;
    _appTxtTheme = _theme.getAppTxtTheme;
    _appBoxDecorationTheme = _theme.getAppBoxDecorationTheme;

    return Container(
      decoration: BoxDecoration(
        color: _appColorTheme.appBarBackgroundColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(25.0),
          topRight: Radius.circular(25.0),
        ),
      ),
      padding: const EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0, bottom: 0),
      child: Column(
        children: [
          _buildTitle(),
          _buildPersonalCoinInfo(),
          _buildRechargeCoinInfo(),
          androidPayPlatformButton('assets/strike_up_list/pay_1.png', '支付宝', 1),
          const SizedBox(height: 10),
          androidPayPlatformButton('assets/strike_up_list/pay_2.png', '微信支付', 0),
          const SizedBox(height: 20),
          _buildExplanationItem(),
          const SizedBox(height: 20),
          _buildAndroidDepositBtn(),
        ],
      ),
    );

  }

  Widget _buildTitle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(width: 24.w,),
        Center(child: Text('支付方式', style:_appTextTheme.appbarTextStyle)),
        InkWell(
          onTap: () {
            BaseViewModel.popPage(context);
          },
          child:ImgUtil.buildFromImgPath(_appImageTheme.bottomSheetCancelBtnIcon, size: 24.w),
        )
      ],
    );
  }

  Widget _buildPersonalCoinInfo() {

    final num coins = ref.read(userInfoProvider).memberPointCoin?.coins ?? 0;

    return Padding(
      padding: const EdgeInsets.only(top: 24, bottom: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ImgUtil.buildFromImgPath(_appImageTheme.iconCoin, size: 24),
          const SizedBox(width: 2.5),
          Text('${selectPhraseOption?.coins?.toInt()}',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 12,
              color: _appColorTheme.depositBottomSheetCoinTextColor
              // color: Color.fromRGBO(68, 70, 72, 1),
            ),
          ),
        ],
      )
    );
  }

  Widget _buildRechargeCoinInfo() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Text(
        '￥${selectPhraseOption?.amount}',
        style: TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 24,
          color: _appColorTheme.depositBottomSheetAmountTextColor
        ),
      ),
    );
  }

  // Android 充值平台選項(支付寶、微信)
  Widget androidPayPlatformButton(String platformImgPath, String platformTitle, int code) {

    Widget checkBox;
    BoxDecoration decoration;

    if (androidPlatformCode == code) {
      checkBox = ImgUtil.buildFromImgPath(_appImageTheme.checkBoxTrueIcon, size: 24);
      decoration = _appBoxDecorationTheme.cellSelectBoxDecoration;
    } else {
      checkBox = ImgUtil.buildFromImgPath(_appImageTheme.checkBoxFalseIcon, size: 24);
      decoration = _appBoxDecorationTheme.cellBoxDecoration;
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        InkWell(
          onTap: () {
            androidPlatformCode = code;
            setState(() {});
          },
          child: Container(
            height: 48,
            decoration: decoration,
            child: Padding(
              padding: const EdgeInsets.only(left: 11, right: 11),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Image.asset(platformImgPath, width: 24, height: 24),
                      const SizedBox(width: 8),
                      Text(
                        platformTitle,
                        style:_appTextTheme.depositCoinTitleTextStyle,
                      ),
                    ],
                  ),
                  checkBox
                ],
              ),
            ),
          ),
        )

      ],
    );
  }

  // 充值協議
  Widget _buildExplanationItem() {

    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('充值即代表已阅读并同意 ', style:_appTextTheme.depositDirectionsContentTextStyle),
        InkWell(
          onTap: () async {
            BaseViewModel.pushPage(context, TextFromAssetWidget(
              title: '${AppConfig.appName}充值协议',
              filePath: _appTxtTheme.rechargeProtocol),
            );
          },
          child: Text('《${AppConfig.appName}充值协议》',style:_appTextTheme.depositDirectionsHighLightTextStyle)),
      ],
    );
  }

  // Android 立即充值 Button
  Widget _buildAndroidDepositBtn() {

    Gradient gradient;
    TextStyle textStyle;

    if (androidPlatformCode == null) {
      gradient = _appLinearGradientTheme.buttonDisableColor;
      textStyle = _appTextTheme.buttonDisableTextStyle;
    } else {
      gradient = _appLinearGradientTheme.buttonPrimaryColor;
      textStyle = _appTextTheme.buttonPrimaryTextStyle;
    }

    return GestureDetector(
      onTap: () {
        if (androidPlatformCode == null) return;
        ref.read(appPaymentManagerProvider).memberRecharge(context, rechargeType: androidPlatformCode!, selectPhraseOption: selectPhraseOption);
      },
      child: Container(
        alignment: Alignment.center,
        height: WidgetValue.mainComponentHeight,
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(99),
        ),
        child: Text('立即充值', style: textStyle),
      ),
    );
  }
}