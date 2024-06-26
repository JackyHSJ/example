
import 'package:flutter/cupertino.dart';
import 'package:frechat/widgets/shared/buttons/base_button.dart';

class CustomBaseButton extends BaseButton {
  final Widget? customWidget;

  CustomBaseButton({
    this.customWidget,
  });

  Widget buildCustomButton({required Function() onTap}) {
    return buildBaseButton(child: Container(child: customWidget,), onTap: onTap);
  }
}