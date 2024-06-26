import 'dart:async';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frechat/system/assets_path/assets_images_path.dart';
import 'package:frechat/widgets/shared/img_util.dart';
import 'package:video_player/video_player.dart';

// 參考來源
// https://itecnote.com/tecnote/flutter-hero-animation-with-an-alertdialog/
class HeroDialogRouteVideo<T> extends PageRoute<T> {

  final Widget widget;
  final VideoPlayerController videoController;

  HeroDialogRouteVideo({
    required this.widget,
    required this.videoController
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
    return VideoView(
      widget: widget,
      videoController: videoController,
    );
  }
}

class VideoView extends StatefulWidget {

  final Widget widget;
  final VideoPlayerController videoController;

  const VideoView({
    super.key,
    required this.widget,
    required this.videoController
  });

  @override
  _VideoViewState createState() => _VideoViewState();
}

class _VideoViewState extends State<VideoView> with SingleTickerProviderStateMixin {

  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 150));
    _animation = Tween(begin: 1.0,  end: 0.0).animate(_controller);
    widget.videoController?.play();
  }

  @override
  void deactivate() {
    widget.videoController?.pause();
    _controller?.dispose();
    super.deactivate();
  }

  void toggleVideoStatus() {

    if (widget.videoController.value.isPlaying) {
      widget.videoController.pause();
    } else {
      widget.videoController.play();
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      titlePadding: const EdgeInsets.all(0),
      contentPadding: const EdgeInsets.all(0),
      insetPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 50),
      actionsPadding: const EdgeInsets.all(0),
      iconPadding: const EdgeInsets.all(0),
      buttonPadding: const EdgeInsets.all(0),
      backgroundColor: Colors.transparent,
      content: _buildCell(),
    );
  }

  Widget _buildCell() {
    return AspectRatio(
        aspectRatio: widget.videoController.value.aspectRatio,
        child: Stack(
          alignment: Alignment.center,
          children: [
            InkWell(
              onTap: () => toggleVideoStatus(),
              child: widget.widget
            ),
            IgnorePointer(
              child: _buildPlayBtn(widget.videoController.value.isPlaying),
            )
          ],
        )
    );
  }

  Widget _buildPlayBtn(bool status) {
    _controller.reset();
    Future.delayed(const Duration(seconds: 1), () => _controller.forward());
    return FadeTransition(
      opacity: _animation,
      child: ImgUtil.buildFromImgPath(status
        ? AssetsImagesPath.iconActivityVideoPauseSmall
        : AssetsImagesPath.iconActivityVideoPlaySmall, size: 48,
      )
    );
  }
}