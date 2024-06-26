import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frechat/screens/profile/edit/nick_name/personal_edit_nick_name_view_model.dart';
import 'package:frechat/system/base_view_model.dart';
import 'package:frechat/system/constant/enum.dart';
import 'package:frechat/system/providers.dart';
import 'package:frechat/widgets/constant_value.dart';
import 'package:frechat/widgets/shared/app_bar.dart';
import 'package:frechat/widgets/shared/img_util.dart';
import 'package:frechat/widgets/shared/main_scaffold.dart';
import 'package:frechat/widgets/shared/main_textfield.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frechat/widgets/theme/app_box_decoration_theme.dart';
import 'package:frechat/widgets/theme/app_color_theme.dart';
import 'package:frechat/widgets/theme/app_image_theme.dart';
import 'package:frechat/widgets/theme/app_text_theme.dart';
import 'package:frechat/widgets/theme/app_theme.dart';


import '../../../../widgets/theme/original/app_colors.dart';
import '../../../../widgets/theme/uidefine.dart';

class PersonalEditNickName extends ConsumerStatefulWidget {
  const PersonalEditNickName({super.key});

  @override
  ConsumerState<PersonalEditNickName> createState() => _PersonalEditNickNameState();
}

class _PersonalEditNickNameState extends ConsumerState<PersonalEditNickName> {
  late PersonalEditNickNameViewModel viewModel;
  late AppTheme _theme;
  late AppColorTheme _appColorTheme;
  late AppTextTheme _appTextTheme;
  late AppImageTheme _appImageTheme;
  late AppBoxDecorationTheme _appBoxDecorationTheme;

  @override
  void initState() {
    viewModel = PersonalEditNickNameViewModel();
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
    final double paddingHeight = UIDefine.getAppBarHeight() + UIDefine.getStatusBarHeight();
    _theme = ref.watch(userInfoProvider).theme ?? AppTheme(themeType: AppThemeType.original);
    _appColorTheme = _theme.getAppColorTheme;
    _appTextTheme = _theme.getAppTextTheme;
    _appImageTheme = _theme.getAppImageTheme;
    _appBoxDecorationTheme = _theme.getAppBoxDecorationTheme;

    // RoundedTextField(
    //   textEditingController: viewModel.phoneController,
    //   focusNode: viewModel.phoneInputFocus,
    //   focusBorderColor: appColorTheme.textFieldFocusingColor,
    //   textInputType: TextInputType.number,
    //   prefixIcon: Padding(
    //     padding: const EdgeInsets.all(9),
    //     child: Image(
    //       image: AssetImage(appImageTheme.iconPhone),
    //     ),
    //   ),
    //   suffixIcon: (viewModel.phoneController.text == "")
    //       ? null
    //       : GestureDetector(
    //     child: const Padding(
    //         padding: EdgeInsets.all(12),
    //         child: Image(
    //             image: AssetImage('assets/images/icon_cancel.png'))),
    //     onTap: () {
    //       viewModel.phoneController.clear();
    //     },
    //   ),
    //   hint: "请输入您的手机号",
    //   hintTextStyle: const TextStyle(
    //     fontWeight: FontWeight.w400,
    //     fontSize: 14,
    //     color: AppColors.mainGrey,
    //   ),
    //   onChange: (text) {
    //     checkButton();
    //     setState(() {});
    //   },
    // ),

    return GestureDetector(

      child: MainScaffold(
        isFullScreen: true,
        backgroundColor:  _appColorTheme.baseBackgroundColor,
        padding: EdgeInsets.only(top: paddingHeight, bottom: UIDefine.getNavigationBarHeight(), left: WidgetValue.horizontalPadding, right: WidgetValue.horizontalPadding),
        appBar: _appBar(),
        child: Column(
          children: [
            SizedBox(height: WidgetValue.verticalPadding),
            buildTextField(),
          ],
        ),
      ),
      onTap: (){
        BaseViewModel.clearAllFocus();
      },
    );
  }

  MainAppBar _appBar(){
    return MainAppBar(
      theme: _theme,
      title: '',
      backgroundColor: _appColorTheme.appBarBackgroundColor,
      titleWidget: Text('昵称', style: _appTextTheme.appbarTextStyle),
      leading: IconButton(
        icon: ImgUtil.buildFromImgPath(_appImageTheme.iconBack, size: 24.w),
        onPressed: () => BaseViewModel.popPage(context),
      ),
      actions: [
        InkWell(
          child: Container(
            margin: EdgeInsets.only(right: 16.w),
            child: Text('保存', style: _appTextTheme.appbarActionTextStyle),
          ),
          onTap: () {
            String text = viewModel.nickNameTextController.text.trim();
            String? newNickName = text.isEmpty ? null : text;
            BaseViewModel.popPage(context, sendMessage: newNickName);
            BaseViewModel.showToast(context, '记得再次点击保存才会储存设定哦');
          },
        ),
      ],
    );
  }

  buildTextField() {
    return Padding(
      padding: EdgeInsets.all(WidgetValue.verticalPadding),
      child: MainTextField(
        radius: 12,
        hintText: '请输入昵称',
        maxLength: 10,
        counterText: '',
        fontColor: _appTextTheme.normalMainTextFieldTextStyle.color,
        fontWeight: _appTextTheme.normalMainTextFieldTextStyle.fontWeight,
        fontSize: _appTextTheme.normalMainTextFieldTextStyle.fontSize,
        hintStyle: _appTextTheme.normalMainTextFieldHintTextStyle,
        backgroundColor:_appColorTheme.textFieldBackgroundColor,
        borderColor: _appColorTheme.textFieldBorderColor,
        controller: viewModel.nickNameTextController,
        suffixIcon: viewModel.nickNameTextController.text.isNotEmpty
            ? IconButton(icon: Icon(Icons.cancel),
          onPressed: () => setState(() => viewModel.nickNameTextController.clear()),
        ) : null,
        hintColor: AppColors.mainGrey,
        onChanged: (text){
          setState(() {});
        },
      ),
    );
  }
}