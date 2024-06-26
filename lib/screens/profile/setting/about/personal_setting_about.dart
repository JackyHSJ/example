import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frechat/system/app_config/app_config.dart';
import 'package:frechat/models/req/check_app_version_req.dart';
import 'package:frechat/models/res/check_app_version_res.dart';
import 'package:frechat/screens/version_update_reminder/version_update_reminder.dart';
import 'package:frechat/system/assets_path/assets_txt_path.dart';
import 'package:frechat/system/base_view_model.dart';
import 'package:frechat/system/constant/enum.dart';
import 'package:frechat/system/global.dart';
import 'package:frechat/system/providers.dart';
import 'package:frechat/system/repository/response_code.dart';
import 'package:frechat/system/util/file_util.dart';
import 'package:frechat/system/util/share_util.dart';
import 'package:frechat/widgets/shared/app_bar.dart';
import 'package:frechat/widgets/shared/divider.dart';
import 'package:frechat/widgets/shared/img_util.dart';
import 'package:frechat/widgets/textfromasset/textfromasset_widget.dart';
import 'package:frechat/widgets/theme/app_box_decoration_theme.dart';
import 'package:frechat/widgets/theme/app_color_theme.dart';
import 'package:frechat/widgets/theme/app_txt_theme.dart';
import 'package:frechat/widgets/theme/original/app_colors.dart';
import 'package:frechat/widgets/theme/app_image_theme.dart';
import 'package:frechat/widgets/theme/app_text_theme.dart';
import 'package:frechat/widgets/theme/app_theme.dart';
import 'package:page_transition/page_transition.dart';

import '../../../../system/provider/user_info_provider.dart';

class PersonalSettingAbout extends ConsumerStatefulWidget {
  const PersonalSettingAbout({super.key});

  @override
  ConsumerState<PersonalSettingAbout> createState() =>
      _PersonalSettingAboutState();
}
class _PersonalSettingAboutState extends ConsumerState<PersonalSettingAbout> {
  late AppTheme _theme;
  late AppColorTheme _appColorTheme;
  late AppTextTheme _appTextTheme;
  late AppImageTheme _appImageTheme;
  late AppTxtTheme _appTxtTheme;
  late AppBoxDecorationTheme _appBoxDecorationTheme;


  @override
  Widget build(BuildContext context) {

    _theme = ref.watch(userInfoProvider).theme ?? AppTheme(themeType: AppThemeType.original);
    _appColorTheme = _theme.getAppColorTheme;
    _appImageTheme = _theme.getAppImageTheme;
    _appTextTheme = _theme.getAppTextTheme;
    _appTxtTheme = _theme.getAppTxtTheme;
    _appBoxDecorationTheme = _theme.getAppBoxDecorationTheme;

    return Scaffold(
      backgroundColor: AppColors.globalBackGround,
      appBar: _buildAppBar(),
      body: Container(
        color: _appColorTheme.appBarBackgroundColor,
        width: MediaQuery.of(context).size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            appIconAndAppNameWidget(),
            contentWidget(),
            copyRightText()
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return MainAppBar(
      theme: _theme,
      title: '',
      titleWidget: Text(
        "关于产品",
        style: _appTextTheme.appbarTextStyle,
      ),
      backgroundColor: _appColorTheme.appBarBackgroundColor,
      leading: IconButton(
        icon: ImgUtil.buildFromImgPath(_appImageTheme.iconBack, size: 24.w),
        onPressed: () => BaseViewModel.popPage(context),
      ),
    );
  }

  //AppIcon
  Widget appIconAndAppNameWidget() {
    final String appName = AppConfig.appName;
    return Column(
      children: [
        InkWell(
          onTap: () => _loadDebugLogs(),
          child: Container(
              margin: EdgeInsets.only(top: 20.h),
              child: ImgUtil.buildFromImgPath(_appImageTheme.appIcon, size: 120.w)),
        ),
        Container(
          margin: EdgeInsets.only(top: 8.h),
          child: Text(
            appName,
            style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.textFormBlack,
            ),
          ),
        )
      ],
    );
  }

  Widget copyRightText(){
    return Text('Copyright©2023\n南宁缘茵文化传媒有限公司 版权所有',
      textAlign: TextAlign.center,
      style: TextStyle(
        fontWeight: FontWeight.w400,
        fontSize: 10,
        color: Colors.grey
    ));
  }

  Future<void> _loadDebugLogs() async {
    final String env = await AppConfig.getEnvStr();
    if(env == 'PROD') {
      return ;
    }
    final File file = await FileUtil.writeText(GlobalData.cacheLogs, fileName: GlobalData.logFileName);
    GlobalData.cacheLogs = [];
    ShareUtil.shareFile(file: file, des: 'debugLogs');
  }

  //內容
  Widget contentWidget() {
    final String appName = AppConfig.appName;
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
      decoration: _appBoxDecorationTheme.cellBoxDecoration,
      child: Column(
        children: [
          SizedBox(height: 12.h),
          InkWell(
            child: contentItemWidget('$appName用户服务协议'),
            onTap: () {
              openTextFromAssetWidget(_appTxtTheme.userAgreement, '${AppConfig.appName}用户服务协议');
            },
          ),
          InkWell(
            child: contentItemWidget('$appName隐私政策'),
            onTap: () {
              openTextFromAssetWidget(_appTxtTheme.privacyAgreement, '${AppConfig.appName}隐私政策');
            },
          ),
          InkWell(
            child: contentItemWidget('第三方共享个人信息清单'),
            onTap: () {
              openTextFromAssetWidget(_appTxtTheme.thirdPartyPersonalInformation, '第三方共享个人信息清单');
            },
          ),
          InkWell(
            child: contentItemWidget('权限申请与使用情况说明'),
            onTap: () {
              openTextFromAssetWidget(_appTxtTheme.permissionRequestsAndUsage, '${AppConfig.appName}权限申请与使用情况说明');
            },
          ),
          checkVersionWidget(),
          SizedBox(height: 12.h),
        ],
      ),
    );
  }

