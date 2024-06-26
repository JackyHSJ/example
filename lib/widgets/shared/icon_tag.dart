import 'package:flutter/material.dart';
import 'package:frechat/widgets/shared/tag/icon_calling_free.dart';
import 'package:frechat/widgets/shared/tag/icon_charm_level.dart';
import 'package:frechat/widgets/shared/tag/icon_gender_age.dart';
import 'package:frechat/widgets/shared/tag/icon_online.dart';
import 'package:frechat/widgets/shared/tag/icon_real_name_auth.dart';
import 'package:frechat/widgets/shared/tag/icon_real_person_auth.dart';
import 'package:frechat/widgets/shared/tag/icon_vip.dart';

class IconTag {

  // 性別 icon + 年齡
  static Widget genderAge({
    required gender,
    required age
  }) {
    return IconGenderAge(gender: gender, age: age,);
  }

  // 魅力等級
  static Widget charmLevel({
    required charmLevel
  }) {
    return IconCharmLevel(level: charmLevel);
  }

  // 實名認證
  static Widget realNameAuth() {
    return const IconRealNameAuth();
  }

  // 真人認證
  static Widget realPersonAuth() {
    return const IconRealPersonAuth();
  }

  // 免費通話
  static Widget callingFree() {
    return const IconCallingFree();
  }

  // 在線上
  static Widget online() {
    return const IconOnline();
  }

  // vip
  static Widget vip() {
    return const IconVip();
  }
}
