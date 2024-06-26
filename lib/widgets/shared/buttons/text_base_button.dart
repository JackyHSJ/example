import 'package:flutter/material.dart';
import 'package:frechat/widgets/shared/buttons/base_button.dart';
import 'package:flutter_screenutil/src/size_extension.dart';

import '../../constant_value.dart';


enum TextBaseButtonAbreastOrientation {
  horizontal,
  vertical,
}
class TextBaseButton extends BaseButton  {

  final String? text;
  final TextStyle? textStyle;
  String? subText;
  final TextStyle? subTextStyle;
  TextBaseButton({
    super.width,
    super.height,
    super.margin,
    super.padding,
    super.broder,
    super.borderRadius,
    super.boxShadowList,
    super.colorBegin,
    super.colorEnd,
    super.colorAlignmentBegin,
    super.colorAlignmentEnd,
    this.text,
    this.textStyle,
    this.subText,
    this.subTextStyle,
  });

  Widget buildTextButton({required Function() onTap}) {
    return buildButton(
        child: Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _textWidget(),
            ],
          )
        ),
        onTap: () {
          onTap();
        });
  }


  Widget buildTextIconButton({required Widget iconWidget, required Function() onTap}) {
    return buildButton(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          iconWidget,
          SizedBox(width:4.w),
          _textWidget(),
        ],
      ),
      onTap: () {
        onTap();
      },
    );
  }
  Widget _textWidget() {
    TextStyle defaultTextStyle = const TextStyle(fontWeight: FontWeight.w400, fontSize: 14, color: Colors.white);
    return Material(
      type: MaterialType.transparency,
      child: Text(
        text ?? '',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: textStyle ?? defaultTextStyle,
      ),
    );
  }
}
