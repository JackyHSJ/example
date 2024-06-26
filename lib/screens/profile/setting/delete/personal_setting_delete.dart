import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frechat/screens/launch/launch.dart';
import 'package:frechat/screens/profile/setting/delete/personal_setting_delete_view_model.dart';
import 'package:frechat/system/app_config/app_config.dart';
import 'package:frechat/system/assets_path/assets_txt_path.dart';
import 'package:frechat/system/base_view_model.dart';
import 'package:frechat/system/constant/enum.dart';
import 'package:frechat/system/global.dart';
import 'package:frechat/system/providers.dart';
import 'package:frechat/system/repository/response_code.dart';
import 'package:frechat/widgets/constant_value.dart';
import 'package:frechat/widgets/shared/dialog/comm_dialog.dart';
import 'package:frechat/widgets/shared/img_util.dart';
import 'package:frechat/widgets/shared/pip/pip.dart';
import 'package:frechat/widgets/theme/app_color_theme.dart';
import 'package:frechat/widgets/theme/app_txt_theme.dart';
import 'package:frechat/widgets/theme/original/app_colors.dart';
import 'package:frechat/widgets/theme/app_image_theme.dart';
import 'package:frechat/widgets/theme/app_linear_gradient_theme.dart';
import 'package:frechat/widgets/theme/app_text_theme.dart';
import 'package:frechat/widgets/theme/app_theme.dart';


import '../../../../widgets/theme/uidefine.dart';

class PersonalSettingDelete extends ConsumerStatefulWidget {
  const PersonalSettingDelete({super.key});

  @override
  ConsumerState<PersonalSettingDelete> createState() => _PersonalSettingState();
}

class _PersonalSettingState extends ConsumerState<PersonalSettingDelete> {
  late PersonalSettingDeleteViewModel viewModel;
  String _text = '';
  bool isLoading = true;
  late AppTheme _theme;
  late AppColorTheme appColorTheme;
  late AppTextTheme appTextTheme;
  late AppLinearGradientTheme appLinearGradientTheme;
  late AppImageTheme appImageTheme;
  late AppTxtTheme appTxtTheme;

  @override
  void initState() {
    viewModel = PersonalSettingDeleteViewModel(ref: ref);
    super.initState();
  }

  Future<void> _loadText() async {
    String assetText;
    assetText = await rootBundle.loadString(appTxtTheme.accountDelete);
    _text = assetText;
    isLoading = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final double paddingHeight = UIDefine.getAppBarHeight() + UIDefine.getStatusBarHeight();
    _theme = ref.watch(userInfoProvider).theme ?? AppTheme(themeType: AppThemeType.original);
    appColorTheme = _theme.getAppColorTheme;
    appImageTheme = _theme.getAppImageTheme;
    appTextTheme = _theme.getAppTextTheme;
    appLinearGradientTheme = _theme.getAppLinearGradientTheme;
    appTxtTheme = _theme.getAppTxtTheme;

    _loadText();

    return Scaffold(
      appBar: AppBar(
        title: Text('${AppConfig.appName}账号注销协议',
          style: appTextTheme.appbarTextStyle,
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: appColorTheme.appBarBackgroundColor,
        leading: GestureDetector(
          child: Padding(
            padding: EdgeInsets.all(14),
            child: Image(
              image: AssetImage(appImageTheme.iconBack),
            ),
          ),
          onTap: () => BaseViewModel.popPage(context),
        ),
      ),
      body: SafeArea(
        child: Container(
          color: appColorTheme.appBarBackgroundColor,
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            children: [
              _buildContent(),
              SizedBox(height: WidgetValue.verticalPadding * 2,),
              Padding(padding: EdgeInsets.symmetric(horizontal: 16), child: _buildVerifyBtn()),
              SizedBox(height: WidgetValue.verticalPadding * 2,),
              Padding(padding: EdgeInsets.symmetric(horizontal: 16), child: _buildConfirmBtn()),
            ],
          )
        ),
      )
    );
  }


  _buildContent(){
    return isLoading
        ? const SizedBox()
        : Expanded(
          child: InAppWebView(
          initialData: InAppWebViewInitialData(data: _text),
          initialSettings: InAppWebViewSettings (
          transparentBackground: true,
        )
      )
    );
  }

  _buildVerifyBtn() {
    final String iconPath = (viewModel.isVerify) ? 'assets/profile/profile_delete_icon_2.png' : 'assets/profile/profile_delete_icon_1.png';
    return InkWell(
      onTap: () {
        viewModel.toggleVerify();
        setState(() {});
      },
      child: Row(
        children: [
          ImgUtil.buildFromImgPath(iconPath, size: WidgetValue.smallIcon),
          SizedBox(width: WidgetValue.separateHeight),
          Text('我已阅读以上信息无异议', style: TextStyle(color: AppColors.textGrey, fontWeight: FontWeight.w600, fontSize: 16))
        ],
      ),
    );
  }

  _buildConfirmBtn() {

    final Color btnColor = (viewModel.isVerify) ? appLinearGradientTheme.buttonPrimaryColor.colors[0] : appLinearGradientTheme.buttonDisableColor.colors[0];
    // final Color btnTextColor = (viewModel.isVerify) ? appTextTheme.buttonPrimaryTextStyle.color : appTextTheme.buttonDisableTextStyle.color;
    return InkWell(
      onTap: () {
        if(!viewModel.isVerify) {
          BaseViewModel.showToast(context, '您尚未勾选已阅读以上信息并无异议');
          return ;
        }
        final bool isPipMode = PipUtil.pipStatus == PipStatus.piping;
        if (isPipMode) {
          CommDialog(context).build(
            theme: _theme,
            title: '提醒',
            contentDes: '您现在正在通话中，无法注销账号',
            rightBtnTitle: '确定',
            rightAction: () {
              BaseViewModel.popupDialog();
              BaseViewModel.popPage(context);
            },
          );
          return;
        }
        _buildDeleteDialog();
      },
      child: Container(
          height: WidgetValue.mainComponentHeight,
          alignment: Alignment.center,
          decoration: BoxDecoration(
              color: btnColor,
              borderRadius: BorderRadius.circular(WidgetValue.btnRadius * 2)
          ),
          child: Text('确定注销', style:(viewModel.isVerify) ? appTextTheme.buttonPrimaryTextStyle: appTextTheme.buttonDisableTextStyle)
      ),
    );
  }

  _buildDeleteDialog() {
    CommDialog(context).build(
      theme: _theme,
        title: '您即将注销账号',
        contentDes: '账号注销后将无法回复',
        leftBtnTitle: '取消',
        rightBtnTitle: '注销',
        leftAction: () => BaseViewModel.popPage(context),
        rightAction: () {
          if(!viewModel.isVerify) {
            return;
          }
          ref.read(authenticationProvider).deleteMember(
              onConnectSuccess: (succMsg) => BaseViewModel.pushAndRemoveUntil(context, GlobalData.launch ??  const Launch()),
              onConnectFail: (errMsg) => BaseViewModel.showToast(context, ResponseCode.map[errMsg]!)
          );
        }
    );
  }
}