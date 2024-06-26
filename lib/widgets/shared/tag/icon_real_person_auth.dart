import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frechat/system/constant/enum.dart';
import 'package:frechat/system/providers.dart';
import 'package:frechat/widgets/shared/img_util.dart';
import 'package:frechat/widgets/theme/app_box_decoration_theme.dart';
import 'package:frechat/widgets/theme/app_image_theme.dart';
import 'package:frechat/widgets/theme/app_theme.dart';

class IconRealPersonAuth extends ConsumerStatefulWidget {

  const IconRealPersonAuth({
    super.key,
  });

  @override
  ConsumerState<IconRealPersonAuth> createState() => _IconRealPersonAuthState();
}

class _IconRealPersonAuthState extends ConsumerState<IconRealPersonAuth> {

  late AppTheme _theme;
  late AppImageTheme _appImageTheme;

  @override
  Widget build(BuildContext context) {

    _theme = ref.watch(userInfoProvider).theme ?? AppTheme(themeType: AppThemeType.original);
    _appImageTheme = _theme.getAppImageTheme;

    return ImgUtil.buildFromImgPath(_appImageTheme.iconTagRealPersonAuth, width: 66, height: 16);
  }
}
