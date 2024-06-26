import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frechat/models/ws_res/check_in/ws_check_in_search_list_res.dart';
import 'package:frechat/screens/profile/check_in/personal_check_in_view_model.dart';
import 'package:frechat/system/base_view_model.dart';
import 'package:frechat/system/constant/enum.dart';
import 'package:frechat/system/providers.dart';
import 'package:frechat/widgets/constant_value.dart';
import 'package:frechat/widgets/profile/cell/personal_check_in_cell.dart';
import 'package:frechat/widgets/shared/buttons/common_button.dart';
import 'package:frechat/widgets/shared/dialog/base_dialog.dart';
import 'package:frechat/widgets/shared/bottom_sheet/recharge/calling_recharge_sheet.dart';
import 'package:frechat/widgets/shared/dialog/check_in_dialog.dart';
import 'package:frechat/widgets/shared/dialog/comm_dialog.dart';
import 'package:frechat/widgets/shared/loading_animation.dart';
import 'package:frechat/widgets/theme/app_box_decoration_theme.dart';
import 'package:frechat/widgets/theme/app_color_theme.dart';
import 'package:frechat/widgets/theme/app_theme.dart';
import 'package:frechat/widgets/theme/original/app_colors.dart';

class PersonalCheckIn extends ConsumerStatefulWidget {
  const PersonalCheckIn({super.key, this.needTopBar = true});
  final bool needTopBar;

  @override
  ConsumerState<PersonalCheckIn> createState() => _PersonalCheckInState();
}

class _PersonalCheckInState extends ConsumerState<PersonalCheckIn> {

  late AppTheme theme;
  late AppBoxDecorationTheme appBoxDecoration;
  late AppColorTheme appColorTheme;


  bool get needTopBar => widget.needTopBar;

  @override
  void initState() {
    PersonalCheckInViewModel.init(context, ref, setState);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    theme = ref.watch(userInfoProvider).theme ?? AppTheme(themeType: AppThemeType.original);
    appBoxDecoration = theme.getAppBoxDecorationTheme;
    appColorTheme = theme.getAppColorTheme;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: needTopBar ? 10 : 0, vertical: needTopBar ? 10 : 0),
      decoration: needTopBar ? appBoxDecoration.checkInBoxDecoration : null,
      child: Column(
        children: [
          Visibility(
            visible: needTopBar,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('每日签到', style: TextStyle(color: appColorTheme.checkInTitleTextColor, fontWeight: FontWeight.w700, fontSize: 18)),
                _buildCheckInBtn()
              ]
            ),
          ),
          const SizedBox(height: 18),
          _buildList()
        ],
      ),
    );
  }

  _buildList() {
    final WsCheckInSearchListRes? searchList = ref.watch(userInfoProvider).checkInSearchList;
    final List<CheckInListInfo> list = searchList?.list ?? [];
    final num todayCount = searchList?.todayCount ?? 0;

    //這個似乎沒用途?
    // final continuousNum = PersonalCheckInViewModel.checkInInfo?.continuousNum ?? 0;

    final bool isEmpty = list.isEmpty;
    return isEmpty ? LoadingAnimation.discreteCircle(size: WidgetValue.userMonsterImg) :  Column(
      children: [
        Row(children: [
          Expanded(
              child: PersonalCheckInCell(
                  todayCount: todayCount, model: list[0], gifName: list[0].giftName!, giftImageUrl: list[0].giftUrl, gifId: list[0].giftId)),
          SizedBox(width: WidgetValue.separateHeight),
          Expanded(
              child: PersonalCheckInCell(
                  todayCount: todayCount, model: list[1], gifName: list[1].giftName!, giftImageUrl: list[1].giftUrl, gifId: list[1].giftId)),
          SizedBox(width: WidgetValue.separateHeight),
          Expanded(
              child: PersonalCheckInCell(
                  todayCount: todayCount, model: list[2], gifName: list[2].giftName!, giftImageUrl: list[2].giftUrl, gifId: list[2].giftId)),
          SizedBox(width: WidgetValue.separateHeight),
          Expanded(
              child: PersonalCheckInCell(
                  todayCount: todayCount, model: list[3], gifName: list[3].giftName!, giftImageUrl: list[3].giftUrl, gifId: list[3].giftId)),
        ]),
        SizedBox(height: WidgetValue.separateHeight),
        Row(
          children: [
            Expanded(
                flex: 1,
                child: PersonalCheckInCell(
                    todayCount: todayCount, model: list[4], gifName: list[4].giftName!, giftImageUrl: list[4].giftUrl, gifId: list[4].giftId)),
            SizedBox(width: WidgetValue.separateHeight),
            Expanded(
                flex: 1,
                child: PersonalCheckInCell(
                    todayCount: todayCount, model: list[5], gifName: list[5].giftName!, giftImageUrl: list[5].giftUrl, gifId: list[5].giftId)),
            SizedBox(width: WidgetValue.separateHeight),
            Expanded(
                flex: 2,
                child: PersonalCheckInCell(
                    isLastDay: true,
                    todayCount: todayCount,
                    model: list[6],
                    gifName: list[6].giftName!,
                    giftImageUrl: list[6].giftUrl,
                    gifId: list[6].giftId)),
          ],
        ),
      ],
    );
  }

  _buildCheckInBtn() {
    final bool btnEnable = PersonalCheckInViewModel.todayIsAlreadyCheck(ref) == false;
    return GestureDetector(
      onTap: () {
        if (btnEnable == false) return;
        showCheckInDialog();
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 3.5.h),
        decoration: btnEnable ? appBoxDecoration.checkInBtnBoxDecoration : appBoxDecoration.checkInBtnDisableBoxDecoration,
        child: Text(btnEnable ? '去签到' : '已签到',
          style: TextStyle(color: appColorTheme.checkInBtnTextColor, fontWeight: FontWeight.w500, fontSize: 12, height: 1.5),
        ),
      ),
    );
  }

  void showCheckInDialog() {


    BaseDialog(context).showTransparentDialog(
      widget: CheckInDialog(
        title: '每日签到',
        isBtnEnable: true,
        onSuccess: () {
          setState(() {});
          PersonalCheckInViewModel.loadPropertyInfo(context, ref: ref);
        },
      ),
    );
  }
}
