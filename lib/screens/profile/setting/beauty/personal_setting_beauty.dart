import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frechat/screens/profile/setting/beauty/personal_setting_beauty_sheet.dart';
import 'package:frechat/screens/profile/setting/beauty/personal_setting_beauty_view_model.dart';
import 'package:frechat/system/constant/enum.dart';
import 'package:frechat/system/providers.dart';
import 'package:frechat/system/zego_call/zego_provider.dart';
import 'package:frechat/widgets/constant_value.dart';
import 'package:frechat/widgets/shared/app_bar.dart';
import 'package:frechat/widgets/shared/bottom_sheet/profile_setting_beauty/beauty_bottom_sheet.dart';
import 'package:frechat/widgets/shared/dialog/comm_dialog.dart';
import 'package:frechat/widgets/shared/img_util.dart';
import 'package:frechat/widgets/shared/main_scaffold.dart';
import 'package:frechat/widgets/theme/app_theme.dart';
import 'package:frechat/widgets/theme/original/app_colors.dart';
import 'package:frechat/widgets/theme/uidefine.dart';
import 'package:frechat/system/base_view_model.dart';

class PersonalSettingBeauty extends ConsumerStatefulWidget {
  const PersonalSettingBeauty({super.key});

  @override
  ConsumerState<PersonalSettingBeauty> createState() =>
      _PersonalSettingBeautyState();
}

class _PersonalSettingBeautyState extends ConsumerState<PersonalSettingBeauty> {
  late PersonalSettingBeautyViewModel viewModel;
  late AppTheme _theme;

  @override
  void initState() {
    viewModel = PersonalSettingBeautyViewModel(setState: setState, ref: ref);
    viewModel.init();
    super.initState();
  }

  @override
  void deactivate() {
    viewModel.dispose();
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    _theme = ref.watch(userInfoProvider).theme ?? AppTheme(themeType: AppThemeType.original);

    return MainScaffold(
      isFullScreen: true,
      needSingleScroll: false,
      padding: EdgeInsets.zero,
      child: Stack(
        children: <Widget>[
          _videoView(),
          SafeArea (
            child: _buildAppBar(),
          ),
          viewModel.isBeautyOpen
            ? const Align(
              alignment: Alignment.bottomCenter,
              child: SettingBeautyBottomSheet()
            ): const SizedBox(),
        ],
      ),
    );
  }

  Widget _videoView() {
    final manager = ref.read(zegoSDKManagerProvider);
    return ValueListenableBuilder<Widget?>(
        valueListenable: manager.getVideoViewNotifier(null),
        builder: (context, view, _) {
          if (view != null) {
            return view;
          } else {
            return Container(
              padding: const EdgeInsets.all(0),
              color: Colors.white,
            );
          }
        });
  }

  // Custom AppBar
  _buildAppBar() {
    return Container(
      width: double.infinity,
      height: 44,
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildReturnBtn(),
          _buildHeadLineBtn(),
          _buildToggleCameraBtn(),
        ],
      ),
    );
  }

  // 返回按鈕
  _buildReturnBtn() {
    return InkWell(
      onTap: () => Navigator.pop(context),
      child: Image.asset('assets/images/icon_back_white.png',
          width: 24, height: 24),
    );
  }

  _buildToggleCameraBtn() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(99.0),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: InkWell(
          onTap: () => viewModel.switchCameraBtn(),
          child: SizedBox(
            width: 36,
            height: 36,
            child: Center(
              child: Image.asset('assets/images/icon_camera_video.png',
                  width: 24, height: 24),
            ),
          ),
        ),
      ),
    );
  }

  _buildHeadLineBtn() {
    return Row(
      children: [
        _buildBeautyToggleBtn(),
        const SizedBox(width: 8),
        _buildResetBtn()
      ],
    );
  }

  // 開啟 / 關閉美顏功能按鈕
  _buildBeautyToggleBtn() {
    return viewModel.isBeautyOpen
    ? _buildLongBtn(
      title: '已开启美颜功能',
      onTap: () {
        CommDialog(context).build(
          theme: _theme,
          title: '是否关闭美颜功能？',
          contentDes: '关闭美颜功能将展示最真实的您',
          leftBtnTitle: '取消',
          leftAction: () => BaseViewModel.popPage(context),
          rightBtnTitle: '关闭',
          rightAction: () => viewModel.closeBeauty(context)
        );
      })
        : ClipRRect(
      borderRadius: BorderRadius.circular(99.0),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: _buildLongBtn(
            title: '已关闭美颜功能',
            onTap: () {
              viewModel.openBeauty(context);
            }),
      ),
    );
  }

  // 恢復默認按鈕
  _buildResetBtn(){
    return ClipRRect(
      borderRadius: BorderRadius.circular(99.0),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: _buildLongBtn(
          title: '恢复默认',
          onTap: () {
            CommDialog(context).build(
              theme: _theme,
              title: '是否恢复默认？',
              contentDes: '恢复默认将回复美颜出厂设定',
              leftBtnTitle: '取消',
              leftAction: () => BaseViewModel.popPage(context),
              rightBtnTitle: '确定',
              rightAction: () => viewModel.originBeauty(context),
            );
          }
        ),
      ),
    );
  }

  _buildLongBtn({
    required String title,
    required Function() onTap,
  }) {
    return InkWell(
        onTap: () => onTap(),
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(99.0),
              gradient: title == '已开启美颜功能'
                  ? AppColors.pinkLightGradientColors
                  : null),
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
            child: Text(title,
                style: const TextStyle(
                    color: AppColors.textWhite,
                    fontSize: 12.0,
                    fontWeight: FontWeight.w500,
                    height: 1.16667)),
          ),
        ));
  }
}
