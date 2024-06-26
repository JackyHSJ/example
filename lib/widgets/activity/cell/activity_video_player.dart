


import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frechat/system/assets_path/assets_images_path.dart';
import 'package:frechat/system/base_view_model.dart';
import 'package:frechat/widgets/shared/dialog/hero_dialog_video.dart';
import 'package:frechat/widgets/shared/img_util.dart';
import 'package:frechat/widgets/shared/skeleton_loading.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:visibility_detector/visibility_detector.dart';

enum VideoSource {
  assets,
  file,
  network,
}

class ActivityVideoPlayer extends ConsumerStatefulWidget {

  VideoSource? source;
  String? videoUrl;
  File? videoFile;
  VoidCallback? removeFile;
  double? borderWidth;
  double? width;
  double? height;
  bool? showDuration;
  bool? showRemoveBtn;
  double? borderRadius;
  bool? showPlayBtn;
  double? playBtnSize;
  bool? isEnablePreview;


  ActivityVideoPlayer({
    super.key,
    this.videoUrl,
    this.videoFile,
    this.source,
    this.removeFile,
    this.width,
    this.height,
    this.borderWidth,
    this.showDuration,
    this.showRemoveBtn,
    this.borderRadius,
    this.showPlayBtn,
    this.playBtnSize,
    this.isEnablePreview,
  });

  @override
  ConsumerState<ActivityVideoPlayer> createState() => _ActivityVideoPlayerState();
}

class _ActivityVideoPlayerState extends ConsumerState<ActivityVideoPlayer> {

  late VideoPlayerController _controller;
  bool isPlaying = false;

  VideoSource get source => widget.source ?? VideoSource.file;
  String get videoUrl => widget.videoUrl ?? '';
  File? get videoFile => widget.videoFile;
  VoidCallback? get removeFile => widget.removeFile;
  double get width => widget.width ?? 50.w;
  double get height => widget.height ?? 50.w;
  double get borderWidth => widget.borderWidth ?? 0;
  bool get showDuration => widget.showDuration ?? false;
  bool get showRemoveBtn => widget.showRemoveBtn ?? false;
  double get borderRadius => widget.borderRadius ?? 0;
  bool get showPlayBtn => widget.showPlayBtn ?? false;
  double get playBtnSize => widget.playBtnSize ?? 48;
  bool get isEnablePreview => widget.isEnablePreview ?? true;

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void initState() {
    super.initState();
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
      _controller = VideoPlayerController.file(videoFile!);
    } else {
      _controller = VideoPlayerController.networkUrl(Uri.parse(videoUrl));
    }
    _controller.addListener(() {});
    _controller.initialize().then((_) => setState(() {}));
  }

  // dispose vide player
  void _disposeVideoPlayer() {
    _controller?.dispose();
    _controller?.removeListener(() { });
  }

  // pause video player
  void _pauseVideoPlayer() {
    setState(() {
      isPlaying = false;
      _controller?.pause();
    });
  }

  // video duration format
  String formatDuration(Duration duration) {
    String minutes = duration.inMinutes.toString().padLeft(2, '0');
    String seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    return _controller.value.isInitialized
        ? _buildVideoPlayer()
        : _buildSkeletonLoading();
  }

  Widget _buildVideoPlayer() {
    return VisibilityDetector(
      key: const Key('activity-video-player'),
      onVisibilityChanged: (VisibilityInfo info) {
        // 如果影片可視範圍小於 0.5，將停止播放影片
        if (info.visibleFraction < 0.5) _pauseVideoPlayer();
      },
      child: InkWell(
        onTap: () {
          if (isEnablePreview) {
            Navigator.push(context, HeroDialogRouteVideo(
              widget: VideoPlayer(_controller),
              videoController: _controller
            ));
          }
        },
        child: Container(
          width: width,
          height: height,
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
                VideoPlayer(_controller),
                showPlayBtn ? _buildPlayBtn(isPlaying) : const SizedBox(),
                showDuration ?  _buildVideoDuration() : const SizedBox(),
                showRemoveBtn ? _buildRemoveFileBtn(): const SizedBox(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPlayBtn(bool status) {
    return ImgUtil.buildFromImgPath(status
      ? AssetsImagesPath.iconActivityVideoPauseSmall
      : AssetsImagesPath.iconActivityVideoPlaySmall, size: playBtnSize
    );
  }

  Widget _buildVideoDuration() {
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
      width: width,
      height: height,
      child: const SkeletonLoading(),
    );
  }
}