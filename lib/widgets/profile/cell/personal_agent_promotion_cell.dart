
import 'package:flutter/material.dart';
import 'package:frechat/widgets/constant_value.dart';
import 'package:frechat/widgets/theme/original/app_colors.dart';
import 'package:frechat/widgets/theme/uidefine.dart';

class PersonalAgentPromotionCell extends StatelessWidget {
  const PersonalAgentPromotionCell({
    super.key,
    required this.title,
    required this.data,
    required this.mainColor,
    required this.imgPath,
  });
  final String title;
  final num data;
  final Color mainColor;
  final String imgPath;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        Container(
          width: UIDefine.getWidth(),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(WidgetValue.btnRadius / 2),
            color: mainColor.withOpacity(0.3),
          ),
          padding: EdgeInsets.symmetric(vertical: WidgetValue.verticalPadding, horizontal: WidgetValue.horizontalPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: TextStyle(color: mainColor, fontSize: 16)),
              Text('$data', style: TextStyle(color: mainColor, fontSize: 18, fontWeight: FontWeight.w600),)
            ],
          ),
        ),
        Opacity(
          opacity: 0.2,
          child: ClipRRect(
            borderRadius: BorderRadius.only(bottomRight: Radius.circular(WidgetValue.btnRadius / 2)),
            child: Image.asset(
              imgPath,
              height: WidgetValue.bigIcon,
              // width: WidgetValue.bigIcon,
            ),
          ),
        )
      ],
    );
  }
}