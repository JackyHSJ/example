import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frechat/system/constant/enum.dart';
import 'package:frechat/system/providers.dart';
import 'package:frechat/widgets/constant_value.dart';
import 'package:frechat/widgets/shared/app_bar.dart';
import 'package:frechat/widgets/shared/main_scaffold.dart';
import 'package:frechat/widgets/theme/app_theme.dart';
import 'package:frechat/widgets/theme/uidefine.dart';

import '../../../../models/profile/personal_cell_model.dart';

class PersonalReportLaw extends ConsumerStatefulWidget {
  PersonalReportLaw({super.key, required this.model});
  PersonalCellModel model;
  @override
  ConsumerState<PersonalReportLaw> createState() => _PersonalReportLawState();
}

class _PersonalReportLawState extends ConsumerState<PersonalReportLaw> {
  PersonalCellModel get model => widget.model;
  late AppTheme _theme;

  @override
  Widget build(BuildContext context) {
    _theme = ref.watch(userInfoProvider).theme ?? AppTheme(themeType: AppThemeType.original);

    final double paddingHeight = UIDefine.getAppBarHeight() + UIDefine.getStatusBarHeight();
    return MainScaffold(
      padding: EdgeInsets.only(top: paddingHeight, bottom: WidgetValue.bottomPadding, left: WidgetValue.horizontalPadding, right: WidgetValue.horizontalPadding),
      isFullScreen: true,
      needSingleScroll: false,
      appBar: MainAppBar(theme:_theme,title: model.title),
      child: SingleChildScrollView(
        child: Column(
          children: model.remark!.map((law) {
            return Text(law, style: TextStyle(fontSize: 16),);
          }).toList(),
        ),
      ),
    );
  }
}