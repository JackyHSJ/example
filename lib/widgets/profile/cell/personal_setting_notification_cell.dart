
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frechat/widgets/constant_value.dart';
import 'package:frechat/widgets/shared/list/main_list.dart';
import 'package:frechat/widgets/theme/original/app_colors.dart';

import '../../../models/profile/personal_setting_notification_model.dart';
import '../../shared/switch_button.dart';

class PersonalSettingNotificationCell extends StatefulWidget {
  PersonalSettingNotificationCell({super.key, required this.model});
  PersonalSettingNotificationModel model;

  @override
  State<PersonalSettingNotificationCell> createState() => PersonalSettingNotificationCellState();
}

class PersonalSettingNotificationCellState extends State<PersonalSettingNotificationCell> {
  PersonalSettingNotificationModel get model => widget.model;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(model.title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
        CustomList.separatedList(
            separator: SizedBox(height: WidgetValue.separateHeight,),
            childrenNum: model.notificationList.length,
            children: (context, index) {
              return _buildDesCell(model.notificationList[index]);
            }
        )
      ],
    );
  }

  _buildDesCell(NotificationInfo model) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: WidgetValue.verticalPadding, horizontal: WidgetValue.horizontalPadding),
      decoration: BoxDecoration(
        color: AppColors.whiteBackGround,
        borderRadius: BorderRadius.circular(WidgetValue.btnRadius / 2)
      ),
      child: Row(
        children: [
          Expanded(child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(model.title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
              Offstage(
                offstage: model.des == null,
                child: Text(model.des ?? '', style: TextStyle(color: AppColors.textGrey, fontSize: 14, fontWeight: FontWeight.w500)),
              ),
            ],
          )),
          SizedBox(width: WidgetValue.horizontalPadding * 2),
          _buildSwitchBtn()
        ],
      ),
    );
  }

  _buildSwitchBtn() {
    return SwitchButton(
      enable: false,
      onChange: (changeState) {  },
    );
  }
}