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

class TagText extends ConsumerStatefulWidget {

  final String text;

  const TagText({
    super.key,
    required this.text
  });

  @override
  ConsumerState<TagText> createState() => _TagTextState();
}

class _TagTextState extends ConsumerState<TagText> {

  String get text => widget.text;

  late AppTheme theme;
  late AppBoxDecorationTheme appBoxDecoration;
  late AppTextTheme appTextTheme;

  @override
  Widget build(BuildContext context) {

    theme = ref.watch(userInfoProvider).theme ?? AppTheme(themeType: AppThemeType.original);
    appBoxDecoration = theme.getAppBoxDecorationTheme;
    appTextTheme = theme.getAppTextTheme;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 1.h),
      margin: EdgeInsets.only(right: 4.w),
      decoration: appBoxDecoration.tagTextBoxDecoration,
      child: Text(
        text,
        style: appTextTheme.tagTextTextStyle,
      ),
    );
  }
}