
import 'package:flutter/material.dart';
import 'package:frechat/widgets/constant_value.dart';

import '../../../models/profile/personal_mission_model.dart';
import '../../theme/original/app_colors.dart';

class PersonalMissionCell extends StatefulWidget {
  PersonalMissionCell({super.key, required this.model});
  final MissionInfo model;

  @override
  State<PersonalMissionCell> createState() => _PersonalMissionCellState();
}

class _PersonalMissionCellState extends State<PersonalMissionCell> {
  MissionInfo get model => widget.model;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: WidgetValue.separateHeight),
      decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(WidgetValue.btnRadius/2)
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: WidgetValue.separateHeight),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.circle, color: AppColors.mainYellow),
                    SizedBox(width: 5,),
                    Text('+${model.awardNum}', style: TextStyle(color: AppColors.mainYellow, fontWeight: FontWeight.w700)),
                  ],
                ),
                Text(model.missionTitle, style: TextStyle(color: AppColors.textBlack, fontWeight: FontWeight.w600)),
                Text(model.missionDes, style: TextStyle(color: AppColors.textGrey, fontWeight: FontWeight.w500, fontSize: 13))
              ],
            ),
            _buildBtn()
          ],
        ),
      ),
    );
  }

  _buildBtn() {
    final Color btnColor = (model.isDone) ? AppColors.btnDeepGrey : AppColors.mainPink;
    final Color textColor = (model.isDone) ? AppColors.textGrey : AppColors.textWhite;
    final String text = (model.isDone) ? '已完成' : '前往';

    return InkWell(
      onTap: () {
        if(model.isDone) {
          return ;
        }

      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: WidgetValue.btnHorizontalPadding, horizontal: WidgetValue.btnHorizontalPadding * 2),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(WidgetValue.btnRadius),
          color: btnColor
        ),
        child: Text(text, style: TextStyle(
          color: textColor,
        )),
      ),
    );
  }
}