import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:frechat/screens/profile/setting/iap/personal_setting_iap.dart';
import 'package:flutter_screenutil/src/size_extension.dart';
import 'package:frechat/system/base_view_model.dart';
import 'package:frechat/system/constant/enum.dart';
import 'package:frechat/system/providers.dart';
import 'package:frechat/widgets/constant_value.dart';
import 'package:frechat/widgets/shared/buttons/common_button.dart';
import 'package:frechat/widgets/theme/app_box_decoration_theme.dart';
import 'package:frechat/widgets/theme/app_linear_gradient_theme.dart';
import 'package:frechat/widgets/theme/app_text_theme.dart';
import 'package:frechat/widgets/theme/app_theme.dart';
import 'package:frechat/widgets/theme/original/app_colors.dart';


class PersonalSettingCharmDialog extends ConsumerStatefulWidget {

  final String message;

  const PersonalSettingCharmDialog({
    super.key,
    required this.message
  });

  @override
  ConsumerState<PersonalSettingCharmDialog> createState() => _PersonalSettingCharmState();
}

class _PersonalSettingCharmState extends ConsumerState<PersonalSettingCharmDialog> {
  late AppTheme _theme;
  late AppTextTheme _appTextTheme;
  late AppLinearGradientTheme _appLinearGradientTheme;
  late AppBoxDecorationTheme _appBoxDecorationTheme;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    _theme = ref.watch(userInfoProvider).theme ?? AppTheme(themeType: AppThemeType.original);
    _appTextTheme = _theme.getAppTextTheme;
    _appLinearGradientTheme = _theme.getAppLinearGradientTheme;
    _appBoxDecorationTheme = _theme.getAppBoxDecorationTheme;

    final message = widget.message;

    List<String> messages;
    messages = message.split('\\n');

    if (messages.length <= 1) messages = message.split('\n');

    Map<String, String> dataMap = {};

    for (int i = 0; i < messages.length; i++) {
      dataMap['$i'] = messages[i];
    }

    String title = dataMap['0'] ?? '';
    String des = dataMap['1'] ?? '';
    String messageCall = dataMap['2'] ?? '';
    String voiceCall = dataMap['3'] ?? '';
    String videoCall = dataMap['4'] ?? '';

    return AlertDialog(
      backgroundColor: _appBoxDecorationTheme.cellBoxDecoration.color,
      surfaceTintColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: WidgetValue.horizontalPadding),
      actionsPadding: const EdgeInsets.only(right: 16, bottom: 20, left: 16),
      titlePadding: const EdgeInsets.only(top: 20, right: 16, left: 16),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
      actionsAlignment: MainAxisAlignment.center,
      title: _buildTitle(title),
      content: _buildContentWidget(des,messageCall, voiceCall, videoCall),
      actions: [_buildButtons()],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
        side: BorderSide(
            width: _appBoxDecorationTheme.cellBoxDecoration.border!.top.width,
            color: _appBoxDecorationTheme.cellBoxDecoration.border!.top.color
        ),
      ),
    );
  }

  Widget _buildTitle(title){

    return Text(
      title,
      style: _appTextTheme.personalSettingCharmDialogTitleTextStyle,
      textAlign: TextAlign.center,
    );
  }

  Widget _buildContentWidget(String des, String messageCall, String voiceCall, String videoCall) {
    return Container(
      padding: const EdgeInsets.only(top: 4, bottom: 20),
      constraints: const BoxConstraints(minWidth: 311),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildPriceList(des, messageCall, voiceCall, videoCall),
        ],
      ),
    );
  }

  Widget _buildPriceList(String des, String messageCall, String voiceCall, String videoCall){

    return Column(
      children: [
        _buildPriceText(des),
        _buildPriceText(messageCall),
        _buildPriceText(voiceCall),
        _buildPriceText(videoCall)
      ],
    );
  }

  Widget _buildPriceText(String text){

    return Text(
      text,
      style: _appTextTheme.personalSettingCharmDialogContentTextStyle
    );
  }

  Widget _buildButtons(){
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(
          child: _buildLeftBtn(
            title: '先等等',
            linearGradient: _appLinearGradientTheme.personalSettingCharmDialogLeftButtonLinearGradient,
            textStyle: _appTextTheme.personalSettingCharmDialogLeftButtonTextStyle,
            action: () => BaseViewModel.popPage(context),
          ),
        ),
        SizedBox(
          width: WidgetValue.separateHeight,
        ),
        Expanded(
          child: _buildRightBtn(
            title: '前往设置',
            linearGradient: _appLinearGradientTheme.personalSettingCharmDialogRightButtonLinearGradient,
            textStyle: _appTextTheme.personalSettingCharmDialogRightButtonTextStyle,
            action: () {
              BaseViewModel.popPage(context);
              BaseViewModel.pushPage(context, const PersonalSettingIAP(),
              );
            },
          ),
        ),
      ],
    );
  }

  _buildLeftBtn({
    String? title,
    TextStyle? textStyle,
    LinearGradient? linearGradient,
    Border? broder,
    required Function() action
  }) {

    if (title == null){
      return Container();
    }

    return CommonButton(
      onTap: () => action(),
      btnType: CommonButtonType.text,
      cornerType: CommonButtonCornerType.round,
      isEnabledTapLimitTimer: false,
      text: title,
      textStyle: textStyle ?? const TextStyle(color:  AppColors.mainPink, fontWeight: FontWeight.w400),
      colorBegin: linearGradient?.colors.first,
      colorEnd: linearGradient?.colors.last,
      colorAlignmentBegin: linearGradient?.begin ??Alignment.topCenter,
      colorAlignmentEnd: linearGradient?.end ?? Alignment.bottomCenter,
      broder: broder ,
    );
  }

  _buildRightBtn({
    String? title,
    TextStyle? textStyle,
    LinearGradient? linearGradient,
    Border? broder,
    required Function() action
  }) {

    if (title == null){
      return Container();
    }

    return CommonButton(
      onTap: () => action(),
      btnType: CommonButtonType.text,
      cornerType: CommonButtonCornerType.round,
      isEnabledTapLimitTimer: false,
      text: title,
      textStyle: textStyle ?? const TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
      colorAlignmentBegin: linearGradient?.begin ??Alignment.topCenter,
      colorAlignmentEnd: linearGradient?.end ?? Alignment.bottomCenter,
      colorBegin: linearGradient?.colors.first,
      colorEnd: linearGradient?.colors.last,
      broder: broder ,
    );
  }
}