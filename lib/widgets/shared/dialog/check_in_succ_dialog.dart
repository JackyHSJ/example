import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frechat/models/ws_res/check_in/ws_check_in_search_list_res.dart';
import 'package:frechat/screens/profile/check_in/personal_check_in.dart';
import 'package:frechat/screens/profile/check_in/personal_check_in_view_model.dart';
import 'package:frechat/system/base_view_model.dart';
import 'package:frechat/system/call_back_function.dart';
import 'package:frechat/system/constant/enum.dart';
import 'package:frechat/system/providers.dart';
import 'package:frechat/system/util/cache_network_image_util.dart';
import 'package:frechat/widgets/constant_value.dart';
import 'package:frechat/widgets/shared/dialog/base_dialog.dart';
import 'package:frechat/widgets/shared/gradient_component.dart';
import 'package:frechat/widgets/shared/img_util.dart';
import 'package:frechat/widgets/shared/loading_animation.dart';
import 'package:frechat/widgets/theme/app_box_decoration_theme.dart';
import 'package:frechat/widgets/theme/app_color_theme.dart';
import 'package:frechat/widgets/theme/app_theme.dart';
import 'package:frechat/widgets/theme/uidefine.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../../system/repository/http_setting.dart';
import '../../theme/original/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CheckInSuccDialog extends ConsumerStatefulWidget {

  String title;
  MainAxisAlignment? mainAxisAlignment;
  EdgeInsetsGeometry? contentPadding;
  EdgeInsets? insetPadding;
  bool isBtnEnable;

  CheckInSuccDialog({
    super.key,
    required this.title,
    this.mainAxisAlignment = MainAxisAlignment.center,
    this.contentPadding,
    this.insetPadding,
    required this.isBtnEnable,
  });


  @override
  _CheckInSuccDialogState createState() => _CheckInSuccDialogState();
}

class _CheckInSuccDialogState extends ConsumerState<CheckInSuccDialog> {
  String get title => widget.title;
  MainAxisAlignment? get mainAxisAlignment => widget.mainAxisAlignment;
  EdgeInsetsGeometry? get contentPadding => widget.contentPadding;
  EdgeInsets? get insetPadding => widget.insetPadding;
  bool get isBtnEnable => widget.isBtnEnable;

  late AppTheme _theme;
  late AppBoxDecorationTheme _appBoxDecoration;
  late AppColorTheme _appColorTheme;

