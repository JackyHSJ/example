import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frechat/models/ws_req/account/ws_account_follow_and_fans_list_req.dart';
import 'package:frechat/models/ws_req/visitor/ws_visitor_list_req.dart';
import 'package:frechat/models/ws_res/account/ws_account_follow_and_fans_list_res.dart';
import 'package:frechat/models/ws_res/member/ws_member_point_coin_res.dart';
import 'package:frechat/models/ws_res/visitor/ws_visitor_list_res.dart';
import 'package:frechat/screens/profile/check_in/personal_check_in.dart';
import 'package:frechat/screens/profile/deposit/personal_deposit.dart';
import 'package:frechat/screens/profile/personal_profile_view_model.dart';
import 'package:frechat/system/base_view_model.dart';
import 'package:frechat/system/constant/enum.dart';
import 'package:frechat/system/provider/user_info_provider.dart';
import 'package:frechat/system/providers.dart';
import 'package:frechat/system/repository/response_code.dart';
import 'package:frechat/widgets/banner_view/banner_view.dart';
import 'package:frechat/widgets/profile/cell/personal_cell.dart';
import 'package:frechat/widgets/profile/personal_data.dart';
import 'package:frechat/widgets/shared/app_bar.dart';
import 'package:frechat/widgets/shared/img_util.dart';
import 'package:frechat/widgets/theme/app_box_decoration_theme.dart';
import 'package:frechat/widgets/theme/app_color_theme.dart';
import 'package:frechat/widgets/theme/original/app_box_decoration.dart';
import 'package:frechat/widgets/theme/original/app_colors.dart';
import 'package:frechat/widgets/theme/app_image_theme.dart';
import 'package:frechat/widgets/theme/app_theme.dart';
import 'package:frechat/widgets/theme/uidefine.dart';

import '../../models/profile/personal_cell_model.dart';
import '../../widgets/constant_value.dart';
import '../../widgets/profile/cell/personal_property_cell.dart';
import '../../widgets/profile/personal_info.dart';
import '../../widgets/shared/divider.dart';
import '../../widgets/shared/list/main_list.dart';
import '../../widgets/shared/main_scaffold.dart';
import 'benefit/personal_benefit.dart';

/// Home 的 4 個 tab 其中之一:
/// 個人頁面
class PersonalProfile extends ConsumerStatefulWidget {
  const PersonalProfile({super.key});

  @override
  ConsumerState<PersonalProfile> createState() => _PersonalProfileState();
}

class _PersonalProfileState extends ConsumerState<PersonalProfile> {
  late PersonalProfileViewModel viewModel;


  // 審核開關
  bool showActivityType = false; // 8. 活動播送


  @override
  void initState() {
    viewModel = PersonalProfileViewModel(ref: ref);
    viewModel.init();
    // checkPersonalCellModelList();
    super.initState();
    showActivityType = ref.read(userInfoProvider).buttonConfigList?.activityType == 1 ? true : false;
  }

  // void checkPersonalCellModelList(){
  //   num? agentLevel = ref.read(userInfoProvider).memberInfo?.agentLevel;
  //   ///一级代理移除我的人脉入口
  //   // if(agentLevel == 1){
  //   //   viewModel.cellList.removeAt(1);
  //   // }
  // }

  _loadMemberInfo() async {
    viewModel.loadMemberInfo(onConnectFail: (errMsg) => BaseViewModel.showToast(context, ResponseCode.map[errMsg]!));
  }

  _loadPropertyInfo() async {
    viewModel.loadPropertyInfo(context);
  }

  _loadGetCharmInfo() async{
    viewModel.getCharmInfo();
  }

  @override
  void dispose() {
    viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final AppTheme theme = ref.watch(userInfoProvider).theme ?? AppTheme(themeType: AppThemeType.original);
    final AppColorTheme appColorTheme = theme.getAppColorTheme;
    // final AppImageTheme appImageTheme = theme.getAppImageTheme;

    return MainScaffold(
      needBackground: true,
      padding: EdgeInsets.only(top: UIDefine.getStatusBarHeight()),
      viewDidAppear: () {
        _loadMemberInfo();
        _loadPropertyInfo();
        _loadGetCharmInfo();
      },
      backgroundColor: appColorTheme.appBarBackgroundColor,
      child: Column(
        children: [
          _buildPersonalTabHome(),
          Padding(padding: EdgeInsets.only(left: 16.w), child: _buildPersonalInfo()),
          Padding(padding: EdgeInsets.only(right: 16.w, left: 16.w), child: _buildPersonalData()),
          SizedBox(height: 16.h),
          Padding(padding: EdgeInsets.only(right: 16.w, left: 16.w), child: _buildProperty()),
          SizedBox(height: 16.h),
          Visibility(visible: showActivityType, child: _buildBannerView()),
          Padding(padding: EdgeInsets.only(right: 16.w, left: 16.w), child: _buildCheckIn()),
          SizedBox(height: 16.h),
          Padding(padding: EdgeInsets.only(right: 16.w, left: 16.w), child: _buildCellList()),
        ],
      ),
    );
  }

  Widget _buildPersonalTabHome() {
    final AppTheme theme = ref.watch(userInfoProvider).theme ?? AppTheme(themeType: AppThemeType.original);
    final AppImageTheme appImageTheme = theme.getAppImageTheme;
    return (appImageTheme.personalTabHome.isNotEmpty)
      ? Padding(padding: const EdgeInsets.only(top: 12),child: ImgUtil.buildFromImgPath(appImageTheme.personalTabHome, width: 104, height: 42))
      : Container();
  }

  Widget _buildPersonalInfo() {
    return Padding(
      padding: const EdgeInsets.only(top: 12, bottom: 4),
      child: PersonalInfo()
    );
  }

