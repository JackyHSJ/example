import 'package:flutter/material.dart';

import '../../theme/original/app_colors.dart';

class CustomIndicator extends Decoration {
  CustomIndicator({this.color = AppColors.textBlack, this.indicatorWidth = 20});
  final Color color;
  final double indicatorWidth;

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) {
    return _CustomPainter(this.color, this.indicatorWidth, onChanged);
  }
}

class _CustomPainter extends BoxPainter {
  _CustomPainter(this.color, this.indicatorWidth, VoidCallback? onChanged) : super(onChanged);

  // 顏色
  final Color color;
  // 定義寬度
  final double indicatorWidth;

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    final paint = Paint();
    paint.color = color;
    paint.style = PaintingStyle.fill;

    final rect = RRect.fromRectAndRadius(
      Rect.fromLTWH(
        offset.dx + (configuration.size!.width - indicatorWidth) / 2, // 使指示器在Tab中心
        configuration.size!.height - 5,
        indicatorWidth,
        5,
      ),
      Radius.circular(2.5),
    );
    canvas.drawRRect(rect, paint);
  }
}
