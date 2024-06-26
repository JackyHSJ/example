
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frechat/models/ws_res/agent/ws_agent_member_list_res.dart';
import 'package:frechat/screens/profile/agent/agent_util.dart';
import 'package:frechat/screens/profile/agent/member_list/second_agent_list/second_agent_list_view_model.dart';
import 'package:frechat/system/constant/enum.dart';
import 'package:frechat/system/providers.dart';
import 'package:frechat/widgets/constant_value.dart';
import 'package:frechat/widgets/profile/cell/personal_agent_member_list_cell.dart';
import 'package:frechat/widgets/shared/list/main_list.dart';
import 'package:frechat/widgets/shared/main_textfield.dart';
import 'package:frechat/widgets/shared/rounded_textfield.dart';
import 'package:frechat/widgets/strike_up_list/top_bottom_pull_loader.dart';
import 'package:frechat/widgets/theme/app_text_theme.dart';
import 'package:frechat/widgets/theme/app_theme.dart';
import 'package:frechat/widgets/theme/original/app_colors.dart';

//
// 推廣中心 -> 成員列表 -> 二級推廣列表
//

class SecondAgentList extends ConsumerStatefulWidget {
  const SecondAgentList({super.key, required this.agentUtil, required this.startTime, required this.endTime});
  final DateTime startTime;
  final DateTime endTime;
  final AgentUtil agentUtil;

  @override
  ConsumerState<SecondAgentList> createState() => _SecondAgentListState();
}

class _SecondAgentListState extends ConsumerState<SecondAgentList> with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  late SecondAgentListViewModel viewModel;
  DateTime get startTime => widget.startTime;
  DateTime get endTime => widget.endTime;

  @override
  bool get wantKeepAlive => true;


  final TextEditingController _textEditController = TextEditingController();

  late AppTheme _theme;
  late AppTextTheme _appTextTheme;

  @override
  void initState() {
    super.initState();
    viewModel = SecondAgentListViewModel(ref: ref, setState: setState);
    widget.agentUtil.setState = setState;
    // widget.agentUtil.initLoadData(context);
    viewModel.init(context, startTime: startTime, endTime: endTime);
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
    return Column(
      children: [
        _searchTextField(),
        Expanded(child: _buildList()),
      ],
    );
  }

  _buildList() {
    final List<AgentMemberInfo> list = widget.agentUtil.filterMemberList?.list ?? [];
    return TopBottomPullLoader(
      enableRefresh: false,
      onRefresh: widget.agentUtil.onRefresh,
      onFetchMore: () => widget.agentUtil.onFetchMore(context),
      child: CustomList.separatedList(
          separator: SizedBox(height: WidgetValue.verticalPadding),
          childrenNum: list.length,
          children: (context, index){
            return PersonalAgentMemberCell(
              agentMember: list[index],
              startTime: startTime,
              endTime: endTime,
              isEnableNextPageArrow: true,
              mode: AgentMemberListMode.agent,
            );
          }
      ),
    );
  }
  /// 搜尋輸入框
  Widget _searchTextField() {
    final WsAgentMemberListRes? memberList = ref.read(userInfoProvider).agentMemberListAgent;

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
        onChange: (text) =>
            widget.agentUtil.filter(userName: text, memberList: memberList),
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
              final WsAgentMemberListRes? memberList = ref.read(userInfoProvider).agentMemberListAgent;
              _textEditController.text = '';
              widget.agentUtil.filter(userName: '', memberList: memberList);
              setState(() {});
            },
          ),
        ));
  }
}