import 'dart:async';
import 'dart:core';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frechat/system/util/timer.dart';
import 'package:frechat/widgets/constant_value.dart';
import 'package:frechat/widgets/theme/original/app_colors.dart';

class BaseButton {
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final Border? broder;
  final BorderRadius? borderRadius;
  final List<BoxShadow>? boxShadowList;
  final Color? colorBegin;
  final Color? colorEnd;
  final AlignmentGeometry? colorAlignmentBegin;
  final AlignmentGeometry? colorAlignmentEnd;

  BaseButton({
    this.width ,
    this.height,
    this.margin,
    this.padding,
    this.broder,
    this.boxShadowList,
    this.borderRadius,
    this.colorBegin,
    this.colorEnd ,
    this.colorAlignmentBegin,
    this.colorAlignmentEnd,
  });

  Widget buildBaseButton({required Widget child,required Function() onTap}) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      child: child,
      onTap: () => onTap.call(),
    );

  }

    Widget buildButton({required Widget child,required Function() onTap}){

    EdgeInsetsGeometry? defaultMargin = EdgeInsets.all(2);
    EdgeInsetsGeometry? defaultPadding = EdgeInsets.all(2);
    double defaultHeight = 48;
    BorderRadius? defaultRadius = BorderRadius.circular(WidgetValue.btnRadius);
    Color? defaultColor = Color(0xffEC6193);
    AlignmentGeometry beginDefaultAlignment = Alignment.topCenter;
    AlignmentGeometry endDefaultAlignment = Alignment.bottomCenter;

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      child: Container(
        margin: margin ?? defaultMargin,
        padding: padding ??defaultPadding,
        width: width ,
        height: height ??defaultHeight,
          decoration: BoxDecoration(
            borderRadius: borderRadius ?? defaultRadius,
            border: broder ,
            boxShadow: boxShadowList,
            gradient: LinearGradient(
              colors: [colorBegin ?? defaultColor, colorEnd ?? defaultColor],
              begin: colorAlignmentBegin ?? beginDefaultAlignment,
              end: colorAlignmentEnd ?? endDefaultAlignment,
            ),
          ),
          child: child
      ),
      onTap: () => onTap.call(),

    );
  }
}


