
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frechat/system/constant/enum.dart';
import 'package:frechat/system/providers.dart';
import 'package:frechat/widgets/theme/app_color_theme.dart';
import 'package:frechat/widgets/theme/app_theme.dart';
import 'package:frechat/widgets/theme/original/app_colors.dart';

class SwitchButton extends ConsumerStatefulWidget {
  SwitchButton({super.key, this.enable = false, required this.onChange});
  bool enable;
  Function(bool) onChange;
  @override
  ConsumerState<SwitchButton> createState() => _SwitchButtonState();
}

class _SwitchButtonState extends ConsumerState<SwitchButton> with TickerProviderStateMixin {
  Function(bool) get onChange => widget.onChange;
  late AppTheme _theme;
  late AppColorTheme appColorTheme;

  @override
  Widget build(BuildContext context) {
    _theme = ref.watch(userInfoProvider).theme ?? AppTheme(themeType: AppThemeType.original);
    appColorTheme = _theme.getAppColorTheme;
    return CupertinoSwitch(
      value: widget.enable,
      activeColor: appColorTheme.tabBarIndicatorColor,
      trackColor: AppColors.btnDeepGrey,
      onChanged: (changeState) {
        widget.enable = changeState;
        onChange(changeState);
        setState(() {});
      }
    );
  }
}