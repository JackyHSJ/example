

import 'package:frechat/system/constant/enum.dart';
import 'package:frechat/widgets/theme/app_theme.dart';

extension StringExtension on String {
  String toBlock() {
    if (length <= 2) {
      return this;
    } else {
      return '${this[0]}${'*' * (length - 2)}${this[length - 1]}';
    }
  }

  num toNum() {
    try {
      return num.parse(this);
    } catch (_) {
      return 0;
    }
  }

  AppTheme? toAppTheme() {
    switch (this) {
      case 'catVersion':
        return AppTheme(themeType: AppThemeType.catVersion);
      case 'original':
        return AppTheme(themeType: AppThemeType.original);
      case 'dogVersion':
        return AppTheme(themeType: AppThemeType.dogVersion);
      case 'yueyuan':
        return AppTheme(themeType: AppThemeType.yueyuan);
      default:
        return null;
    }
  }
}