  Widget _buildPersonalData() {
    return const PersonalData();
  }



  _buildProperty() {
    return Consumer(builder: (context, ref, _) {
      final property = ref.watch(userUtilProvider).memberPointCoin;
      final AppTheme theme = ref.watch(userInfoProvider).theme ?? AppTheme(themeType: AppThemeType.original);
      final AppBoxDecorationTheme appBoxDecoration = theme.getAppBoxDecorationTheme;

      viewModel.list[0].num = property?.coins?.toInt() ?? 0;
      viewModel.list[1].num = property?.points?.toInt() ?? 0;
      return Container(
        decoration: appBoxDecoration.personalPropertyBoxDecoration,
        child: Row(
          children: [
            Expanded(
              child: InkWell(
                onTap: () =>
                    BaseViewModel.pushPage(context, const PersonalDeposit()),
                child: PersonalPropertyCell(data: viewModel.list[0]),
              ),
            ),
            Expanded(
              child: InkWell(
                onTap: () =>
                    BaseViewModel.pushPage(context, PersonalBenefit(isFromBannerView: false)),
                child: PersonalPropertyCell(data: viewModel.list[1]),
              ),
            )
          ],
        ),
      );
    });
  }

  _buildCheckIn() {
    return PersonalCheckIn();
  }

  _buildBannerView() {
    return Container(
      margin: EdgeInsets.only(right: 16.w, left: 16.w, bottom: 16.h),
      child: const BannerView(
        padding: EdgeInsets.all(0.0),
        locatedPageFilter: 5,
        aspectRatio: 3.43,
        inAppWebView: true,
      ),
    );
  }

  _buildCellList() {
    /// 如果是男生不顯示魅力等級Cell
    if (ref.read(userInfoProvider).memberInfo?.gender == 1) {
      viewModel.cellList.removeWhere((personalCellModel) => personalCellModel.title == '魅力等级');
    }

    /// 推廣會員才顯示推廣中心
    if (ref.read(userInfoProvider).memberInfo?.agentName == '' || ref.read(userInfoProvider).memberInfo?.agentName == null) {
      viewModel.cellList.removeWhere((personalCellModel) => personalCellModel.title == '推广中心');
    }

    final AppTheme theme = ref.watch(userInfoProvider).theme ?? AppTheme(themeType: AppThemeType.original);
    final AppBoxDecorationTheme appBoxDecoration = theme.getAppBoxDecorationTheme;
    final AppColorTheme appColorTheme = theme.getAppColorTheme;

    return Container(
      margin: EdgeInsets.symmetric( vertical: WidgetValue.horizontalPadding),
      padding: EdgeInsets.symmetric(horizontal: WidgetValue.horizontalPadding, vertical: WidgetValue.horizontalPadding),
      decoration: appBoxDecoration.personalProfileCellListBoxDecoration,
      child: CustomList.separatedList(
          separator: MainDivider(color: appColorTheme.dividerColor, weight: 1),
          physics: const NeverScrollableScrollPhysics(),
          childrenNum: viewModel.cellList.length,
          children: (context, index) {
            return Consumer(builder: (context, ref, _){
              _checkCharm(index);
              _checkAgent(index);
              return PersonalCell(model: viewModel.cellList[index], desList: [_buildDes(viewModel.cellList[index])]);
            });
          }),
    );
  }

  _checkCharm(int index) {
    if(viewModel.cellList[index].title == '魅力等级') {
      final charm = ref.watch(userInfoProvider).charmAchievement;
      final isMaxLevel = charm?.personalCharm?.charmLevel == 8;
      final currentLevel = charm?.personalCharm?.charmLevel ?? 0;
      final targetLevel = isMaxLevel ? currentLevel : currentLevel + 1;
      final currentPoints = charm?.personalCharm?.charmPoints ?? 0;
      final nextLevelInfo = charm?.list?.firstWhere((item) => item.charmLevel == '$targetLevel');
      final nextLevelCondition = nextLevelInfo?.levelCondition?.split('|');
      final nextLevelTargetPoint = int.parse(nextLevelCondition![1]);
      final pointLeft = nextLevelTargetPoint - currentPoints;
      final displayText = isMaxLevel
          ? '目前已达最高等级'
          : pointLeft < 0
          ? '再完成一次互动即可升级'
          : '升级 Lv.$targetLevel 还需 ${pointLeft.toStringAsFixed(2)} 积分';

      viewModel.cellList[index].des = displayText;
    }
  }

  _checkAgent(int index) {
    final charm = ref.watch(userInfoProvider);
    // if(viewModel.cellList[index].title == '推广中心' && charm != null) {
    //   try {
    //     final level = charm.getLevel();
    //     final target = level + 1;
    //     final resultPoint = charm.getPoint(level: level);
    //     viewModel.cellList[index].des = '升级 Lv.$target 还需 $resultPoint 积分';
    //   } catch(e) {
    //     viewModel.cellList[index].des = '亲～您的魅力满级啰';
    //   }
    // }
  }

  _buildDes(PersonalCellModel model) {
    final AppTheme theme = ref.watch(userInfoProvider).theme ?? AppTheme(themeType: AppThemeType.original);
    // final AppImageTheme appImageTheme = theme.getAppImageTheme;
    final AppColorTheme appColorTheme = theme.getAppColorTheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(model.des ?? '', style: TextStyle(color: appColorTheme.descriptionTextColor, fontWeight: FontWeight.w600, fontSize: 12)),
        const SizedBox(width: 5),
        Visibility(
          visible: (model.hintImg != null),
          child: (model.hintImg == '')?Container():ImgUtil.buildFromImgPath(model.hintImg ?? '', size: WidgetValue.smallIcon),
        )
      ],
    );
  }


}
