
import 'package:flutter/cupertino.dart';

class PersonalSettingModel {
  PersonalSettingModel({
    required this.title,
    this.des,
    this.enableArrow = true,
    this.pushPage,
    this.isCacheCell = false,
  });
  String title;
  String? des;
  bool enableArrow;
  Widget? pushPage;
  bool isCacheCell;
}