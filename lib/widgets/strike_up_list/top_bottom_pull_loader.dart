import 'dart:async';

import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:flutter/material.dart';
import 'package:frechat/system/base_view_model.dart';
import 'package:frechat/widgets/theme/original/app_colors.dart';

///上下拉更新 by Benson
class TopBottomPullLoader extends StatelessWidget {
  final Widget child;
  final VoidCallback onRefresh;
  final VoidCallback onFetchMore;
  final bool enableRefresh;
  final bool enableFetchMore;
  final Widget? refreshIcon;
  final Widget? fetchMoreIcon;
  final Widget? loadingIcon;

  TopBottomPullLoader({
    Key? key,
    required this.child,
    required this.onRefresh,
    required this.onFetchMore,
    this.enableRefresh = true,
    this.enableFetchMore = true,
    this.refreshIcon,
    this.fetchMoreIcon,
    this.loadingIcon,
  }) : super(key: key);

  int sid = 0;

  Future<void> _timeoutCheck(Function() action) async {
    try {
      await Future.any([
        Future<void>(action),
        Future.delayed(const Duration(seconds: 5), () => throw TimeoutException('亲～网速延迟加载超时啰'))
      ]);
    } on TimeoutException catch (msg) {
      final BuildContext currentContext = BaseViewModel.getGlobalContext();
      if(currentContext.mounted) BaseViewModel.showToast(currentContext, msg.message ?? '');
    }
  }

  @override
  Widget build(BuildContext context) {
    const height = 100.0, topHeight = 70.0;
    return CustomRefreshIndicator(
      onRefresh: () async => sid == 1 ? _timeoutCheck(onRefresh) : _timeoutCheck(onFetchMore),
      trigger: IndicatorTrigger.bothEdges,
      trailingScrollIndicatorVisible: false,
      leadingScrollIndicatorVisible: true,
      child: child,
      builder: (BuildContext context, Widget child, IndicatorController controller) {
        return AnimatedBuilder(
            animation: controller,
            builder: (context, _) {
              //final dy = controller.value.clamp(0.0, 1.25) * -(height - (height * 0.25));
              double dy = 0.0;
              if (controller.side == IndicatorSide.bottom) {
                sid = 2;
                dy = controller.value.clamp(0.0, 1.25) * -(height - (height * 0.25));
              }
              if (controller.side == IndicatorSide.top) {
                sid = 1;
                dy = controller.value.clamp(0.0, 1.25) * (topHeight + (topHeight * 0.25));
              }
              return Stack(
                children: [
                  Transform.translate(
                    offset: Offset(0.0, dy),
                    child: child,
                  ),
                  if (controller.side == IndicatorSide.top && enableRefresh == true)
                    Positioned(
                      top: -topHeight,
                      left: 0,
                      right: 0,
                      height: topHeight,
                      child: Container(
                        transform: Matrix4.translationValues(0.0, dy, 0.0),
                        padding: const EdgeInsets.only(bottom: 0.0),
                        constraints: const BoxConstraints.expand(),
                        child: Column(
                          children: [
                            if (controller.isLoading)
                              loadingIcon ??Image.asset('assets/strike_up_list/refresh_Icon.png', width: 36, height: 36)
                            else
                              refreshIcon ??Image.asset('assets/strike_up_list/refresh_don.png', width: 36, height: 36),
                            const SizedBox(height: 6),
                            Text(
                              controller.isLoading ? "重新整理中" : "下拉以重新整理",
                              style: const TextStyle(fontSize: 12, color: AppColors.mainDark),
                            )
                          ],
                        ),
                      ),
                    ),
                  if (controller.side == IndicatorSide.bottom && enableFetchMore == true)
                    Positioned(
                      bottom: -height,
                      left: 0,
                      right: 0,
                      height: height,
                      child: Container(
                        transform: Matrix4.translationValues(0.0, dy, 0.0),
                        padding: const EdgeInsets.only(top: 0.0),
                        constraints: const BoxConstraints.expand(),
                        child: Column(
                          children: [
                            if (controller.isLoading)
                              loadingIcon ?? Image.asset('assets/strike_up_list/refresh_Icon.png', width: 36, height: 36)
                            else
                              fetchMoreIcon ?? Image.asset('assets/strike_up_list/refresh_up.png', width: 36, height: 36),
                            const SizedBox(height: 6),
                            Text(
                              controller.isLoading ? "正在加载中" : "上拉以加载更多",
                              style: const TextStyle(fontSize: 12, color: AppColors.mainDark),
                            )
                          ],
                        ),
                      ),
                    ),
                ],
              );
            });
      },
    );
  }
}
