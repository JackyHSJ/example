import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frechat/system/constant/enum.dart';
import 'package:frechat/system/providers.dart';
import 'package:frechat/widgets/shared/img_util.dart';
import 'package:frechat/widgets/theme/app_box_decoration_theme.dart';
import 'package:frechat/widgets/theme/app_image_theme.dart';
import 'package:frechat/widgets/theme/app_theme.dart';

class IconOnline extends ConsumerStatefulWidget {

  const IconOnline({
    super.key,
  });

  @override
  ConsumerState<IconOnline> createState() => _IconOnlineState();
}

class _IconOnlineState extends ConsumerState<IconOnline> {

  late AppTheme _theme;
  late AppImageTheme _appImageTheme;

  @override
  Widget build(BuildContext context) {

    _theme = ref.watch(userInfoProvider).theme ?? AppTheme(themeType: AppThemeType.original);
    _appImageTheme = _theme.getAppImageTheme;

    return ImgUtil.buildFromImgPath(_appImageTheme.iconOnline, width: 39, height: 16);
  }
}
