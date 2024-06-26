import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frechat/models/ws_res/agent/ws_agent_member_list_res.dart';
import 'package:frechat/models/ws_res/agent/ws_agent_promoter_info_res.dart';
import 'package:frechat/screens/profile/agent/personal_invite_agent.dart';
import 'package:frechat/screens/profile/agent/promotion/personal_agent_promotion_view_model.dart';
import 'package:frechat/screens/profile/invite_friend/personal_invite_frined.dart';
import 'package:frechat/system/base_view_model.dart';
import 'package:frechat/system/constant/enum.dart';
import 'package:frechat/system/providers.dart';
import 'package:frechat/system/util/convert_util.dart';
import 'package:frechat/widgets/constant_value.dart';
import 'package:frechat/widgets/profile/cell/personal_agent_promotion_cell.dart';
import 'package:frechat/widgets/shared/divider.dart';
import 'package:frechat/widgets/shared/img_util.dart';
import 'package:frechat/widgets/theme/app_box_decoration_theme.dart';
import 'package:frechat/widgets/theme/app_color_theme.dart';
import 'package:frechat/widgets/theme/app_image_theme.dart';
import 'package:frechat/widgets/theme/app_linear_gradient_theme.dart';
import 'package:frechat/widgets/theme/app_text_theme.dart';
import 'package:frechat/widgets/theme/app_theme.dart';
import 'package:frechat/widgets/theme/original/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

//
// 推廣中心(Tab 1)
//



class PersonalAgentPromotion extends ConsumerStatefulWidget {
  const PersonalAgentPromotion({super.key});
  @override
  ConsumerState<PersonalAgentPromotion> createState() => _PersonalAgentPromotionState();
}

class _PersonalAgentPromotionState extends ConsumerState<PersonalAgentPromotion> {
  late PersonalAgentPromotionViewModel viewModel;
  late AppTheme _theme;
  late AppTextTheme _appTextTheme;
  late AppImageTheme _appImageTheme;
  late AppColorTheme _appColorTheme;
  late AppLinearGradientTheme _appLinearGradientTheme;
  late AppBoxDecorationTheme _appBoxDecorationTheme;

  @override
  void initState() {
    viewModel = PersonalAgentPromotionViewModel(ref: ref, setState: setState);
    viewModel.init(context);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final promoterInfo = ref.watch(userInfoProvider).agentPromoterInfo;
    _theme = ref.watch(userInfoProvider).theme ?? AppTheme(themeType: AppThemeType.original);
    _appTextTheme = _theme.getAppTextTheme;
    _appImageTheme = _theme.getAppImageTheme;
    _appColorTheme = _theme.getAppColorTheme;
    _appLinearGradientTheme = _theme.getAppLinearGradientTheme;
    _appBoxDecorationTheme = _theme.getAppBoxDecorationTheme;

    return Container(
      color: _appColorTheme.baseBackgroundColor,
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: (promoterInfo == null) ? _emptyImg() : _buildPromotion(),
    );
  }

  _emptyImg() {
    return Column(
      children: [
        SizedBox(height: WidgetValue.mainComponentHeight,),
        ImgUtil.buildFromImgPath('assets/profile/profile_agent_empty_img.png', size: WidgetValue.userMonsterImg),
        Text('您目前没有推广成员', style: TextStyle(color: AppColors.textBlack, fontSize: 16, fontWeight: FontWeight.w600)),
        Text('快去邀请推广成员吧', style: TextStyle(color: AppColors.textGrey, fontSize: 14, fontWeight: FontWeight.w600)),
        SizedBox(height: WidgetValue.verticalPadding),
        _buildBtn(padding: EdgeInsets.symmetric(
          horizontal: WidgetValue.horizontalPadding * 4,
          vertical: WidgetValue.verticalPadding * 1.5
        ))
      ],
    );
  }

