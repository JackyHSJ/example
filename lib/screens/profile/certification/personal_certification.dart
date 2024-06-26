import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frechat/models/certification_model.dart';
import 'package:frechat/models/ws_res/member/ws_member_info_res.dart';
import 'package:frechat/screens/profile/certification/real_name/personal_certification_real_name.dart';
import 'package:frechat/screens/profile/certification/real_person/personal_certification_real_person.dart';
import 'package:frechat/screens/profile/setting/iap/personal_setting_iap.dart';
import 'package:frechat/system/base_view_model.dart';
import 'package:frechat/system/constant/enum.dart';
import 'package:frechat/system/global/shared_preferance.dart';
import 'package:frechat/system/providers.dart';
import 'package:frechat/widgets/constant_value.dart';
import 'package:frechat/widgets/profile/cell/personal_certification_cell.dart';
import 'package:frechat/widgets/shared/buttons/common_button.dart';
import 'package:frechat/widgets/shared/dialog/comm_dialog.dart';
import 'package:frechat/widgets/shared/img_util.dart';
import 'package:frechat/widgets/shared/pip/pip.dart';
import 'package:frechat/widgets/theme/app_color_theme.dart';
import 'package:frechat/widgets/theme/app_text_theme.dart';
import 'package:frechat/widgets/theme/original/app_colors.dart';
import 'package:frechat/widgets/theme/app_image_theme.dart';
import 'package:frechat/widgets/theme/app_theme.dart';
import 'package:frechat/widgets/theme/original/app_texts.dart';

import '../../../widgets/shared/app_bar.dart';
import '../../../widgets/shared/main_scaffold.dart';
import '../../../widgets/theme/uidefine.dart';

class PersonalCertification extends ConsumerStatefulWidget {
  const PersonalCertification({super.key});

  @override
  ConsumerState<PersonalCertification> createState() =>
      _PersonalCertificationState();
}

class _PersonalCertificationState extends ConsumerState<PersonalCertification> {

  num? realNameAuth;
  num? realPersonAuth;
  num? gender;
  bool isOpenDialog = false;
  late AppTheme _theme;
  late AppColorTheme _appColorTheme;
  late AppImageTheme _appImageTheme;
  late AppTextTheme _appTextTheme;

  void _buildChargeSettingsDialog(){
    AppTheme theme = ref.read(userInfoProvider).theme ?? AppTheme(themeType: AppThemeType.original);
    isOpenDialog = true;
    CommDialog(context).build(
      theme: theme,
      title: '提示',
      contentDes: '恭喜你完成认证\n收费设置功能现已开启',
      rightBtnTitle: '取消',
      rightAction: () => BaseViewModel.popPage(context),
      actionWidget: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
            CommonButton(
              btnType: CommonButtonType.text,
              cornerType: CommonButtonCornerType.round,
              isEnabledTapLimitTimer: false,
              text: '前往查看',
              textStyle: _appTextTheme.dialogConfirmButtonTextStyle,
              colorBegin: theme.getAppLinearGradientTheme.dialogConfirmButtonColor.colors[0],
              colorEnd: theme.getAppLinearGradientTheme.dialogConfirmButtonColor.colors[1],
              onTap: () {
                BaseViewModel.popPage(context);
                BaseViewModel.pushPage(
                    context, const PersonalSettingIAP());
              },
            ),
            CommonButton(
              btnType: CommonButtonType.custom,
              cornerType: CommonButtonCornerType.custom,
              isEnabledTapLimitTimer: false,
              customWidget: Container(
                margin: EdgeInsets.symmetric(vertical: 10.h),
                child: Text('稍後在說',style: _appTextTheme.dialogLaterButtonTextStyle,),
              ),
              onTap: () {
                BaseViewModel.popPage(context);
              },
            ),
            Padding(
              padding: EdgeInsets.only(top: 10.h),
              child: Text('查看路径:我的>系统设置>收费等级',
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.mainGrey,
                ),
              ),
            ),
          ],
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    final double paddingHeight = UIDefine.getAppBarHeight() + UIDefine.getStatusBarHeight();

    _theme = ref.watch(userInfoProvider).theme ?? AppTheme(themeType: AppThemeType.original);
    _appColorTheme = _theme.getAppColorTheme;
    _appImageTheme = _theme.getAppImageTheme;
    _appTextTheme = _theme.getAppTextTheme;

    String iconCertificationPhonePath = _appImageTheme.iconPersonalCertificationPhone;
    String iconCertificationPersonalPath =  _appImageTheme.iconPersonalCertificationPersonal;
    String iconCertificationNamePath =  _appImageTheme.iconPersonalCertificationName;

