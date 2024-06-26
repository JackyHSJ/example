import 'package:flutter/material.dart';

///by Benson
class ColorBox extends StatelessWidget {
  final Text? text;
  //final double? width;
  final double height;
  final double radius;
  final LinearGradient? linearGradient;
  final Widget? icon;

  const ColorBox({
    super.key,
    required this.text,
    //this.width,
    required this.height,
    this.radius = 0.0,
    this.linearGradient,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return text == null
        ? const SizedBox()
        : FittedBox(
            child: Container(
              //width: width,
              height: height,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(radius),
                //border: Border.all(width: 0),//框線
                gradient: linearGradient,
              ),
              child: Padding(
                //沒有icon時左右對稱
                padding: icon == null ? const EdgeInsets.fromLTRB(6, 0, 6, 2) : const EdgeInsets.fromLTRB(3, 0, 6, 0),
                child: Row(
                  children: [
                    if (icon != null) icon!,
                    if (text != null)
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: text!,
                      ),
                  ],
                ),
              ),
            ),
          );
  }
}
