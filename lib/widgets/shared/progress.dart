import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frechat/widgets/constant_value.dart';
import 'package:frechat/widgets/theme/app_color_theme.dart';
import 'package:frechat/widgets/theme/app_theme.dart';

import '../../system/constant/enum.dart';
import '../../system/providers.dart';
import '../theme/original/app_colors.dart';

class ProgressIndicatorWidget extends ConsumerStatefulWidget {

  bool enableCountDown;
  int? countDownTime;
  double beginPercent;
  double progressWidth;
  double progressHeight;

  ProgressIndicatorWidget({
    super.key,
    this.enableCountDown = false,
    this.countDownTime,
    this.beginPercent = 1,
    this.progressHeight = 5,
    this.progressWidth = 200,
  });

  @override
  ConsumerState<ProgressIndicatorWidget> createState() => _ProgressIndicatorState();

}

class _ProgressIndicatorState extends ConsumerState<ProgressIndicatorWidget> with TickerProviderStateMixin {
  late AppTheme _theme;
  late AppColorTheme _appColorTheme;
  late AnimationController controller;
  late Animation<double> animation;

  int? get countDownTime => widget.countDownTime;
  double get beginPercent => widget.beginPercent;
  bool get enableCountDown => widget.enableCountDown;
  double get progressWidth => widget.progressWidth;
  double get progressHeight => widget.progressHeight;

  @override
  void initState() {
    super.initState();
    _animate();
  }
  @override
  void dispose() {
    _dispose();
    super.dispose();
  }

  _dispose() {
    if(enableCountDown == false) {
      return ;
    }
    controller.dispose();
  }

  _animate() {
    if(enableCountDown == false) {
      return ;
    }
    controller = AnimationController(duration: Duration(seconds: countDownTime!), vsync: this);
    animation = Tween<double>(begin: beginPercent, end: 0.0).animate(controller)
      ..addListener(() {
        if (animation.value == 0) {
          Future.delayed(const Duration(milliseconds: 2000), () {
        });
        }
        setState(() {});
      });
    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    _theme = ref.watch(userInfoProvider).theme ?? AppTheme(themeType: AppThemeType.original);
    _appColorTheme = _theme!.getAppColorTheme;

    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(WidgetValue.btnRadius)),
      child: SizedBox(
        width: progressWidth,
        child: LinearProgressIndicator(
          minHeight: progressHeight,
          backgroundColor: _appColorTheme.progressbarLineColors,
          valueColor: AlwaysStoppedAnimation(_appColorTheme.progressbarIndicatorColors),
          value: (enableCountDown == true) ? animation.value : beginPercent,
        ),
      ),
    );
  }
}
