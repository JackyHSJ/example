import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:frechat/screens/profile/contact/score_detail/personal_score_detail_view_model.dart';
import 'package:frechat/screens/profile/invite_friend/personal_invite_frined.dart';

import 'package:frechat/system/base_view_model.dart';
import 'package:frechat/system/constant/enum.dart';
import 'package:frechat/system/providers.dart';
import 'package:frechat/system/util/date_format_util.dart';

import 'package:frechat/widgets/shared/img_util.dart';
import 'package:frechat/widgets/shared/picker.dart';
import 'package:frechat/widgets/constant_value.dart';
import 'package:frechat/widgets/profile/cell/personal_score_cell.dart';
import 'package:frechat/widgets/shared/app_bar.dart';
import 'package:frechat/widgets/theme/app_box_decoration_theme.dart';
import 'package:frechat/widgets/theme/app_color_theme.dart';
import 'package:frechat/widgets/theme/app_text_theme.dart';
import 'package:frechat/widgets/theme/original/app_colors.dart';
import 'package:frechat/widgets/strike_up_list/top_bottom_pull_loader.dart';
import 'package:frechat/widgets/theme/app_image_theme.dart';
import 'package:frechat/widgets/theme/app_theme.dart';


class PersonalScoreDetail extends ConsumerStatefulWidget {
  num todayRevenue;
  num lastWeekRevenue;
  num thisWeekRevenue;
  PersonalScoreDetail({super.key, required this.todayRevenue, required this.lastWeekRevenue, required this.thisWeekRevenue});

  @override
  ConsumerState<PersonalScoreDetail> createState() => _PersonalScoreDetailState();
}

class _PersonalScoreDetailState extends ConsumerState<PersonalScoreDetail> {
  late PersonalScoreDetailViewModel viewModel;
  late AppTheme _theme;
  late AppTextTheme _appTextTheme;
  late AppImageTheme _appImageTheme;
  late AppColorTheme _appColorTheme;
  late AppBoxDecorationTheme _appBoxDecorationTheme;
  @override
  void initState() {
    viewModel = PersonalScoreDetailViewModel(ref: ref, setState: setState, context: context);
    viewModel.init();
    super.initState();
  }

  _onRefresh() {
    viewModel.refreshHandler();
  }

  _onFetchMore()  {
    viewModel.fetchMoreHandler();
  }

  @override
  Widget build(BuildContext context) {
    _theme = ref.watch(userInfoProvider).theme ?? AppTheme(themeType: AppThemeType.original);
    _appTextTheme = _theme.getAppTextTheme;
    _appImageTheme = _theme.getAppImageTheme;
    _appColorTheme = _theme.getAppColorTheme;
    _appBoxDecorationTheme = _theme.getAppBoxDecorationTheme;

    return Scaffold(
      appBar: MainAppBar(
        theme: _theme,
        title: '贡献积分明细',
        backgroundColor: _appColorTheme.appBarBackgroundColor,
        leading: IconButton(
          icon: ImgUtil.buildFromImgPath(_appImageTheme.iconBack, size: 24.w),
          onPressed: () => BaseViewModel.popPage(context),
        ),
      ),
      body: Container(
        color: _appColorTheme.baseBackgroundColor,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildScoreList(),
              _buildTimePicker(),
              _buildFriendBenefitView(),
            ],
          ),
        ),
      )
    );
  }

  _buildTimePicker() {
    final startTimeFormat = DateFormatUtil.getDateWith24HourFormat(viewModel.startTime); // YYYY-MM-DD
    final endTimeFormat = DateFormatUtil.getDateWith24HourFormat(viewModel.endTime); // YYYY-MM-DD
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
                if (date.isAfter(viewModel.endTime)) {
                  viewModel.startTime = date;
                  viewModel.endTime = date;
                } else {
                  viewModel.startTime = date;
                }
              },
            ),
            Text(' ~ ', style:_appTextTheme.labelPrimaryTextStyle),
            _buildTimeItem(
              dateTime: DateTime.parse(endTimeFormat),
              timeFormat: endTimeFormat,
              onSelect: (date) {
                if (date.isBefore(viewModel.startTime)) {
                  viewModel.startTime = date;
                  viewModel.endTime = date;
                } else {
                  viewModel.endTime = date;
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
          final bool result = viewModel.selectHandler(date, viewModel.endTime, 0);
          if (result) {
            viewModel.startTime = date;
            BaseViewModel.popPage(context);
            viewModel.resetToInitState();
            viewModel.getContactFriendBenefitList();
          }
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

  _buildFriendBenefitView(){
    return Expanded(
      child: TopBottomPullLoader(
        onRefresh: _onRefresh,
        onFetchMore: _onFetchMore,
        child: _buildFriendBenefitList()
      )
    );
  }

  _buildFriendBenefitList(){

    final list =  viewModel.contactList;

    return (list.isEmpty)
        ? _buildEmptyFriend()
        : ListView.builder(itemCount: list.length, itemBuilder: (context, index) {
            return Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 10),
                child: PersonalScoreCell(model: list[index])
            );
      },
    );
  }

  _buildEmptyFriend() {

    return Center(
      child: Container(
        height: 500.h,
        padding: EdgeInsets.all(WidgetValue.horizontalPadding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ImgUtil.buildFromImgPath(_appImageTheme.imageDetailEmpty, size: 200.w),
             Text('您目前没有贡献纪录', style: _appTextTheme.labelPrimarySubtitleTextStyle,),
             Text('描述', style: _appTextTheme.labelPrimaryContentTextStyle),
            InkWell(
              onTap: () => BaseViewModel.pushPage(context, const PersonalInviteFriend(type: InviteFriendType.contact)),
              child:  Text('邀请好友', style: _appTextTheme.labelMainUnderLineTextStyle,),
            ),
          ],
        ),
      ),
    );
  }

  _buildScoreList() {
    return Row(
      children: [
        Expanded(
          child: _buildItem(
              title: '今日',
              data: widget.todayRevenue,
              imgPath: _appImageTheme.imageProfileContactTodayItem,
              titleTextStyle: _appTextTheme.profileContactTodayTitleTextStyle,
              contentTextStyle:
              _appTextTheme.profileContactTodayContentTextStyle),
        ),
        SizedBox(width: WidgetValue.horizontalPadding),
        Expanded(
          child: _buildItem(
            title: '本周',
            data: widget.thisWeekRevenue,
            imgPath: _appImageTheme.imageProfileContactWeekItem,
            titleTextStyle: _appTextTheme.profileContactWeekTitleTextStyle,
            contentTextStyle:
            _appTextTheme.profileContactWeekContentTextStyle,
          ),
        ),
        SizedBox(width: WidgetValue.horizontalPadding,),
        Expanded(
          child: _buildItem(
              title: '上周',
              data: widget.lastWeekRevenue,
              imgPath: _appImageTheme.imageProfileContactLastWeekItem,
              titleTextStyle:
              _appTextTheme.profileContactLastWeekTitleTextStyle,
              contentTextStyle:
              _appTextTheme.profileContactLastWeekContentTextStyle),
        ),

      ],
    );
  }

  _buildItem(
      {required String title,
        required num data,
        required String imgPath,
        required TextStyle titleTextStyle,
        required TextStyle contentTextStyle,}) {
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: WidgetValue.horizontalPadding,
          vertical: WidgetValue.verticalPadding),
      decoration: BoxDecoration(
        image: DecorationImage(
            image: Image.asset(imgPath).image, fit: BoxFit.fill),
      ),
      child: SizedBox(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: titleTextStyle),
            Text('$data', style: contentTextStyle),
          ],
        ),
      ),
    );
  }

}
