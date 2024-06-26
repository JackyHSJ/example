


import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frechat/system/assets_path/assets_images_path.dart';
import 'package:frechat/system/base_view_model.dart';
import 'package:frechat/widgets/activity/cell/activity_video_player.dart';
import 'package:frechat/widgets/shared/dialog/hero_dialog_video.dart';
import 'package:frechat/widgets/shared/img_util.dart';
import 'package:frechat/widgets/shared/skeleton_loading.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:visibility_detector/visibility_detector.dart';

// 有無外層包裹
class AspectRatioVideo extends ConsumerStatefulWidget {

  final VideoSource source;
  final String filePath;

  double? width;
  double? height;
  VoidCallback? removeFile;
  double? borderWidth;
  bool? showDuration;
  bool? showRemoveBtn;
  double? borderRadius;
  bool? showPlayBtn;
  double? playBtnSize;
  bool? enablePreview;
  num? page;


  AspectRatioVideo({
    super.key,
    required this.filePath,
    required this.source,
    this.width,
    this.height,
    this.removeFile,
    this.borderWidth,
    this.showDuration,
    this.showRemoveBtn,
    this.borderRadius,
    this.showPlayBtn,
    this.playBtnSize,
    this.enablePreview,
    this.page
  });

  @override
  ConsumerState<AspectRatioVideo> createState() => _AspectRatioVideoState();
}

class _AspectRatioVideoState extends ConsumerState<AspectRatioVideo> {

  late VideoPlayerController _controller;
  bool isPlaying = false;
  late double width;
  late double height;

  VideoSource get source => widget.source;
  String get filePath => widget.filePath;
  VoidCallback? get removeFile => widget.removeFile;
  double get borderWidth => widget.borderWidth ?? 0;
  bool get showDuration => widget.showDuration ?? false;
  bool get showRemoveBtn => widget.showRemoveBtn ?? false;
  double get borderRadius => widget.borderRadius ?? 0;
  bool get showPlayBtn => widget.showPlayBtn ?? false;
  double get playBtnSize => widget.playBtnSize ?? 48;
  bool get enablePreview => widget.enablePreview ?? true;
  num get page => widget.page ?? 0;

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void initState() {
    super.initState();
    width = widget.width ?? 200;
    height = widget.height ?? 200;
    _initVideoPlayer();
  }

  @override
  void deactivate() {
    _disposeVideoPlayer();
    super.deactivate();
  }

  // init video player
  void _initVideoPlayer() {
    if (source == VideoSource.file) {
      _controller = VideoPlayerController.file(File(filePath));
    } else if (source == VideoSource.network) {
      _controller = VideoPlayerController.networkUrl(Uri.parse(filePath));
    } else {
      _controller = VideoPlayerController.asset(filePath);
    }

    _controller.addListener(() {});
    _controller.initialize().then((_) => getVideoRatio());
  }

  // dispose vide player
  void _disposeVideoPlayer() {
    _controller?.dispose();
    _controller?.removeListener(() {});
  }

  // pause video player
  void _pauseVideoPlayer() {
    setState(() {
      isPlaying = false;
      _controller?.pause();
    });
  }

  void getVideoRatio() {
    double aspectRatio = _controller.value.size.width.toDouble() /_controller.value.size.height.toDouble();
    if (aspectRatio > 1) {
      width = 266.7;
      height = 200;
    } else if (aspectRatio < 1) {
      width = 200;
      height = 266.67;
    } else {
      width = 200;
      height = 200;
    }
    setState(() { });
  }

  void showPreview() {
    if (enablePreview) {
      Navigator.push(context, HeroDialogRouteVideo(widget: VideoPlayer(_controller), videoController: _controller));
    }
  }

  // video duration format
  String formatDuration(Duration duration) {
    String minutes = duration.inMinutes.toString().padLeft(2, '0');
    String seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {

    if (_controller.value.isInitialized) {
      return _buildVideoPlayer();
    }

    return _buildSkeletonLoading();
  }

  Widget _buildVideoPlayer() {
    return VisibilityDetector(
      key: const Key('activity-video-player'),
      onVisibilityChanged: (VisibilityInfo info) {
        // 如果影片可視範圍小於 0.5，將停止播放影片
        if (info.visibleFraction < 0.5) _pauseVideoPlayer();
      },
      child: InkWell(
        onTap: () => showPreview(),
        child: Container(
          width: page == 1 ? 112 : width,
          height: page == 1 ? 112 : height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(borderRadius + 1),
            border: borderWidth != 0 ? Border.all(width: borderWidth) : null,
            color: const Color(0xffEAEAEA)
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(borderRadius),
            child: Stack(
              alignment: Alignment.center,
              children: [
                _buildVideoView(),
                _buildPlayBtn(isPlaying),
                _buildVideoDuration(),
                _buildRemoveFileBtn(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildVideoView() {
    return SizedBox.expand(
      child: FittedBox(
        fit: BoxFit.cover,
        child: SizedBox(
          width: page == 1 ? 112 : width,
          height: page == 1 ? 112 : height,
          child: VideoPlayer(_controller),
        )
      ),
    );
  }

  Widget _buildPlayBtn(bool status) {

    if (!showPlayBtn) return const SizedBox();

    return ImgUtil.buildFromImgPath(status
        ? AssetsImagesPath.iconActivityVideoPauseSmall
        : AssetsImagesPath.iconActivityVideoPlaySmall, size: playBtnSize
    );
  }

  Widget _buildVideoDuration() {

    if (!showDuration) return const SizedBox();

    return Positioned(
      left: 6,
      bottom: 6,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        decoration: BoxDecoration(
          color: const Color.fromRGBO(42, 43, 54, 0.7),
          borderRadius: BorderRadius.circular(99),
        ),
        child: Text(
          formatDuration(_controller.value.duration),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }

  Widget _buildRemoveFileBtn() {

    if (!showRemoveBtn) return const SizedBox();

    return Positioned(
      right: 0,
      bottom: 0,
      child: InkWell(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onTap: removeFile,
          child: SizedBox(
            width: 21,
            height: 21,
            child: Center(
              child: ImgUtil.buildFromImgPath(AssetsImagesPath.iconActivityPostCancel, size: 16),
            ),
          )
      ),
    );
  }

  Widget _buildSkeletonLoading() {
    return SizedBox(
      width: page == 1 ? 112 : width,
      height: page == 1 ? 112 : height,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: const SkeletonLoading(),
      )
    );
  }
}