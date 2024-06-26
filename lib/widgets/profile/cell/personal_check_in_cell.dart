import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frechat/models/ws_res/check_in/ws_check_in_search_list_res.dart';
import 'package:frechat/system/util/cache_network_image_util.dart';
import 'package:frechat/widgets/shared/img_util.dart';
import 'package:frechat/widgets/theme/app_color_theme.dart';
import 'package:frechat/widgets/theme/app_theme.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'dart:math';

import '../../../system/constant/enum.dart';
import '../../../system/providers.dart';
import '../../../system/repository/http_setting.dart';
import '../../constant_value.dart';
import '../../shared/gradient_component.dart';
import '../../theme/original/app_colors.dart';

class PersonalCheckInCell extends ConsumerStatefulWidget {
  const PersonalCheckInCell({
    super.key,
    required this.todayCount,
    required this.model,
    this.isLastDay = false,
    this.imgPath = 'assets/images/icon_check_in_coin.png',
    required this.gifId,
    this.gifName,
    this.giftImageUrl,
  });

  final num todayCount;
  final CheckInListInfo model;
  final bool isLastDay;
  final String imgPath;
  final num? gifId;
  final String? gifName;
  final String? giftImageUrl;

  @override
  ConsumerState<PersonalCheckInCell> createState() => _PersonalCheckInCellState();
}

class _PersonalCheckInCellState extends ConsumerState<PersonalCheckInCell> {
  CheckInListInfo get model => widget.model;
  num get day => widget.model.day ?? 0;
  bool get isLastDay => widget.isLastDay;
  String get imgPath => widget.imgPath;
  num get todayCount => widget.todayCount;
  late AppTheme _theme;
  late AppColorTheme _appColorTheme;



  @override
  Widget build(BuildContext context) {

    _theme = ref.watch(userInfoProvider).theme ?? AppTheme(themeType: AppThemeType.original);
    _appColorTheme = _theme.getAppColorTheme;

    final alreadyAward = model.punchInFlag == 1;
    return Stack(
      fit: StackFit.passthrough,
      children: [
        Container(
          height: 120,
          margin: EdgeInsets.only(top: WidgetValue.verticalPadding, right: 2, left: 2),
          decoration: BoxDecoration(
            color: alreadyAward ? _appColorTheme.checkedInBgColor : _appColorTheme.notCheckInBgColor,
            borderRadius: BorderRadius.circular(WidgetValue.btnRadius / 2)
          ),
          child: isLastDay ? _buildLastDay() : _buildNormalDay(),
        ),
        _buildAlreadyAward(),
        _buildTodayAward()
      ],
    );
  }

  _buildAlreadyAward() {
    final alreadyAward = model.punchInFlag == 1;
    return Visibility(
      visible: alreadyAward,
      child: Align(
        alignment: Alignment.topRight,
        child: Transform.rotate(
          /// 旋轉角度
          angle: 30 * pi / 180, // 旋转45度
          child: MainGradient(linearGradient: AppColors.labelOrangeColors).icon(iconData: MdiIcons.checkDecagram, iconSize: 24),
        ),
      ),
    );
  }

