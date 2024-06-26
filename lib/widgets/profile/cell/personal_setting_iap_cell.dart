
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frechat/system/constant/enum.dart';
import 'package:frechat/system/providers.dart';
import 'package:frechat/widgets/constant_value.dart';
import 'package:frechat/widgets/shared/img_util.dart';
import 'package:frechat/widgets/shared/list/main_list.dart';
import 'package:frechat/widgets/theme/app_box_decoration_theme.dart';
import 'package:frechat/widgets/theme/app_color_theme.dart';
import 'package:frechat/widgets/theme/app_image_theme.dart';
import 'package:frechat/widgets/theme/app_linear_gradient_theme.dart';
import 'package:frechat/widgets/theme/app_text_theme.dart';
import 'package:frechat/widgets/theme/app_theme.dart';
import 'package:frechat/widgets/theme/app_txt_theme.dart';
import 'package:frechat/widgets/theme/original/app_colors.dart';

import '../../../models/profile/personal_setting_iap_model.dart';
import '../../shared/switch_button.dart';

class PersonalSettingIAPCell extends ConsumerStatefulWidget {
  PersonalSettingIAPCell({super.key, required this.model});
  PersonalSettingIAPModel model;

  @override
  ConsumerState<PersonalSettingIAPCell> createState() => PersonalSettingIAPCellState();
}

class PersonalSettingIAPCellState extends ConsumerState<PersonalSettingIAPCell> {
  PersonalSettingIAPModel get model => widget.model;

  late AppTheme _theme;
  late AppTextTheme _appTextTheme;
  late AppLinearGradientTheme _appLinearGradientTheme;
  late AppColorTheme _appColorTheme;
  late AppImageTheme _appImageTheme;
  late AppBoxDecorationTheme _appBoxDecorationTheme;
  late AppTxtTheme _appTxtTheme;
  @override
  Widget build(BuildContext context) {
    _theme = ref.watch(userInfoProvider).theme ?? AppTheme(themeType: AppThemeType.original);
    _appTextTheme = _theme.getAppTextTheme;
    _appColorTheme = _theme.getAppColorTheme;
    _appImageTheme = _theme.getAppImageTheme;
    _appLinearGradientTheme= _theme.getAppLinearGradientTheme;
    _appBoxDecorationTheme = _theme.getAppBoxDecorationTheme;
    _appTxtTheme = _theme.getAppTxtTheme;
    return Container(
      padding: EdgeInsets.symmetric(vertical: WidgetValue.verticalPadding * 1.5, horizontal: WidgetValue.horizontalPadding),
      decoration:_appBoxDecorationTheme.cellBoxDecoration,
      child: Row(
        children: [
          ImgUtil.buildFromImgPath('assets/profile/profile_coin_icon_2.png', size: WidgetValue.primaryIcon),
          SizedBox(width: WidgetValue.horizontalPadding,),
          Expanded(child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(model.title, style: _appTextTheme.depositCoinTitleTextStyle),
              Text('${model.phraseNum} 金币/${model.unit}', style: _appTextTheme.labelMainBoldContentTextStyle),
            ],
          )),
          ImgUtil.buildFromImgPath(_appImageTheme.iconEditPrices, size: 25)
        ],
      ),
    );
  }
}