
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frechat/screens/profile/agent/agent_util.dart';
import 'package:frechat/screens/profile/agent/member_list/personal_agent_member_list_view_model.dart';
import 'package:frechat/screens/profile/agent/member_list/personal_contact_list/personal_contact_list.dart';
import 'package:frechat/screens/profile/agent/member_list/second_agent_list/second_agent_list.dart';
import 'package:frechat/screens/profile/agent/second_agent_list/agent_tab/personal_second_agent_tab.dart';
import 'package:frechat/system/base_view_model.dart';
import 'package:frechat/system/constant/enum.dart';
import 'package:frechat/system/providers.dart';
import 'package:frechat/system/util/convert_util.dart';
import 'package:frechat/system/util/date_format_util.dart';
import 'package:frechat/widgets/constant_value.dart';
import 'package:frechat/widgets/shared/divider.dart';
import 'package:frechat/widgets/shared/img_util.dart';
import 'package:frechat/widgets/shared/picker.dart';
import 'package:frechat/widgets/shared/tab_bar/main_tab_bar.dart';
import 'package:frechat/widgets/theme/app_box_decoration_theme.dart';
import 'package:frechat/widgets/theme/app_color_theme.dart';
import 'package:frechat/widgets/theme/app_image_theme.dart';
import 'package:frechat/widgets/theme/app_linear_gradient_theme.dart';
import 'package:frechat/widgets/theme/app_text_theme.dart';
import 'package:frechat/widgets/theme/app_theme.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../second_agent_list/friend_tab/personal_second_friend_tab.dart';
import 'agent_contact_list/agent_contact_list.dart';

//
// 成員列表(Tab 2)
//

class PersonalAgentMemberList extends ConsumerStatefulWidget {
  const PersonalAgentMemberList({super.key});

  @override
  ConsumerState<PersonalAgentMemberList> createState() => _PersonalAgentMemberListState();
}

class _PersonalAgentMemberListState extends ConsumerState<PersonalAgentMemberList> with SingleTickerProviderStateMixin {
  late PersonalAgentMemberListViewModel viewModel;
  bool isLoading = false;
  late AppTheme _theme;
  late AppTextTheme _appTextTheme;
  late AppImageTheme _appImageTheme;
  late AppColorTheme _appColorTheme;
  late AppBoxDecorationTheme _appBoxDecorationTheme;
  @override
  void initState() {
    super.initState();
    viewModel = PersonalAgentMemberListViewModel(ref: ref, setState: setState, tickerProvider: this);
    viewModel.init(context);
    if(viewModel.type == 0){
      viewModel.tabviews = [
        PersonalSecondAgentTab(agentMember: viewModel.agentMember!),
        PersonalSecondFriendTab(agentMember: viewModel.agentMember!),
      ];
    }else{
      viewModel.tabviews = [
        AgentContactList(startTime: AgentUtil.startTime, endTime: AgentUtil.endTime, agentUtil: viewModel.agentContactListUtil),
        PersonalContactList(startTime: AgentUtil.startTime, endTime: AgentUtil.endTime, agentUtil:  viewModel.personalContactListUtil),
        SecondAgentList(startTime: AgentUtil.startTime, endTime: AgentUtil.endTime, agentUtil:  viewModel.secondAgentListUtil)
      ];
    }
  }

