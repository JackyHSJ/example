



import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frechat/system/repository/http_setting.dart';
import 'package:frechat/widgets/shared/circle_progress.dart';
import 'package:frechat/widgets/shared/img_util.dart';
import 'package:frechat/widgets/shared/skeleton_loading.dart';
import 'package:frechat/widgets/theme/original/app_colors.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class VideoThumbnailUtil extends StatefulWidget {

  final String videoUrl;
  final int quality;

  const VideoThumbnailUtil({
    super.key,
    required this.videoUrl,
    this.quality = 70,
 });

  @override
  State<VideoThumbnailUtil> createState() => _VideoThumbnailState();
}

class _VideoThumbnailState extends State<VideoThumbnailUtil> {

  bool isLoading = true;
  String thumbnailPath = '';

  int get quality => widget.quality;
  String get videoUrl => widget.videoUrl;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    getVideoThumbnail();
  }

  Future getVideoThumbnail() async {
    final String thumbnailFileName = await VideoThumbnail.thumbnailFile(
      video: HttpSetting.baseImagePath + videoUrl,
      thumbnailPath: (await getTemporaryDirectory()).path,
      imageFormat: ImageFormat.JPEG,
      quality: quality,
    ) ?? '';
    thumbnailPath = thumbnailFileName;
    isLoading = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const SkeletonLoading()
        : ImgUtil.buildFromImgPath(thumbnailPath, size: double.infinity, fit: BoxFit.cover);
  }

}