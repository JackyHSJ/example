
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frechat/screens/profile/setting/notification/personal_setting_notification_view_model.dart';
import 'package:frechat/system/constant/enum.dart';
import 'package:frechat/system/providers.dart';
import 'package:frechat/widgets/constant_value.dart';
import 'package:frechat/widgets/profile/cell/personal_setting_notification_cell.dart';
import 'package:frechat/widgets/shared/app_bar.dart';
import 'package:frechat/widgets/shared/list/main_list.dart';
import 'package:frechat/widgets/shared/main_scaffold.dart';
import 'package:frechat/widgets/theme/app_theme.dart';
import 'package:frechat/widgets/theme/original/app_colors.dart';
import 'package:frechat/widgets/theme/uidefine.dart';

class PersonalSettingNotification extends ConsumerStatefulWidget {
  const PersonalSettingNotification({super.key});

  @override
  ConsumerState<PersonalSettingNotification> createState() => _PersonalSettingNotificationState();
}

class _PersonalSettingNotificationState extends ConsumerState<PersonalSettingNotification> {
  late PersonalSettingNotificationViewModel viewModel;
  late AppTheme _theme;

  @override
  void initState() {
    viewModel = PersonalSettingNotificationViewModel();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _theme = ref.watch(userInfoProvider).theme ?? AppTheme(themeType: AppThemeType.original);
    final double paddingHeight = UIDefine.getAppBarHeight() + UIDefine.getStatusBarHeight();
    return MainScaffold(
      isFullScreen: true,
      padding: EdgeInsets.only(top: paddingHeight, bottom: WidgetValue.bottomPadding, left: WidgetValue.horizontalPadding, right: WidgetValue.horizontalPadding),
      appBar: MainAppBar(theme:_theme,title: '消息通知'),
      child: CustomList.separatedList(
        separator: SizedBox(height: WidgetValue.separateHeight * 5),
        childrenNum: viewModel.cellList.length,
        children: (context, index) {
          return PersonalSettingNotificationCell(model: viewModel.cellList[index]);
        }
      ),
    );
  }
}