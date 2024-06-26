import 'package:flutter/material.dart';
import 'package:frechat/widgets/theme/original/app_colors.dart';

class GradientText extends StatefulWidget {

  final String text;
  final bool? italic;

  const GradientText({
    super.key,
    required this.text,
    this.italic,
  });

  @override
  _GradientTextState createState() => _GradientTextState();
}

class _GradientTextState extends State<GradientText> {

  String get text => widget.text;
  bool get italic => widget.italic ?? false;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (Rect bounds) {
        return const LinearGradient(
          colors: [AppColors.mainOrange, AppColors.mainYellow],
        ).createShader(bounds);
      },
      child: Text(
        text,
        style: TextStyle(
          color: Colors.white,
          fontStyle: italic ? FontStyle.italic : FontStyle.normal,
          fontSize: 14.0,
          fontWeight: FontWeight.w600,
          height: 1,
        ),
      ),
    );
  }
}
