import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// 參考來源
// https://itecnote.com/tecnote/flutter-hero-animation-with-an-alertdialog/
class HeroDialogRoute<T> extends PageRoute<T> {

  final String tag;
  final Widget widget;

  HeroDialogRoute({
    required this.tag,
    required this.widget
  });

  @override
  String? get barrierLabel => null;

  @override
  bool get opaque => false;

  @override
  bool get barrierDismissible => true;

  @override
  Duration get transitionDuration => const Duration(milliseconds: 300);

  @override
  bool get maintainState => true;

  @override
  Color get barrierColor => Colors.black54;

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
    return FadeTransition(
      opacity: CurvedAnimation(parent: animation, curve: Curves.easeOut),
      child: child
    );
  }

  @override
  Widget buildPage(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
    return AlertDialog(
      titlePadding: const EdgeInsets.all(0),
      contentPadding: const EdgeInsets.all(0),
      insetPadding: const EdgeInsets.all(0),
      actionsPadding: const EdgeInsets.all(0),
      iconPadding: const EdgeInsets.all(0),
      buttonPadding: const EdgeInsets.all(0),
      backgroundColor: Colors.transparent,
      content: Hero(
        tag: tag,
        child: widget,
      ),
    );
  }
}