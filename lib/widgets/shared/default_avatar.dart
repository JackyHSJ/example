

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frechat/system/constant/enum.dart';
import 'package:frechat/system/providers.dart';
import 'package:frechat/widgets/shared/img_util.dart';
import 'package:frechat/widgets/shared/skeleton_loading.dart';
import 'package:frechat/widgets/theme/app_image_theme.dart';
import 'package:frechat/widgets/theme/app_theme.dart';
import 'package:video_player/video_player.dart';

class DefaultAvatar extends ConsumerStatefulWidget {

  final num gender;
  final double size;

  const DefaultAvatar({
    super.key,
    required this.gender,
    required this.size,
  });

  @override
  ConsumerState<DefaultAvatar> createState() => _DefaultAvatarState();
}

class _DefaultAvatarState extends ConsumerState<DefaultAvatar> {

  num get gender => widget.gender;
  double get size => widget.size;

  late AppTheme _theme;
  late AppImageTheme _appImageTheme;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    _theme = ref.watch(userInfoProvider).theme ?? AppTheme(themeType: AppThemeType.original);
    _appImageTheme = _theme.getAppImageTheme;

    return ImgUtil.buildFromImgPath(gender == 0
        ? _appImageTheme.defaultFemaleAvatar
        : _appImageTheme.defaultMaleAvatar,
      size: size
    );
  }
}