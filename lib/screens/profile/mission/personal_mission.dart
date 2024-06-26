import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:frechat/models/ws_res/member/ws_member_point_coin_res.dart';
import 'package:frechat/models/ws_res/mission/ws_mission_search_status_res.dart';

import 'package:frechat/system/global.dart';
import 'package:frechat/system/base_view_model.dart';
import 'package:frechat/system/providers.dart';
import 'package:frechat/system/constant/enum.dart';

import 'package:frechat/screens/profile/edit/personal_edit.dart';
import 'package:frechat/screens/profile/mission/personal_mission_view_model.dart';
import 'package:frechat/screens/profile/invite_friend/personal_invite_friend_qrcode.dart';
import 'package:frechat/screens/profile/mission/personal_mission_dialog.dart';

import 'package:frechat/widgets/constant_value.dart';
import 'package:frechat/widgets/shared/app_bar.dart';
import 'package:frechat/widgets/shared/img_util.dart';
import 'package:frechat/widgets/shared/main_scaffold.dart';
import 'package:frechat/widgets/theme/app_box_decoration_theme.dart';
import 'package:frechat/widgets/theme/app_color_theme.dart';
import 'package:frechat/widgets/theme/app_image_theme.dart';
import 'package:frechat/widgets/theme/app_text_theme.dart';
import 'package:frechat/widgets/theme/app_theme.dart';
import 'package:frechat/widgets/theme/uidefine.dart';

class PersonalMission extends ConsumerStatefulWidget {

  const PersonalMission({
    super.key
  });

  @override
  ConsumerState<PersonalMission> createState() => _PersonalMissionState();
}

class _PersonalMissionState extends ConsumerState<PersonalMission> {

  late PersonalMissionViewModel viewModel;
  late AppTheme _theme;
  late AppColorTheme _appColorTheme;
  late AppImageTheme _appImageTheme;
  late AppBoxDecorationTheme _appBoxDecorationTheme;

  @override
  void initState() {
    viewModel = PersonalMissionViewModel(ref: ref, setState: setState);
    viewModel.init(context);
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
    _appImageTheme = _theme.getAppImageTheme;
    _appBoxDecorationTheme = _theme.getAppBoxDecorationTheme;

    return MainScaffold(
      isFullScreen: true,
      needSingleScroll: true,
      padding: EdgeInsets.only(top: paddingHeight, bottom: UIDefine.getNavigationBarHeight(), left: WidgetValue.horizontalPadding, right: WidgetValue.horizontalPadding),
      appBar: MainAppBar(
        theme: _theme,
        backgroundColor: _appColorTheme.appBarBackgroundColor,
        title: '任务中心',
        leading: IconButton(
          icon: ImgUtil.buildFromImgPath(_appImageTheme.iconBack, size: 24.w),
          onPressed: () => BaseViewModel.popPage(context),
        ),
      ),
      backgroundColor: _appColorTheme.appBarBackgroundColor,
      child: Consumer(builder: (context, ref, _){
        final List<MissionStatusList> list = ref.watch(userInfoProvider).missionInfo?.list ?? [];
        return Column(
          children: [
            _buildUserProperty(),
            SizedBox(height: 24.h),
            _buildMissionTitle('新手任务', '每个任务只能完成一次'),
            _buildRookieList(list),
            SizedBox(height: 20.h),
            _buildMissionTitle('每日任务', ''),
            _buildDailyList(list),
            SizedBox(height: 8.h),
          ],
        );
      })
    );
  }

