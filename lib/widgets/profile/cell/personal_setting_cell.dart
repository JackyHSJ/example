import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frechat/system/app_config/app_config.dart';
import 'package:frechat/system/constant/enum.dart';
import 'package:frechat/system/extension/string.dart';
import 'package:frechat/system/providers.dart';
import 'package:frechat/widgets/shared/img_util.dart';
import 'package:frechat/widgets/theme/app_text_theme.dart';
import 'package:frechat/widgets/theme/original/app_colors.dart';
import 'package:frechat/widgets/theme/app_image_theme.dart';
import 'package:frechat/widgets/theme/app_theme.dart';

import '../../../models/profile/personal_setting_model.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PersonalSettingCell extends ConsumerStatefulWidget {
  PersonalSettingCell({required this.model});
  PersonalSettingModel model;

  @override
  ConsumerState<PersonalSettingCell> createState() =>
      _PersonalSettingCellState();
}

class _PersonalSettingCellState extends ConsumerState<PersonalSettingCell> {

  late AppTheme theme;
  late AppImageTheme appImageTheme;
  late AppTextTheme appTextTheme;

  PersonalSettingModel get model => widget.model;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AppTheme theme = ref.watch(userInfoProvider).theme ?? AppTheme(themeType: AppThemeType.original);
    appImageTheme = theme.getAppImageTheme;
    appTextTheme = theme.getAppTextTheme;
    String title = model.title;

    if (title == "账号注销协议") {
      title = '${AppConfig.appName}账号注销协议';
    }

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 14.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: appTextTheme.cellListMainTextStyle),
              Offstage(
                offstage: model.des == null,
                child: Text(model.des ?? '', style: appTextTheme.cellListSubTextStyle),
              ),
            ],
          ),
          Offstage(
            offstage: !model.enableArrow,
            child: ImgUtil.buildFromImgPath(appImageTheme.iconRightArrow, size: 24.w),
          )
        ],
      ),
    );
  }
}
