import 'package:flutter/cupertino.dart';
import 'package:frechat/widgets/shared/list/main_list.dart';
import 'package:frechat/widgets/theme/original/app_colors.dart';

class PersonalTagCell extends StatelessWidget {
  PersonalTagCell({super.key,
    this.location, this.height, this.weight, this.occupation
});

  String? location;
  num? height;
  num? weight;
  String? occupation;

  List<String> get getList {
    final String? getHeight = (height == null) ? null : '${height}cm';
    final String? getWeight = (weight == null) ? null : '${weight}kg';

    return [
      if (location != null) location!,
      if (getHeight != null) getHeight,
      if (getWeight != null) getWeight,
      if (occupation != null) occupation!,
    ];
  }


  @override
  Widget build(BuildContext context) {
    final list = getList;
    return CustomList.separatedList(
        separator: SizedBox(width: 2,),
        childrenNum: list.length,
        scrollDirection: Axis.horizontal,
        children: (context, index) {
          return _buildTagFormat(title: list[index]);
        });
  }

  _buildTagFormat({required String? title}) {
    return Visibility(
      visible: (title != null),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 5),
        decoration: BoxDecoration(
            color: AppColors.textBackGroundGrey,
            borderRadius: BorderRadius.circular(2)
        ),
        child: Text('$title', style: const TextStyle(color: AppColors.textGrey, fontWeight: FontWeight.w500, fontSize: 12)),
      ),
    );
  }
}