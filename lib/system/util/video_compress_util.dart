import 'dart:io';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:uuid/uuid.dart';
import 'package:video_compress/video_compress.dart';

class VideoCompressUtil {

  // 取得資訊
  static Future<MediaInfo> getMediaInfo(String path) async {
    final MediaInfo info = await VideoCompress.getMediaInfo(path ?? '');
    return info;
  }

  // 取得時間
  // 單位：秒
  static num getMediaDuration(MediaInfo info) {
    final num videoDuration = (info.duration)! / 1000;
    return videoDuration;
  }

  // 取得大小
  // 單位：MB
  static num getMediaFileSize(MediaInfo info) {
    final num mediaFileSize = (info.filesize)! / 1048576;
    return mediaFileSize;
  }

  // 壓縮
  static Future<String> compressMediaFile(File file) async {
    MediaInfo? mediaInfo = await VideoCompress.compressVideo(
      file.path,
      quality: VideoQuality.DefaultQuality,
      deleteOrigin: false,
    );
    MediaInfo info = await getMediaInfo(mediaInfo!.path!);
    return info.path!;
  }
}
