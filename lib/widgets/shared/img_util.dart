import 'dart:io';

import 'package:flutter/material.dart';
import 'package:frechat/widgets/constant_value.dart';
import 'package:frechat/widgets/theme/original/app_colors.dart';

class ImgUtil {
  static Widget buildFromImgPath(String imgPath, {
    double? size,
    double? width,
    double? height,
    double? opacity,
    double radius = 0,
    Color background = Colors.transparent,
    BoxFit? fit = BoxFit.cover
  }) {
    final isContainAsset = imgPath.contains('assets/');
    return Container(
      width: (size != null) ? size : _getWidth(width),
      height: (size != null) ? size : _getHeight(height),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        color: background,
        image: DecorationImage(
          opacity: opacity ?? 1,
          // image: AssetImage(imgPath),
          // image: ExactAssetImage(imgPath), //AssetImage(imgPath),
          image: isContainAsset
              ? _buildAssetImage(imgPath)
              : _buildFileImg(imgPath), //AssetImage(imgPath),
          fit: fit,
        ),
      ),
    );
  }

  static ImageProvider _buildFileImg(String imgPath) {
    return FileImage(File(imgPath));
  }

  static ImageProvider _buildAssetImage(String imgPath) {
    return ExactAssetImage(imgPath);
  }

  static double _getWidth(double? width) {
    return width ?? WidgetValue.userSmallImg;
  }

  static double _getHeight(double? height) {
    return height ?? WidgetValue.userSmallImg;
  }

  static loadLongImg(String imgPath, {double radius = 0}) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
      ),
      child: Image.asset(imgPath),
    );
  }
}
