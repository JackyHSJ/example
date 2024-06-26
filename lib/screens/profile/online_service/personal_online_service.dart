import 'dart:io';

import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frechat/models/profile/personal_online_service_model.dart';
import 'package:frechat/models/ws_res/customer_service_hour/ws_customer_service_hour_res.dart';
import 'package:frechat/screens/profile/deposit/personal_deposit.dart';
import 'package:frechat/screens/profile/online_service/chat/personal_online_service_chat.dart';
import 'package:frechat/screens/profile/online_service/law/personal_online_service_law.dart';
import 'package:frechat/screens/profile/online_service/personal_online_service_view_model.dart';
import 'package:frechat/system/base_view_model.dart';
import 'package:frechat/system/constant/enum.dart';
import 'package:frechat/system/constant/law.dart';
import 'package:frechat/system/providers.dart';
import 'package:frechat/widgets/shared/app_bar.dart';
import 'package:frechat/widgets/shared/dialog/comm_dialog.dart';
import 'package:frechat/widgets/shared/loading_animation.dart';
import 'package:frechat/widgets/shared/main_scaffold.dart';
import 'package:frechat/widgets/textfromasset/textfromasset_widget.dart';
import 'package:frechat/widgets/theme/app_box_decoration_theme.dart';
import 'package:frechat/widgets/theme/app_color_theme.dart';
import 'package:frechat/widgets/theme/app_image_theme.dart';
import 'package:frechat/widgets/theme/app_theme.dart';
import 'package:frechat/widgets/theme/app_txt_theme.dart';

import '../../../widgets/constant_value.dart';
import '../../../widgets/profile/cell/personal_online_service_cell.dart';
import '../../../widgets/shared/divider.dart';
import '../../../widgets/shared/img_util.dart';
import '../../../widgets/shared/list/main_list.dart';
import '../../../widgets/theme/original/app_colors.dart';
import '../../../widgets/theme/uidefine.dart';

class PersonalOnlineService extends ConsumerStatefulWidget {
  const PersonalOnlineService({super.key});

  @override
  ConsumerState<PersonalOnlineService> createState() => _PersonalOnlineServiceState();
}

class _PersonalOnlineServiceState extends ConsumerState<PersonalOnlineService> with AfterLayoutMixin {
  late PersonalOnlineServiceViewModel viewModel;

  late AppTheme _theme;
  late AppColorTheme _appColorTheme;
  late AppImageTheme _appImageTheme;
  late AppTxtTheme _appTxtTheme;
  late AppBoxDecorationTheme _appBoxDecorationTheme;
  bool loading = true;

  List<String> durationList = [];
  String dialogContent = '';


  @override
  void initState() {
    viewModel = PersonalOnlineServiceViewModel(ref: ref, context: context);
    super.initState();
  }

  @override
  void afterFirstLayout(BuildContext context) async {
    WsCustomerServiceHourRes res = await viewModel.loadCustomerServiceHour();
    if(res !=null){
      durationList = res.duration!.split('|');
      String startDay = viewModel.getWeekdayName(durationList![0]);
      String endDay = viewModel.getWeekdayName(durationList![1]);
      String startTime = durationList![2];
      if(durationList.length >3){
        String endTime = durationList![3];
        dialogContent ='客服时间\n$startDay至$endDay\n$startTime、$endTime\n(法定节假日除外)';
      }else{
        dialogContent ='客服时间\n$startDay至$endDay\n$startTime\n(法定节假日除外)';
      }
      loading = false;
      CommDialog(context).build(
          theme: _theme,
          title: '提醒',
          contentDes: dialogContent,
          rightBtnTitle: '确认',
          rightAction: () {
            BaseViewModel.popPage(context);
            setState(() {});
          }
      );
    }
  }

  void openTextFromAssetWidget(String filePath, String title) {
    BaseViewModel.pushPage(context, TextFromAssetWidget(title: title, filePath: filePath));
  }

  @override
  Widget build(BuildContext context) {
    final double paddingHeight = UIDefine.getAppBarHeight() + UIDefine.getStatusBarHeight();

    _theme = ref.watch(userInfoProvider).theme ?? AppTheme(themeType: AppThemeType.original);
    _appColorTheme = _theme.getAppColorTheme;
    _appImageTheme = _theme.getAppImageTheme;
    _appTxtTheme = _theme.getAppTxtTheme;
    _appBoxDecorationTheme = _theme.getAppBoxDecorationTheme;


    return MainScaffold(
      isFullScreen: true,
      padding: EdgeInsets.only(
        top: paddingHeight,
        bottom: WidgetValue.bottomPadding,
        left: WidgetValue.horizontalPadding,
        right: WidgetValue.horizontalPadding,
      ),
      appBar: MainAppBar(
        theme: _theme,
        title: '在线客服',
        backgroundColor: _appColorTheme.customServiceAppbarColor,
        leading: IconButton(
          icon: ImgUtil.buildFromImgPath(_appImageTheme.iconBack, size: 24.w),
          onPressed: () => BaseViewModel.popPage(context),
        ),
        actions: [_buildCallServiceBtn()],
      ),
      backgroundColor: _appColorTheme.customServiceBgColor,
      child: (loading)?_buildLoading():Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 12),
          _buildTitle(),
          const SizedBox(height: 8),
          _buildCellList(),
        ],
      ),
    );
  }

  Widget _buildLoading() {
    return LoadingAnimation.discreteCircle(color: _appColorTheme.primaryColor);
  }

  _buildCallServiceBtn() {
    return IconButton(
      icon: ImgUtil.buildFromImgPath(_appImageTheme.iconOnlineService, size: 24.w),
      onPressed: () => BaseViewModel.pushPage(context, PersonalOnlineServiceChat()),
    );
  }

  _buildTitle() {
    return Text(
      '常见问题',
      style: TextStyle(
        fontWeight: FontWeight.w700,
        fontSize: 14,
        color: _appColorTheme.customServicePrimaryTextColor,
      ),
    );
  }

  _buildCellList() {
    return CustomList.separatedList(
        separator: SizedBox(height: WidgetValue.verticalPadding),
        physics: const NeverScrollableScrollPhysics(),
        childrenNum: viewModel.cellList.length,
        children: (context, index) {
          return InkWell(
            onTap: () {
              if (viewModel.cellList[index].lawList == null) {
                return;
              }

              openTextFromAssetWidget(_appTxtTheme.platformGuidelines, '平台准则');
            },
            child: PersonalOnlineServiceCell(model: viewModel.cellList[index]),
          );
        });
  }
}
