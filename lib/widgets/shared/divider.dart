import 'package:flutter/material.dart';

import '../theme/original/app_colors.dart';
import '../theme/uidefine.dart';

Widget MainDivider({
  Color color = AppColors.dividerBlack,
  double? weight,
  double? height,
  double? width,
}) {
  return Divider(
    color: color,
    thickness: weight,
    height: (height == null) ? null : height,
    indent: (width == null) ? null :  UIDefine.getWidth()/2 -width,
    endIndent: (width == null) ? null :  UIDefine.getWidth()/2 - width,
  );
}