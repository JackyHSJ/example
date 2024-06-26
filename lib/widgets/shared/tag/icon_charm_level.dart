import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frechat/system/constant/enum.dart';
import 'package:frechat/system/providers.dart';
import 'package:frechat/widgets/shared/img_util.dart';
import 'package:frechat/widgets/theme/app_box_decoration_theme.dart';
import 'package:frechat/widgets/theme/app_theme.dart';

class IconCharmLevel extends ConsumerStatefulWidget {

  final num level;

  const IconCharmLevel({
    super.key,
    required this.level,
  });

  @override
  ConsumerState<IconCharmLevel> createState() => _IconCharmLevelState();
}

class _IconCharmLevelState extends ConsumerState<IconCharmLevel> {

  late AppTheme _theme;
  late AppBoxDecorationTheme _appBoxDecorationTheme;
  num get level => widget.level;

  @override
  Widget build(BuildContext context) {

    _theme = ref.watch(userInfoProvider).theme ?? AppTheme(themeType: AppThemeType.original);
    _appBoxDecorationTheme = _theme.getAppBoxDecorationTheme;

    return Container(
      padding: const EdgeInsets.only(left: 4, right: 6, top: 2, bottom: 2),
      decoration: _buildBoxDecoration(),
      child: Row(
        children: [
          _buildIcon(),
          const SizedBox(width: 2),
          _buildText(),
        ],
      ),
    );
  }

  BoxDecoration _buildBoxDecoration() {
    return _appBoxDecorationTheme.tagCharmLevelBoxDecoration;
  }

  Widget _buildIcon() {
    return ImgUtil.buildFromImgPath('assets/profile/profile_contact_heart_white_icon.png',size: 12);
  }

  Widget _buildText() {
    return Text(
      '$level',
      style: const TextStyle(
        color: Colors.white,
        fontSize: 10,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}
