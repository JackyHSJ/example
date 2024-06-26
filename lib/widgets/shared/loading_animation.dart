
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:frechat/system/providers.dart';
import 'package:frechat/widgets/constant_value.dart';
import 'package:frechat/widgets/theme/app_color_theme.dart';
import 'package:frechat/widgets/theme/app_theme.dart';
import 'package:frechat/widgets/theme/original/app_colors.dart';
import 'package:frechat/widgets/theme/uidefine.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class LoadingAnimation {
  static OverlayEntry? _overlayEntry;

  static Widget discreteCircle({
    Color? color,
    double? size
  }) {
    final double paddingHeight = UIDefine.getAppBarHeight() + UIDefine.getStatusBarHeight();
    return SizedBox(
      height: size ?? UIDefine.getHeight() - paddingHeight,
      width: UIDefine.getWidth(),
      child: Center(
        child: LoadingAnimationWidget.fourRotatingDots (
          color: color ?? AppColors.mainPink,
          size: WidgetValue.primaryLoading,
        ),
      ),
    );
  }

  static void showOverlayMask(BuildContext context, {
    double opacity = 0
  }) {
    if(_overlayEntry != null) {
      return ;
    }
    _overlayEntry = OverlayEntry(
      builder: (context) =>  Stack(
        children: <Widget>[
          Opacity(
            opacity: opacity,
            child: ModalBarrier(dismissible: false, color: Colors.white),
          ),
        ],
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  static void showOverlayDotsLoading(BuildContext context, {
    required AppTheme appTheme
  }) {
    if(_overlayEntry != null) {
      return ;
    }
    final AppColorTheme appColorTheme = appTheme.getAppColorTheme;
    _overlayEntry = OverlayEntry(
      builder: (context) =>  Stack(
        children: <Widget>[
          Opacity(
            opacity: 0.5,
            child: ModalBarrier(dismissible: false, color: Colors.white),
          ),
          Center(
            child: LoadingAnimationWidget.fourRotatingDots (
              color: appColorTheme.primaryColor,
              size: WidgetValue.primaryLoading,
            ), // 这里可以自定义你的加载动画
          ),
        ],
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  static void showOverlayLoading(BuildContext context) {
    if(_overlayEntry != null) {
      return ;
    }
    _overlayEntry = OverlayEntry(
      builder: (context) => const Stack(
        children: <Widget>[
          Opacity(
            opacity: 0.5,
            child: ModalBarrier(dismissible: false, color: Colors.black),
          ),
          Center(
            child: CircularProgressIndicator(), // 这里可以自定义你的加载动画
          ),
        ],
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  static void cancelOverlayLoading() {
    if(_overlayEntry == null) {
      return ;
    }
    _overlayEntry?.remove();
    _overlayEntry = null;
  }
}