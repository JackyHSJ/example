import 'package:flutter/cupertino.dart';
import 'package:frechat/widgets/shared/buttons/base_button.dart';


enum LayoutBaseButtonOrientation {
  horizontal,
  vertical,
}
class LayoutBaseButton extends BaseButton {

  final Widget? title;
  final Widget? leading;
  final Widget? ending;
  final Widget? bottom;
  final Widget? header;
  LayoutBaseButton({
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
    this.title,
    this.leading,
    this.ending,
    this.bottom,
    this.header
  });

  Widget buildLayoutButton({required Function() onTap}) {
    return buildButton(
      child: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            leading ?? Container(),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                header ?? Container(),
                title ?? Container(),
                bottom ?? Container(),
              ],
            ),
            ending ?? Container(),
          ],
        ),
      ),
      onTap: () {
        onTap();
      },
    );
  }
}