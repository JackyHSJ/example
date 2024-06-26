import 'dart:async';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:frechat/widgets/shared/buttons/custom_base_button.dart';
import 'package:frechat/widgets/shared/buttons/layout_base_button.dart';
import 'package:frechat/widgets/shared/buttons/icon_base_button.dart';
import 'package:frechat/widgets/shared/buttons/text_base_button.dart';

import '../../../system/util/timer.dart';
import '../../constant_value.dart';
enum CommonButtonType {
  text, /// 單行文字
  text_icon, ///文字+圖形
  icon, ///圖形
  layout,///佈局
  custom,///自訂
}
enum CommonButtonCornerType {
  round,///圓角
  circle,///圓邊
  square,///直角
  custom,///自訂
}
class CommonButton extends StatefulWidget {
  final CommonButtonType btnType;
  final CommonButtonCornerType cornerType;
  final bool isEnabledTapLimitTimer;
  final Function() onTap;
  final bool? isEnabled;
  final int? clickLimitTime;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final double? width;
  final double? height;
  final Border? broder;
  final double? radius;
  final List<BoxShadow>? boxShadowList;
  final Color? colorBegin;
  final Color? colorEnd;
  final AlignmentGeometry? colorAlignmentBegin;
  final AlignmentGeometry? colorAlignmentEnd;
  final String? text;
  final TextStyle? textStyle;
  final Widget? iconWidget ;
  final Widget? layoutTitle;
  final Widget? layoutLeading;
  final Widget? layoutEnding;
  final Widget? layoutBottom;
  final Widget? layoutHeader;
  final Widget? customWidget;

  const CommonButton(
      {super.key,
        required this.btnType,
        required this.cornerType,
        required this.isEnabledTapLimitTimer,
        required this.onTap,
        this.isEnabled = true,
        this.clickLimitTime,
        this.margin,
        this.padding,
        this.width ,
        this.height,
        this.broder,
        this.radius,
        this.boxShadowList,
        this.colorBegin,
        this.colorEnd,
        this.colorAlignmentBegin,
        this.colorAlignmentEnd,
        this.text,
        this.textStyle,
        this.iconWidget,
        this.layoutTitle,
        this.layoutLeading,
        this.layoutEnding,
        this.layoutHeader,
        this.layoutBottom,
        this.customWidget,
      });

  @override
  State<CommonButton> createState() => _CommonButtonState();
}

class _CommonButtonState extends State<CommonButton> {

  bool isOnLimitTime = false;
  Timer? timer;
  Widget defaultIconWidget = const Image(image: AssetImage('assets/images/icon_exclamationmark.png'),);
  Color? defaultIconBgColor = Colors.transparent;
  double defaultIconSize = 30;
  int defaultClickLimitTime = 1;

  void _onTap(){
    if(widget.isEnabled == false){
      return;
    }
    if(widget.isEnabledTapLimitTimer == false){
      widget.onTap();
      return;
    }
    if (isOnLimitTime == false) {
      isOnLimitTime = true;
      widget.onTap();
      _startIntervalTimer();
    }
  }

  void _startIntervalTimer() {
    int time = widget.clickLimitTime ?? defaultClickLimitTime;
    timer ??= TimerUtil.periodic(
        timerType: TimerType.seconds,
        timerNum: time,
        timerCallback: (time) {
          _stopIntervalTimer();
        });
  }

  void _stopIntervalTimer() {
    if (timer != null) {
      print("限制點擊結束");
      timer!.cancel();
      timer = null;
      isOnLimitTime = false;
    }
  }

