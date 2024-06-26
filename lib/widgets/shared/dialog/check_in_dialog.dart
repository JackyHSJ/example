import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frechat/models/ws_res/check_in/ws_check_in_search_list_res.dart';
import 'package:frechat/screens/profile/check_in/personal_check_in.dart';
import 'package:frechat/screens/profile/check_in/personal_check_in_view_model.dart';
import 'package:frechat/system/base_view_model.dart';
import 'package:frechat/system/call_back_function.dart';
import 'package:frechat/system/constant/enum.dart';
import 'package:frechat/system/providers.dart';
import 'package:frechat/system/repository/response_code.dart';
import 'package:frechat/widgets/constant_value.dart';
import 'package:frechat/widgets/shared/dialog/base_dialog.dart';
import 'package:frechat/widgets/shared/dialog/check_in_succ_dialog.dart';
import 'package:frechat/widgets/shared/gradient_component.dart';
import 'package:frechat/widgets/shared/loading_animation.dart';
import 'package:frechat/widgets/theme/app_box_decoration_theme.dart';
import 'package:frechat/widgets/theme/app_color_theme.dart';
import 'package:frechat/widgets/theme/app_theme.dart';
import 'package:frechat/widgets/theme/uidefine.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../theme/original/app_colors.dart';

class CheckInDialog extends ConsumerStatefulWidget {

  String title;
  MainAxisAlignment? mainAxisAlignment;
  EdgeInsetsGeometry? contentPadding;
  EdgeInsets? insetPadding;
  bool isBtnEnable;
  bool toCheckInSuccess;
  Function() onSuccess;

  CheckInDialog({
    super.key,
    required this.title,
    this.mainAxisAlignment = MainAxisAlignment.center,
    this.contentPadding,
    this.insetPadding,
    required this.isBtnEnable,
    this.toCheckInSuccess = false,
    required this.onSuccess,
  });




  @override
  ConsumerState<CheckInDialog> createState() => _CheckInDialogState();
}

class _CheckInDialogState extends ConsumerState<CheckInDialog> {
  String get title => widget.title;
  MainAxisAlignment? get mainAxisAlignment => widget.mainAxisAlignment;
  EdgeInsetsGeometry? get contentPadding => widget.contentPadding;
  EdgeInsets? get insetPadding => widget.insetPadding;
  bool get isBtnEnable => widget.isBtnEnable;
  bool get toCheckInSuccess => widget.toCheckInSuccess;
  Function() get onSuccess => widget.onSuccess;
  bool isLoading = false;

  late AppTheme _theme;
  late AppBoxDecorationTheme _appBoxDecoration;
  late AppColorTheme _appColorTheme;



  @override
  Widget build(BuildContext context) {

    _theme = ref.watch(userInfoProvider).theme ?? AppTheme(themeType: AppThemeType.original);
    _appBoxDecoration = _theme.getAppBoxDecorationTheme;
    _appColorTheme = _theme.getAppColorTheme;

    return isLoading ? _buildLoading() : _buildMainContent();
  }


  Widget _buildLoading() {
    return LoadingAnimation.discreteCircle(color: _appColorTheme.primaryColor);
  }