  _buildPromotion() {
    return Consumer(builder: (context, ref, _) {
      final WsAgentPromoterInfoRes? promoterInfo = ref.watch(userInfoProvider).agentPromoterInfo;
      return SingleChildScrollView(
        child: Container(
          color: _appColorTheme.baseBackgroundColor,
          child: Column(
            children: [
              /// ----------
              _buildTitle('收入数据（元）'),
              showIcomeList(promoterInfo!),
              SizedBox(height: 20.h),
              /// ----------
              _buildTitle('人脉数据（人）'),
              contactList(promoterInfo),
              SizedBox(height: 20.h),
              // /// ----------
              _buildTitle('主播数据（人）'),
              promoterList(promoterInfo),
              SizedBox(height: 66.h),
              _buildBtn(padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 14.h
              ))
            ],
          ),
        ),
      );
    });
  }

  Widget promoterList(WsAgentPromoterInfoRes promoterInfo){
    final num promoterCount = promoterInfo.promoterCount ?? 0;
    final num totalPromoterCount = promoterInfo.totalPromoterCount ?? 0;
    return Container(
      margin: EdgeInsets.symmetric(horizontal: WidgetValue.horizontalPadding),
      padding: EdgeInsets.symmetric(vertical: 12.h,horizontal: 16.w),
      decoration: _appBoxDecorationTheme.personalAgentItemBoxDecoration,
      child:Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          nowCharmAndIncomeItem('昨日新增推广', promoterCount.toString()),
          MainDivider(color: _appColorTheme.dividerColor, weight: 1),
          nowCharmAndIncomeItem('累计推广', totalPromoterCount.toString()),
        ],
      ),
    );
  }

  Widget contactList(WsAgentPromoterInfoRes promoterInfo){
    final num memberCount = promoterInfo.memberCount ?? 0;
    final num totalMemberCount = promoterInfo.totalMemberCount ?? 0;
    return Container(
      margin: EdgeInsets.symmetric(horizontal: WidgetValue.horizontalPadding),
      padding: EdgeInsets.symmetric(vertical: 12.h,horizontal: 16.w),
      decoration: _appBoxDecorationTheme.personalAgentItemBoxDecoration,
      child:Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          nowCharmAndIncomeItem('昨日新增人脉', memberCount.toString()),
          MainDivider(color: _appColorTheme.dividerColor, weight: 1),
          nowCharmAndIncomeItem('累计人脉', totalMemberCount.toString()),
        ],
      ),
    );
  }

  Widget showIcomeList(WsAgentPromoterInfoRes promoterInfo){
    final num todayIncome = promoterInfo.todayIncome ?? 0;
    final num yesterdayIncome = promoterInfo.yesterdayIncome ?? 0;
    final num weekIncome = promoterInfo.weekIncome ?? 0;
    final num monthIncome = promoterInfo.monthIncome ?? 0;
    return Container(
      margin: EdgeInsets.symmetric(horizontal: WidgetValue.horizontalPadding),
      padding: EdgeInsets.symmetric(vertical: 12.h,horizontal: 16.w),
      decoration: _appBoxDecorationTheme.personalAgentItemBoxDecoration,
      child:Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          nowCharmAndIncomeItem('今日收入', ConvertUtil.toRMB(todayIncome)),
          MainDivider(color: _appColorTheme.dividerColor, weight: 1),
          nowCharmAndIncomeItem('昨日收入', ConvertUtil.toRMB(yesterdayIncome)),
          MainDivider(color: _appColorTheme.dividerColor, weight: 1),
          nowCharmAndIncomeItem('本周收入', ConvertUtil.toRMB(weekIncome)),
          MainDivider(color: _appColorTheme.dividerColor, weight: 1),
          nowCharmAndIncomeItem('本月收入', ConvertUtil.toRMB(monthIncome)),
    ],
      ),
    );
  }

  Widget nowCharmAndIncomeItem(String title, String content){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style:_appTextTheme.labelPrimarySubtitleTextStyle),
        Text(content, style:_appTextTheme.labelPrimaryTextStyle),
      ],
    );
  }

  _buildTitle(String title) {
    return Container(
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.symmetric(horizontal: WidgetValue.horizontalPadding, vertical: WidgetValue.verticalPadding),
      child: Text(title, style: _appTextTheme.personalAgentTitleTextStyle),
    );
  }

  _buildBtn({
    EdgeInsetsGeometry? padding
  }) {
    return InkWell(
      onTap: () => BaseViewModel.pushPage(context, const PersonalInviteAgent(type: InviteFriendType.agent)),
      child: Container(
        margin: EdgeInsets.only(bottom: WidgetValue.btnBottomPadding),
        decoration: BoxDecoration(
          gradient: _appLinearGradientTheme.personalAgentInviteButtonGradientColor,
            borderRadius: BorderRadius.circular(WidgetValue.btnRadius * 2)
        ),
        padding: padding ?? EdgeInsets.symmetric(horizontal: WidgetValue.horizontalPadding * 2, vertical: WidgetValue.verticalPadding),
        // margin: EdgeInsets.symmetric(vertical: WidgetValue.btnBottomPadding),
        child:  Text('邀请成员', style:_appTextTheme.personalAgentInviteButtonTextStyle),
      ),
    );
  }
}