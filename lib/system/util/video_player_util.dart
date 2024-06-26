import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerUtil {
  VideoPlayerController? _controller;

  Future<void> init({required String url}) async {
    // final url = Uri.parse(urlStr);
    // _controller = VideoPlayerController.networkUrl(url);
    _controller = VideoPlayerController.networkUrl(Uri.parse(url));
    // _controller = VideoPlayerController.asset(path);
    await _controller?.initialize();
  }

  void setFinishCallback({required VoidCallback callback}) {
    _controller?.addListener(() {
      // if (_controller != null && _controller!.value.position == _controller!.value.duration) {
      if (_controller != null) {
          callback();
      }
    });
  }

  Widget buildVideoPlayer() {
    if (_controller != null && isInit()) {
      return AspectRatio(
        aspectRatio: _controller!.value.aspectRatio,
        child: VideoPlayer(_controller!),
      );
    } else {
      return Center(child: CircularProgressIndicator());
    }
  }

  void play() {
    _controller?.play();
  }

  void pause() {
    _controller?.pause();
  }

  void dispose() {
    _controller?.dispose();
  }

  bool isPlaying() {
    return _controller != null && _controller!.value.isPlaying;
  }

  bool isInit() {
    return _controller != null && _controller!.value.isInitialized;
  }

  Duration? getVideoLength() {
    return _controller?.value.duration;
  }

  Duration? getCurrentPosition() {
    return _controller?.value.position;
  }

  void seekTo(Duration position) {
    _controller?.seekTo(position);
  }
}
