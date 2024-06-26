
import 'package:flutter/material.dart';
import 'package:frechat/widgets/theme/original/app_colors.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class MainGradient {
  MainGradient({
    this.linearGradient = AppColors.labelOrangeColors
  });

  LinearGradient linearGradient;

  Widget text({
    required String title,
    double fontSize = 12,
    FontWeight fontWeight = FontWeight.w400,
    TextAlign? textAlign
  }) {
    return ShaderMask(
      shaderCallback: (bounds) => linearGradient.createShader(bounds),
      child: Text(
        title,
        textAlign: textAlign ?? TextAlign.start,
        style: TextStyle(
          // 白色與漸變的顏色相乘以形成最終的顏色
          color: Colors.white,
          fontSize: fontSize,
          fontWeight: fontWeight,
        ),
      ),
    );
  }

  Widget icon({
    required IconData iconData,
    double iconSize = 20
  }) {
    return ShaderMask(
      shaderCallback: (bounds) => linearGradient.createShader(bounds),
      child: Icon(iconData, color: Colors.white, size: iconSize),
    );
  }
}