  Widget _buildUserProperty() {

    return Consumer(builder: (context, ref, _){
      final WsMemberPointCoinRes? pointAndCoinInfo = ref.watch(userInfoProvider).memberPointCoin;
      final num coins = pointAndCoinInfo?.coins?.toInt() ?? 0;
      final num count = coins;

      return SizedBox(
        width: double.infinity,
        child: Column(mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ImgUtil.buildFromImgPath(_appImageTheme.iconCoin, size: 24.w),
              Text('我的金币', style: TextStyle(fontSize: 14, color: _appColorTheme.missionTitleTextColor, fontWeight: FontWeight.w700)),
              Text('$count', style: TextStyle(fontSize: 28, color: _appColorTheme.missionTitleTextColor, fontWeight: FontWeight.w700)),
            ]
        ),
      );
    });
  }

  Widget _buildMissionTitle(String title, String subTitle){
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: SizedBox(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: _appColorTheme.missionPrimaryTextColor)),
            Visibility(
              visible: subTitle != '',
              child: Text(subTitle, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: _appColorTheme.missionSecondaryTextColor)),
            ),
            const SizedBox(height: 8)
          ],
        ),
      ),
    );
  }

  Widget _buildRookieList(list){
    List rookieMissionList = list?.sublist(0, 4) ?? [];
    return Container(
      decoration: _appBoxDecorationTheme.cellBoxDecoration,
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.only(top: 8, bottom: 8),
        child: Column(
          children: List.generate(
            rookieMissionList.length, (index) =>
              _buildMissionItem(rookieMissionList[index]),
          ),
        ),
      ),
    );
  }

  Widget _buildDailyList(list){

    List dailyMissionList = list?.sublist(4) ?? [];

    return Container(
      decoration: _appBoxDecorationTheme.cellBoxDecoration,
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.only(top: 8, bottom: 8),
        child: Column(
          children: List.generate(dailyMissionList.length, (index) =>
              _buildMissionItem(dailyMissionList[index]),
          ),
        ),
      ),
    );
  }

  Widget _buildMissionItem(item){
    final AppTheme theme = ref.watch(userInfoProvider).theme ?? AppTheme(themeType: AppThemeType.original);
    final AppImageTheme appImageTheme = theme.getAppImageTheme;
    final AppTextTheme appTextTheme = theme.getAppTextTheme;

    final gender = viewModel.gender ?? 0;
    final status = item.status ?? 0;
    final titles = item.name?.split('-')[gender.toInt()].split('/');
    final target = item.target ?? 0;
    final title = titles?[0] ?? '';
    final subTitle = titles?[1] ?? '';

    String buttonText;
    Decoration btnBgColor;
    Color textColor;


    switch (status) {
      case '-1':
        buttonText = '前往';
        btnBgColor = _appBoxDecorationTheme.goToBtnBoxDecoration;
        textColor = _appColorTheme.goToTextColor;
        break;
      case '0':
        buttonText = '领取';
        btnBgColor = _appBoxDecorationTheme.receiveBtnBoxDecoration;
        textColor = _appColorTheme.receiveTextColor;
        break;
      case '1':
        buttonText = '已完成';
        btnBgColor = _appBoxDecorationTheme.completedBtnBoxDecoration;
        textColor = _appColorTheme.completedTextColor;
        break;
      default:
        buttonText = '已完成';
        btnBgColor = _appBoxDecorationTheme.completedBtnBoxDecoration;
        textColor = _appColorTheme.completedTextColor;
        break;
    }


    final num coins = item.coins ?? 0;
    final num points = item.points ?? 0;
    num count = gender == 0 ? points : coins;

    if (gender == 0 && item.status == '-1') {
      count = points;
    } else {
      count = coins;
    }

    if (gender == 1) {
      count = coins;
    }

    return Padding(
        padding: const EdgeInsets.only(top: 8, bottom: 8, left: 11, right: 11),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      ImgUtil.buildFromImgPath(_appImageTheme.iconCoin, size: 24.w),
                      SizedBox(width: 2.w),
                      Text('+$count', style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: _appColorTheme.missionTitleTextColor,
                      ))
                    ],
                  ),
                  SizedBox(height: 4.h),
                  Text(title, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: _appColorTheme.missionPrimaryTextColor)),
                  Text(subTitle, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: _appColorTheme.missionSecondaryTextColor))
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                _missionHandler(status, target, title, subTitle, count, gender);
              },
              child: Container(
                width: 52,
                height: 32,
                decoration: btnBgColor,
                child: Center(
                  child: Text(buttonText, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: textColor)),
                ),
              ),
            )
          ],
        )
    );
  }

  void _missionHandler(status, target, title, subTitle, count, gender){
    if (status == '-1') {
      switch (target) {
        case 0:
        case 1:
        case 2:
        case 3:
          Navigator.of(context).push(MaterialPageRoute(builder: (context) =>
          const PersonalEdit(),),
          ).then((value) {
            viewModel.init(context);
          });
          break;
        case 4:
          naviBarController?.jumpToPage(0);
          Navigator.pop(context);
          break;
        case 5:
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return const InviteFriendQrcodeDialog(type: InviteFriendType.contact);
            },
          );
          break;
        case 6:
        case 7:
        case 8:
          if (Platform.isIOS) {
            naviBarController?.jumpToPage(3);
          } else {
            naviBarController?.jumpToPage(2);
          }
          Navigator.pop(context);
          break;
        default:
      }
    } else if (status == '0') {
      showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return PersonalMissionDialog(target: target,  title: title, subTitle: subTitle, count: count, gender: gender);
        },
      ).then((value) {
        viewModel.init(context);
      });
    }
  }
}


