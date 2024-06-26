
import 'dart:async';

import 'package:after_layout/after_layout.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frechat/models/ws_res/agent/ws_agent_member_list_res.dart';
import 'package:frechat/screens/profile/agent/benefit/personal_agent_benefit_view_model.dart';
import 'package:frechat/system/base_view_model.dart';
import 'package:frechat/system/constant/enum.dart';
import 'package:frechat/system/providers.dart';
import 'package:frechat/system/util/date_format_util.dart';
import 'package:frechat/widgets/constant_value.dart';
import 'package:frechat/widgets/profile/cell/personal_agent_member_list_cell.dart';
import 'package:frechat/widgets/shared/img_util.dart';
import 'package:frechat/widgets/shared/list/main_list.dart';
import 'package:frechat/widgets/shared/main_textfield.dart';
import 'package:frechat/widgets/shared/picker.dart';
import 'package:frechat/widgets/sliver/header.dart';
import 'package:frechat/widgets/theme/app_theme.dart';
import 'package:frechat/widgets/theme/original/app_colors.dart';
import 'package:frechat/widgets/theme/uidefine.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class PersonalAgentBenefit extends ConsumerStatefulWidget {
  const PersonalAgentBenefit({super.key});
  @override
  ConsumerState<PersonalAgentBenefit> createState() => _PersonalAgentBenefitState();
}

class _PersonalAgentBenefitState extends ConsumerState<PersonalAgentBenefit> {
  late PersonalAgentBenefitViewModel viewModel;
  late AppTheme _theme;

  @override
  void initState() {
    viewModel = PersonalAgentBenefitViewModel(ref: ref, setState: setState, context: context);
    viewModel.init(context);
    super.initState();
  }

  @override
  void dispose() {
    viewModel.dispose();
    super.dispose();
  }

  double roundToTwoDecimals(num inputValue){
    double modifiedValue = double.parse(inputValue.toStringAsFixed(2));
    return modifiedValue;
  }

  @override
  Widget build(BuildContext context) {
    _theme = ref.watch(userInfoProvider).theme ?? AppTheme(themeType: AppThemeType.original);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: WidgetValue.horizontalPadding),
      child: CustomScrollView(
        controller: viewModel.scrollController,
        slivers: <Widget>[
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTimeRange(),
                SizedBox(height: WidgetValue.separateHeight),
                incomeList(),
                SizedBox(height: WidgetValue.separateHeight),
              ],
            ),
          ),
          SliverPersistentHeader(
              pinned: true,
              delegate: SliverHeaderDelegate(
                  minHeight: WidgetValue.sliverPrimaryHeight, maxHeight: WidgetValue.sliverPrimaryHeight,
                  child: Column(
                    // mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: UIDefine.getWidth(),
                        color: AppColors.whiteBackGround,
                        child: _buildTitle('收益成员列表'),
                      ),
                      _buildTextField(),
                    ],
                  )
              )
          ),
          SliverToBoxAdapter(
            child: _buildList(),
          )
        ],
      ),
    );
  }

  Widget incomeList(){
    return Container(
      // margin: EdgeInsets.symmetric(horizontal: WidgetValue.horizontalPadding),
      padding: EdgeInsets.symmetric(vertical: 12.h,horizontal: 16.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(12.0)),
        border: Border.all(width: 1, color: Color(0xFFEAEAEA)),
      ),
      child:Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          nowCharmAndIncomeItem('总收益/元', roundToTwoDecimals(viewModel.totalAmount).toString()),
          Divider(height: 12.w,color: Color(0xFFEAEAEA)),
          nowCharmAndIncomeItem('文字', roundToTwoDecimals(viewModel.messageAmount).toString()),
          Divider(height: 12.w,color: Color(0xFFEAEAEA)),
          nowCharmAndIncomeItem('礼物', roundToTwoDecimals(viewModel.giftAmount).toString()),
          Divider(height: 12.w,color: Color(0xFFEAEAEA)),
          nowCharmAndIncomeItem('语音', roundToTwoDecimals(viewModel.voiceAmount).toString()),
          Divider(height: 12.w,color: Color(0xFFEAEAEA)),
          nowCharmAndIncomeItem('视频', roundToTwoDecimals(viewModel.videoAmount).toString()),
          Divider(height: 12.w,color: Color(0xFFEAEAEA)),
          nowCharmAndIncomeItem('搭讪', roundToTwoDecimals(viewModel.pickupAmount).toString()),
        ],
      ),
    );
  }

  Widget nowCharmAndIncomeItem(String title, String content){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title,
            style:TextStyle(
                fontWeight: FontWeight.w700,
                color: Color(0xff444648),
                fontSize: 14.sp
            )),
        Text(content,
            style:TextStyle(
                fontWeight: FontWeight.w700,
                color: Color(0xff444648),
                fontSize: 14.sp
            )),
      ],
    );
  }

  _buildList() {
    final List<AgentMemberInfo>  memberList = viewModel.filterMemberList?.list ?? [];
    return CustomList.separatedList(
        separator: SizedBox(height: WidgetValue.verticalPadding),
        physics: const PageScrollPhysics(),
        childrenNum: memberList.length,
        children: (context, index){
          return PersonalAgentMemberCell(agentMember:  memberList[index],startTime: viewModel.startTime, endTime: viewModel.endTime);
        }
    );
  }

  _buildTitle(String title) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: WidgetValue.separateHeight),
      child: Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
    );
  }

  _buildTextField() {
    return MainTextField(
      backgroundColor: AppColors.btnLightGrey,
      prefixIcon: const Icon(Icons.search, color: AppColors.textGrey,),
      borderEnable: false,
      radius: WidgetValue.btnRadius / 2,
      hintText: '输入成员ID',
      controller: viewModel.searchMemberTextController,
      onChanged: (userName) => viewModel.filter(userName),
    );
  }

  _buildTimeRange() {
    final startTimeFormat = DateFormatUtil.getDateWith24HourFormat(viewModel.startTime);
    final endTimeFormat = DateFormatUtil.getDateWith24HourFormat(viewModel.endTime);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTitle('计算区间'),
        Row(
          children: [
            _buildTimeItem(
                dateTime: viewModel.startTime,
                timeFormat: startTimeFormat,
                onSelect: (date) => viewModel.startTime = date
            ),
            const Text(' ~ '),
            _buildTimeItem(
                dateTime: viewModel.endTime,
                timeFormat: endTimeFormat,
                onSelect: (date) => viewModel.endTime = date
            ),
          ],
        )
      ],
    );
  }

  _buildTimeItem({required String timeFormat, required Function(DateTime) onSelect, required DateTime dateTime}) {
    return InkWell(
      onTap: () => Picker.showDatePicker(context,
          initialDateTime: dateTime,
          appTheme: _theme,
          onSelect: (date){
            onSelect(date);
            BaseViewModel.popPage(context);
            /// api refresh list
            viewModel.page = '1';
            viewModel.getAgentMemberList(context);
            setState(() {});
          },
          onCancel: () => BaseViewModel.popPage(context)
      ),
      child: Row(
        children: [
          Text(timeFormat, style: const TextStyle(fontSize: 16, letterSpacing: -1)),
          SizedBox(width: WidgetValue.separateHeight),
          ImgUtil.buildFromImgPath('assets/profile/profile_date_picker_icon.png', size: WidgetValue.smallIcon),
        ],
      ),
    );
  }
}