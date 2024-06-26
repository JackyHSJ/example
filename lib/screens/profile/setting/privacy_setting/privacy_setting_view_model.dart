

import 'package:flutter/cupertino.dart';
import 'package:frechat/system/app_config/app_config.dart';
import 'package:frechat/system/base_view_model.dart';
import 'package:frechat/system/constant/enum.dart';
import 'package:frechat/system/provider/user_info_provider.dart';
import 'package:frechat/widgets/shared/picker.dart';
import 'package:frechat/widgets/theme/app_theme.dart';

class PrivacyViewModel {
  List<AppThemeType?> typeList = [
    null,
    AppThemeType.catVersion
  ];

  init() {

  }

  dispose() {

  }

  void selectTheme(int selectIndex, UserNotifier userUtil) {
    switch(selectIndex) {
      case 0:
        final appTheme = AppConfig.getDefaultAppTheme();
        userUtil.setDataToPrefs(theme: appTheme.themeType.name);
        break;
      case 1:
        userUtil.setDataToPrefs(theme: AppThemeType.catVersion.name);
        break;
      default:
        break;
    }
  }

  String getPickerItemTitle(AppThemeType? appThemeType) {
    switch (appThemeType) {
      case null:
        return '预设';
      case AppThemeType.catVersion:
        return '猫版';
      default:
        return '预设';
    }
  }
}