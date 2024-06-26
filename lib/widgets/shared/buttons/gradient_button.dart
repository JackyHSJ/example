import 'package:flutter/material.dart';
import 'package:frechat/widgets/shared/buttons/common_button.dart';
import 'package:frechat/widgets/theme/original/app_colors.dart';

//漸層色按鈕
class GradientButton extends StatelessWidget {
  GradientButton(
      {this.text = '',
      this.onPressed,
      this.gradientColorBegin = AppColors.mainPink,
      this.gradientColorEnd = AppColors.mainPetalPink,
      this.alignmentBegin = Alignment.topCenter,
      this.alignmentEnd = Alignment.bottomCenter,
      this.radius = 5.0,
      this.textStyle,
      this.height = 48.0,
      this.widget,
      this.border,
      Key? key})
      : super(key: key);

  final Color gradientColorBegin;
  final Color gradientColorEnd;
  final AlignmentGeometry alignmentBegin;
  final AlignmentGeometry alignmentEnd;
  final double radius;
  final double height;
  String text;
  final TextStyle? textStyle;
  final Widget? widget;
  final Function()? onPressed;
  final Border? border;

  @override
  Widget build(BuildContext context) {
    return CommonButton(
        btnType: widget!=null ?CommonButtonType.text_icon:CommonButtonType.text,
        cornerType: CommonButtonCornerType.custom,
        isEnabledTapLimitTimer: false,
        radius: radius,
        colorBegin: gradientColorBegin,
        colorEnd: gradientColorEnd,
        colorAlignmentBegin: alignmentBegin,
        colorAlignmentEnd: alignmentEnd,
        broder: border,
        text: text,
        textStyle:textStyle ,
        iconWidget: widget,
        onTap: () {
          onPressed?.call();
        });
  }
}