  @override
  Widget build(BuildContext context) {

    _theme = ref.watch(userInfoProvider).theme ?? AppTheme(themeType: AppThemeType.original);
    _appBoxDecoration = _theme.getAppBoxDecorationTheme;
    _appColorTheme = _theme.getAppColorTheme;

    return AlertDialog(
      backgroundColor: _appBoxDecoration.cellBoxDecoration.color,
      surfaceTintColor: Colors.transparent,
      insetPadding: insetPadding ?? EdgeInsets.symmetric(horizontal: WidgetValue.horizontalPadding),
      title: Text(title, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20, color: _appColorTheme.checkInTitleTextColor), textAlign: TextAlign.center,),
      content: _buildContent(),
      contentPadding: contentPadding ?? EdgeInsets.symmetric(horizontal: WidgetValue.horizontalPadding),
      actionsAlignment: mainAxisAlignment,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
        side: BorderSide(
            width: _appBoxDecoration.cellBoxDecoration.border!.top.width,
            color: _appBoxDecoration.cellBoxDecoration.border!.top.color
        ),
      ),
      actions: [
        InkWell(
          onTap: () => BaseViewModel.popPage(context),
          child: Container(
            padding: EdgeInsets.symmetric(vertical: WidgetValue.verticalPadding * 1.5),
            width: double.maxFinite,
            // decoration: ,
            decoration: isBtnEnable ? _appBoxDecoration.checkInBtnBoxDecoration : _appBoxDecoration.checkInBtnDisableBoxDecoration,
            // decoration: BoxDecoration(
            //     gradient: (isBtnEnable) ? AppColors.labelOrangeColors : null,
            //     color: (isBtnEnable) ? null : AppColors.btnLightGrey,
            //     borderRadius: BorderRadius.circular(WidgetValue.btnRadius * 2)
            // ),
            child: const Text('签到', textAlign: TextAlign.center, style: TextStyle(color: AppColors.textWhite, fontWeight: FontWeight.w600)),
          ),
        )
      ],
    );
  }

  _buildContent() {
    return Consumer(builder: (context, ref, _){
      final WsCheckInSearchListRes? checkInInfo = ref.watch(userInfoProvider).checkInSearchList;
      final num continuousNum = checkInInfo?.continuousNum ?? 0;
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildCellOrSucc(),
          Padding(
            padding: EdgeInsets.symmetric(vertical: WidgetValue.verticalPadding * 2),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('已连续签到', style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16, color: _appColorTheme.checkInTitleTextColor)),
                Text(' $continuousNum ', style: const TextStyle(color: AppColors.mainYellow, fontWeight: FontWeight.w600, fontSize: 16)),
                Text('天奖励', style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16, color: _appColorTheme.checkInTitleTextColor))
              ],
            ),
          ),
        ],
      );
    });
  }

  _buildAlreadyAward() {
    return Positioned(
      top: -4,
      right: -9,
      child: Transform.rotate(
        angle: 30 * pi / 180,  // 旋转45度
        child: MainGradient(linearGradient: AppColors.labelOrangeColors).icon(
          iconData: MdiIcons.checkDecagram,
          iconSize: 36
        ),
      )
    );
  }

  _buildCellOrSucc() {
    return Consumer(builder: (context, ref, _){
      final WsCheckInSearchListRes? checkInInfo = ref.watch(userInfoProvider).checkInSearchList;
      final num today = checkInInfo?.todayCount ?? 0;
      final int index = checkInInfo?.list?.indexWhere((info) => info.day == today) ?? 0;
      final num goldNum = checkInInfo?.list?[index].gold ?? 0;
      final String giftUrl = checkInInfo?.list?[index].giftUrl ?? '';
      final String giftName = checkInInfo?.list?[index].giftName ?? '';
      final num giftId = checkInInfo?.list?[index].giftId ?? -1;
      final bool bothAward = goldNum != 0 && giftUrl != '-1';

      // 金幣是 0 跟 沒有禮物
      if (goldNum == 0 && giftId == -1) {
        return  Container();
      }

      // 金幣不等於 0 & 沒有禮物
      if (goldNum != 0 && giftId == -1) {
        return Column(
          children: [
            const SizedBox(height: 26),
            Stack(
              alignment: Alignment.topRight,
              clipBehavior: Clip.none,
              children: [
                Container(
                  padding: const EdgeInsets.only(
                      top: 40, right: 16, left: 16, bottom: 16.5),
                  decoration: BoxDecoration(
                      color: const Color(0xffFFF6EE),
                      borderRadius:
                          BorderRadius.circular(WidgetValue.btnRadius)),
                  child: Column(
                    children: [
                      ImgUtil.buildFromImgPath(
                          'assets/images/icon_check_in_coin.png',
                          size: 70.w),
                      const SizedBox(height: 20),
                      MainGradient().text(
                          title: '金币+$goldNum${bothAward ? ',' : ''}',
                          fontSize: 16,
                          fontWeight: FontWeight.w800),
                    ],
                  ),
                ),
                _buildAlreadyAward(),
              ],
            )
          ],
        );
      }

      // 金幣等於 0 & 有禮物
      if (goldNum == 0 && giftId != -1) {
        return Column(
          children: [
            const SizedBox(height: 26),
            Stack(
              alignment: Alignment.topRight,
              clipBehavior: Clip.none,
              children: [
                Container(
                  padding: const EdgeInsets.only(
                      top: 40, right: 16, left: 16, bottom: 16.5),
                  decoration: BoxDecoration(
                      color: const Color(0xffFFF6EE),
                      borderRadius:
                          BorderRadius.circular(WidgetValue.btnRadius)),
                  child: Column(
                    children: [
                      _buildGiftInfo(giftUrl, giftName),
                      const SizedBox(height: 20),
                      MainGradient().text(
                          title: '$giftName',
                          fontSize: 16,
                          fontWeight: FontWeight.w800),
                    ],
                  ),
                ),
                _buildAlreadyAward(),
              ],
            )
          ],
        );
      }

      // 金幣不等於 0 & 有禮物
      return Column(
        children: [
          const SizedBox(height: 26),
          Stack(
            alignment: Alignment.topRight,
            clipBehavior: Clip.none,
            children: [
              Container(
                padding: const EdgeInsets.only(top: 40, right: 16, left: 16, bottom: 16.5),
                decoration: BoxDecoration(
                  color: _appColorTheme.checkedInBgColor,
                  borderRadius: BorderRadius.circular(WidgetValue.btnRadius),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ImgUtil.buildFromImgPath('assets/images/icon_check_in_coin.png', size: 70.w),
                        Visibility(
                          visible: giftUrl != '-1',
                          child: _buildGiftInfo(giftUrl, giftName),
                        )
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        MainGradient().text(
                            title: '金币+$goldNum${bothAward ? ',' : ''}',
                            fontSize: 16,
                            fontWeight: FontWeight.w800),
                        MainGradient().text(
                            title: '$giftName',
                            fontSize: 16,
                            fontWeight: FontWeight.w800),
                      ],
                    )
                  ],
                ),
              ),
              _buildAlreadyAward(),
            ],
          )
        ],
      );
    });
  }

  _buildGiftInfo(giftUrl, giftName){
    return Column(
      children: [
        Image.network(HttpSetting.baseImagePath + giftUrl, width: 70, height: 70, fit: BoxFit.contain,),
      ],
    );
  }
}