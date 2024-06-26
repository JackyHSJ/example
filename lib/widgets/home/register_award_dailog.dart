import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frechat/models/res/member_register_res.dart';
import 'package:frechat/system/base_view_model.dart';
import 'package:frechat/system/constant/enum.dart';
import 'package:frechat/system/providers.dart';
import 'package:frechat/system/repository/http_setting.dart';
import 'package:frechat/system/util/cache_network_image_util.dart';
import 'package:frechat/widgets/constant_value.dart';
import 'package:frechat/widgets/shared/dialog/comm_dialog.dart';
import 'package:frechat/widgets/shared/img_util.dart';
import 'package:frechat/widgets/theme/app_box_decoration_theme.dart';
import 'package:frechat/widgets/theme/app_color_theme.dart';
import 'package:frechat/widgets/theme/app_linear_gradient_theme.dart';
import 'package:frechat/widgets/theme/app_text_theme.dart';
import 'package:frechat/widgets/theme/app_theme.dart';
import 'package:frechat/widgets/theme/original/app_colors.dart';
import 'package:frechat/widgets/theme/uidefine.dart';

class RegisterAwardDialog extends ConsumerStatefulWidget {
  RegisterBenefit? registerBenefit;
  num gender;
  final Function onClose;

  RegisterAwardDialog({
    super.key,
    this.registerBenefit,
    required this.gender,
    required this.onClose,
  });

  @override
  ConsumerState<RegisterAwardDialog> createState() => _registerAwardDialogState();
}

class _registerAwardDialogState extends ConsumerState<RegisterAwardDialog> {
  RegisterBenefit? get registerBenefit => widget.registerBenefit;

  num get gender => widget.gender;
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
      insetPadding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Container(
        decoration: _appBoxDecorationTheme.dialogBoxDecoration,
        padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
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
  }

  Widget _buildTitle() {
    return Text(
      '注册奖励',
      style: _appTextTheme.dialogTitleTextStyle,
      textAlign: TextAlign.center,
    );
  }

  Widget _buildContentWidget() {
    String? goldCoinText = gender == 0 ? registerBenefit?.femaleCoin : registerBenefit?.maleCoin;
    String giftUrl = registerBenefit?.giftUrl ?? '';
    String giftName = registerBenefit?.giftName ?? '';

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 4),
        _buildSubTitle(),
        const SizedBox(height: 20),
        goldCoinText == null ? _buildGiftAwardContent(giftUrl, giftName) : _buildCoinAwardContent(goldCoinText),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildSubTitle() {
    return Text(
      '恭喜您完成注册，预祝您展开美好的一天',
      style: _appTextTheme.dialogContentTextStyle,
      textAlign: TextAlign.center,
    );
  }

  Widget _buildCoinAwardContent(String coinText) {
    return Container(
      padding: const EdgeInsets.only(top: 8, right: 12, bottom: 12, left: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.0),
        color: _appColorTheme.awardBgColor,
      ),
      child: Column(
        children: [
          ImgUtil.buildFromImgPath('assets/common/icon_coin_large.png', size: 60.w),
          SizedBox(height: 4.h),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ImgUtil.buildFromImgPath('assets/common/icon_coin_01.png', size: 16.w),
              Text(
                '+$coinText',
                style: TextStyle(
                  color: _appColorTheme.registerAwardCoinTextColor,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  height: 1.0,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildGiftAwardContent(String giftUrl, String giftName) {
    return Container(
      padding: const EdgeInsets.only(top: 8, right: 12, bottom: 12, left: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.0),
        color: _appColorTheme.awardBgColor,
      ),
      child: Column(
        children: [
          CachedNetworkImageUtil.load(HttpSetting.baseImagePath + giftUrl, size: 60.w),
          SizedBox(height: 4.h),
          Text(
            giftName,
            style: TextStyle(
              color: _appColorTheme.registerAwardGiftTextColor,
              fontSize: 12,
              fontWeight: FontWeight.w700,
              height: 1.0,
            ),
          ),
        ],
      ),
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
        height: 50.h,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(WidgetValue.btnRadius * 2),
            gradient: _appLinearGradientTheme.buttonPrimaryColor),
        child: Text('确定', style: _appTextTheme.buttonPrimaryTextStyle),
      ),
    );
  }
}
