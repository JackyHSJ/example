


import 'package:flutter/cupertino.dart';
import 'package:frechat/screens/profile/certification/personal_certification.dart';
import 'package:frechat/system/base_view_model.dart';
import 'package:frechat/widgets/shared/dialog/comm_dialog.dart';
import 'package:frechat/widgets/theme/app_theme.dart';

class DialogUtil {

  // 真人認證彈窗
  static Future popupRealPersonDialog({required AppTheme theme,required BuildContext context,required String description}) async {
    CommDialog(context).build(
      theme: theme,
      title: '真人/实名认证',
      contentDes: description,
      leftBtnTitle: '考虑一下',
      rightBtnTitle: '立即认证',
      leftAction: () {
        BaseViewModel.popPage(context);
      },
      rightAction: () {
        BaseViewModel.popPage(context);
        BaseViewModel.pushPage(context, const PersonalCertification());
      },
    );
  }
}