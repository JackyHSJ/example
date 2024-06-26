import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frechat/system/constant/enum.dart';
import 'package:frechat/system/providers.dart';
import 'package:frechat/widgets/shared/img_util.dart';
import 'package:frechat/widgets/theme/app_box_decoration_theme.dart';
import 'package:frechat/widgets/theme/app_image_theme.dart';
import 'package:frechat/widgets/theme/app_theme.dart';

class IconVip extends ConsumerStatefulWidget {

  const IconVip({
    super.key,
  });

  @override
  ConsumerState<IconVip> createState() => _IconVipState();
}

class _IconVipState extends ConsumerState<IconVip> {

  late AppTheme _theme;
  late AppImageTheme _appImageTheme;

  @override
  Widget build(BuildContext context) {

    _theme = ref.watch(userInfoProvider).theme ?? AppTheme(themeType: AppThemeType.original);
    _appImageTheme = _theme.getAppImageTheme;

    return _theme.themeType == AppThemeType.original
      ? ImgUtil.buildFromImgPath(_appImageTheme.iconVip, width: 46, height: 16)
      : ImgUtil.buildFromImgPath(_appImageTheme.iconVip, width: 30, height: 16);
  }
}
