import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frechat/screens/profile/report/personal_report_view_model.dart';
import 'package:frechat/system/constant/enum.dart';
import 'package:frechat/system/providers.dart';
import 'package:frechat/widgets/shared/app_bar.dart';
import 'package:frechat/widgets/theme/app_theme.dart';

import '../../../../widgets/constant_value.dart';
import '../../../../widgets/profile/cell/personal_report_cell.dart';
import '../../../../widgets/shared/divider.dart';
import '../../../../widgets/shared/list/main_list.dart';
import '../../../../widgets/shared/main_scaffold.dart';
import '../../../../widgets/theme/original/app_colors.dart';
import '../../../../widgets/theme/uidefine.dart';

class PersonalReportDetail extends ConsumerStatefulWidget {
  PersonalReportDetail({super.key, required this.viewModel});
  PersonalReportViewModel viewModel;

  @override
  ConsumerState<PersonalReportDetail> createState() => _PersonalReportDetailState();
}

class _PersonalReportDetailState extends ConsumerState<PersonalReportDetail> {
  PersonalReportViewModel get viewModel => widget.viewModel;
  final double paddingHeight = UIDefine.getAppBarHeight() + UIDefine.getStatusBarHeight();
  late AppTheme _theme;

  @override
  Widget build(BuildContext context) {
    _theme = ref.watch(userInfoProvider).theme ?? AppTheme(themeType: AppThemeType.original);

    return MainScaffold(
      isFullScreen: true,
      padding: EdgeInsets.only(top: paddingHeight, bottom: WidgetValue.bottomPadding, left: WidgetValue.horizontalPadding, right: WidgetValue.horizontalPadding),
      appBar: MainAppBar(theme:_theme,title: '禁網封禁'),
      child: Column(
        children: [
          _buildLastUpdateDes(title: '最近更新: 2023-07-10 01:00:00'),
          SizedBox(height: WidgetValue.verticalPadding),
          _buildReoprtList()
        ],
      ),
    );
  }

  _buildLastUpdateDes({required String title}) {
    return Text(title, style: TextStyle(color: AppColors.textGrey, fontWeight: FontWeight.w600, fontSize: 14));
  }

  _buildReoprtList() {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(WidgetValue.btnRadius/2),
          border: Border.all(width: 2, color: AppColors.dividerGrey),
          color: AppColors.whiteBackGround
      ),
      child: CustomList.separatedList(
          separator: MainDivider(color: AppColors.dividerGrey, weight: 2),
          physics: const NeverScrollableScrollPhysics(),
          childrenNum: viewModel.reportUserList.length,
          children: (context, index) {
            return PersonalReportCell(model: viewModel.reportUserList[index]);
          }
      ),
    );
  }
}