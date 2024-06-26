import 'dart:math';
import 'package:flutter/material.dart';
import 'package:frechat/widgets/theme/original/app_colors.dart';

class CircleProgressIndicatorWidget extends StatefulWidget {
  final IconData iconData;
  final double iconSize;
  final double borderWidth;
  final Color borderColor;
  final Duration updateDuration;
  final Color recordingIconColor;
  final Color unRecordIconColor;
  final Color? backgroundColor;
  AnimationController controller;
  CircleProgressIndicatorWidget({
    required this.iconData,
    required this.controller,
    this.recordingIconColor = AppColors.mainPink,
    this.unRecordIconColor = AppColors.whiteBackGround,
    this.backgroundColor,
    this.iconSize = 60.0,
    this.borderWidth = 5.0,
    this.borderColor = AppColors.mainPink,
    this.updateDuration = const Duration(milliseconds: 100),
  });

  @override
  _CircleProgressIndicatorWidgetState createState() => _CircleProgressIndicatorWidgetState();
}

class _CircleProgressIndicatorWidgetState extends State<CircleProgressIndicatorWidget> with SingleTickerProviderStateMixin {

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        TweenAnimationBuilder(
          tween: Tween(begin: 0.0, end: widget.controller.value),
          duration: widget.updateDuration,
          builder: (_, double value, __) {
            return CustomPaint(
              painter: CircleProgressPainter(value, widget.borderWidth, widget.borderColor,
                  widget.backgroundColor ?? AppColors.whiteBackGround,
                  isRecording: widget.controller.isAnimating,
                  type: widget.controller.status
              ),
              child: SizedBox(
                width: widget.iconSize + widget.borderWidth * 2,
                height: widget.iconSize + widget.borderWidth * 2,
              ),
            );
          },
        ),
        Icon(widget.iconData, size: widget.iconSize,
            color: (widget.controller.isAnimating) ? widget.recordingIconColor : widget.unRecordIconColor),
      ],
    );
  }
}

class CircleProgressPainter extends CustomPainter {
  final double progress;
  final double strokeWidth;
  final Color color;
  final Color backGroundColor;
  final bool isRecording;
  final AnimationStatus type;
  CircleProgressPainter(this.progress, this.strokeWidth, this.color, this.backGroundColor, {required this.isRecording, required this.type});

  @override
  void paint(Canvas canvas, Size size) {
    final backgroundPaint = Paint()
      ..color = backGroundColor
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final progressPaint = Paint()
      ..color = isRecording ? color : backGroundColor
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;
    // 先畫背景圓圈
    canvas.drawCircle(Offset(size.width / 2, size.height / 2), (size.width - strokeWidth) / 2, backgroundPaint);

    // 接著畫進度圓圈
    canvas.drawArc(Rect.fromCenter(center: Offset(size.width / 2, size.height / 2), width: size.width - strokeWidth, height: size.height - strokeWidth),
        -pi / 2, 2 * pi * progress, false, progressPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
