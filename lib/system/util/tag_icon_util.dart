import 'package:flutter/material.dart';

import 'package:flutter_screenutil/src/size_extension.dart';
import 'package:frechat/widgets/shared/icon_tag.dart';
import 'package:frechat/widgets/shared/img_util.dart';
import 'package:frechat/widgets/theme/original/app_colors.dart';

class TagIconUtil {

  // name
  static Widget tagNameWidget(String name) {
    return Text(
      name,
      style: const TextStyle(
        color: AppColors.mainDark,
        fontSize: 14.0,
        fontWeight: FontWeight.w700,
        height: 1,
      ),
    );
  }

  // gender and age
  static Widget tagGenderAgeWidget(num gender, num age) {
    return IconTag.genderAge(gender: gender, age: age);
  }

  // real name auth
  static Widget tagRealNameAuthWidget() {
    return Row(
      children: [
        ImgUtil.buildFromImgPath('assets/profile/profile_contact_name_certi_cyan_icon.png', size: 16),
        const SizedBox(width: 2)
      ],
    );
  }
}
