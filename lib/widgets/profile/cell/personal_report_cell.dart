import 'package:flutter/material.dart';
import 'package:frechat/system/extension/string.dart';
import 'package:frechat/widgets/constant_value.dart';
import 'package:frechat/widgets/theme/original/app_colors.dart';
import '../../../models/profile/personal_report_model.dart';

class PersonalReportCell extends StatelessWidget {
  PersonalReportCell({required this.model});
  PersonalReportCellModel model;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(WidgetValue.verticalPadding),
      child: Column(
        children: [
          Row(
            children: [
              Text(model.userId.toBlock(), style: TextStyle(fontWeight: FontWeight.w700, letterSpacing: -1)),
              SizedBox(width: 5,),
              Text(model.nickName, style: TextStyle(fontWeight: FontWeight.w700, letterSpacing: -1)),
            ],
          ),
          Row(
            children: [
              Icon(Icons.block_rounded, size: 15, color: AppColors.mainRed),
              SizedBox(width: 5,),
              Text(model.reportReason, style: TextStyle(color: AppColors.textGrey, fontWeight: FontWeight.w700, letterSpacing: -1)),
            ],
          )
        ],
      ),
    );
  }


}