import 'dart:io';
import 'package:flutter/material.dart';

import 'package:flutter_screenutil/src/size_extension.dart';

import 'package:frechat/system/base_view_model.dart';
import 'package:frechat/system/util/cache_network_image_util.dart';

import 'package:frechat/widgets/shared/img_util.dart';
import 'package:frechat/widgets/shared/default_avatar.dart';

class AvatarUtil {
  static const double borderRadius = 6.0;

  // 一般頭貼
  static Widget userAvatar(String avatarPath, {double? size, double? radius}) {
    size ??= 64.w;
    radius ??= borderRadius;

    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: CachedNetworkImageUtil.load(
        avatarPath,
        size: size,
      ),
    );
  }

  // 預設頭貼
  static Widget defaultAvatar(num gender, {double? size, double? radius}) {
    size ??= 64.w;
    radius ??= borderRadius;

    return ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: DefaultAvatar(gender: gender, size: size),
    );
  }

  // local
  static Widget localAvatar(String avatarPath, {double? size, double? radius}) {
    size ??= 64.w;
    radius ??= borderRadius;

    return  ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: ImgUtil.buildFromImgPath(avatarPath, size: size),
    );
  }

  // file
  static Widget fileAvatar(File selectedImage, {double? size, double? radius}) {
    size ??= 64.w;
    radius ??= borderRadius;

    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: SizedBox(
        width: size,
        height: size,
        child: Image(
          image: FileImage(selectedImage),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
