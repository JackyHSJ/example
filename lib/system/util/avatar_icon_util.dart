import 'package:flutter/material.dart';

import 'package:flutter_screenutil/src/size_extension.dart';
import 'package:frechat/widgets/shared/img_util.dart';

class AvatarIconUtil {

  // online icon
  static Widget onlineIconWidget(num isOnline) {
    return (isOnline == 1)
        ? Positioned(
            right: 0,
            bottom: 0,
            child: Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color.fromRGBO(146, 209, 72, 1),
                border: Border.all(
                  color: Colors.white,
                  width: 1,
                ),
              ),
            ),
          )
        : const SizedBox();
  }

  // pinTop icon
  static Widget pinTopWidget(num isPinTop,String imagePath) {
    return (isPinTop == 1)
        ? Positioned(
            bottom: 0,
            left: 0,
            child: ImgUtil.buildFromImgPath(imagePath, size: 16.w),
          )
        : const SizedBox();
  }
}