  BorderRadius _getBorderRadius(){
    double radius =  0;
    switch(widget.cornerType){
      case CommonButtonCornerType.round:
        radius = 99.0;
        // radius = WidgetValue.btnRadius;
        break;
      case CommonButtonCornerType.circle:
        radius = 999;
        // radius = widget.height ?? WidgetValue.btnRadius*2;
        break;
      case CommonButtonCornerType.square:
        radius = 0;
      case CommonButtonCornerType.custom:
        radius = widget.radius ?? 0;
        break;
    }
    return BorderRadius.circular(radius);
  }
  @override
  Widget build(BuildContext context) {
    switch(widget.btnType){
      case CommonButtonType.text:
        return _textButton();
      case CommonButtonType.text_icon:
        return _textIconButton();
      case CommonButtonType.icon:
        return _iconButton();
      case CommonButtonType.layout:
        return _layoutButton();
      case CommonButtonType.custom:
        return _customButton();
      default:
        return Container();
    }
  }

  Widget _textButton() {
    TextBaseButton textBaseButton = TextBaseButton(
      margin: widget.margin,
      padding: widget.padding,
      width: widget.width,
      height: widget.height,
      broder: widget.broder,
      borderRadius: _getBorderRadius(),
      boxShadowList: widget.boxShadowList,
      colorBegin: widget.colorBegin,
      colorEnd: widget.colorEnd,
      colorAlignmentBegin: widget.colorAlignmentBegin ,
      colorAlignmentEnd: widget.colorAlignmentEnd,
      text: widget.text,
      textStyle: widget.textStyle,
    );
    return textBaseButton.buildTextButton(onTap: () {
      _onTap();
    });
  }

  Widget _textIconButton() {
    TextBaseButton textBaseButton = TextBaseButton(
      margin: widget.margin,
      padding: widget.padding,
      width: widget.width,
      height: widget.height ,
      broder: widget.broder,
      borderRadius: _getBorderRadius(),
      boxShadowList: widget.boxShadowList,
      colorBegin: widget.colorBegin,
      colorEnd: widget.colorEnd ,
      colorAlignmentBegin: widget.colorAlignmentBegin,
      colorAlignmentEnd: widget.colorAlignmentEnd,
      text: widget.text,
      textStyle: widget.textStyle,

    );
    return textBaseButton.buildTextIconButton(
        iconWidget: widget.iconWidget ?? defaultIconWidget,
        onTap: () {
          _onTap();
        });
  }

  Widget _iconButton(){
    IconBaseButton iconBaseButton = IconBaseButton(
      margin: widget.margin,
      padding: widget.padding,
      width: widget.width ?? defaultIconSize,
      height: widget.height ?? defaultIconSize,
      broder: widget.broder,
      borderRadius: _getBorderRadius(),
      boxShadowList: widget.boxShadowList,
      colorBegin: widget.colorBegin ?? defaultIconBgColor,
      colorEnd: widget.colorEnd ?? defaultIconBgColor ,
      colorAlignmentBegin: widget.colorAlignmentBegin,
      colorAlignmentEnd: widget.colorAlignmentEnd,
      iconWidget: widget.iconWidget ?? defaultIconWidget,
    );
    return iconBaseButton.buildIconButton(onTap: () {
      _onTap();
    });
  }

  Widget _layoutButton(){
    LayoutBaseButton layoutBaseButton = LayoutBaseButton(
      margin: widget.margin,
      padding: widget.padding,
      width: widget.width,
      height: widget.height ,
      broder: widget.broder,
      borderRadius: _getBorderRadius(),
      boxShadowList: widget.boxShadowList,
      colorBegin: widget.colorBegin,
      colorEnd: widget.colorEnd ,
      colorAlignmentBegin: widget.colorAlignmentBegin,
      colorAlignmentEnd: widget.colorAlignmentEnd,
      title: widget.layoutTitle,
      header: widget.layoutHeader,
      bottom: widget.layoutBottom,
      leading: widget.layoutLeading,
      ending: widget.layoutEnding,

    );
    return layoutBaseButton.buildLayoutButton(onTap: () {
      _onTap();
    });
  }

  Widget _customButton(){
    CustomBaseButton customBaseButton = CustomBaseButton(customWidget: widget.customWidget);
    return customBaseButton.buildCustomButton(onTap:()=> _onTap.call());
  }
}
