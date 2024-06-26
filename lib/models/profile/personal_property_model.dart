import 'package:flutter/material.dart';

class PersonalPropertyModel {
  PersonalPropertyModel({
    required this.title,
    required this.num,
    required this.image,
    required this.backgroundImg,
    this.backgroundImgOpacity = 1,
    required this.backgroundColor,
  });

  String title;
  int num;
  String image;
  String backgroundImg;
  Color backgroundColor;
  double backgroundImgOpacity;
}