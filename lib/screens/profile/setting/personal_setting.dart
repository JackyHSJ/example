import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frechat/models/certification_model.dart';
import 'package:frechat/models/req/error_log_req.dart';
import 'package:frechat/screens/launch/launch.dart';
import 'package:frechat/screens/profile/setting/personal_setting_view_model.dart';
import 'package:frechat/system/app_config/app_config.dart';
import 'package:frechat/system/base_view_model.dart';
import 'package:frechat/system/constant/enum.dart';
import 'package:frechat/system/global.dart';
import 'package:frechat/system/notification/notification_handler.dart';
import 'package:frechat/system/notification/notification_manager.dart';
import 'package:frechat/system/payment/wechat/wechat_manager.dart';
import 'package:frechat/system/payment/wechat/wechat_setting.dart';
import 'package:frechat/system/provider/chat_user_model_provider.dart';
import 'package:frechat/system/provider/user_info_provider.dart';
import 'package:frechat/system/providers.dart';
import 'package:frechat/system/util/share_util.dart';
import 'package:frechat/system/task_manager/task_manager.dart';
import 'package:frechat/widgets/constant_value.dart';
import 'package:frechat/widgets/shared/app_bar.dart';
import 'package:frechat/widgets/shared/dialog/check_dialog.dart';
import 'package:frechat/widgets/shared/dialog/comm_dialog.dart';
import 'package:frechat/widgets/shared/img_util.dart';
import 'package:frechat/widgets/shared/list/main_list.dart';
import 'package:frechat/widgets/shared/loading_animation.dart';
import 'package:frechat/widgets/shared/main_scaffold.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frechat/widgets/shared/pip/pip.dart';
import 'package:frechat/widgets/strike_up_list/strike_up_list_member_card_view_model.dart';
import 'package:frechat/widgets/theme/app_box_decoration_theme.dart';
import 'package:frechat/widgets/theme/app_color_theme.dart';
import 'package:frechat/widgets/theme/app_image_theme.dart';
import 'package:frechat/widgets/theme/app_linear_gradient_theme.dart';
import 'package:frechat/widgets/theme/app_text_theme.dart';
import 'package:frechat/widgets/theme/app_theme.dart';
import 'package:wechat_kit/wechat_kit.dart';
import 'package:zego_zpns/zego_zpns.dart';
import '../../../widgets/profile/cell/personal_setting_cell.dart';
import '../../../widgets/shared/divider.dart';
import '../../../widgets/theme/original/app_colors.dart';
import '../../../widgets/theme/uidefine.dart';

class PersonalSetting extends ConsumerStatefulWidget {
  const PersonalSetting({super.key});

  @override
  ConsumerState<PersonalSetting> createState() => _PersonalSettingState();
}

class _PersonalSettingState extends ConsumerState<PersonalSetting> {

  late PersonalSettingViewModel viewModel;
  late AppTheme _theme;
  late AppColorTheme _appColorTheme;
  late AppImageTheme _appImageTheme;
  late AppTextTheme _appTextTheme;
  late AppLinearGradientTheme _appLinearGradientTheme;
  late AppBoxDecorationTheme _appBoxDecorationTheme;


  @override
  void initState() {
    viewModel = PersonalSettingViewModel(ref: ref, setState: setState);
    viewModel.init();
    super.initState();
  }

  @override
  void dispose() {
    viewModel.dispose();
    super.dispose();
  }

  void _buildClearCacheDialog() {
    CommDialog(context).build(
      theme: _theme,
      title: '是否删除${AppConfig.appName}数据？',
      contentDes: '清除暂缓数据以释放容量',
      leftBtnTitle: '取消',
      rightBtnTitle: '删除',
      leftAction: () => BaseViewModel.popPage(context),
      rightAction: () {
        viewModel.clearCache(context);
        BaseViewModel.popPage(context);
      },
    );
  }

  @override
  Widget build(BuildContext context) {

    _theme = ref.watch(userInfoProvider).theme ?? AppTheme(themeType: AppThemeType.original);
    _appColorTheme = _theme.getAppColorTheme;
    _appImageTheme = _theme.getAppImageTheme;
    _appTextTheme = _theme.getAppTextTheme;
    _appLinearGradientTheme = _theme.getAppLinearGradientTheme;
    _appBoxDecorationTheme = _theme.getAppBoxDecorationTheme;
    final double paddingHeight = UIDefine.getAppBarHeight() + UIDefine.getStatusBarHeight();


    return MainScaffold(
      isFullScreen: true,
      padding: EdgeInsets.only(
        top: paddingHeight,
        bottom: WidgetValue.bottomPadding,
        left: WidgetValue.horizontalPadding,
        right: WidgetValue.horizontalPadding,
      ),
      appBar: _buildMainAppBar(),
      backgroundColor: _appColorTheme.appBarBackgroundColor,
      child: viewModel.isLoading ? _buildLoading() : _buildMainContent()
    );
  }

  Widget _buildLoading() {
    return LoadingAnimation.discreteCircle(color: _appColorTheme.primaryColor);
  }