  _buildTodayAward() {
    final isTodayCanCheck = model.punchInFlag == 0 && todayCount == day;
    return Visibility(
      visible: isTodayCanCheck,
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 5),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: const Color(0xffFFF6EE),
            borderRadius: BorderRadius.circular(WidgetValue.btnRadius / 3),
            boxShadow: const [
              BoxShadow(
                color: Color(0x1A000000),
                offset: Offset(0, 5),
                blurRadius: 10,
                spreadRadius: 0,
              ),
            ],
          ),
          child: const Text('今日可领', style: TextStyle(
            fontWeight: FontWeight.w500, fontSize: 10, height: 1.5),
          ),
        ),
      ),
    );
  }

  _buildNormalDay() {

    final bothAward = model.gold != null && model.gold != 0 && widget.gifId != -1 && widget.gifName != null && widget.gifName!.isNotEmpty;


    return Padding(
      padding: EdgeInsets.all(WidgetValue.verticalPadding),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text('第${model.day}天', style: TextStyle(
            color: _appColorTheme.checkInTitleTextColor, fontWeight: FontWeight.w600, fontSize: 14),
            overflow: TextOverflow.visible,
          ),
          _buildCoinAndGift(),
          Visibility(
            visible: model.gold != null && model.gold != 0,
            child: FittedBox(
              fit: BoxFit.contain,
              child: Text(
                '金币+${model.gold}${bothAward ? ',' : ''}',
                style: const TextStyle(color: Color(0xFFE6803D), fontSize: 10, fontWeight: FontWeight.w700, height: 1),
                overflow: TextOverflow.visible,
              )
            ),
          ),
          const SizedBox(height: 2),
          Visibility(
            visible: widget.gifId != -1 && widget.gifName != null && widget.gifName!.isNotEmpty,
            child: FittedBox(
              fit: BoxFit.contain,
              child: Text(
                widget.gifName!,
                style: const TextStyle(color: Color(0xFFE6803D), fontSize: 10, fontWeight: FontWeight.w700, height: 1),
                overflow: TextOverflow.visible,
              )
            ),
          ),
        ],
      ),
    );
  }

  _buildLastDay() {
    final bothAward = model.gold != null && model.gold != 0 && widget.gifId != -1 && widget.gifName != null && widget.gifName!.isNotEmpty;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          flex: 2,
          child: Padding(
            padding: EdgeInsets.only(
              top: WidgetValue.verticalPadding,
              left: WidgetValue.verticalPadding,
              bottom: WidgetValue.verticalPadding,
            ),
            // padding: EdgeInsets.all(WidgetValue.verticalPadding),
            child: Column(
              children: [
                Text('第${model.day}天', style: TextStyle(color: _appColorTheme.checkInTitleTextColor, fontWeight: FontWeight.w600, fontSize: 14)),
                Expanded(child: Container(),),
                Visibility(
                  visible: model.gold != null && model.gold != 0,
                  child: FittedBox(
                    fit: BoxFit.contain,
                    child: Text(
                      '金币+${model.gold}${bothAward ? ',' : ''}',
                      style: const TextStyle(color: Color(0xFFE6803D), fontSize: 10, fontWeight: FontWeight.w700, height: 1),
                      overflow: TextOverflow.visible,
                    )
                  ),
                ),
                const SizedBox(height: 2),
                Visibility(
                  visible: widget.gifId != -1 && widget.gifName != null && widget.gifName!.isNotEmpty,
                  child: FittedBox(
                    fit: BoxFit.contain,
                    child: Text(
                      widget.gifName!,
                      style: const TextStyle(color: Color(0xFFE6803D), fontSize: 10, fontWeight: FontWeight.w700, height: 1),
                      overflow: TextOverflow.visible,
                    )
                  ),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: Padding(
            padding: EdgeInsets.only(
              top: WidgetValue.verticalPadding,
              bottom: WidgetValue.verticalPadding,
              right: WidgetValue.verticalPadding,
            ),
            child: _buildLastDayCoinAndGift(),
          )
        ),
      ],
    );
  }

  _buildCoinAndGift() {

    if (model.gold == 0 && widget.gifId == -1) {
      return Expanded(child: Container(),);
    }

    if (model.gold != 0 && widget.gifId == -1) {
      return Expanded(child: Image.asset(widget.imgPath, height: WidgetValue.bigIcon));
    }


    return Expanded(child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Visibility(
            visible: model.gold != 0,
            child: Flexible(child: Image.asset(widget.imgPath))
        ),
        Visibility(
          visible: model.gold != 0 && widget.gifId != -1,
          child: const Text('+', style: TextStyle(
              color: Color(0xFFE6803D),
              fontSize: 10,
              fontWeight: FontWeight.w700, height: 1),
          ),
        ),
        Flexible(
            child: Image.network(HttpSetting.baseImagePath + widget.giftImageUrl!)
        ), //network(widget.giftPath!)),
      ],
    ));
  }

  _buildLastDayCoinAndGift() {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Visibility(
              visible: model.gold != 0,
              child: Flexible(child: Image.asset(widget.imgPath))
          ),
          Visibility(
            visible: model.gold != 0 && widget.gifId != -1,
            child: const Text('+', style: TextStyle(
                color: Color(0xFFE6803D),
                fontSize: 10,
                fontWeight: FontWeight.w700, height: 1),
            ),
          ),
          Flexible(
              child: Image.network(HttpSetting.baseImagePath + widget.giftImageUrl!)
          ),
        ],
      ),
    );
  }
}
