import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frechat/system/constant/enum.dart';
import 'package:frechat/system/providers.dart';
import 'package:frechat/widgets/theme/app_color_theme.dart';
import 'package:frechat/widgets/theme/app_text_theme.dart';
import 'package:frechat/widgets/theme/original/app_colors.dart';
import 'package:frechat/widgets/theme/app_theme.dart';

//圓角輸入框
class RoundedTextField extends ConsumerStatefulWidget {

  final double radius;
  final double height;
  final String hint;
  final TextStyle? hintTextStyle;
  final TextEditingController? textEditingController;
  final FocusNode? focusNode;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final TextInputType textInputType;
  final Function(String text)? onChange;
  final EdgeInsetsGeometry? margin;
  final bool enableTextField;
  final int? maxLength;
  final Color? borderColor;
  final Color? focusBorderColor;
  final TextAlign? textAlign;
  final Color? fillColor;
  final TextStyle? textStyle;
  final InputBorder? enabledBorder;
  final InputBorder? focusedBorder;
  final InputBorder? disabledBorder;

  const RoundedTextField({
    super.key,
    this.hint = '',
    this.onChange,
    this.hintTextStyle,
    this.radius = 12.0,
    this.height = 44.0,
    this.textEditingController,
    this.focusNode,
    this.prefixIcon,
    this.suffixIcon,
    this.textInputType = TextInputType.number,
    this.margin = const EdgeInsets.only(left: 24, right: 24),
    this.enableTextField = true,
    this.maxLength,
    this.borderColor,
    this.focusBorderColor,
    this.textAlign,
    this.fillColor,
    this.textStyle,
    this.enabledBorder,
    this.focusedBorder,
    this.disabledBorder,
  });



  @override
  ConsumerState<RoundedTextField> createState() => _RoundedTextFieldState();
}

class _RoundedTextFieldState extends ConsumerState<RoundedTextField> {
  bool get enableTextField => widget.enableTextField;
  late AppTheme theme;
  late AppColorTheme appColorTheme;
  late AppTextTheme appTextTheme;
  Color get borderColor => widget.borderColor ?? AppColors.mainLightGrey;
  Color get focusBorderColor => widget.focusBorderColor ?? AppColors.mainLightGrey;
  TextAlign get textAlign => widget.textAlign ?? TextAlign.left;


  @override
  Widget build(BuildContext context) {
    final hasFocus = widget.focusNode?.hasFocus ?? false;
    theme = ref.watch(userInfoProvider).theme ?? AppTheme(themeType: AppThemeType.original);
    appColorTheme = theme.getAppColorTheme;
    appTextTheme = theme.getAppTextTheme;

    return Container(
      margin: widget.margin, //const EdgeInsets.only(left: 24, right: 24),
      padding: const EdgeInsets.all(1),
      height: widget.height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(widget.radius),
        color: (hasFocus) ? focusBorderColor : borderColor,
      ),
      child: TextField(
        enabled: enableTextField,
        textAlignVertical: TextAlignVertical.center,
        controller: widget.textEditingController,
        focusNode: widget.focusNode,
        keyboardType: widget.textInputType,
        maxLength: widget.maxLength,
        style: (widget.textStyle != null)?widget.textStyle:appTextTheme.inputFieldTextStyle,
        textAlign: textAlign,
        decoration: InputDecoration(
          counterText: '',
          contentPadding: const EdgeInsets.symmetric(horizontal: 12.0),
          focusedBorder: (widget.focusedBorder!= null)?widget.focusedBorder:OutlineInputBorder(
            borderRadius: BorderRadius.circular(widget.radius),
            borderSide: BorderSide.none,
          ),
          enabledBorder: (widget.enabledBorder!= null)?widget.enabledBorder:OutlineInputBorder(
            borderRadius: BorderRadius.circular(widget.radius),
            borderSide: BorderSide.none,
          ),
          disabledBorder: (widget.disabledBorder !=null)?widget.disabledBorder:OutlineInputBorder(
            borderRadius: BorderRadius.circular(widget.radius),
            borderSide: BorderSide.none,
          ),
          prefixIcon: widget.prefixIcon,
          suffixIcon: widget.suffixIcon,
          filled: true,
          hintStyle: const TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 14,
            color: AppColors.mainGrey,
          ),
          hintText: widget.hint,
          fillColor: (widget.fillColor!=null)?widget.fillColor:appColorTheme.inputFieldColor
        ),
        onTap: () {
          setState(() {});
        },
        onEditingComplete: () {
          setState(() {
            FocusScope.of(context).requestFocus(FocusNode());
          });
        },
        onChanged: (text) {
          widget.onChange?.call(text);
        },
      ),
    );
  }
}
