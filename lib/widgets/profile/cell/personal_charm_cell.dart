import 'package:flutter/material.dart';
import 'package:frechat/models/ws_res/setting/ws_setting_charm_achievement_res.dart';
import 'package:frechat/widgets/constant_value.dart';
import 'package:frechat/widgets/profile/cell/personal_setting_charm_cell.dart';
import 'package:frechat/widgets/shared/img_util.dart';
import 'package:frechat/widgets/shared/list/main_list.dart';
import 'package:frechat/widgets/theme/original/app_colors.dart';

class CharmCell extends StatefulWidget {
  CharmCell({
    super.key,
    required this.index,
    required this.model,
  });

  final num index;
  final CharmAchievementInfo model;

  @override
  State<CharmCell> createState() => _PersonalCharmCellState();
}

class _PersonalCharmCellState extends State<CharmCell> {
  CharmAchievementInfo get model => widget.model;
  num get index => widget.index;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildTitle(),
        _buildList(),
      ],
    );
  }

  _buildList() {
    return Row(
      children: [
        Expanded(
            child: PersonalSettingCharmCell(
          title: '消息',
          numData: widget.model.messageCharge.toString(),
          mainColor: AppColors.mainYellow,
          crossAxisAlignment: CrossAxisAlignment.center,
          iconData: 'assets/profile/profile_coin_icon_2.png',
        )),
        SizedBox(width: WidgetValue.separateHeight),
        Expanded(
            child: PersonalSettingCharmCell(
          title: '语音',
          numData: widget.model.voiceCharge.toString(),
          mainColor: AppColors.mainYellow,
          crossAxisAlignment: CrossAxisAlignment.center,
          iconData: 'assets/profile/profile_coin_icon_2.png',
        )),
        SizedBox(width: WidgetValue.separateHeight),
        Expanded(
            child: PersonalSettingCharmCell(
          title: '视频',
          numData: widget.model.streamCharge.toString(),
          mainColor: AppColors.mainYellow,
          crossAxisAlignment: CrossAxisAlignment.center,
          iconData: 'assets/profile/profile_coin_icon_2.png',
        )),
      ],
    );
  }

  _buildTitle() {
    final part = model.levelCondition!.split('|');
    final day = part[0];
    final point = part[1];
    return Row(
      children: [
        Text('魅力值 ${model.charmLevel}: ${day}天內 ≥ ', style: TextStyle(color: AppColors.textBlack, fontWeight: FontWeight.w600, fontSize: 16)),
        ImgUtil.buildFromImgPath('assets/profile/profile_coin_icon_2.png', size: WidgetValue.primaryIcon),
        Text(' $point 积分', style: TextStyle(color: AppColors.textBlack, fontWeight: FontWeight.w600, fontSize: 16)),
      ],
    );
  }
}
