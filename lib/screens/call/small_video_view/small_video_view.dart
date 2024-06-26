
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frechat/system/zego_call/zego_provider.dart';
import 'package:frechat/system/zego_call/zego_sdk_manager.dart';
import 'package:frechat/widgets/constant_value.dart';
import 'package:frechat/widgets/theme/original/app_colors.dart';
import 'package:frechat/widgets/theme/uidefine.dart';

class SmallVideoView extends ConsumerStatefulWidget {
  const SmallVideoView({super.key, required this.isCameraOpen});
  final bool isCameraOpen;

  @override
  ConsumerState<SmallVideoView> createState() => _SmallVideoViewState();
}

class _SmallVideoViewState extends ConsumerState<SmallVideoView> {

  bool get isCameraOpen => widget.isCameraOpen;
  double _top = 0;
  double _left = 0;

  @override
  Widget build(BuildContext context) {
    final screenWidth = UIDefine.getWidth();
    final screenHeight = UIDefine.getHeight();

    final double statusBarHeight = WidgetValue.topPadding;
    final double bottomBarHeight = WidgetValue.bottomPadding;
    return Stack(
      children: [
        Positioned(
          top: _top,
          left: _left,
          child: GestureDetector(
            onPanUpdate: (details) {
              setState(() {
                _top += details.delta.dy;
                _left += details.delta.dx;

                if (_top < 0) {
                  _top = 0;
                } else if (_top > screenHeight - WidgetValue.smallVideoHeight - bottomBarHeight) {
                  _top = screenHeight - WidgetValue.smallVideoHeight - bottomBarHeight;
                }

                if (_left < 0) {
                  _left = 0;
                } else if (_left > screenWidth - WidgetValue.smallVideoWidth) {
                  _left = screenWidth - WidgetValue.smallVideoWidth;
                }
              });
            },

            onPanEnd: (details) {
              setState(() {
                if (_left + WidgetValue.smallVideoWidth / 2 < screenWidth / 2) {
                  _left = 0;
                } else {
                  _left = screenWidth - WidgetValue.smallVideoWidth;
                }

                if (_top < 0) {
                  _top = 0;
                } else if (_top > screenHeight - WidgetValue.smallVideoHeight - bottomBarHeight) {
                  _top = screenHeight - WidgetValue.smallVideoHeight - bottomBarHeight;
                }
              });
            },

            child: smallVideoView(),
          ),
        ),
      ],
    );
  }

  Widget smallVideoView() {
    return LayoutBuilder(builder: (context, constraints) {
      final manager = ref.read(zegoSDKManagerProvider);
      return ValueListenableBuilder<Widget?>(
          valueListenable: manager.getVideoViewNotifier(null),
          builder: (context, view, _) {
            return ClipRRect(
              borderRadius: BorderRadius.circular(WidgetValue.btnRadius / 2),
              child: Stack(
                children: [
                  Container(
                    height: WidgetValue.smallVideoHeight, width: WidgetValue.smallVideoWidth,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(WidgetValue.btnRadius / 2),
                      color: (view == null) ? AppColors.whiteBackGround : null,
                    ),
                    child: view,
                  ),
                  Visibility(
                      visible: isCameraOpen == false,
                      child: _buildBlurMask()
                  ),
                ],
              ),
            );
          });
    });
  }

  _buildBlurMask() {
    return Positioned(
      top: 0, left: 0,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
        child: Container(
          width: UIDefine.getWidth(),
          height: UIDefine.getHeight(),
          color: Colors.black.withOpacity(0.5), // 半透明的黑色
        ),
      ),
    );
  }
}
