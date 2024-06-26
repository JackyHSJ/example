import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frechat/system/constant/enum.dart';
import 'package:frechat/system/providers.dart';
import 'package:frechat/widgets/theme/app_box_decoration_theme.dart';
import 'package:frechat/widgets/theme/app_color_theme.dart';
import 'package:frechat/widgets/theme/app_theme.dart';
import 'package:frechat/widgets/theme/original/app_colors.dart';

class UserInfoViewDataCell extends ConsumerStatefulWidget {

  final String? title;
  final String? text;
  final AppTheme? theme;

  const UserInfoViewDataCell({
    super.key,
    this.title,
    this.text,
    this.theme,
  });

  @override
  ConsumerState<UserInfoViewDataCell> createState() => _UserInfoDataCellState();

}

  class _UserInfoDataCellState extends ConsumerState<UserInfoViewDataCell> {

    String? get title => widget.title ?? '';
    String? get text => widget.text ?? '';

    late AppTheme theme;
    late AppColorTheme appColorTheme;
    late AppBoxDecorationTheme appBoxDecorationTheme;

    @override
    Widget build(BuildContext context) {

      final AppTheme defaultTheme = ref.watch(userInfoProvider).theme ?? AppTheme(themeType: AppThemeType.original);
      theme = widget.theme ?? defaultTheme;
      appColorTheme = theme.getAppColorTheme;
      appBoxDecorationTheme = theme.getAppBoxDecorationTheme;

      return Expanded(
        child: Container(
          width: double.infinity,
          height: 46.h,
          decoration: appBoxDecorationTheme.userInfoViewDataCellBoxDecoration,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(6, 0, 0, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildTitle(),
                _buildDes()
              ],
            ),
          ),
        ),
      );
    }

    Widget _buildTitle() {
      return Text(
        title ?? '',
        style: TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: 10,
          color: appColorTheme.userInfoViewCellPrimaryTextColor
        ),
      );
    }

    Widget _buildDes() {

      if (text == null) {
        return SizedBox();
      }

      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            Text(
              text ?? '',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 12,
                color: appColorTheme.userInfoViewCellSecondaryTextColor
              ),
            ),
          ],
        ),
      );
    }

  }




