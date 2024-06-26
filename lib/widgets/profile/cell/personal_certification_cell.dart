import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frechat/system/constant/enum.dart';
import 'package:frechat/system/providers.dart';
import 'package:frechat/widgets/shared/img_util.dart';
import 'package:frechat/widgets/theme/app_box_decoration_theme.dart';
import 'package:frechat/widgets/theme/app_color_theme.dart';
import 'package:frechat/widgets/theme/app_theme.dart';
import '../../constant_value.dart';
import '../../shared/buttons/common_button.dart';
import '../../theme/original/app_colors.dart';

/// alreadyCertification & authenticating 則一填入
class PersonalCertificationCell extends ConsumerStatefulWidget {

  final bool? authenticating;
  final String title;
  final String des;
  final String imgPath;
  final bool btnEnable;
  final String btnTitle;
  final Function()? onBtnPress;
  CertificationType type;

  PersonalCertificationCell({
    super.key,
    this.authenticating,
    required this.title,
    required this.des,
    required this.imgPath,
    this.btnEnable = true,
    required this.btnTitle,
    this.onBtnPress,
    required this.type
  });

  @override
  ConsumerState<PersonalCertificationCell> createState() => _PersonalCertificationCellState();
}

class _PersonalCertificationCellState extends ConsumerState<PersonalCertificationCell> {

  late AppTheme _theme;
  late AppColorTheme _appColorTheme;
  late AppBoxDecorationTheme _appBoxDecorationTheme;

  @override
  Widget build(BuildContext context) {

    _theme = ref.watch(userInfoProvider).theme ?? AppTheme(themeType: AppThemeType.original);
    _appColorTheme = _theme.getAppColorTheme;
    _appBoxDecorationTheme = _theme.getAppBoxDecorationTheme;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: WidgetValue.horizontalPadding,
        vertical: WidgetValue.verticalPadding,
      ),
      decoration: _appBoxDecorationTheme.personalCertificationCellBoxDecoration,
      child: Row(
        children: [
          _buildIcon(),
          SizedBox(width: WidgetValue.horizontalPadding),
          Expanded(child: _buildText()),
          _buildBtn()
        ],
      ),
    );
  }

  _buildIcon() {
    return ImgUtil.buildFromImgPath(widget.imgPath, size: WidgetValue.primaryIcon);
  }

  _buildText() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.title,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: _appColorTheme.personalProfilePrimaryTextColor
          ),
        ),
        Text(
          widget.des,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: _appColorTheme.personalProfileSecondaryTextColor
          ),
        ),
      ],
    );
  }

  _buildBtn() {
    if (widget.type == CertificationType.done) {
      return CommonButton(
        btnType: CommonButtonType.text,
        cornerType: CommonButtonCornerType.circle,
        isEnabledTapLimitTimer: false,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        text: widget.btnTitle,
        textStyle: TextStyle(color: _appColorTheme.personalCertifiedTextColor, fontSize: 12, fontWeight: FontWeight.w500),
        colorBegin: _appBoxDecorationTheme.personalCertifiedBoxDecoration.color,
        colorEnd: _appBoxDecorationTheme.personalCertifiedBoxDecoration.color,
        onTap: () {}
      );
    }

    if (widget.type == CertificationType.processing) {
      return CommonButton(
        btnType: CommonButtonType.text,
        cornerType: CommonButtonCornerType.circle,
        isEnabledTapLimitTimer: false,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        text: widget.btnTitle,
        textStyle: TextStyle(color: _appColorTheme.personalProcessCertificationTextColor, fontSize: 12, fontWeight: FontWeight.w500),
        colorBegin: _appBoxDecorationTheme.personalProcessCertificationBoxDecoration.color,
        colorEnd: _appBoxDecorationTheme.personalProcessCertificationBoxDecoration.color,
        onTap: () {}
      );
    }

    return CommonButton(
      btnType: CommonButtonType.text,
      cornerType: CommonButtonCornerType.circle,
      isEnabledTapLimitTimer: false,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      text: widget.btnTitle,
      textStyle: TextStyle(color: _appColorTheme.personalUncertifiedTextColor, fontSize: 12),
      colorBegin: _appBoxDecorationTheme.personalUncertifiedBoxDecoration.gradient?.colors[0],
      colorEnd: _appBoxDecorationTheme.personalUncertifiedBoxDecoration.gradient?.colors[1],
      onTap: () => widget.onBtnPress?.call()
    );
  }
}
