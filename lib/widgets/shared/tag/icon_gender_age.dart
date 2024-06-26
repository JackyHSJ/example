import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frechat/system/constant/enum.dart';
import 'package:frechat/system/providers.dart';
import 'package:frechat/widgets/shared/img_util.dart';
import 'package:frechat/widgets/theme/app_box_decoration_theme.dart';
import 'package:frechat/widgets/theme/app_theme.dart';

class IconGenderAge extends ConsumerStatefulWidget {

  final num gender;
  final num age;

  const IconGenderAge({
    super.key,
    required this.gender,
    required this.age
  });

  @override
  ConsumerState<IconGenderAge> createState() => _IconGenderAgeState();
}

class _IconGenderAgeState extends ConsumerState<IconGenderAge> {

  late AppTheme _theme;
  late AppBoxDecorationTheme _appBoxDecorationTheme;
  num get gender => widget.gender;
  num get age => widget.age;

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
    return gender == 0
        ? _appBoxDecorationTheme.tagGenderAgeFemaleBoxDecoration
        : _appBoxDecorationTheme.tagGenderAgeMaleBoxDecoration;
  }

  Widget _buildIcon() {
    return gender == 0
        ? ImgUtil.buildFromImgPath('assets/profile/profile_contact_female_icon.png', size: 12)
        : ImgUtil.buildFromImgPath('assets/profile/profile_contact_male_icon.png', size: 12);
  }

  Widget _buildText() {
    return Text(
      '$age',
      style: const TextStyle(
        color: Colors.white,
        fontSize: 10,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}
