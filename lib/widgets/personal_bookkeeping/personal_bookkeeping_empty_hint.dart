import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frechat/system/constant/enum.dart';
import 'package:frechat/system/providers.dart';
import 'package:frechat/widgets/shared/img_util.dart';
import 'package:frechat/widgets/theme/app_image_theme.dart';
import 'package:frechat/widgets/theme/app_theme.dart';

class PersonalBookkeepingEmptyHint extends ConsumerStatefulWidget {
  const PersonalBookkeepingEmptyHint({required this.onResetSearchPressed, Key? key}) : super(key: key);

  final Function() onResetSearchPressed;

  @override
  ConsumerState<PersonalBookkeepingEmptyHint> createState() => _PersonalBookkeepingEmptyHintState();
}

class _PersonalBookkeepingEmptyHintState extends ConsumerState<PersonalBookkeepingEmptyHint> {

  late AppTheme _theme;
  late AppImageTheme _appImageTheme;


  @override
  Widget build(BuildContext context) {

    _theme = ref.watch(userInfoProvider).theme ?? AppTheme(themeType: AppThemeType.original);
    _appImageTheme = _theme.getAppImageTheme;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // ImgUtil.buildFromImgPath(_appImageTheme.imgEmptyBookkeepingBanner, size: 144),
        // // Image.asset('assets/strike_up_list/personal_bookkeeping_no_dtl.png'),
        // const SizedBox(height: 8),
        // Text('无记录', style: Theme.of(context).textTheme.headline6!.copyWith(color: Colors.grey)),
        // const SizedBox(height: 2),
        // Text('重新设定日期', style: Theme.of(context).textTheme.bodyText1!.copyWith(color: Colors.grey)),
        // const SizedBox(height: 4),
        // InkWell(
        //     onTap: widget.onResetSearchPressed,
        //     child: Text('清除搜寻设定',
        //         style: Theme.of(context)
        //             .textTheme
        //             .bodyText1!
        //             .copyWith(color: Colors.grey, decoration: TextDecoration.underline))),
      ],
    );
  }
}