  Widget _buildMainContent() {
    return Column(
      children: [
        _buildSettingList(),
        SizedBox(height: WidgetValue.btnBottomPadding),
        _buildLogoutBtn(),
        SizedBox(height: WidgetValue.btnBottomPadding)
      ],
    );
  }

 Widget _buildMainAppBar() {

   return MainAppBar(
     theme: _theme,
     title: '',
     titleWidget: Text(
       "设置",
       style: _appTextTheme.appbarTextStyle,
     ),
     backgroundColor: _appColorTheme.appBarBackgroundColor,
     leading: IconButton(
       icon: ImgUtil.buildFromImgPath(_appImageTheme.iconBack, size: 24.w),
       onPressed: () => BaseViewModel.popPage(context),
     ),
   );
 }



  Widget _buildSettingList() {

    /// 男生 删除收费设置、招呼設置
    /// 美顏暫時删除
    if (ref.read(userInfoProvider).memberInfo?.gender == 1) {
      viewModel.cellList.removeWhere((cell) {
        if (cell.title == '收费设置' || cell.title == '招呼设置') {
          return true;
        }
        return false;
      });
    } else {
      final num realPersonAuth =
          ref.read(userInfoProvider).memberInfo?.realPersonAuth ?? 0;
      final num realNameAuth =
          ref.read(userInfoProvider).memberInfo?.realNameAuth ?? 0;
      CertificationType personAuthType =
          CertificationModel.getType(authNum: realPersonAuth);
      CertificationType nameAuthType =
          CertificationModel.getType(authNum: realNameAuth);
      if (personAuthType != CertificationType.done ||
          nameAuthType != CertificationType.done) {
        viewModel.cellList.removeWhere((cell) {
          if (cell.title == '收费设置') {
            return true;
          }
          return false;
        });
      }
    }

    return Container(
      decoration: _appBoxDecorationTheme.personalProfileCellListBoxDecoration,
      padding: EdgeInsets.all(WidgetValue.horizontalPadding),
      child: CustomList.separatedList(
          separator: MainDivider(color: _appColorTheme.dividerColor, weight: 1.h),
          childrenNum: viewModel.cellList.length,
          physics: const NeverScrollableScrollPhysics(),
          children: (context, index) {
            return InkWell(
              onTap: () async {
                final bool isHavePage =
                    viewModel.cellList[index].pushPage != null;
                if (isHavePage) {
                  final bool isPipMode = PipUtil.pipStatus == PipStatus.piping;
                  if (isPipMode) {
                    if (viewModel.cellList[index].title == '收费设置') {
                      BaseViewModel.showToast(context, "您正在通话中，不可调整收费设置");
                      return;
                    }
                    if (viewModel.cellList[index].title == '美颜设置') {
                      BaseViewModel.showToast(context, "您正在通话中，不可调整美颜设置");
                      return;
                    }
                    if (viewModel.cellList[index].title ==
                        '${AppConfig.appName}账号注销协议') {
                      BaseViewModel.showToast(context, "您正在通话中，不可注销账号");
                      return;
                    }
                  }
                }
                final bool isCacheCell =
                    viewModel.cellList[index].isCacheCell == true;
                if (isCacheCell) {
                  _buildClearCacheDialog();
                }

                if (!isHavePage) {
                  print('123123123');
                  return;
                }

                BaseViewModel.pushPage(
                    context, viewModel.cellList[index].pushPage!);
              },
              child: PersonalSettingCell(model: viewModel.cellList[index]),
            );
          }),
    );
  }

  _buildLogoutBtn() {
    return InkWell(
      onTap: () {
        final bool isPipMode = PipUtil.pipStatus == PipStatus.piping;
        if (isPipMode) {
          BaseViewModel.showToast(context, '您正在通话中，不可退出登录');
        } else {
          _buildLogoutDialog();
        }
      },
      child: Container(
        height: WidgetValue.mainComponentHeight,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(WidgetValue.btnRadius * 2),
          color: AppColors.textBlack,
        ),
        child: Text('退出登录',
            style: TextStyle(
                color: AppColors.textWhite,
                fontWeight: FontWeight.w600,
                fontSize: 14.sp)),
      ),
    );
  }

  _buildLogoutDialog() {

    CommDialog(context).build(
        theme: _theme,
        title: '退出登录？',
        contentDes: '退出登录',
        leftBtnTitle: '取消',
        rightBtnTitle: '退出',
        backgroundColor: _appColorTheme.dialogBackgroundColor,
        leftLinearGradient: _appLinearGradientTheme.buttonSecondaryColor,
        rightLinearGradient: _appLinearGradientTheme.buttonPrimaryColor,
        leftTextStyle: _appTextTheme.dialogCancelButtonTextStyle,
        rightTextStyle: _appTextTheme.dialogConfirmButtonTextStyle,
        leftAction: () => BaseViewModel.popPage(context),
        rightAction: () => ref.read(authenticationProvider).logout(
          loadingContext: context,
          onConnectSuccess: (succMsg) => BaseViewModel.pushAndRemoveUntil(context, GlobalData.launch ??  const Launch()),
          onConnectFail: (errMsg) => BaseViewModel.showToast(context, errMsg)));
  }
}
