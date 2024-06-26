import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frechat/screens/profile/setting/teen/personal_setting_teen.dart';
import 'package:frechat/system/base_view_model.dart';
import 'package:frechat/system/constant/enum.dart';
import 'package:frechat/system/providers.dart';
import 'package:frechat/widgets/constant_value.dart';
import 'package:frechat/widgets/shared/buttons/common_button.dart';
import 'package:frechat/widgets/shared/img_util.dart';
import 'package:frechat/widgets/theme/app_box_decoration_theme.dart';
import 'package:frechat/widgets/theme/original/app_colors.dart';
import 'package:frechat/widgets/theme/app_image_theme.dart';
import 'package:frechat/widgets/theme/app_linear_gradient_theme.dart';
import 'package:frechat/widgets/theme/app_text_theme.dart';
import 'package:frechat/widgets/theme/app_theme.dart';

import '../../../system/global/shared_preferance.dart';
import '../../shared/buttons/gradient_button.dart';
import '../../theme/app_color_theme.dart';

class StrikeUpListTeenDialog extends ConsumerStatefulWidget {
  final Function onClose;
  const StrikeUpListTeenDialog({super.key,required this.onClose});
  @override
  ConsumerState<StrikeUpListTeenDialog> createState() => _StrikeUpListTeenDialogState();
}

class _StrikeUpListTeenDialogState extends ConsumerState<StrikeUpListTeenDialog> {
  late AppTheme _theme;
  late AppImageTheme _appImageTheme;
  late AppLinearGradientTheme _appLinearGradientTheme;
  late AppTextTheme _appTextTheme;
  late AppBoxDecorationTheme _appBoxDecorationTheme;

  @override
  Widget build(BuildContext context) {

    _theme = ref.watch(userInfoProvider).theme ?? AppTheme(themeType: AppThemeType.original);
    _appImageTheme = _theme.getAppImageTheme;
    _appLinearGradientTheme = _theme.getAppLinearGradientTheme;
    _appTextTheme = _theme.getAppTextTheme;
    _appBoxDecorationTheme = _theme.getAppBoxDecorationTheme;

    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal:16.w),
      child: Container(
        decoration:_appBoxDecorationTheme.dialogBoxDecoration,
        padding: EdgeInsets.symmetric(vertical: 16.h,horizontal: 16.w),
        child: _buildContent(),
      ),
    );

  }

  Widget _buildContent() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ImgUtil.buildFromImgPath(_appImageTheme.teenSettingDialogImage, width: 139.w, height: 150.h),
          Padding(
            padding: EdgeInsets.fromLTRB(24, 20, 24, 10),
            child: SizedBox(
              child: Text(
                '青少年模式',
                style:_appTextTheme.dialogTitleTextStyle,
              ),
            ),
          ),
          Center(
            child: Text(
              '为呵护为成年人健康成长，我们特别推出青少年模式，该模式下部份功能无法正常使用。请监护人主动选择，并设置监护密码',
              textAlign: TextAlign.center,
              style: _appTextTheme.dialogContentTextStyle,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 20.h),
            child: GradientButton(
              text: '我知道了',
              textStyle: _appTextTheme.dialogConfirmButtonTextStyle,
              radius: 25,
              gradientColorBegin: _appLinearGradientTheme.dialogConfirmButtonColor.colors[0],
              gradientColorEnd: _appLinearGradientTheme.dialogConfirmButtonColor.colors[1],
              height: 50,
              onPressed: () {
                FcPrefs.setTeenTips(true);
                BaseViewModel.popPage(context);
                widget.onClose.call();

              },
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 6.h),
            child: GradientButton(
              text: '进入青少年模式 >',
              textStyle: _appTextTheme.dialogCancelButtonTextStyle,
              radius: 25,
              gradientColorBegin: _appLinearGradientTheme.dialogCancelButtonColor.colors[0],
              gradientColorEnd: _appLinearGradientTheme.dialogCancelButtonColor.colors[1],
              height: 50,
              onPressed: () {
                BaseViewModel.popPage(context);
                widget.onClose.call();
                BaseViewModel.pushPage(context, const PersonalSettingTeen());
              },
            ),
          ),
        ],
      ),
    );
  }


}