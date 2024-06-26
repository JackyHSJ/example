import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frechat/system/constant/enum.dart';
import 'package:frechat/system/providers.dart';
import 'package:frechat/widgets/constant_value.dart';
import 'package:frechat/widgets/theme/app_color_theme.dart';
import 'package:frechat/widgets/theme/original/app_colors.dart';
import 'package:frechat/widgets/theme/app_linear_gradient_theme.dart';
import 'package:frechat/widgets/theme/app_text_theme.dart';
import 'package:frechat/widgets/theme/app_theme.dart';

import '../buttons/gradient_button.dart';
import '../rounded_textfield.dart';

/// 泛用型選擇對話框
class CheckDialog extends ConsumerStatefulWidget {
  //直接跳這個選擇對話框給使用
  static Future show(
    BuildContext context, {
    bool barrierDismissible = true,

    //標題物件 (圖片)(可以沒有)
    Widget? titleWidget,

    //標題文字 (可以沒有)
    String titleText = '',
    TextStyle titleTextStyle = const TextStyle(
        fontSize: 18.0,
        fontWeight: FontWeight.w600,
        color: AppColors.textFormBlack),

    //中央訊息文字 (required)
    String messageText = '',
    Widget? messageWidget,
    TextStyle? messageTextStyle =
        const TextStyle(fontSize: 14, color: AppColors.textFormBlack),
    TextAlign? messageTextAlign,
    EdgeInsetsGeometry messagePadding =
        const EdgeInsets.fromLTRB(16, 16, 16, 0),

    //輸入框 (可以沒有)
    bool showInputField = false,
    String inputFieldHintText = 'Input here',
    int inputFieldMaxLength = 12,

    //Buttons setting (Cancel/Confirm)
    bool showCancelButton = false,
    String cancelButtonText = '取消',
    String confirmButtonText = '确定',
    bool isCancelButtonNeedPop = true,
    AppTheme? appTheme,
    Color backgroundColor = Colors.white,
    Color cancelGradientColorBegin = const Color.fromRGBO(249, 226, 231, 1),
    Color confirmGradientColorBegin = const Color.fromRGBO(235, 93, 142, 1),
    Color cancelGradientColorEnd = const Color.fromRGBO(249, 226, 231, 1),
    Color confirmGradientColorEnd = const Color.fromRGBO(240, 138, 191, 1),
    TextStyle cancelButtonTextStyle = const TextStyle(
        fontWeight: FontWeight.w400,
        fontSize: 14,
        color: Color.fromRGBO(236, 97,147, 1)
    ),
    TextStyle confirmButtonTextStyle = const TextStyle(
        fontWeight: FontWeight.w500,
        fontSize: 14,
        color: Colors.white
    ),
    Function()? onCancelPress,
    Function()? onConfirmPress,
    Function(String)? onInputConfirmPress,
  }) async {
    //Use showDialog here.
    await showDialog(
      barrierDismissible: barrierDismissible,
      context: context,
      builder: (BuildContext context) {
        return CheckDialog(
          titleWidget: titleWidget,
          titleText: titleText,
          titleTextStyle: titleTextStyle,
          messageText: messageText,
          messageWidget: messageWidget,
          messageTextStyle: messageTextStyle,
          messageTextAlign: messageTextAlign,
          messagePadding: messagePadding,
          showInputField: showInputField,
          inputFieldHintText: inputFieldHintText,
          inputFieldMaxLength: inputFieldMaxLength,
          showCancelButton: showCancelButton,
          cancelButtonText: cancelButtonText,
          confirmButtonText: confirmButtonText,
          onCancelPress: onCancelPress,
          isCancelButtonNeedPop: isCancelButtonNeedPop,
          onConfirmPress: onConfirmPress,
          onInputConfirmPress: onInputConfirmPress,
          appTheme: appTheme,
          backgroundColor: backgroundColor,
          cancelGradientColorBegin: cancelGradientColorBegin,
          confirmGradientColorBegin: confirmGradientColorBegin,
          cancelGradientColorEnd: cancelGradientColorEnd,
          confirmGradientColorEnd: confirmGradientColorEnd,
          cancelButtonTextStyle: cancelButtonTextStyle,
          confirmButtonTextStyle: confirmButtonTextStyle,
        );
      },
    );
  }

  //Constructor.
  CheckDialog(
      {
        this.appTheme,
        this.backgroundColor = Colors.white,
        this.cancelButtonTextStyle = const TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: 14,
          color: Color.fromRGBO(236, 97,147, 1)
        ),
        this.cancelGradientColorBegin = const Color.fromRGBO(249, 226, 231, 1),
        this.cancelGradientColorEnd = const Color.fromRGBO(249, 226, 231, 1),
        this.confirmButtonTextStyle = const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 14,
            color: Colors.white
        ),
        this.confirmGradientColorBegin = const Color.fromRGBO(235, 93, 142, 1),
        this.confirmGradientColorEnd = const Color.fromRGBO(240, 138, 191, 1),
      //標題物件 (圖片)(可以沒有)
      this.titleWidget,

      //標題文字 (可以沒有)
      this.titleText = '',
      this.titleTextStyle = const TextStyle(
          fontSize: 18.0,
          fontWeight: FontWeight.w600,
          color: AppColors.textFormBlack),

      //中央訊息文字 (required)
      this.messageText = '',
      this.messageTextStyle,
      this.messageTextAlign,
      this.messagePadding = const EdgeInsets.fromLTRB(16, 16, 16, 0),

      //輸入框 (可以沒有)
      this.showInputField = false,
      this.inputFieldHintText = 'Input here',
      this.inputFieldMaxLength = 12,

