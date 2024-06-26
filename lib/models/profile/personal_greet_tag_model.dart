

import 'package:flutter/cupertino.dart';

class PersonalGreetTagModel {
  PersonalGreetTagModel({
    required this.title,
    required this.imgPath,
    required this.boxDecoration,
    required this.textStyle,
    this.needBoard,
    this.needOpacity,
    this.onTap
  });

  String imgPath;
  String title;
  BoxDecoration boxDecoration;
  TextStyle textStyle;
  bool? needOpacity;
  bool? needBoard;
  Function()? onTap;
}