  //單行item
  Widget contentItemWidget(String text) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.symmetric(vertical: 12.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(text, style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w700,
                  color: _appTextTheme.cellListMainTextStyle.color
                )),
                ImgUtil.buildFromImgPath(_appImageTheme.iconRightArrow, size: 24.w),
              ],
            ),
          ),
          MainDivider(color: _appColorTheme.dividerColor, weight: 1)
        ],
      ),
    );
  }

  //檢查版本更新
  Widget checkVersionWidget() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('检查版本更新',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w700,
                  color: _appTextTheme.cellListMainTextStyle.color
                )),
            Text("V${AppConfig.appVersion}",
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w400,
                  color: _appTextTheme.cellListSubTextStyle.color,
                ))
          ],
        ),
        InkWell(
          onTap: () => _checkAppVersion(),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 19.w, vertical: 6.h),
            decoration: const BoxDecoration(
              color: AppColors.textFormBlack,
              borderRadius: BorderRadius.all(Radius.circular(48)),
            ),
            child: Text('检查',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                )),
          ),
        ),
      ]),
    );
  }

  void openTextFromAssetWidget(String filePath, String title) {
    BaseViewModel.pushPage(context, TextFromAssetWidget(title: title, filePath: filePath));
  }

  _checkAppVersion() async {
    final String token = ref.read(userInfoProvider).commToken ?? '';
    final CheckAppVersionReq reqBody = CheckAppVersionReq.create(tId: token);
    String? resultCodeCheck;
    CheckAppVersionRes? res = await ref.read(commApiProvider).checkAppVersion(reqBody,
        onConnectSuccess: (code) =>resultCodeCheck = code, onConnectFail: (errMsg) { resultCodeCheck = '002'; });
    if(resultCodeCheck == ResponseCode.CODE_SUCCESS) {
      _pushVersionUpdateReminderPage(res);
    }
  }

  void _pushVersionUpdateReminderPage(CheckAppVersionRes? checkAppVersionRes){
    bool isNeedUpdate = false;
    bool isForceUpdate = false;
    String updateVersion = checkAppVersionRes?.appVersion ?? '';
    String currentVersion = AppConfig.appVersion;
    List<String> updateVersionList = updateVersion.split('.');
    List<String> currentVersionList = currentVersion.split('.');
    try {
      for(int i = 0;i < updateVersionList.length; i++){
        if(int.parse(currentVersionList[i]) > int.parse(updateVersionList[i])){
          isNeedUpdate = false;
          BaseViewModel.showToast(context, '已为最新版本');
          return;
        }else if(int.parse(currentVersionList[i]) == int.parse(updateVersionList[i])){
          isNeedUpdate = false;
          continue;
        }else{
          isNeedUpdate = true;
          //前兩碼為強制更新
          if(i<2){
            isForceUpdate = true;
          }else{
            isForceUpdate = false;
          }
          break;
        }
      }
      if(!isNeedUpdate){
        BaseViewModel.showToast(context, '已为最新版本');
        return;
      }
      BaseViewModel.pushPage(
          context,
          pageTransitionType: PageTransitionType.bottomToTop,
          VersionUpdateReminder(
            isForceUpdate: isForceUpdate,
            appVersion: updateVersion,
            downloadLink: checkAppVersionRes?.downloadLink,
            updateDescription: checkAppVersionRes?.updateDescription,
          ));
    } catch (e) {
      print('版號有誤');
    }
  }
}
