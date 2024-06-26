
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frechat/screens/profile/setting/privacy_setting/privacy_setting_view_model.dart';
import 'package:frechat/system/base_view_model.dart';
import 'package:frechat/system/constant/enum.dart';
import 'package:frechat/system/provider/user_info_provider.dart';
import 'package:frechat/system/providers.dart';
import 'package:frechat/widgets/shared/picker.dart';
import 'package:frechat/widgets/shared/switch_button.dart';
import 'package:frechat/widgets/theme/app_box_decoration_theme.dart';
import 'package:frechat/widgets/theme/app_color_theme.dart';
import 'package:frechat/widgets/theme/original/app_colors.dart';
import 'package:frechat/widgets/theme/app_image_theme.dart';
import 'package:frechat/widgets/theme/app_linear_gradient_theme.dart';
import 'package:frechat/widgets/theme/app_text_theme.dart';
import 'package:frechat/widgets/theme/app_theme.dart';

class PrivacySettingPage extends ConsumerStatefulWidget {
  const PrivacySettingPage({Key? key}) : super(key: key);

  @override
  ConsumerState<PrivacySettingPage> createState() => _PrivacySettingPageState();
}

class _PrivacySettingPageState extends ConsumerState<PrivacySettingPage> {
  late PrivacyViewModel viewModel;
  late AppTheme _theme;
  late AppColorTheme _appColorTheme;
  late AppImageTheme _appImageTheme;
  late AppTextTheme _appTextTheme;
  late AppLinearGradientTheme _appLinearGradientTheme;
  late AppBoxDecorationTheme _appBoxDecorationTheme;

  @override
  void initState() {
    viewModel = PrivacyViewModel();
    viewModel.init();
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
    _appColorTheme = _theme.getAppColorTheme;
    _appImageTheme = _theme.getAppImageTheme;
    _appTextTheme = _theme.getAppTextTheme;
    _appLinearGradientTheme = _theme.getAppLinearGradientTheme;
    _appBoxDecorationTheme = _theme.getAppBoxDecorationTheme;

    bool isClosePersonalizedRecommendationsStatus = ref.watch(userInfoProvider).isClosePersonalizedRecommendations ?? false;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "隐私设置",
          style: _appTextTheme.appbarTextStyle,
        ),
        elevation: 0,
        backgroundColor: _appColorTheme.appBarBackgroundColor,
        centerTitle: true,
          leading: GestureDetector(
            child: Padding(
              padding: EdgeInsets.all(14),
              child: Image(
                image: AssetImage(_appImageTheme.iconBack),
              ),
            ),
            onTap: () => BaseViewModel.popPage(context),
          )
      ),
      backgroundColor: _appColorTheme.baseBackgroundColor,
      body: GestureDetector(
        onTap: () => BaseViewModel.clearAllFocus(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            switchItem(title:"个性化推荐", status:!isClosePersonalizedRecommendationsStatus, onToggle:(val) async {
              ref.read(userUtilProvider.notifier).setDataToPrefs(isClosePersonalizedRecommendations: !val);
              setState(() {});
            }),
            Padding(padding: EdgeInsets.only(left: 28.w,top: 4.h),
              child: Text(
                '关闭后，将无法使用缘分页的推荐功能',
                style: TextStyle(
                  fontSize: 12.sp,
                  color: AppColors.textGrey
                ),
              )),
            // (Platform.isIOS)?_buildThemeItem(appLinearGradientTheme, appTextTheme, title:"主题切换"):Container(),
          ],
        ),
      ),
    );
  }

  _buildThemeItem(AppLinearGradientTheme appLinearGradientTheme, AppTextTheme appTextTheme, {
    required String title
  }) {
    return Container(
        height: 70.h,
        margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
        padding:  EdgeInsets.symmetric(horizontal: 12.w),
        decoration: _appBoxDecorationTheme.cellBoxDecoration,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: appTextTheme.cellListMainTextStyle),
            _buildBtn(appLinearGradientTheme, appTextTheme),
          ],
        ));
  }

  _buildBtn(AppLinearGradientTheme appLinearGradientTheme, AppTextTheme appTextTheme) {
    return InkWell(
      onTap: () => _buildPicker(0, viewModel.typeList),
      child: Container(
        padding:  EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
        decoration: BoxDecoration(
          gradient: appLinearGradientTheme.buttonPrimaryColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text('选择', style: appTextTheme.buttonPrimaryTextStyle),
      ),
    );
  }

  //選項item(有開關)
  Widget switchItem({required String title, required bool status,required Function (bool) onToggle}) {
    return Container(
        height: 70.h,
        margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
        padding:  EdgeInsets.symmetric(horizontal: 12.w),
        decoration: _appBoxDecorationTheme.cellBoxDecoration,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: _appTextTheme.cellListMainTextStyle),
            SwitchButton(
              enable: status,
              onChange: (val) => onToggle.call(val),
            ),
          ],
        ));
  }

  void _buildPicker(int defaultIndex, List<AppThemeType?> list) {
    FixedExtentScrollController fixedExtentScrollController = FixedExtentScrollController(initialItem: defaultIndex);
    final UserNotifier userUtil = ref.read(userUtilProvider.notifier);
    Picker.iconDataPicker(context,
        length: list.length,
        defaultIndex: defaultIndex,
        appTheme: _theme,
        fixedExtentScrollController: fixedExtentScrollController,
        itemBuilder: (context, index) => _buildPickerItem(index, list),
        onSelect: (selectIndex) {
          viewModel.selectTheme(selectIndex, userUtil);
          BaseViewModel.popPage(context);
        },
        onCancel: () => BaseViewModel.popPage(context)
    );
  }

  _buildPickerItem(int index, List<AppThemeType?> list) {
    final String title = viewModel.getPickerItemTitle(list[index]);
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(title,style: _appTextTheme.pickerDialogContentTextStyle),
        ],
      ),
    );
  }
}
