import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frechat/screens/activity/activity_notification_view_model.dart';
import 'package:frechat/system/assets_path/assets_images_path.dart';
import 'package:frechat/system/base_view_model.dart';
import 'package:frechat/system/constant/enum.dart';
import 'package:frechat/system/database/model/activity_message_model.dart';
import 'package:frechat/system/extension/json.dart';
import 'package:frechat/system/provider/activity_message_model_provider.dart';
import 'package:frechat/system/providers.dart';
import 'package:frechat/system/zego_call/interal/zim/zim_service_defines.dart';
import 'package:frechat/system/zego_call/interal/zim/zim_util.dart';
import 'package:frechat/widgets/activity/cell/activity_notification_cell.dart';
import 'package:frechat/widgets/constant_value.dart';
import 'package:frechat/widgets/shared/app_bar.dart';
import 'package:frechat/widgets/shared/divider.dart';
import 'package:frechat/widgets/shared/img_util.dart';
import 'package:frechat/widgets/shared/list/main_list.dart';
import 'package:frechat/widgets/shared/main_scaffold.dart';
import 'package:frechat/widgets/strike_up_list/top_bottom_pull_loader.dart';
import 'package:frechat/widgets/theme/app_box_decoration_theme.dart';
import 'package:frechat/widgets/theme/app_image_theme.dart';
import 'package:frechat/widgets/theme/app_text_theme.dart';
import 'package:frechat/widgets/theme/app_theme.dart';
import 'package:frechat/widgets/theme/original/app_colors.dart';
import 'package:frechat/widgets/theme/uidefine.dart';
import 'package:flutter_screenutil/src/size_extension.dart';

import '../../system/zego_call/zego_provider.dart';
import '../../widgets/theme/app_color_theme.dart';


class ActivityNotification extends ConsumerStatefulWidget {
  const ActivityNotification({super.key});

  @override
  ConsumerState<ActivityNotification> createState() => _ActivityNotificationState();
}

class _ActivityNotificationState extends ConsumerState<ActivityNotification> {
  late ActivityNotificationViewModel viewModel;
  late AppTheme _theme;
  late AppColorTheme _appColorTheme;
  late AppBoxDecorationTheme _appBoxDecorationTheme;
  late AppTextTheme _appTextTheme;
  late AppImageTheme _appImageTheme;
  @override
  void initState() {
    super.initState();
    viewModel = ActivityNotificationViewModel(ref: ref, context: context, setState: setState);
    viewModel.init();
  }

  @override
  Widget build(BuildContext context) {

    final double paddingHeight = UIDefine.getAppBarHeight() + UIDefine.getStatusBarHeight();
    _theme = ref.watch(userInfoProvider).theme ?? AppTheme(themeType: AppThemeType.original);
    _appColorTheme = _theme.getAppColorTheme;
    _appBoxDecorationTheme = _theme.getAppBoxDecorationTheme;
    _appTextTheme = _theme.getAppTextTheme;
    _appImageTheme = _theme.getAppImageTheme;

    return Consumer(builder: (context, ref, _) {
      List<ActivityMessageModel?> activityList = ref.watch(activityMessageModelNotifierProvider);
      activityList = activityList.reversed.toList();

      return MainScaffold(
        isFullScreen: true,
        needSingleScroll: false,
        backgroundColor: _appColorTheme.baseBackgroundColor,
        padding: EdgeInsets.only(
          top: paddingHeight,
          bottom: WidgetValue.bottomPadding,
        ),
        appBar: _buildMainAppbar(),
        child: activityList.isEmpty ? _emptyContentWidget() : _contentWidget(activityList),
      );
    });



  }

  // App Bar
  PreferredSizeWidget _buildMainAppbar() {
    return MainAppBar(
      theme: _theme,
      title: '消息通知',
      leading: IconButton(
        icon: ImgUtil.buildFromImgPath(_appImageTheme.iconBack, size: 24.w),
        onPressed: () => BaseViewModel.popPage(context),
      ),
    );
  }

  Widget _contentWidget(List<ActivityMessageModel?> activityList) {
    return ListView.separated(
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      physics: const AlwaysScrollableScrollPhysics(),
      separatorBuilder: (BuildContext context, int index) => MainDivider(weight: 1, color: _appColorTheme.activityPostCellSeparatorLineColor, height: 1),
      itemCount: activityList.length,
      itemBuilder: (BuildContext context, int index) {
        return  SizedBox(
          height: 60.h,
          child: ActivityNotificationCell(
              key: ValueKey(activityList[index]),
              activityMessageModel: activityList[index]!
          ),
        );
      },
    );
  }

  Widget _emptyContentWidget(){
    return  Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ImgUtil.buildFromImgPath(_appImageTheme.imageMessageEmpty, size: 150.w),
        SizedBox(height: 23.h),
        Text(
          "消息通知",
          textAlign: TextAlign.center,
          style: _appTextTheme.labelPrimaryTitleTextStyle
        ),
        Text(
          "您目前还没有通知哦！快去互动吧",
          textAlign: TextAlign.center,
          style:_appTextTheme.labelSecondaryTextStyle,
        )

      ],

    );
  }
}
