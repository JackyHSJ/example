
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frechat/system/constant/enum.dart';
import 'package:frechat/system/providers.dart';
import 'package:frechat/widgets/constant_value.dart';
import 'package:frechat/widgets/shared/img_util.dart';
import 'package:frechat/widgets/theme/app_box_decoration_theme.dart';
import 'package:frechat/widgets/theme/app_color_theme.dart';
import 'package:frechat/widgets/theme/original/app_colors.dart';
import 'package:frechat/widgets/theme/app_image_theme.dart';
import 'package:frechat/widgets/theme/app_theme.dart';

import '../../../models/profile/personal_online_service_model.dart';

class PersonalOnlineServiceCell extends ConsumerStatefulWidget {

  final PersonalOnlineServiceModel model;

  PersonalOnlineServiceCell({
    super.key,
    required this.model
  });

  @override
  ConsumerState<PersonalOnlineServiceCell> createState() => _PersonalOnlineServiceCellState();
}

class _PersonalOnlineServiceCellState extends ConsumerState<PersonalOnlineServiceCell> {

  PersonalOnlineServiceModel get model => widget.model;
  bool isDesExpand = false;
  late AppTheme _theme;
  late AppBoxDecorationTheme _appBoxDecorationTheme;
  late AppColorTheme _appColorTheme;
  late AppImageTheme _appImageTheme;

  @override
  Widget build(BuildContext context) {
    _theme = ref.watch(userInfoProvider).theme ?? AppTheme(themeType: AppThemeType.original);
    _appBoxDecorationTheme = _theme.getAppBoxDecorationTheme;
    _appColorTheme = _theme.getAppColorTheme;
    _appImageTheme = _theme.getAppImageTheme;
    final bool isHaveDes = model.des != null;

    return (isHaveDes) ? Container(
      decoration: _appBoxDecorationTheme.customServiceCellBoxDecoration,
      padding: EdgeInsets.symmetric(horizontal: WidgetValue.horizontalPadding, vertical: WidgetValue.verticalPadding * 1.5),
      child: InkWell(
        onTap: () {
          isDesExpand = !isDesExpand;
          setState((){});
        },
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildTitle(),
                _buildArrow()
              ],
            ),
            const SizedBox(height: 4),
            Visibility(
              visible: model.des != null && isDesExpand,
              child: _buildDes(),
            ),
          ],
        ),
      ),
    ) : Container(
      decoration: _appBoxDecorationTheme.customServiceCellBoxDecoration,
      padding: EdgeInsets.symmetric(horizontal: WidgetValue.horizontalPadding, vertical: WidgetValue.verticalPadding * 1.5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildTitle(),
          _buildRightArrow()
        ],
      ),
    );
  }

  Widget _buildTitle() {
    return Text(
      model.title,
      style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w700,
          color: _appColorTheme.customServicePrimaryTextColor
      ),
    );
  }

  Widget _buildDes() {
    return Text(
      model.des ?? '',
      style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: _appColorTheme.customServiceSecondaryTextColor
      ),
    );
  }

  _buildArrow() {
    final String iconData = isDesExpand ? _appImageTheme.iconKBArrowUp : _appImageTheme.iconKBArrowDown;
    return ImgUtil.buildFromImgPath(iconData, size: 24);
  }

  _buildRightArrow() {
    final AppTheme theme = ref.watch(userInfoProvider).theme ?? AppTheme(themeType: AppThemeType.original);
    final AppImageTheme appImageTheme = theme.getAppImageTheme;
    return ImgUtil.buildFromImgPath(appImageTheme.iconRightArrow, size: 24);
  }
}