import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frechat/screens/profile/edit/intro/personal_edit_intro_view_model.dart';
import 'package:frechat/system/base_view_model.dart';
import 'package:frechat/system/constant/enum.dart';
import 'package:frechat/system/providers.dart';
import 'package:frechat/widgets/constant_value.dart';
import 'package:frechat/widgets/shared/app_bar.dart';
import 'package:frechat/widgets/shared/img_util.dart';
import 'package:frechat/widgets/shared/main_scaffold.dart';
import 'package:frechat/widgets/shared/main_textfield.dart';
import 'package:frechat/widgets/theme/app_color_theme.dart';
import 'package:frechat/widgets/theme/original/app_colors.dart';
import 'package:frechat/widgets/theme/app_image_theme.dart';
import 'package:frechat/widgets/theme/app_theme.dart';
import 'package:frechat/widgets/theme/uidefine.dart';
import 'package:flutter_screenutil/src/size_extension.dart';

import '../../../../widgets/theme/app_text_theme.dart';

// 自我介绍
class PersonalEditIntro extends ConsumerStatefulWidget {

  const PersonalEditIntro({super.key});

  @override
  ConsumerState<PersonalEditIntro> createState() => _IntroMyselfState();
}

class _IntroMyselfState extends ConsumerState<PersonalEditIntro> {
  late PersonalEditIntroViewModel viewModel;
  TextEditingController textEditingController = TextEditingController();
  int textCount = 0;
  late AppTheme _theme;
  late AppColorTheme _appColorTheme;
  late AppTextTheme _appTextTheme;
  late AppImageTheme _appImageTheme;

  @override
  void initState() {
    viewModel = PersonalEditIntroViewModel();
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
    _appTextTheme = _theme.getAppTextTheme;
    _appImageTheme = _theme.getAppImageTheme;
    final double paddingHeight =
        UIDefine.getAppBarHeight() + UIDefine.getStatusBarHeight();
    return MainScaffold(
      padding: EdgeInsets.only(
          top: paddingHeight,
          bottom: WidgetValue.bottomPadding,
          left: WidgetValue.horizontalPadding,
          right: WidgetValue.horizontalPadding),
      isFullScreen: true,
      backgroundColor:  _appColorTheme.baseBackgroundColor,
      appBar:  _appBar(),
      child: Column(
        children: [
          _buildIntroTextField(),
        ],
      ),
    );
  }
  MainAppBar _appBar(){
    return MainAppBar(
      theme: _theme,
      title: '',
      backgroundColor: _appColorTheme.appBarBackgroundColor,
      titleWidget: Text(' 自我介绍', style: _appTextTheme.appbarTextStyle),
      leading: IconButton(
        icon: ImgUtil.buildFromImgPath(_appImageTheme.iconBack, size: 24.w),
        onPressed: () => BaseViewModel.popPage(context),
      ),
      actions: [_buildSaveBtn()],
    );
  }

  Widget _buildSaveBtn() {
    return InkWell(
      child: Container(
        alignment: Alignment.centerRight,
        margin: EdgeInsets.only(right: 16.w),
        child: Text('保存', style: _appTextTheme.appbarActionTextStyle),
      ),
      onTap: () {
        BaseViewModel.popPage(context,sendMessage: viewModel.controller.text);
        BaseViewModel.showToast(context, '记得再次点击保存才会储存设定哦');
      },
    );
  }

  Widget _buildIntroTextField() {
    return Stack(
      children: [
        SizedBox(
          height: 160,
          child: MainTextField(
            radius: 12,
            hintText: '简单介绍一下自己吧',
            counterText: '',
            fontColor: _appTextTheme.normalMainTextFieldTextStyle.color,
            fontWeight: _appTextTheme.normalMainTextFieldTextStyle.fontWeight,
            fontSize: _appTextTheme.normalMainTextFieldTextStyle.fontSize,
            hintStyle: _appTextTheme.normalMainTextFieldHintTextStyle,
            backgroundColor:_appColorTheme.textFieldBackgroundColor,
            borderColor: _appColorTheme.textFieldBorderColor,
            controller: viewModel.controller,
            maxLength: 100,
            enableMultiLines: true,
            hintColor: AppColors.mainGrey,
            onChanged: (text){
              textCount = viewModel.controller.text.length;
              setState(() {});
            },
          ),
        ),
        Positioned(
          right: 12,
          bottom: 10,
          child: Text(
            "$textCount/100",
            style: const TextStyle(
              fontWeight: FontWeight.w400,
              color: AppColors.mainGrey,
            ),
          ),
        )
      ],
    );
  }


}
