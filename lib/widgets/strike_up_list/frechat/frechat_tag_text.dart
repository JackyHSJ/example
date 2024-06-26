import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frechat/system/constant/enum.dart';
import 'package:frechat/system/providers.dart';
import 'package:frechat/widgets/theme/app_box_decoration_theme.dart';
import 'package:frechat/widgets/theme/app_text_theme.dart';
import 'package:frechat/widgets/theme/app_theme.dart';

//
// 標籤用
//

class FrechatTagText extends ConsumerStatefulWidget {

  final String text;

  const FrechatTagText({
    super.key,
    required this.text
  });

  @override
  ConsumerState<FrechatTagText> createState() => _FrechatTagTextState();
}

class _FrechatTagTextState extends ConsumerState<FrechatTagText> {

  String get text => widget.text;

  late AppTheme theme;
  late AppBoxDecorationTheme appBoxDecoration;
  late AppTextTheme appTextTheme;

  @override
  Widget build(BuildContext context) {

    return Text(text, style: TextStyle(
        fontWeight: FontWeight.w400,
        fontSize: 14,
        color: Color(0xff222222)
    ));
  }
}