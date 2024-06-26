
import 'package:app_settings/app_settings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frechat/screens/network_lock/network_lock_detail.dart';
import 'package:frechat/system/base_view_model.dart';
import 'package:frechat/system/providers.dart';
import 'package:frechat/widgets/constant_value.dart';
import 'package:frechat/widgets/shared/buttons/common_button.dart';
import 'package:frechat/widgets/shared/img_util.dart';
import 'package:frechat/widgets/shared/main_scaffold.dart';
import 'package:frechat/widgets/theme/app_theme.dart';
import 'package:frechat/widgets/theme/original/app_colors.dart';

class NetworkLock extends ConsumerStatefulWidget {
  const NetworkLock({
    Key? key,
  }) : super(key: key);

  @override
  _NetworkLockState createState() => _NetworkLockState();
}

class _NetworkLockState extends ConsumerState<NetworkLock> {
  AppTheme? theme;

  @override
  Widget build(BuildContext context) {
    theme = ref.watch(userInfoProvider).theme;
    return MainScaffold(
      isFullScreen: true,
      needSingleScroll: false,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ImgUtil.buildFromImgPath('assets/images/img_network_lock.png', size: WidgetValue.userMonsterImg),
          Text('网络似乎断开了'),
          Text('检查一下网络连接再重试吧'),
          SizedBox(height: WidgetValue.mainComponentHeight),
          _buildRefreshBtn(),
          // _buildNetworkBtn(),
          SizedBox(height: WidgetValue.mainComponentHeight),
          _buildNetworkSettingBtn(),
        ],
      ),
    );
  }

  _buildRefreshBtn() {
    return CommonButton(
      btnType: CommonButtonType.text,
      cornerType: CommonButtonCornerType.circle,
      isEnabledTapLimitTimer: false,
      width: 180,
      height: 48,
      text: '刷新一下',
      textStyle: theme?.getAppTextTheme.buttonPrimaryTextStyle,
      colorBegin: theme?.getAppLinearGradientTheme.buttonPrimaryColor.colors[0],
      colorEnd: theme?.getAppLinearGradientTheme.buttonPrimaryColor.colors[1],
      onTap: () => BaseViewModel.showToast(context, '亲～网路连线重试中'),
    );
  }

  _buildNetworkBtn() {
    return CommonButton(
      btnType: CommonButtonType.text,
      cornerType: CommonButtonCornerType.circle,
      isEnabledTapLimitTimer: false,
      width: 180,
      height: 48,
      text: '网络诊断',
      textStyle: theme?.getAppTextTheme.buttonSecondaryTextStyle,
      colorBegin: theme?.getAppLinearGradientTheme.buttonSecondaryColor.colors[0],
      colorEnd: theme?.getAppLinearGradientTheme.buttonSecondaryColor.colors[1],
      onTap: () => BaseViewModel.pushPage(context, const NetworkLockDetail()),
    );
  }

  _buildNetworkSettingBtn() {
    return InkWell(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('查看您的网路设置', style: TextStyle(
            color: AppColors.mainBlack,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          )),
          Icon(Icons.arrow_forward_ios, size: WidgetValue.smallIcon)
        ],
      ),
      onTap: () => AppSettings.openAppSettings(type: AppSettingsType.wifi),
    );
  }
}