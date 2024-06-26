import 'package:flutter/material.dart';
import 'package:frechat/system/base_view_model.dart';
import 'package:frechat/system/constant/enum.dart';
import 'package:frechat/widgets/shared/bottom_sheet/base_bottom_sheet.dart';
import 'package:frechat/widgets/shared/bottom_sheet/recharge/calling_recharge_sheet.dart';
import 'package:frechat/widgets/shared/bottom_sheet/recharge/recharge_bottom_sheet.dart';
import 'package:frechat/widgets/shared/dialog/calling_recharge_dialog.dart';
import 'package:frechat/widgets/shared/dialog/recharge_dialog.dart';
import 'package:frechat/widgets/theme/app_theme.dart';

class RechargeUtil {

  static bool rechargeBottomSheet = false;

  // 首充彈窗
  static showFirstTimeRechargeDialog(String msg) {
    final BuildContext currentContext = BaseViewModel.getGlobalContext();
    showDialog(
      context: currentContext,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return RechargeDialog(msg: msg);
      },
    ).then((value) {
      print('首充彈窗: $value');
    });
  }

  // 儲值彈窗
  static showRechargeBottomSheet({AppTheme? theme}) {
    final BuildContext currentContext = BaseViewModel.getGlobalContext();
    theme = theme ?? AppTheme(themeType: AppThemeType.original);
    RechargeBottomSheet.show(context: currentContext,theme:theme);
  }
}