  @override
  void dispose() {
    viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _theme = ref.watch(userInfoProvider).theme ?? AppTheme(themeType: AppThemeType.original);
    _appTextTheme = _theme.getAppTextTheme;
    _appImageTheme = _theme.getAppImageTheme;
    _appColorTheme = _theme.getAppColorTheme;
    _appBoxDecorationTheme = _theme.getAppBoxDecorationTheme;


    return Container(
      padding: EdgeInsets.symmetric(horizontal:16.w),
      color: _appColorTheme.baseBackgroundColor,
      child: CustomScrollView(
        slivers: <Widget>[
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTimePicker(),
                SizedBox(height: 12.h),
                _buildIncomeList(),
                SizedBox(height: 12.h),
              ],
            ),
          ),

          SliverFillRemaining(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                _buildTabBar(),
                Expanded(child: _buildTabBarView())
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIncomeList(){
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12.h,horizontal: 16.w),
      decoration: _appBoxDecorationTheme.personalAgentItemBoxDecoration,
      child:Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          nowCharmAndIncomeItem('总收益/元', ConvertUtil.toRMB(viewModel.agentUtil.totalAmount), _appImageTheme.iconProfileAgentIncome),
          MainDivider(color: _appColorTheme.dividerColor, weight: 1),
          nowCharmAndIncomeItem('文字', ConvertUtil.toRMB(viewModel.agentUtil.messageAmount), _appImageTheme.iconProfileAgentText),
          MainDivider(color: _appColorTheme.dividerColor, weight: 1),
          nowCharmAndIncomeItem('礼物', ConvertUtil.toRMB(viewModel.agentUtil.giftAmount), _appImageTheme.iconProfileAgentGift),
          MainDivider(color: _appColorTheme.dividerColor, weight: 1),
          nowCharmAndIncomeItem('语音', ConvertUtil.toRMB(viewModel.agentUtil.voiceAmount), _appImageTheme.iconProfileAgentCallVoice),
          MainDivider(color: _appColorTheme.dividerColor, weight: 1),
          nowCharmAndIncomeItem('视频', ConvertUtil.toRMB(viewModel.agentUtil.videoAmount), _appImageTheme.iconProfileAgentCallVideo),
          MainDivider(color: _appColorTheme.dividerColor, weight: 1),
          nowCharmAndIncomeItem('搭讪', ConvertUtil.toRMB(viewModel.agentUtil.pickupAmount), _appImageTheme.iconProfileAgentStrikeUp),
          // MainDivider(color: _appColorTheme.dividerColor, weight: 1),
          // nowCharmAndIncomeItem('动态打赏', ConvertUtil.toRMB(viewModel.agentUtil.feedDonateAmount, decimal: 5), _appImageTheme.iconProfileAgentActivityDonate),
        ],
      ),
    );
  }

  Widget nowCharmAndIncomeItem(String title, String content, String iconPath){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            ImgUtil.buildFromImgPath(iconPath, size: 16.w),
            SizedBox(width: 6.w),
            Text(title, style:_appTextTheme.labelPrimarySubtitleTextStyle),
          ],
        ),
        Text(content, style:_appTextTheme.labelPrimaryTextStyle),
      ],
    );
  }


  //TabBar
  Widget _buildTabBar() {
    return Container(
      decoration: _appBoxDecorationTheme.personalAgentTabbarBoxDecoration,
      child: MainTabBar(controller: viewModel.tabController, tabList: viewModel.tabTitles)
          .tabBar(
        padding: EdgeInsets.zero,
        dividerColor: Colors.transparent,
        tabAlignment: TabAlignment.fill,
        indicatorPadding: EdgeInsets.symmetric(vertical: 3.h),
        indicator: _appBoxDecorationTheme.personalAgentTabbarIndicatorBoxDecoration,
        selectTextStyle: _appTextTheme.personalAgentTabbarSelectTextStyle,
        unSelectTextStyle: _appTextTheme.personalAgentTabbarUnselectTextStyle,
      ),
    );
  }

  //Tab內容
  Widget _buildTabBarView() {
    return TabBarView(
      controller: viewModel.tabController,
      children: viewModel.tabviews,
    );
  }

  _buildTimePicker() {
    final startTimeFormat = DateFormatUtil.getDateWith24HourFormat(AgentUtil.startTime); // YYYY-MM-DD
    final endTimeFormat = DateFormatUtil.getDateWith24HourFormat(AgentUtil.endTime); // YYYY-MM-DD
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: WidgetValue.separateHeight),
          child:  Text('计算区间', style:_appTextTheme.labelPrimaryTitleTextStyle),
        ),
        Row(
          children: [
            _buildTimeItem(
              dateTime:  DateTime.parse(startTimeFormat),
              timeFormat: startTimeFormat,
              onSelect: (date) {
                if (date.isAfter(AgentUtil.endTime)) {
                  AgentUtil.startTime = date;
                  AgentUtil.endTime = date;
                } else {
                  AgentUtil.startTime = date;
                }
              },
            ),
            Text(' ~ ', style:_appTextTheme.labelPrimaryTextStyle),
            _buildTimeItem(
              dateTime: DateTime.parse(endTimeFormat),
              timeFormat: endTimeFormat,
              onSelect: (date) {
                if (date.isBefore(AgentUtil.startTime)) {
                  AgentUtil.startTime = date;
                  AgentUtil.endTime = date;
                } else {
                  AgentUtil.endTime = date;
                }
              },

            ),
          ],
        )
      ],
    );
  }

  _buildTimeItem({required String timeFormat, required Function(DateTime) onSelect, required DateTime dateTime}) {

    DateTime sixtyDaysAgoDateTime = DateTime.now().subtract(Duration(days: 60));
    DateTime minimumDate = DateTime(sixtyDaysAgoDateTime.year, sixtyDaysAgoDateTime.month, sixtyDaysAgoDateTime.day,);
    DateTime maximumDate = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day,);

    return InkWell(
      onTap: () => Picker.showDatePicker(
        context,
        appTheme: _theme,
        initialDateTime: dateTime,
        minimumDate: minimumDate,
        maximumDate:maximumDate ,
        onSelect: (date) {
          onSelect(date);
          BaseViewModel.popPage(context);
          viewModel.setTimeAndGetAgentMemberList(context);
          setState(() {});
        },
        onCancel: () => BaseViewModel.popPage(context),
      ),
      child: Row(
        children: [
          Text(timeFormat, style:_appTextTheme.labelPrimaryTextStyle),
          SizedBox(width: WidgetValue.separateHeight),
          ImgUtil.buildFromImgPath(_appImageTheme.iconCalendar, size: WidgetValue.smallIcon),
        ],
      ),
    );
  }


}