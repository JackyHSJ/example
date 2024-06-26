
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frechat/models/ws_res/agent/ws_agent_member_list_res.dart';

import 'package:frechat/screens/profile/agent/second_agent_list/friend_tab/personal_second_friend_tab_view_model.dart';
import 'package:frechat/screens/profile/agent/second_agent_list/personal_second_agent_list_view_model.dart';
import 'package:frechat/system/base_view_model.dart';
import 'package:frechat/system/constant/enum.dart';
import 'package:frechat/system/extension/agent_second_member_info.dart';
import 'package:frechat/system/providers.dart';
import 'package:frechat/system/util/date_format_util.dart';
import 'package:frechat/widgets/constant_value.dart';
import 'package:frechat/widgets/profile/cell/personal_agent_member_list_cell.dart';
import 'package:frechat/widgets/shared/app_bar.dart';
import 'package:frechat/widgets/shared/img_util.dart';
import 'package:frechat/widgets/shared/list/main_list.dart';
import 'package:frechat/widgets/shared/main_scaffold.dart';
import 'package:frechat/widgets/shared/main_textfield.dart';
import 'package:frechat/widgets/shared/picker.dart';
import 'package:frechat/widgets/shared/rounded_textfield.dart';
import 'package:frechat/widgets/theme/app_image_theme.dart';
import 'package:frechat/widgets/theme/app_text_theme.dart';
import 'package:frechat/widgets/theme/app_theme.dart';
import 'package:frechat/widgets/theme/original/app_colors.dart';
import 'package:frechat/widgets/theme/uidefine.dart';

class PersonalSecondFriendTab extends ConsumerStatefulWidget {
  const PersonalSecondFriendTab({super.key, required this.agentMember});
  final AgentMemberInfo agentMember;

  @override
  ConsumerState<PersonalSecondFriendTab> createState() => _PersonalSecondFriendTabState();
}

class _PersonalSecondFriendTabState extends ConsumerState<PersonalSecondFriendTab> with TickerProviderStateMixin{
  late PersonalSecondFriendTabViewModel viewModel;
  AgentMemberInfo get agentMember => widget.agentMember;
  final TextEditingController _textEditController = TextEditingController();

  late AppTheme _theme;
  late AppTextTheme _appTextTheme;
  late AppImageTheme _appImageTheme;

  @override
  void initState() {
    viewModel = PersonalSecondFriendTabViewModel(ref: ref, setState: setState, agentMember: agentMember);
    viewModel.init(context);
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
    _appTextTheme = _theme.getAppTextTheme;
    _appImageTheme = _theme.getAppImageTheme;

    return Column(
      children: [
        _searchTextField(),
        _buildTimePicker(),
        SizedBox(height: 12.h),
        Expanded(child: _buildList(),),
      ],
    );
  }

  _buildList() {
    final WsAgentMemberListRes? filterMemberList = viewModel.secondAgentListUtil.filterMemberList;
    final List<AgentMemberInfo> list = filterMemberList?.list ?? [];
    return CustomList.separatedList(
        separator: SizedBox(height: WidgetValue.verticalPadding),
        childrenNum: list.length,
        children: (context, index){
          final AgentMemberInfo agentMember = list[index].toAgentMemberInfo();
          return PersonalAgentMemberCell(
              parentId: widget.agentMember.id,
              agentMember: agentMember,
              startTime: viewModel.secondAgentListUtil.startTime,
              endTime: viewModel.secondAgentListUtil.endTime,
              isEnableNextPageArrow: false,
              mode: AgentMemberListMode.secondFriendContact,
          );
        }
    );
  }
  /// 搜尋輸入框
  Widget _searchTextField() {
    final WsAgentMemberListRes? memberList = ref.read(userInfoProvider).agentSecondFriendList;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12.h),
      child: RoundedTextField(
        margin: EdgeInsets.zero,
        radius: 12.w,
        textEditingController: _textEditController,
        borderColor: _theme.getAppColorTheme.textFieldBorderColor,
        textInputType: TextInputType.text,
        prefixIcon: _searchTextFieldPrefixIconButton(),
        suffixIcon: _searchTextFieldSuffixIconButton(),
        hint: '输入成员 ID',
        hintTextStyle: _appTextTheme.labelSecondaryTextStyle,
        onChange: (userName) => viewModel.secondAgentListUtil.filter(
            userName: userName,
            memberList: memberList
        ),
      ),
    );
  }
  /// 搜尋輸入框 - 放大鏡icon
  Widget _searchTextFieldPrefixIconButton(){
    return Icon(Icons.search, color: AppColors.mainGrey, size: 24.w,);
  }

  /// 搜尋輸入框 - 搜尋 & 清空icon
  Widget _searchTextFieldSuffixIconButton(){
    return Visibility(
        visible: _textEditController.text.isNotEmpty,
        child: Padding(
          padding: EdgeInsets.all(13.h),
          child: InkWell(
            child: const Image(
                image: AssetImage('assets/images/icon_text_file_cancel.png')),
            onTap: () {
              final WsAgentMemberListRes? memberList = ref.read(userInfoProvider).agentSecondFriendList;
              _textEditController.text = '';
              viewModel.secondAgentListUtil.filter(userName: '', memberList: memberList);
              setState(() {});
            },
          ),
        ));
  }


  _buildTimePicker() {
    final startTimeFormat = DateFormatUtil.getDateWith24HourFormat(viewModel.secondAgentListUtil.startTime); // YYYY-MM-DD
    final endTimeFormat = DateFormatUtil.getDateWith24HourFormat(viewModel.secondAgentListUtil.endTime); // YYYY-MM-DD
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
                dateTime: viewModel.secondAgentListUtil.startTime,
                timeFormat: startTimeFormat,
                onSelect: (date) {
                  if (date.isAfter(viewModel.secondAgentListUtil.endTime)) {
                    viewModel.secondAgentListUtil.startTime = date;
                    viewModel.secondAgentListUtil.endTime = date;
                  } else {
                    viewModel.secondAgentListUtil.startTime = date;
                  }
                }
            ),
            const Text(' ~ '),
            _buildTimeItem(
                dateTime: viewModel.secondAgentListUtil.endTime,
                timeFormat: endTimeFormat,
                onSelect: (date) {
                  if (date.isBefore(viewModel.secondAgentListUtil.startTime)) {
                    viewModel.secondAgentListUtil.startTime = date;
                    viewModel.secondAgentListUtil.endTime = date;
                  } else {
                    viewModel.secondAgentListUtil.endTime = date;
                  }
                }
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
            viewModel.secondAgentListUtil.resetToInitState();
            viewModel.secondAgentListUtil.getAgentMemberList(context);
            setState(() {});
          },
          onCancel: () => BaseViewModel.popPage(context)
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
