import 'package:flutter/material.dart';
import 'package:frechat/widgets/constant_value.dart';
import 'package:frechat/widgets/shared/img_util.dart';
import 'package:frechat/widgets/theme/original/app_colors.dart';
import 'package:frechat/widgets/theme/uidefine.dart';

class PersonalSettingCharmCell extends StatefulWidget {
  PersonalSettingCharmCell({
    super.key,
    required this.title,
    required this.numData,
    this.des,
    this.backGroundImgPath,
    this.mainColor = AppColors.mainGreen,
    this.crossAxisAlignment = CrossAxisAlignment.start,
    this.iconData,
    this.imgPath,
    this.stackAlignment = Alignment.bottomLeft,
    this.imageOpacity,
  });
  String title;
  String numData;
  String? des;
  String? backGroundImgPath;
  Color mainColor;
  CrossAxisAlignment crossAxisAlignment;
  AlignmentGeometry stackAlignment;
  String? iconData;
  String? imgPath;
  double? imageOpacity;
  @override
  State<PersonalSettingCharmCell> createState() => PersonalSettingCharmCellState();
}

class PersonalSettingCharmCellState extends State<PersonalSettingCharmCell> {
  String get numData => widget.numData;
  String get title => widget.title;
  String? get des => widget.des;
  String? get backGroundImgPath => widget.backGroundImgPath;
  Color get mainColor => widget.mainColor;
  CrossAxisAlignment get crossAxisAlignment => widget.crossAxisAlignment;
  String? get iconData => widget.iconData;
  String? get imgPath => widget.imgPath;
  AlignmentGeometry get stackAlignment => widget.stackAlignment;
  double? get imageOpacity => widget.imageOpacity;

  @override
  Widget build(BuildContext context) {
    final bool isHaveBackGroundImg = backGroundImgPath != null;
    final bool isHaveIconData = iconData != null;
    return Container(
      decoration: BoxDecoration(
        image: isHaveBackGroundImg ? DecorationImage(image: Image.asset(backGroundImgPath!).image) : null,
        // color: isHaveIconData
        //   ? AppColors.textBackGroundGrey.withOpacity(0.5)
        //   : isHaveBackGroundImg ? null : mainColor.withOpacity(0.3),
          color: const Color.fromRGBO(253,241,246, 1),
        borderRadius: BorderRadius.circular(WidgetValue.btnRadius)
      ),
      child: Stack(
        alignment: stackAlignment,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: WidgetValue.verticalPadding * 1.5, horizontal: WidgetValue.horizontalPadding),
            child: Column(
              crossAxisAlignment: crossAxisAlignment,
              children: [
                Text(title, style: const TextStyle(color:  Color.fromRGBO(236,97,147, 1), fontWeight: FontWeight.w700)),
                _buildNumDate(),
                Offstage(
                  offstage: des == null,
                  child: Text(des ?? '', style: const TextStyle(color: Color.fromRGBO(236,97,147, 1), fontWeight: FontWeight.w400, fontSize: 18)),
                )
              ],
            ),
          ),
          Visibility(
            visible: imgPath != null,
            child: Align(
              alignment: Alignment.bottomRight,
              child: ClipRRect(
                borderRadius: BorderRadius.only(bottomRight: Radius.circular(WidgetValue.btnRadius)),
                child: ImgUtil.buildFromImgPath(imgPath ?? '', size: WidgetValue.bigIcon, opacity: imageOpacity),
              ),
            )
          )
        ],
      ),
    );
  }

  _buildNumDate() {
    final bool isHaveIconData = iconData != null;
    if (isHaveIconData) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ImgUtil.buildFromImgPath(iconData ?? '', size: WidgetValue.primaryIcon),
          Text(numData, style: TextStyle(color: mainColor, fontWeight: FontWeight.w600, fontSize: 18))
        ],
      );
    } else {
      return Text(numData, style: const TextStyle(color: Color.fromRGBO(236,97,147, 1), fontWeight: FontWeight.w700, fontSize: 18));
    }
  }
}