      //Buttons setting (Cancel/Confirm)
      this.showCancelButton = false,
      this.cancelButtonText = 'Cancel',
      this.confirmButtonText = 'Confirm',
      this.onCancelPress,
      this.onConfirmPress,
      this.onInputConfirmPress,
      this.messageWidget,
      this.isCancelButtonNeedPop = true,
      Key? key})
      : super(key: key);

  //標題物件 (圖片)(可以沒有)
  final Widget? titleWidget;

  //標題文字 (可以沒有)
  final String titleText;
  final TextStyle titleTextStyle;

  //中央訊息文字 (required)
  final String messageText;
  final TextStyle? messageTextStyle;
  final TextAlign? messageTextAlign;
  final EdgeInsetsGeometry? messagePadding;

  //輸入框 (可以沒有)
  final bool showInputField;
  final String inputFieldHintText;
  final int inputFieldMaxLength;

  //Buttons setting (Cancel/Confirm)
  final bool showCancelButton;
  final String cancelButtonText;
  final String confirmButtonText;
  final bool isCancelButtonNeedPop;

  final Widget? messageWidget;
  final Function()? onCancelPress;
  final Function()? onConfirmPress;
  final Function(String)? onInputConfirmPress;
  final AppTheme? appTheme;
  final Color backgroundColor;
  final TextStyle cancelButtonTextStyle;
  final TextStyle confirmButtonTextStyle;
  final Color cancelGradientColorBegin;
  final Color cancelGradientColorEnd;
  final Color confirmGradientColorBegin;
  final Color confirmGradientColorEnd;

  @override
  ConsumerState<CheckDialog> createState() => _CheckDialogState();
}

class _CheckDialogState extends ConsumerState<CheckDialog> {
  final TextEditingController textEditController = TextEditingController();


  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Material(
                color: Colors.transparent,
                child: Container(
                  decoration: BoxDecoration(
                    color: (widget.appTheme != null)? widget.appTheme!.getAppColorTheme.dialogBackgroundColor : widget.backgroundColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      children: [
                        _titleWidget(),

                        Visibility(
                            visible: widget.titleText.isNotEmpty,
                            child: _titleText()),

                        SizedBox(height: WidgetValue.verticalPadding,),

                        Visibility(
                            visible: widget.messageText.isNotEmpty,
                            child: _messageText()),

                        _messageWidget(),

                        Visibility(
                            visible: widget.showInputField,
                            child: _inputField()),

                        SizedBox(height: WidgetValue.verticalPadding,),

                        _selectionButtons(),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _titleWidget() {
    return widget.titleWidget == null ? const SizedBox() : widget.titleWidget!;
  }

  Widget _titleText() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
      child: Text(widget.titleText, style: widget.titleTextStyle),
    );
  }

  Widget _messageText() {
    return Padding(
      padding: widget.messagePadding ?? EdgeInsets.zero,
      child: Text(
        widget.messageText,
        textAlign: widget.messageTextAlign ?? TextAlign.center,
        style: widget.messageTextStyle,
      ),
    );
  }

  Widget _messageWidget() {
    return widget.messageWidget == null ? const SizedBox() : widget.messageWidget!;
  }

  Widget _inputField() {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: RoundedTextField(
        textEditingController: textEditController,
        textInputType: TextInputType.text,
        suffixIcon: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
                '${textEditController.text.length}/${widget.inputFieldMaxLength}',
                style: const TextStyle(color: AppColors.mainGrey),
            ),
          ],
        ),
        hint: widget.inputFieldHintText,
        maxLength: widget.inputFieldMaxLength,
        hintTextStyle: const TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: 14,
          color: AppColors.mainGrey,
        ),
        onChange: (v){
          setState(() {});
        },
      ),
    );
  }

  Widget _selectionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        //Cancel button (optional)
        Visibility(
          visible: widget.showCancelButton,
          child: Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(6, 20, 6, 0),
              child: GradientButton(
                text: widget.cancelButtonText,
                textStyle: (widget.appTheme!=null)?widget.appTheme!.getAppTextTheme.buttonSecondaryTextStyle:widget.cancelButtonTextStyle,
                radius: 24,
                gradientColorBegin: (widget.appTheme != null)?widget.appTheme!.getAppLinearGradientTheme.buttonSecondaryColor.colors[0]:widget.cancelGradientColorBegin!,
                gradientColorEnd: (widget.appTheme != null)?widget.appTheme!.getAppLinearGradientTheme.buttonSecondaryColor.colors[1]:widget.cancelGradientColorEnd!,
                height: 44,
                onPressed: () {
                  if(widget.isCancelButtonNeedPop){
                    Navigator.pop(context);
                  }
                  widget.onCancelPress?.call();
                },
              ),
            ),
          ),
        ),

        //Confirm button (required)
        Expanded(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(6, 20, 6, 0),
            child: GradientButton(
              text: widget.confirmButtonText,
              textStyle: (widget.appTheme != null)?widget.appTheme!.getAppTextTheme.buttonPrimaryTextStyle:widget.confirmButtonTextStyle,
              radius: 24,
              gradientColorBegin: (widget.appTheme != null)?widget.appTheme!.getAppLinearGradientTheme.buttonPrimaryColor.colors[0]:widget.confirmGradientColorBegin!,
              gradientColorEnd: (widget.appTheme != null)?widget.appTheme!.getAppLinearGradientTheme.buttonPrimaryColor.colors[1]:widget.confirmGradientColorEnd!,
              height: 44,
              onPressed: () async {
                Navigator.pop(context);
                widget.onConfirmPress?.call();
                widget.onInputConfirmPress?.call(textEditController.text);
              },
            ),
          ),
        ),
      ],
    );
  }
}
