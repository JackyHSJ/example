import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frechat/screens/profile/online_service/chat/personal_online_service_chat_view_model.dart';
import 'package:frechat/system/base_view_model.dart';
import 'package:frechat/system/constant/enum.dart';
import 'package:frechat/system/providers.dart';
import 'package:frechat/widgets/shared/app_bar.dart';
import 'package:frechat/widgets/shared/img_util.dart';
import 'package:frechat/widgets/shared/inappweb.dart';
import 'package:frechat/widgets/shared/main_scaffold.dart';
import 'package:frechat/widgets/theme/app_color_theme.dart';
import 'package:frechat/widgets/theme/app_image_theme.dart';
import 'package:frechat/widgets/theme/app_theme.dart';
import 'package:frechat/widgets/theme/uidefine.dart';

import '../../../../widgets/constant_value.dart';

class PersonalOnlineServiceChat extends ConsumerStatefulWidget {
  const PersonalOnlineServiceChat({super.key});
  @override
  ConsumerState<PersonalOnlineServiceChat> createState() =>
      _PersonalOnlineServiceChatState();
}

class _PersonalOnlineServiceChatState extends ConsumerState<PersonalOnlineServiceChat> {

  late PersonalOnlineServiceChatViewModel viewModel;
  late AppTheme _theme;
  late AppColorTheme _appColorTheme;
  late AppImageTheme _appImageTheme;

  @override
  void initState() {
    viewModel = PersonalOnlineServiceChatViewModel(ref: ref);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _theme = ref.watch(userInfoProvider).theme ?? AppTheme(themeType: AppThemeType.original);
    _appColorTheme = _theme.getAppColorTheme;
    _appImageTheme = _theme.getAppImageTheme;

    final String platform = BaseViewModel.isIos ? 'ios' : 'android';
    final double paddingHeight = UIDefine.getAppBarHeight() + UIDefine.getStatusBarHeight();
    final num userId = viewModel.getUserId();
    final String userName = viewModel.getUserName();

    return MainScaffold(
      appBar: _buildAppbar(),
      needSingleScroll: false,
      padding: EdgeInsets.only(
          top: paddingHeight,
          bottom: WidgetValue.bottomPadding,
          left: WidgetValue.horizontalPadding,
          right: WidgetValue.horizontalPadding),
      child: InAppWebViewBrowser(
          url: 'https://tb.53kf.com/code/app/f3e83b13b5c75d026e646c039023876b6/1?header=none&device=$platform&u_cust_id=$userId&u_cust_name=$userName'),
    );
  }

  Widget _buildAppbar() {
    return MainAppBar(
      theme: _theme,
      title: '客服',
      backgroundColor: _appColorTheme.customServiceAppbarColor,
      leading: IconButton(
        icon: ImgUtil.buildFromImgPath(_appImageTheme.iconBack, size: 24.w),
        onPressed: () => BaseViewModel.popPage(context),
      ),
    );
  }
}
