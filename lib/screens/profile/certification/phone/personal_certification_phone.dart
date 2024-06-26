import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frechat/screens/profile/certification/phone/personal_certification_phone_view_model.dart';
import 'package:frechat/system/constant/enum.dart';
import 'package:frechat/system/providers.dart';
import 'package:frechat/widgets/constant_value.dart';
import 'package:frechat/widgets/shared/app_bar.dart';
import 'package:frechat/widgets/shared/main_scaffold.dart';
import 'package:frechat/widgets/theme/app_theme.dart';
import 'package:frechat/widgets/theme/uidefine.dart';

class PersonalCertificationPhone extends ConsumerStatefulWidget {
  const PersonalCertificationPhone({super.key});

  @override
  ConsumerState<PersonalCertificationPhone> createState() => _PersonalCertificationPhoneState();
}

class _PersonalCertificationPhoneState extends ConsumerState<PersonalCertificationPhone> {
  late PersonalCertificationPhoneViewModel viewModel;
  late AppTheme _theme;

  @override
  void initState() {
    viewModel = PersonalCertificationPhoneViewModel();
    viewModel.init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _theme = ref.watch(userInfoProvider).theme ?? AppTheme(themeType: AppThemeType.original);

    final double paddingHeight = UIDefine.getAppBarHeight() + UIDefine.getStatusBarHeight();
    return MainScaffold(
      isFullScreen: true,
      needSingleScroll: false,
      padding: EdgeInsets.only(top: paddingHeight, bottom: WidgetValue.bottomPadding, left: WidgetValue.horizontalPadding, right: WidgetValue.horizontalPadding),
      appBar: MainAppBar(theme:_theme,title: '手机认证'),
      child: Column(
        children: [
        ],
      ),
    );
  }
}