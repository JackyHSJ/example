
import 'package:flutter/material.dart';

Widget MainGridView({
  Key? key, bool shrinkWrapEnable = false,
  Axis direction = Axis.vertical,
  ScrollPhysics? physics,
  bool reverse = false,
  double paddingLeft = 0,
  double paddingRight = 0,
  double paddingTop = 10,
  double paddingBottom = 10,
  double verticalSpace = 10,
  double horizontalSpace = 5,
  required double childAspectRatio,
  required int crossAxisCount,
  required children
}) {
  return GridView.count(
    key: key, shrinkWrap: shrinkWrapEnable,
    mainAxisSpacing: verticalSpace,
    crossAxisSpacing: verticalSpace,
    padding: EdgeInsets.only(top: paddingTop,bottom: paddingBottom, left: paddingLeft, right: paddingRight),
    scrollDirection: direction,
    physics: physics,
    reverse: reverse,
    crossAxisCount: crossAxisCount,
    childAspectRatio: childAspectRatio,
    children: children,
  );
}