    WsMemberInfoRes? memberInfoRes = ref.watch(userInfoProvider).memberInfo;

    if (memberInfoRes != null) {
      gender = ref.read(userInfoProvider).memberInfo!.gender;
      realNameAuth = memberInfoRes.realNameAuth;
      realPersonAuth = memberInfoRes.realPersonAuth;
    }

    final CertificationType personAuthType = CertificationModel.getType(authNum: realPersonAuth);
    final CertificationType nameAuthType = CertificationModel.getType(authNum: realNameAuth);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      bool result = await FcPrefs.getIsShowGoPersonalSettingIAPDialog();

      if(!result){
        if(gender == 0 && personAuthType == CertificationType.done && nameAuthType == CertificationType.done){
          if(!isOpenDialog){
            FcPrefs.setIsShowGoPersonalSettingIAPDialog(true);
            _buildChargeSettingsDialog();
          }
        }
      }
    });

    return MainScaffold(
      isFullScreen: true,
      needSingleScroll: false,
      padding: EdgeInsets.only(
        top: paddingHeight,
        bottom: WidgetValue.bottomPadding,
        left: WidgetValue.horizontalPadding,
        right: WidgetValue.horizontalPadding,
      ),
      appBar: MainAppBar(
        theme: _theme,
        backgroundColor: _appColorTheme.appBarBackgroundColor,
        title: '我的认证',
        leading: IconButton(
          icon: ImgUtil.buildFromImgPath(_appImageTheme.iconBack, size: 24.w),
          onPressed: () => BaseViewModel.popPage(context),
        ),
      ),
      backgroundColor: _appColorTheme.baseBackgroundColor,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Column(
          children: [
            //手機認證
            PersonalCertificationCell(
              title: '手机认证',
              btnTitle: '已认证',
              des: '完成官方手机认证標示',
              imgPath: iconCertificationPhonePath,
              btnEnable: false,
              type: CertificationType.done,
            ),
            SizedBox(height: WidgetValue.verticalPadding),
            //实名认证
            PersonalCertificationCell(
                title: '实名认证',
                btnTitle: _getAuthBtnTitle(realNameAuth),
                des: '完成官方实名认证標示',
                imgPath: iconCertificationNamePath,
                authenticating: _getIsAuthenticating(realNameAuth),
                btnEnable: _getAuthBtnEnable(realNameAuth),
                type: nameAuthType,
                onBtnPress: () {
                  BaseViewModel.pushPage(
                      context, const PersonalCertificationRealName());
                }),
            SizedBox(height: WidgetValue.verticalPadding),
            // 真人认证
            PersonalCertificationCell(
                title: '真人认证',
                btnTitle: _getAuthBtnTitle(realPersonAuth),
                des: '完成官方真人认证標示',
                imgPath: iconCertificationPersonalPath,
                authenticating: _getIsAuthenticating(realPersonAuth),
                btnEnable: _getAuthBtnEnable(realPersonAuth),
                type: personAuthType,
                onBtnPress: () {
                  final bool isPipMode = PipUtil.pipStatus == PipStatus.piping;
                  if (isPipMode){
                    BaseViewModel.showToast(context, '您正在通话中，不可拍摄照片');
                  } else {
                    BaseViewModel.pushPage(context, const PersonalCertificationRealPerson());
                  }
                }),
            Visibility(
                visible: gender == 0,
                child: Container(
                  margin: EdgeInsets.only(top: 20.h),
                  child: const Text(
                    '注意:通过实名认证与真人认证才可开启收费设置并与其他用户互动',
                    style: TextStyle(
                      color: AppColors.mainGrey,
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                )
            )
          ],
        ),
      )
    );
  }

  //按鈕文字
  String _getAuthBtnTitle(num? auth) {
    final type = CertificationModel.getType(authNum: auth);
    switch (type) {
      case CertificationType.fail:
        return '重新认证';
      case CertificationType.processing:
        return '认证中';
      case CertificationType.done:
        return '已认证';
      case CertificationType.not:
        return '未认证';
      default:
        return '未认证';
    }
  }

  //某按鈕是否應該可以按
  bool _getAuthBtnEnable(num? auth) {
    final type = CertificationModel.getType(authNum: auth);
    switch (type) {
      case CertificationType.fail:
        return true;
      case CertificationType.processing:
        return false;
      case CertificationType.done:
        return false;
      case CertificationType.not:
        return true;
      default:
        return true;
    }
  }

  //是否驗證中
  bool _getIsAuthenticating(num? auth) {
    final  type = CertificationModel.getType(authNum: auth);
    switch (type) {
      case CertificationType.processing:
        return true;
      default:
        return false;
    }
  }


}
