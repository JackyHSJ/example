
import 'package:flutter/cupertino.dart';

class CustomList {
  const CustomList();

  static Widget mainList({
    Key? key, bool shrinkWrapEnable = true,
    Axis direction = Axis.vertical,
    ScrollController? controller,
    ScrollPhysics? physics,
    bool reverse = false,
    required itemCount, required child
  }) {
    return ListView.builder(
        key: key,
        padding: EdgeInsets.symmetric(vertical: 10),
        shrinkWrap: shrinkWrapEnable,
        scrollDirection: direction,
        physics: physics,
        reverse: reverse,
        controller: controller,
        itemBuilder: child,
        itemCount: itemCount);
  }

  static Widget separatedList({
    Key? key,
    ScrollPhysics? physics,
    double paddingTop = 0,
    double paddingBottom = 0,
    Axis scrollDirection = Axis.vertical,
    ScrollController? controller,
    required Widget separator,
    required int childrenNum,
    required Widget? Function(BuildContext, int) children
  }) {
    return ListView.separated(
      key: key,
      padding: EdgeInsets.only(top: paddingTop, bottom: paddingBottom),
      physics: physics,
      scrollDirection: scrollDirection,
      shrinkWrap: true,
      itemBuilder: children,
      controller: controller,
      separatorBuilder: (BuildContext context, int index) {
        return separator;
      },
      itemCount: childrenNum,
    );
  }
}