import 'package:flutter/material.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';

import '../constant_value.dart';
import '../theme/original/app_colors.dart';

class MainSwiper {
  final SwiperController? controller;
  final int itemCount;

  final Function(int)? onTap;
  final Function(int)? onIndexChanged;

  final SwiperPlugin? pagination;
  final bool enablePagination;

  final bool autoplay;
  final int autoplayDelayTime;

  final double? swiperWidth;
  final double? swiperHeight;
  final double? viewportFraction;
  final double? scale;

  /// 輪播滑動方向
  final Axis scrollDirection;

  final SwiperLayout? swiperLayout;
  final ScrollPhysics? physics;
  final CustomLayoutOption? customLayoutOption;

  MainSwiper({
    this.controller,
    required this.itemCount,
    required this.scrollDirection,
    this.onTap,
    this.onIndexChanged,
    this.pagination,
    this.enablePagination = true,
    this.autoplay = true,
    this.autoplayDelayTime = 3000,
    this.swiperWidth,
    this.swiperHeight,
    this.viewportFraction,
    this.scale,
    this.swiperLayout,
    this.physics,
    this.customLayoutOption,
  });

  Widget build({
    required Widget Function(BuildContext, int) itemBuilder
  }) {
    return SizedBox(
        width: swiperWidth ?? double.maxFinite,
        height: swiperHeight ?? WidgetValue.swiperHeight,
        child: Swiper(
          layout: swiperLayout,
          scrollDirection: scrollDirection,
          controller: controller,
          pagination: enablePagination
            ? pagination ?? _buildPagination()
            : null,
          itemBuilder: itemBuilder,
          loop: false,
          autoplay: autoplay,
          /// 自動播放時間 單位(ms)
          autoplayDelay: autoplayDelayTime,
          itemCount: itemCount,
          viewportFraction: viewportFraction ?? 0.9,
          scale: scale ?? 0.9,
          physics: physics ?? const NeverScrollableScrollPhysics(),
          onTap: (index) => onTap?.call(index),
          onIndexChanged: (index) => onIndexChanged?.call(index),
        ));
  }

  _buildPagination() {
    return const SwiperPagination(
        alignment: Alignment.bottomCenter,
        margin: EdgeInsets.zero,
        builder: DotSwiperPaginationBuilder(
            size: 5,
            activeColor: AppColors.textBlack, activeSize: 10,
            color: AppColors.textGrey)
    );
  }
}