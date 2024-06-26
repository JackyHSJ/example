import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frechat/system/constant/enum.dart';
import 'package:frechat/system/providers.dart';
import 'package:frechat/widgets/shared/icon_tag.dart';
import 'package:frechat/widgets/shared/img_util.dart';
import 'package:frechat/widgets/theme/app_image_theme.dart';
import 'package:frechat/widgets/theme/app_theme.dart';

import '../../models/ws_res/member/ws_member_fate_recommend_res.dart';

class StrikeUpListPersonalInfo extends ConsumerStatefulWidget {
  final FateListInfo fateListInfo;

  const StrikeUpListPersonalInfo({
    super.key,
    required this.fateListInfo
  });

  @override
  ConsumerState<StrikeUpListPersonalInfo> createState() => StrikeUpListPersonalInfoState();
}

class StrikeUpListPersonalInfoState extends ConsumerState<StrikeUpListPersonalInfo> {

  FateListInfo get fateListInfo => widget.fateListInfo;

  @override
  Widget build(BuildContext context) {

    return Row(
      children: [
        IconTag.genderAge(gender: fateListInfo.gender ?? 0, age: fateListInfo.age ?? 0),
        const SizedBox(width: 4),
        _buildRealNameWidget(),
      ],
    );
  }

  Widget _buildRealNameWidget() {
    AppTheme theme = ref.read(userInfoProvider).theme ?? AppTheme(themeType: AppThemeType.original);
    AppImageTheme appImageTheme = theme.getAppImageTheme;
    return fateListInfo.realNameAuth == 1
        ? ImgUtil.buildFromImgPath(appImageTheme.iconTagRealName, size: 16.w)
        : const SizedBox();
  }
}