  Widget _buildMainContent() {
    return AlertDialog(
      surfaceTintColor: Colors.transparent,
      backgroundColor: _appBoxDecoration.cellBoxDecoration.color,
      insetPadding: insetPadding ?? EdgeInsets.symmetric(horizontal: WidgetValue.horizontalPadding),
      title: Text(title, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20, color: _appColorTheme.checkInTitleTextColor), textAlign: TextAlign.center,),
      content: _buildContent(toCheckInSuccess),
      contentPadding: contentPadding ?? EdgeInsets.symmetric(horizontal: 14),
      buttonPadding: EdgeInsets.only(left: 14, right: 14, bottom: 20.0),
      actionsAlignment: mainAxisAlignment,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
        side: BorderSide(
          width: _appBoxDecoration.cellBoxDecoration.border!.top.width,
          color: _appBoxDecoration.cellBoxDecoration.border!.top.color
        ),
      ),
      actions: [
        InkWell(
          onTap: () async {
            String? resultCodeCheck;
            isLoading = true;
            setState(() {});
            await PersonalCheckInViewModel.checkIn(context, ref, setState,
                onConnectSuccess: (succMsg) => resultCodeCheck = succMsg
            );
            isLoading = false;
            if(resultCodeCheck == ResponseCode.CODE_SUCCESS) {
              BaseViewModel.popPage(context);
              BaseDialog(context).showTransparentDialog(
                  widget: CheckInSuccDialog(
                      title: '签到成功',
                      isBtnEnable: true
                  )
              );
              onSuccess();
            }
            setState(() {});
          },
          child: Container(
            padding: EdgeInsets.symmetric(vertical: WidgetValue.verticalPadding * 1.5),
            width: double.maxFinite,
            decoration: isBtnEnable ? _appBoxDecoration.checkInBtnBoxDecoration : _appBoxDecoration.checkInBtnDisableBoxDecoration,
            child: Text('签到', textAlign: TextAlign.center, style: TextStyle(color: _appColorTheme.checkInBtnTextColor, fontWeight: FontWeight.w600)),
          ),
        )
      ],
    );
  }

  _buildContent(bool toCheckInSuccess) {
    return Consumer(builder: (context, ref, _){
      final WsCheckInSearchListRes? checkInInfo = ref.watch(userInfoProvider).checkInSearchList;
      final num continuousNum = checkInInfo?.continuousNum ?? 0;
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildCellOrSucc(toCheckInSuccess),
          Padding(
            padding: EdgeInsets.symmetric(vertical: WidgetValue.verticalPadding * 2),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('已连续签到', style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16, color: _appColorTheme.checkInTitleTextColor)),
                Text(' $continuousNum ', style: TextStyle(color: AppColors.mainYellow, fontWeight: FontWeight.w600, fontSize: 16)),
                Text('天', style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16, color: _appColorTheme.checkInTitleTextColor))
              ],
            ),
          ),
        ],
      );
    });
  }

  _buildAlreadyAward() {
    return Transform.rotate(
      /// 旋轉角度
      angle: 30 * pi / 180,  // 旋转45度
      child: MainGradient(linearGradient: AppColors.labelOrangeColors).icon(
          iconData: MdiIcons.checkDecagram,
          iconSize: 30
      ),
    );
  }

  _buildCellOrSucc(bool toCheckInSuccess) {
    if (toCheckInSuccess){
      return Consumer(builder: (context, ref, _){
        final WsCheckInSearchListRes? checkInInfo = ref.watch(userInfoProvider).checkInSearchList;
        final today = checkInInfo?.todayCount ?? 0;
        final int index = checkInInfo?.list?.indexWhere((info) => info.day == today) ?? 0;
        final num goldNum = checkInInfo?.list?[index].gold ?? 0;
        return Stack(
          alignment: Alignment.topRight,
          children: [
            Container(
              width: UIDefine.getWidth(),
              padding: EdgeInsets.symmetric(vertical: WidgetValue.verticalPadding),
              decoration: BoxDecoration(
                  color: AppColors.btnOrangeBackGround,
                  borderRadius: BorderRadius.circular(WidgetValue.btnRadius)
              ),
              child: Column(
                children: [
                  Image.asset('assets/profile/profile_check_in_icon_3.png', width: WidgetValue.userBigImg),
                  MainGradient().text(title: '金币+$goldNum', fontSize: 16, fontWeight: FontWeight.w800),
                ],
              ),
            ),
            _buildAlreadyAward(),
            // Loading的Widget
          ],
        );
      });
    } else {
      return PersonalCheckIn(needTopBar: false);
    }
  }
}