import 'package:flutter/material.dart';

class CustomUnderlineTabIndicator extends Decoration {
  final double width;
  final double height;
  final double radius;
  final Color color;

  const CustomUnderlineTabIndicator({
    this.width = 10,
    this.height = 3,
    this.radius = 1,
    this.color = const Color.fromRGBO(236, 94, 143, 1),
  });

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) {
    return _CustomUnderlinePainter(
      width: width,
      height: height,
      radius: radius,
      color: color,
      onChanged: onChanged,
    );
  }
}

class _CustomUnderlinePainter extends BoxPainter {
  final double width;
  final double height;
  final double radius;
  final Color color;

  _CustomUnderlinePainter({
    required this.width,
    required this.height,
    required this.radius,
    required this.color,
    VoidCallback? onChanged,
  }) : super(onChanged);

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    final Rect rect = offset & configuration.size!;
    final Paint paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final double indicatorTop = rect.bottom - height;
    final double indicatorLeft = rect.center.dx - width / 2;
    final double indicatorRight = rect.center.dx + width / 2;
    final double indicatorBottom = rect.bottom;

    final Path path = Path()
      ..moveTo(indicatorLeft + radius, indicatorTop)
      ..lineTo(indicatorRight - radius, indicatorTop)
      ..arcTo(
        Rect.fromLTWH(
            indicatorRight - 2 * radius, indicatorTop, 2 * radius, 2 * radius),
        -90 * (3.1415927 / 180),
        90 * (3.1415927 / 180),
        false,
      )
      ..lineTo(indicatorRight, indicatorBottom)
      ..lineTo(indicatorLeft, indicatorBottom)
      ..lineTo(indicatorLeft, indicatorTop)
      ..arcTo(
        Rect.fromLTWH(indicatorLeft, indicatorTop, 2 * radius, 2 * radius),
        -90 * (3.1415927 / 180),
        -90 * (3.1415927 / 180),
        false,
      );

    canvas.drawPath(path, paint);
  }
}
