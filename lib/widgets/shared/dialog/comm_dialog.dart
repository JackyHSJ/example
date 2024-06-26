import 'package:flutter/material.dart';
import 'package:frechat/widgets/constant_value.dart';
import 'package:frechat/widgets/shared/buttons/common_button.dart';
import 'package:frechat/widgets/shared/dialog/base_dialog.dart';
import 'package:frechat/widgets/theme/app_theme.dart';
import 'package:frechat/widgets/theme/original/app_colors.dart';
import 'package:frechat/widgets/theme/uidefine.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CommDialog extends BaseDialog {
  CommDialog(super.context);

  build({
    AppTheme? theme ,
    required String title,
    required String contentDes,
    required String rightBtnTitle,
    required Function()? rightAction,
    String? leftBtnTitle,
    Function()? leftAction,
    double? horizontalPadding,
    Widget? widget,
    Widget? actionWidget,
    TextStyle? rightTextStyle,
    TextStyle? leftTextStyle,
    LinearGradient? rightLinearGradient,
    LinearGradient? leftLinearGradient,
    Border? rightBroder,
    Border? leftBroder,
    bool isDialogCancel = true,
    Color? backgroundColor,
    BoxDecoration? dialogBoxDecoration,
    TextStyle? titleTextStyle,
    TextStyle? contentTextStyle,
  }) {

    return buildDialog(
      isDialogCancel: isDialogCancel,
      child: Container(
        decoration:(theme != null)?theme.getAppBoxDecorationTheme.dialogBoxDecoration : dialogBoxDecoration,
        padding: EdgeInsets.symmetric(vertical: 16.h,horizontal: 16.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _alertTitle(theme,title,titleTextStyle),
            widget == null ? _alertContentText(theme,contentDes,contentTextStyle) : _alertContentWidget(widget),
            actionWidget ?? Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Visibility(
                  visible: leftBtnTitle != null,
                  child: Expanded(
                    child: _buildLeftBtn(
                        theme: theme,
                        title: leftBtnTitle,
                        textStyle: leftTextStyle,
                        linearGradient: leftLinearGradient,
                        action: () => leftAction?.call()),
                  ),
                ),
                Visibility(
                  visible: leftBtnTitle != null,
                  child: SizedBox(
                    width: WidgetValue.separateHeight,
                  ),
                ),
                Expanded(
                  child: _buildRightBtn(
                      theme: theme,
                      title: rightBtnTitle,
                      textStyle: rightTextStyle,
                      linearGradient: rightLinearGradient,
                      action: () => rightAction?.call()),
                ),
              ],
            ),
          ],
        ),
      )
    );
  }


  _alertTitle(AppTheme? theme,String title,TextStyle? titleTextStyle) {
    return Text(
      title,
      style:(theme != null)?theme.getAppTextTheme.dialogTitleTextStyle : titleTextStyle,
      textAlign: TextAlign.center,
    );
  }

  _alertContentText(AppTheme? theme,String contentDes,TextStyle? contentTextStyle) {
    return Container(
      padding: const EdgeInsets.only(top: 4, bottom: 20),
      constraints: const BoxConstraints(minWidth: 311),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            contentDes,
            style: (theme != null)? theme.getAppTextTheme.dialogContentTextStyle : contentTextStyle,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  _alertContentWidget(Widget? widget) {
    return Container(
      padding: const EdgeInsets.only(top: 4, bottom: 20),
      constraints: const BoxConstraints(minWidth: 311),
      child: widget,
    );
  }

  _buildLeftBtn({
    String? title,
    TextStyle? textStyle,
    LinearGradient? linearGradient,
    Border? broder,
    AppTheme? theme,
    required Function() action
  }) {

    if (title == null){
      return Container();
    }

    return CommonButton(
      onTap: () => action(),
      btnType: CommonButtonType.text,
      cornerType: CommonButtonCornerType.round,
      isEnabledTapLimitTimer: false,
      text: title,
      textStyle: (theme != null)?theme.getAppTextTheme.dialogCancelButtonTextStyle : textStyle,
      colorBegin: (theme != null)?theme.getAppLinearGradientTheme.dialogCancelButtonColor.colors[0]:linearGradient?.colors[0],
      colorEnd: (theme != null)?theme.getAppLinearGradientTheme.dialogCancelButtonColor.colors[1]:linearGradient?.colors[1],
      colorAlignmentBegin: linearGradient?.begin ??Alignment.topCenter,
      colorAlignmentEnd: linearGradient?.end ?? Alignment.bottomCenter,
      broder: broder ,
    );
  }

  _buildRightBtn({
    String? title,
    TextStyle? textStyle,
    LinearGradient? linearGradient,
    Border? broder,
    AppTheme? theme,
    required Function() action
  }) {

    if (title == null){
      return Container();
    }

    return CommonButton(
      onTap: () => action(),
      btnType: CommonButtonType.text,
      cornerType: CommonButtonCornerType.round,
      isEnabledTapLimitTimer: false,
      text: title,
      textStyle: (theme != null)?theme.getAppTextTheme.dialogConfirmButtonTextStyle:textStyle,
      colorBegin: (theme != null)?theme.getAppLinearGradientTheme.dialogConfirmButtonColor.colors[0]:linearGradient?.colors[0],
      colorEnd: (theme != null)?theme.getAppLinearGradientTheme.dialogConfirmButtonColor.colors[1]:linearGradient?.colors[1],
      colorAlignmentBegin: linearGradient?.begin ??Alignment.topCenter,
      colorAlignmentEnd: linearGradient?.end ?? Alignment.bottomCenter,
      broder: broder ,
    );
  }
}
