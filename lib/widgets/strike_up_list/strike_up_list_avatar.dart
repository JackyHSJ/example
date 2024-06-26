import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frechat/system/constant/enum.dart';
import 'package:frechat/system/util/avatar_util.dart';
import 'package:flutter_screenutil/src/size_extension.dart';
import 'package:frechat/widgets/shared/img_util.dart';
import 'package:frechat/widgets/theme/app_image_theme.dart';
import 'package:frechat/widgets/theme/app_theme.dart';

import '../../models/ws_res/member/ws_member_fate_recommend_res.dart';
import '../../system/providers.dart';
import '../../system/repository/http_setting.dart';
import 'strike_up_list_extension.dart';

class StrikeUpListAvatar extends ConsumerStatefulWidget {
  final FateListInfo fateListInfo;
  //final num realPerson;
  const StrikeUpListAvatar({super.key, required this.fateListInfo}); //, required this.realPerson});

  @override
  ConsumerState<StrikeUpListAvatar> createState() => _StrikeUpListAvatarState();
}

class _StrikeUpListAvatarState extends ConsumerState<StrikeUpListAvatar> {

  String get avatar => widget.fateListInfo.avatar ?? '';
  num get gender => widget.fateListInfo.gender ?? 0;

  @override
  Widget build(BuildContext context) {

    return Stack(
      children: [
        // 頭像
        _buildAvatar(),
        // 真人
        Positioned(
          right: 0,
          top: 0,
          child: widget.fateListInfo.realPersonAuth == 1 ? _buildRealPerson() : const SizedBox(),
        ),
        // 在線
        Positioned(
          right: 0,
          bottom: 0,
          child: widget.fateListInfo.isOnline == 1 ? StrikeUpListExtension.online() : const SizedBox(width: 0, height: 0),
          //child: SizedBox(width: 0, height: 0),
        ),
      ],
    );
  }

  Widget _buildAvatar() {
    return (avatar.isNotEmpty)
        ? AvatarUtil.userAvatar(HttpSetting.baseImagePath + avatar, size: 64.w)
        : AvatarUtil.defaultAvatar(gender, size: 64.w);
  }

  ///真人认证ICON
  Widget _buildRealPerson() {

    AppTheme theme = ref.read(userInfoProvider).theme ?? AppTheme(themeType: AppThemeType.original);
    AppImageTheme appImageTheme = theme.getAppImageTheme;
    return ImgUtil.buildFromImgPath(appImageTheme.iconTagRealPerson, width: 20.w, height: 11.h);
  }
}
