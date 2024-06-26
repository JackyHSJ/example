
import 'package:flutter/material.dart';

class PersonalReportModel {
  PersonalReportModel({
    required this.title,
    required this.reportNum,
    required this.backGroundColor
  });

  String title;
  int reportNum;
  Color backGroundColor;
}

class PersonalReportCellModel {
  PersonalReportCellModel({
    required this.userId,
    required this.nickName,
    required this.reportReason
  });

  String userId;
  String nickName;
  String reportReason;
}