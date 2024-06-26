import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme/original/app_colors.dart';

class MainTextField extends StatefulWidget {
  const MainTextField(
      {Key? key,
      required this.hintText,
      this.hintColor,
      this.isSecure = false,
      this.prefixIcon,
      this.onChanged,
      this.onTap,
      this.enabledColor,
      this.focusedColor,
      this.initColor,
      this.keyboardType,
      required this.controller,
      this.contentPaddingRight = 0,
      this.contentPaddingTop = 20,
      this.contentPaddingBottom = 0,
      this.contentPaddingLeft = 20,
      this.textFieldHeight,
      this.bLimitDecimalLength = false,
      this.bPasswordFormatter = false,
      this.inputFormatters = const [],
      this.vertical = 5,
      this.suffixIcon,
      this.enabled,
      this.backgroundColor,
      this.radius = 5,
      this.borderEnable = true,
      this.enableMultiLines = false,
      this.fontSize,
      this.errorText,
      this.fontColor,
      this.fontWeight,
      this.maxLength = null,
      this.focusNode,
      this.hintStyle,
      this.counterText = '',
      this.textAlign = TextAlign.start,
      this.borderColor = AppColors.dividerGrey})
      : super(key: key);
  final String hintText;
  final Color? hintColor;
  final bool isSecure;
  final Widget? prefixIcon;
  final TextEditingController controller;
  final ValueChanged<String>? onChanged;
  final GestureTapCallback? onTap;
  final TextInputType? keyboardType;
  final double contentPaddingRight;
  final double contentPaddingTop;
  final double contentPaddingBottom;
  final double contentPaddingLeft;
  final double vertical;
  final double radius;
  final TextAlign textAlign;
  final double? fontSize;
  final bool borderEnable;
  final bool enableMultiLines;
  final double? textFieldHeight;
  final String? errorText;
  final String? counterText;
  final TextStyle? hintStyle;

  /// 國家地區輸入
  final Widget? suffixIcon;
  final bool? enabled;

  ///MARK: 小數點限制兩位
  final bool bLimitDecimalLength;

  ///MARK: 密碼輸入資訊限制
  final bool bPasswordFormatter;

  ///MARK: 自定義 在前兩者限制為false啟用
  final List<TextInputFormatter> inputFormatters;

  ///控制不同狀態下的框限顏色
  final Color? enabledColor; //可用狀態
  final Color? focusedColor; //點選中
  final Color? initColor; //初始化
  final Color? fontColor;
  final Color? backgroundColor;
  final FontWeight? fontWeight;
  final int? maxLength;
  final FocusNode? focusNode;

  final Color borderColor;
  @override
  State<MainTextField> createState() => _MainTextFieldState();
}

class _MainTextFieldState extends State<MainTextField> {
  bool isPasswordVisible = true;

  @override
  Widget build(BuildContext context) {
    return Container(alignment: Alignment.center, height: widget.textFieldHeight, margin: EdgeInsets.symmetric(vertical: widget.vertical), child: _buildEdit());
  }

  Widget _buildEdit() {
    Color textFieldColor = Colors.grey;
    return TextField(
        focusNode: widget.focusNode,
        enabled: widget.enabled,
        controller: widget.controller,
        inputFormatters: widget.bLimitDecimalLength
            ? [
                // NumLengthInputFormatter(decimalLength: 2),
                FilteringTextInputFormatter.allow(RegExp(r"[\d.]")),
              ] // 小數點限制兩位 整數預設99位
            : widget.bPasswordFormatter //英文+數字，且不能超過32個字元 remove white space
                ? [
                    FilteringTextInputFormatter.deny(RegExp(r' ')),
                    FilteringTextInputFormatter.allow(RegExp(r"[a-zA-Z\d]")),
                    LengthLimitingTextInputFormatter(32),
                  ]
                : widget.inputFormatters,
        obscureText: widget.isSecure && isPasswordVisible,
        keyboardType: widget.keyboardType ?? TextInputType.text,
        textInputAction: TextInputAction.next,
        textAlign: widget.textAlign,
        textAlignVertical: TextAlignVertical.center,
        onChanged: widget.onChanged,
        onTap: widget.onTap,
        maxLines: (widget.enableMultiLines) ? 50 : 1,
        maxLength: widget.maxLength,

        /// 游標顏色
        cursorColor: AppColors.textBlack,
        style: TextStyle(color: widget.fontColor, fontSize: widget.fontSize, fontWeight: widget.fontWeight),
        decoration: InputDecoration(
            filled: widget.backgroundColor != null,
            fillColor: widget.backgroundColor,
            hintText: widget.hintText,
            errorText: widget.errorText,
            counterText: widget.counterText,
            hintStyle: (widget.hintStyle != null)?widget.hintStyle:TextStyle(fontSize: widget.fontSize, height: 1.1, color: widget.hintColor ?? textFieldColor),
            alignLabelWithHint: true,
            contentPadding: EdgeInsets.only(
                top: widget.contentPaddingTop, left: widget.contentPaddingLeft, right: widget.contentPaddingRight, bottom: widget.contentPaddingBottom),
            disabledBorder: outlineBorder(),
            enabledBorder: outlineBorder(),
            focusedBorder: outlineBorder(),
            border: outlineBorder(),
            suffixIcon: widget.isSecure ? _buildSecureView() : widget.suffixIcon,
            prefixIcon: widget.prefixIcon));
  }

  Widget _buildSecureView() {
    return IconButton(
        icon: Icon(isPasswordVisible ? Icons.visibility_off : Icons.visibility, color: Colors.grey),
        onPressed: () {
          setState(() {
            isPasswordVisible = !isPasswordVisible;
          });
        });
  }

  InputBorder outlineBorder() {
    final Color borderColor = (widget.borderEnable == true) ? widget.borderColor : Colors.transparent;
    return OutlineInputBorder(
      borderSide: BorderSide(width: 1, color: borderColor),
      borderRadius: BorderRadius.circular(widget.radius),
    );
  }
}
