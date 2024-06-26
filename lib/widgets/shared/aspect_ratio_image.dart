import 'dart:async';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frechat/system/util/cache_network_image_util.dart';
import 'package:frechat/widgets/shared/img_util.dart';

enum FromPage {
  activity,
  chatroom
}

enum FileType {
  asset,
  file,
  network,
}

enum ImageRatioType {
  square,
  portrait,
  landscape,
}

class AspectRatioImage extends ConsumerStatefulWidget {

  final String imagePath;
  final FileType fileType;
  final FromPage fromPage;
  double? size;
  double? width;
  double? height;
  double? radius;

  AspectRatioImage({
    super.key,
    required this.imagePath,
    required this.fileType,
    required this.fromPage,
    this.size,
    this.width,
    this.height,
    this.radius,
  });

  @override
  ConsumerState<AspectRatioImage> createState() => _AspectRatioImageState();
}

class _AspectRatioImageState extends ConsumerState<AspectRatioImage> {

  String get imagePath => widget.imagePath;
  FileType get fileType => widget.fileType;
  FromPage get fromPage => widget.fromPage;

  double size = 0;
  double? width;
  double? height;
  double radius = 0;

  late ImageStreamListener _listener;
  late Completer<ImageRatioType>? _completer;
  late Image _image;

  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  void dispose() {
    _image.image.resolve(const ImageConfiguration()).removeListener(_listener);
    _completer = null;
    super.dispose();
  }


  void init() {
    size = widget.size ?? 200;
    width = widget.width;
    height = widget.height;
    radius = widget.radius ?? 12;

    _completer = Completer<ImageRatioType>();
    _listener = ImageStreamListener((ImageInfo info, bool _) {

      // https://cloud.tencent.com/developer/ask/sof/106697791
      if (_completer?.isCompleted ?? false) return;

      double aspectRatio = info.image.width.toDouble() / info.image.height.toDouble();
      if (aspectRatio > 1) {
        fromPage == FromPage.chatroom ? width = 200 : width = 266.67;
        fromPage == FromPage.chatroom ? height = 150 : height = 200;
        _completer?.complete(ImageRatioType.landscape);
      } else if (aspectRatio < 1) {
        fromPage == FromPage.chatroom ? width = 150 : width = 200;
        fromPage == FromPage.chatroom ? height = 200 : height = 266.7;
        _completer?.complete(ImageRatioType.portrait);
      } else {
        fromPage == FromPage.chatroom ? width = 150 : width = 200;
        fromPage == FromPage.chatroom ? height = 150 : height = 200;
        _completer?.complete(ImageRatioType.square);
      }
    });

    if (fileType == FileType.asset) {
      _image = Image.asset(imagePath);
    } else if (fileType == FileType.file) {
      File imageFile = File(imagePath);
      _image = Image.file(imageFile);
    } else {
      _image = Image.network(imagePath);
    }

    _image.image.resolve(const ImageConfiguration()).addListener(_listener);

  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ImageRatioType>(
      future: _completer?.future,
      builder: (BuildContext context, AsyncSnapshot<ImageRatioType> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildLoading();
        } else if (snapshot.hasData) {
          return _buildImageView(snapshot);
        } else if (snapshot.hasError) {
          return _buildErrorView();
          // return Text('Error: ${snapshot.error}');
        } else {
          return _buildErrorView();
          // return const Text('Waiting for image...');
        }
      },
    );
  }

  Widget _buildLoading() {
    return SizedBox(
      width: size,
      height: size,
      child: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget _buildImageView(AsyncSnapshot<ImageRatioType> snapshot) {

    if (fileType == FileType.file) {
      File imageFile = File(imagePath);
      return ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: Image.file(imageFile, width: width, height: height, fit: BoxFit.cover)
      );
    }

    return ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: Image.network(imagePath, width: width, height: height, fit: BoxFit.cover)
    );
  }

  Widget _buildErrorView() {
    return SizedBox(
      width: width,
      height: height,
    );
  }
}
