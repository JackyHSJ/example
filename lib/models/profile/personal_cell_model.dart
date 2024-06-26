
import 'package:flutter/material.dart';
import 'package:frechat/system/constant/enum.dart';

class PersonalCellModel {
  PersonalCellModel({
    required this.title,
    required this.icon,
    this.des,
    this.hint,
    this.hintImg,
    this.remark,
    this.type = PersonalCellType.normal,
    this.editable = true,
    this.statusTag = '',
    this.pushPage
  });
  String title;
  String icon;
  String? des;
  String? hint;
  String? hintImg;
  List<String>? remark;
  PersonalCellType type;
  bool editable;
  String statusTag;
  Widget? pushPage;
}