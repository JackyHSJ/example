
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frechat/system/constant/enum.dart';
import 'package:frechat/system/providers.dart';
import 'package:frechat/widgets/constant_value.dart';
import 'package:frechat/widgets/shared/img_util.dart';
import 'package:frechat/widgets/theme/app_color_theme.dart';
import 'package:frechat/widgets/theme/app_image_theme.dart';
import 'package:frechat/widgets/theme/app_theme.dart';

import '../../../models/profile/personal_property_model.dart';
import '../../theme/original/app_colors.dart';

class PersonalPropertyCell extends ConsumerStatefulWidget {

  final PersonalPropertyModel data;

  const PersonalPropertyCell({
    super.key,
    required this.data
  });


  @override
  ConsumerState<PersonalPropertyCell> createState() => _PersonalPropertyCellState();
}

class _PersonalPropertyCellState extends ConsumerState<PersonalPropertyCell> {
  PersonalPropertyModel get data => widget.data;
  late AppTheme _theme;
  late AppColorTheme _appColorTheme;
  late AppImageTheme _appImageTheme;

  @override
  Widget build(BuildContext context) {
    final AppTheme theme = ref.watch(userInfoProvider).theme ?? AppTheme(themeType: AppThemeType.original);
    final AppImageTheme appImageTheme = theme.getAppImageTheme;
    String imagePth = appImageTheme.profileDepositWalletBtnIcon;

    _theme = ref.watch(userInfoProvider).theme ?? AppTheme(themeType: AppThemeType.original);
    _appColorTheme = _theme.getAppColorTheme;
    _appImageTheme = _theme.getAppImageTheme;

    if(data.title.contains('收益')){
      imagePth = appImageTheme.profileBenefitWalletBtnIcon;
    }
    return SizedBox(
      width: 105,
      height: 85,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ImgUtil.buildFromImgPath(imagePth, size: 32),
          _buildPropertyInfo()
        ],
      ),
    );
  }

  _buildPropertyInfo() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(data.title, style: TextStyle(
          color: _appColorTheme.personalProfilePrimaryTextColor,
          fontWeight: FontWeight.w500,
          fontSize: 12,
        )),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Text('${data.num}', style: TextStyle(
            color: _appColorTheme.personalProfileSecondaryTextColor,
            fontWeight: FontWeight.w500,
            fontSize: 12,
          ),
            maxLines: 1,
          ),
        ),
      ],
    );
  }
}