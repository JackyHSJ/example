import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frechat/models/ws_req/mission/ws_mission_get_award_req.dart';
import 'package:frechat/screens/profile/setting/teen/personal_setting_teen_view_model.dart';
import 'package:frechat/system/base_view_model.dart';
import 'package:frechat/system/constant/enum.dart';
import 'package:frechat/system/providers.dart';
import 'package:frechat/system/repository/response_code.dart';
import 'package:frechat/widgets/constant_value.dart';
import 'package:frechat/widgets/shared/dialog/comm_dialog.dart';
import 'package:frechat/widgets/shared/img_util.dart';
import 'package:frechat/widgets/shared/main_textfield.dart';
import 'package:frechat/widgets/theme/app_box_decoration_theme.dart';
import 'package:frechat/widgets/theme/app_color_theme.dart';
import 'package:frechat/widgets/theme/app_image_theme.dart';
import 'package:frechat/widgets/theme/app_linear_gradient_theme.dart';
import 'package:frechat/widgets/theme/app_text_theme.dart';
import 'package:frechat/widgets/theme/app_theme.dart';
import 'package:frechat/widgets/theme/original/app_colors.dart';
import 'package:frechat/widgets/theme/uidefine.dart';

// import '../../../theme/app_colors.dart';

class PersonalMissionDialog extends ConsumerStatefulWidget {

  final num target;
  final String title;
  final String subTitle;
  final int count;
  final int gender;

  const PersonalMissionDialog({
    super.key,
    required this.target,
    required this.title,
    required this.subTitle,
    required this.count,
    required this.gender,
  });

  @override
  ConsumerState<PersonalMissionDialog> createState() => _PersonalMissionDialogState();
}

class _PersonalMissionDialogState extends ConsumerState<PersonalMissionDialog> {
  FocusNode _focusNode = FocusNode();

  num get target => widget.target;
  String get title => widget.title;
  String get subTitle => widget.subTitle;
  int get count => widget.count;
  int get gender => widget.gender;

  late AppTheme _theme;
  late AppImageTheme _appImageTheme;
  late AppTextTheme _appTextTheme;
  late AppLinearGradientTheme _appLinearGradientTheme;
  late AppBoxDecorationTheme _appBoxDecorationTheme;

  Future<void> _getMissionAward() async {
    String? resultCodeCheck;
    final reqBody = WsMissionGetAwardReq.create(target: widget.target.toString());
    await ref.read(missionWsProvider).wsMissionGetAward(reqBody,
        onConnectSuccess: (succMsg) => resultCodeCheck = succMsg,
        onConnectFail: (errMsg) => BaseViewModel.showToast(context, ResponseCode.map[errMsg]!));

    setState(() {});
  }



  @override
  Widget build(BuildContext context) {
    FocusScope.of(context).requestFocus(_focusNode);

    _theme = ref.watch(userInfoProvider).theme ?? AppTheme(themeType: AppThemeType.original);
    _appImageTheme = _theme.getAppImageTheme;
    _appTextTheme = _theme.getAppTextTheme;
    _appLinearGradientTheme = _theme.getAppLinearGradientTheme;
    _appBoxDecorationTheme = _theme.getAppBoxDecorationTheme;
    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal:16.w),
      child: Container(
        decoration:_appBoxDecorationTheme.dialogBoxDecoration,
        padding: EdgeInsets.symmetric(vertical: 16.h,horizontal: 16.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildTitle(),
            _buildContentWidget(),
            _buildActionsBtn(),
          ],
        ),
      ),
    );



    return AlertDialog(
      backgroundColor: AppColors.whiteBackGround,
      surfaceTintColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: WidgetValue.horizontalPadding),
      actionsPadding: const EdgeInsets.only(right: 16, bottom: 20, left: 16),
      titlePadding: const EdgeInsets.only(top: 20, right: 16, left: 16),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
      actionsAlignment: MainAxisAlignment.center,
      title: _buildTitle(),
      content: _buildContentWidget(),
      actions: [
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildConfirmBtn(),
            _buildBenefitText(),
          ],
        )
      ],

      /// 这里定义了圆角
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(WidgetValue.btnRadius), // 你可以调整这个值来改变圆角的大小
      ),
    );
  }

  Widget _buildTitle() {
    final String stageLabel = target < 4 ? '完成新手任务' : '完成每日任务';
    return Text(
      stageLabel,
      style: _appTextTheme.missionDialogTitleTextStyle,
      textAlign: TextAlign.center,
    );
  }

  Widget _buildContentWidget() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 4),
        _buildSubTitle(),
        const SizedBox(height: 15),
        ImgUtil.buildFromImgPath(_appImageTheme.missionCompleteImage, width: 139.25, height: 150),
        const SizedBox(height: 11),
        _buildMissionTitle(),
        const SizedBox(height: 4),
        _buildMissionSubTitle(),
        const SizedBox(height: 20),
      ],
    );
  }


  Widget _buildSubTitle() {
    // final String type = gender == 0  ? '积分' : '金币';
    String type = '金币';
    return Text(
      '+$count $type',
      style: _appTextTheme.missionDialogSubTitleTextStyle,
      textAlign: TextAlign.center,
    );
  }

  Widget _buildMissionTitle() {
    return Text(
      title,
      style: _appTextTheme.missionDialogContentBoldTextStyle,
      textAlign: TextAlign.center,
    );
  }

  Widget _buildMissionSubTitle() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Text(
        subTitle,
        style: _appTextTheme.missionDialogContentTextStyle,
        textAlign: TextAlign.center,
      ),
    );
  }


  _buildActionsBtn(){
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildConfirmBtn(),
        _buildBenefitText(),
      ],
    );
  }

  _buildConfirmBtn() {
    return InkWell(

      onTap: () async {
        await _getMissionAward();
        if (context.mounted) BaseViewModel.popPage(context);
      },
      child: Container(
        alignment: Alignment.center,
        width: UIDefine.getWidth(),
        height: 50,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(WidgetValue.btnRadius * 2),gradient:  _appLinearGradientTheme.buttonPrimaryColor),
        child:  Text('确认',  style: _appTextTheme.buttonPrimaryTextStyle),
      ),
    );
  }

  _buildBenefitText() {
    return Container(
      alignment: Alignment.center,
      width: UIDefine.getWidth(),
      height: 50,
      child: Text('奖励已存放至你的收益', style: _appTextTheme.missionDialogContentTextStyle,),
    );
  }

}
