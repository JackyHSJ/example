

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frechat/widgets/shared/skeleton_loading.dart';
import 'package:video_player/video_player.dart';

class MediaThumbnail extends ConsumerStatefulWidget {

  String videoUrl;
  double? width;
  double? height;
  double? borderRadius;

  MediaThumbnail({
    super.key,
    required this.videoUrl,
    this.width,
    this.height,
    this.borderRadius,
  });

  @override
  ConsumerState<MediaThumbnail> createState() => _MediaThumbnailState();
}

class _MediaThumbnailState extends ConsumerState<MediaThumbnail> {

  late VideoPlayerController _controller;
  String get videoUrl => widget.videoUrl;
  double get width => widget.width ?? 50.w;
  double get height => widget.height ?? 50.w;
  double get borderRadius => widget.borderRadius ?? 0;

  void _initVideoPlayer() {
    _controller = VideoPlayerController.networkUrl(Uri.parse(videoUrl));
    _controller.initialize().then((_) => setState(() {}));
  }

  void _disposeVideoPlayer() {
    _controller?.dispose();
  }

  @override
  void initState() {
    super.initState();
    _initVideoPlayer();
  }

  @override
  void dispose() {
    _disposeVideoPlayer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _controller.value.isInitialized
        ? _buildVideoPlayer()
        : _buildSkeletonLoading();

  }

  Widget _buildVideoPlayer() {
    return SizedBox(
      width: width,
      height: height,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: Stack(
          alignment: Alignment.center,
          children: [
            VideoPlayer(_controller),
          ],
        ),
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