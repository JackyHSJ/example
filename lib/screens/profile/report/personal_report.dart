import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frechat/screens/profile/report/law/personal_report_law.dart';
import 'package:frechat/screens/profile/report/personal_report_view_model.dart';
import 'package:frechat/system/constant/enum.dart';
import 'package:frechat/system/providers.dart';
import 'package:frechat/widgets/profile/cell/personal_report_cell.dart';
import 'package:frechat/widgets/shared/app_bar.dart';
import 'package:frechat/widgets/shared/list/grid_list.dart';
import 'package:frechat/widgets/shared/main_scaffold.dart';
import 'package:frechat/widgets/shared/main_swiper.dart';
import 'package:frechat/widgets/theme/app_theme.dart';
import 'package:frechat/widgets/theme/original/app_colors.dart';

import '../../../system/base_view_model.dart';
import '../../../widgets/constant_value.dart';
import '../../../widgets/profile/cell/personal_cell.dart';
import '../../../widgets/shared/divider.dart';
import '../../../widgets/shared/list/main_list.dart';
import '../../../widgets/theme/uidefine.dart';
import 'detail/personal_report_detail.dart';

class PersonalReport extends ConsumerStatefulWidget {
  const PersonalReport({super.key});

  @override
  ConsumerState<PersonalReport> createState() => _PersonalReportState();
}

class _PersonalReportState extends ConsumerState<PersonalReport> {
  late PersonalReportViewModel viewModel;
  late AppTheme _theme;

  @override
  void initState() {
    viewModel = PersonalReportViewModel();
    viewModel.init();
    super.initState();
  }

  @override
  void dispose() {
    viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _theme = ref.watch(userInfoProvider).theme ?? AppTheme(themeType: AppThemeType.original);
    final double paddingHeight = UIDefine.getAppBarHeight() + UIDefine.getStatusBarHeight();
    return MainScaffold(
      isFullScreen: true,
      padding: EdgeInsets.only(top: paddingHeight, bottom: WidgetValue.bottomPadding, left: WidgetValue.horizontalPadding, right: WidgetValue.horizontalPadding),
      appBar: MainAppBar(theme:_theme,title: '淨網行動'),
      child: Column(
        children: [
          _buildGuardDes(),
          _buildImg(),
          _buildLastUpdateDes(title1: '近90天淨網數據', title2: '最近更新: 2023-07-01 00:00'),
          SizedBox(height: WidgetValue.verticalPadding),
          _buildReportInfoGrid(),
          _buildSwiperCard(),
          _buildUserLawList(),
          _buildLastUpdateDes(title1: '淨網封禁', title2: '最近更新: 2023-07-01 00:00'),
          _buildReoprtList(),
          SizedBox(height: WidgetValue.verticalPadding),
          _buildMoreReoprtListBtn()
        ],
      ),
    );
  }

  _buildGuardDes() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.shield, color: AppColors.mainGreen, size: 20,),
        Text('7*24小時AI+人工檢測', style: TextStyle(color: AppColors.mainGreen, fontWeight: FontWeight.w600))
      ],
    );
  }

  _buildLastUpdateDes({required String title1, required String title2}) {
    return Column(
      children: [
        Text(title1, style: TextStyle(color: AppColors.textBlack, fontWeight: FontWeight.w600, fontSize: 18)),
        Text(title2, style: TextStyle(color: AppColors.textGrey, fontWeight: FontWeight.w600))
      ],
    );
  }

  _buildImg() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: WidgetValue.verticalPadding),
      child: Image.asset('assets/profile/profile_report_img.png'),
    );
  }

  _buildReportInfoGrid() {
    return MainGridView(
      childAspectRatio: 2.5,
      shrinkWrapEnable: true,
      crossAxisCount: 2,
      physics: const NeverScrollableScrollPhysics(),
      children: viewModel.reportList.map((report) {
        return Container(
          decoration: BoxDecoration(
            color: report.backGroundColor,
            borderRadius: BorderRadius.circular(WidgetValue.btnRadius/2)
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(report.title, style: TextStyle(color: AppColors.textWhite, fontWeight: FontWeight.w400)),
              Text('${report.reportNum}', style: TextStyle(color: AppColors.textWhite, fontWeight: FontWeight.w600, fontSize: 25)),
            ],
          ),
        );
      }).toList()
    );
  }

  _buildSwiperCard() {
    List<String> imageList = viewModel.swiperList.map((swiperModel) => swiperModel.icon).toList();
    // return MainSwiper(controller: viewModel.swiperController, cardImgList: imageList,
    //   onTap: (index) => BaseViewModel.pushPage(context, PersonalReportLaw(model: viewModel.swiperList[index]))
    // );
  }

  _buildUserLawList() {
    return CustomList.separatedList(
        separator: SizedBox(height: 3,),
        physics: const NeverScrollableScrollPhysics(),
        childrenNum: viewModel.cellList.length,
        children: (context, index) {
          return InkWell(
            onTap: () => BaseViewModel.pushPage(context, PersonalReportLaw(model: viewModel.cellList[index])),
            child: PersonalCell(model: viewModel.cellList[index]),
          );
        }
    );
  }

  _buildReoprtList() {
    // 最多只顯示十筆資料
    final reportLength = (viewModel.reportUserList.length > 10) ? 10 : viewModel.reportUserList.length;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(WidgetValue.btnRadius/2),
        border: Border.all(width: 2, color: AppColors.dividerGrey),
        color: AppColors.whiteBackGround
      ),
      child: CustomList.separatedList(
          separator: MainDivider(color: AppColors.dividerGrey, weight: 2),
          physics: const NeverScrollableScrollPhysics(),
          childrenNum: reportLength,
          children: (context, index) {
            return PersonalReportCell(model: viewModel.reportUserList[index]);
          }
      ),
    );
  }

  _buildMoreReoprtListBtn() {
    final bool isMoreThanTen = viewModel.reportUserList.length > 10;
    return Offstage(
      offstage: !isMoreThanTen,
      child: InkWell(
        onTap: () => BaseViewModel.pushPage(context, PersonalReportDetail(viewModel: viewModel,)),
        child: Container(
          height: WidgetValue.mainComponentHeight,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(WidgetValue.btnRadius/2),
              border: Border.all(width: 2, color: AppColors.dividerGrey),
              color: AppColors.whiteBackGround
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('查看更多', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
              Icon(Icons.keyboard_arrow_down_outlined)
            ],
          ),
        ),
      ),
    );
  }
}