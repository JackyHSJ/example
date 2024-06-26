import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frechat/models/ws_res/member/ws_member_fate_recommend_res.dart';
import 'package:frechat/system/constant/enum.dart';
import 'package:frechat/system/providers.dart';
import 'package:frechat/widgets/shared/icon_tag.dart';
import 'package:frechat/widgets/shared/img_util.dart';
import 'package:frechat/widgets/theme/app_image_theme.dart';
import 'package:frechat/widgets/theme/app_theme.dart';


class FrechatStrikeUpListPersonalInfo extends ConsumerStatefulWidget {
  final FateListInfo fateListInfo;

  const FrechatStrikeUpListPersonalInfo({
    super.key,
    required this.fateListInfo
  });

  @override
  ConsumerState<FrechatStrikeUpListPersonalInfo> createState() => _FrechatStrikeUpListPersonalInfoState();
}

class _FrechatStrikeUpListPersonalInfoState extends ConsumerState<FrechatStrikeUpListPersonalInfo> {

  FateListInfo get fateListInfo => widget.fateListInfo;

  @override
  Widget build(BuildContext context) {

    List<Widget> showTags = [];

    if (fateListInfo.realNameAuth == 1) {
      showTags.add(_buildRealNameWidget());
    }

    if (fateListInfo.realPersonAuth == 1) {
      showTags.add(const SizedBox(width: 3));
      showTags.add(_buildRealPersonalWidget());
    }

    return Row(
      children: showTags,
    );
  }

  Widget _buildRealNameWidget() {
    return ImgUtil.buildFromImgPath('assets/strike_up_list/frechat/icon_real_name_auth.png', width: 38, height: 16);
  }

  Widget _buildRealPersonalWidget() {
    return ImgUtil.buildFromImgPath('assets/strike_up_list/frechat/icon_real_personal_auth.png', width: 38, height: 16);
  }
}
