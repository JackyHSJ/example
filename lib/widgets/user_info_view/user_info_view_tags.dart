import 'package:flutter/cupertino.dart';
// import 'package:flutter_draggable_gridview/constants/colors.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frechat/models/ws_res/member/ws_member_info_res.dart';
import 'package:frechat/system/constant/enum.dart';
import 'package:frechat/system/providers.dart';
import 'package:frechat/widgets/constant_value.dart';
import 'package:frechat/widgets/shared/list/main_wrap.dart';
import 'package:frechat/widgets/theme/app_color_theme.dart';
import 'package:frechat/widgets/theme/app_theme.dart';
import 'package:frechat/widgets/theme/original/app_colors.dart';

class UserInfoViewTags extends ConsumerStatefulWidget {
  ///觀看自己以外的成員資訊需傳入
  final WsMemberInfoRes? memberInfo;

  const UserInfoViewTags({
    super.key,
    required this.memberInfo,
  });

  @override
  ConsumerState<UserInfoViewTags> createState() => _UserInfoViewTagsState();
}

class _UserInfoViewTagsState extends ConsumerState<UserInfoViewTags> {

  late AppTheme _theme;
  late AppColorTheme _appColorTheme;

  @override
  Widget build(BuildContext context) {


    _theme = ref.watch(userInfoProvider).theme ?? AppTheme(themeType: AppThemeType.original);
    _appColorTheme = _theme.getAppColorTheme;

    int index = -1;
    final List<String> tagList = widget.memberInfo?.tag?.split(',') ?? [];
    return MainWrap().wrap(
        children: tagList.map((info) {
          index = index + 1;
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(99),
              color: _appColorTheme.tagColorList[index]
            ),
            child: Text(
              info,
              style: const TextStyle(
                color: Color(0xff444648),
                fontSize: 14,
                fontWeight: FontWeight.w500
                ),
            ),
          );
        }).toList());
  }
}
