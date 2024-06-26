import 'package:flutter/material.dart';
import 'package:frechat/system/base_view_model.dart';
import 'package:frechat/system/constant/enum.dart';
import 'package:frechat/widgets/theme/app_theme.dart';

class BaseBottomSheet {

  static void showBottomSheet(BuildContext context, {
    required Widget widget,
    AppTheme? theme,
    bool? isScrollControlled,
    Color? barrierColor,
  }) {
    AppTheme _theme = theme ?? AppTheme(themeType: AppThemeType.original);

    showModalBottomSheet<void>(
      barrierColor: barrierColor ?? _theme.getAppColorTheme.bottomSheetBackgroundColor,
      backgroundColor: Colors.transparent,
      isScrollControlled: isScrollControlled ?? false,
      context: context,
      builder: (BuildContext context) {
        return InkWell(
          onTap: () => BaseViewModel.clearAllFocus(),
          child: widget,
        );
      },
    );
  }
}