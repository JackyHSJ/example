import 'package:flutter/material.dart';
import 'package:frechat/widgets/shared/buttons/base_button.dart';

class IconBaseButton extends BaseButton{

  final Widget? iconWidget;
  IconBaseButton({
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
    this.iconWidget,
  });

  Widget buildIconButton({required Function() onTap}) {
    return buildButton(
      child: Container(child: iconWidget),
      onTap: () {
        onTap();
      },
    );
  }
}
