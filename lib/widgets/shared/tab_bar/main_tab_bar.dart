
import 'package:flutter/material.dart';
import 'package:frechat/widgets/constant_value.dart';

import '../../theme/original/app_colors.dart';
import '../../theme/uidefine.dart';

class MainTabBar {
  MainTabBar({
    required this.controller,
    required this.tabList,
  });
  TabController controller;
  List<Tab> tabList;

  Widget tabBar({
    Color indicatorColor = AppColors.textBlack,
    TextStyle? selectTextStyle,
    TextStyle? unSelectTextStyle,
    bool isScrollable = false,
    double indicatorWeight = 2,
    TabBarIndicatorSize? indicatorSize,
    Decoration? indicator,
    EdgeInsetsGeometry indicatorPadding = EdgeInsets.zero,
    EdgeInsetsGeometry? padding,
    Color dividerColor = AppColors.mainTransparent,
    TabAlignment? tabAlignment,
    Function(int)? onTap
  }) {
    return TabBar(
      padding: padding ?? EdgeInsets.symmetric(horizontal: WidgetValue.horizontalPadding),
      dividerColor: dividerColor,
      indicatorWeight: indicatorWeight,
      isScrollable: isScrollable,
      indicatorColor: indicatorColor,
      indicatorSize: indicatorSize,
      indicator: indicator,
      indicatorPadding: indicatorPadding,

      labelColor: selectTextStyle?.color ?? AppColors.textBlack,
      labelStyle: selectTextStyle ?? TextStyle(color: AppColors.textBlack, fontSize: 16, fontWeight: FontWeight.w600),
      unselectedLabelColor: AppColors.textGrey,
      unselectedLabelStyle: unSelectTextStyle ?? TextStyle(color: AppColors.textGrey, fontSize: 16, fontWeight: FontWeight.w400),
      controller: controller,
      tabAlignment: tabAlignment,
      labelPadding: EdgeInsets.only(left: 20),
      tabs: tabList,
      onTap: (index) {
        onTap?.call(index);
        controller.animateTo(index);
      },
    );
  }
}