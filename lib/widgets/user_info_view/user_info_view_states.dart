import 'package:flutter/material.dart';
import 'package:frechat/widgets/shared/icon_tag.dart';
import 'package:frechat/models/ws_res/member/ws_member_info_res.dart';

class UserInfoStates extends StatelessWidget {
  final WsMemberInfoRes memberInfo;
  const UserInfoStates({super.key, required this.memberInfo});

  @override
  Widget build(BuildContext context) {

    final num gender = memberInfo.gender ?? 0;
    final num age = memberInfo.age ?? 0;
    final num charmLevel =  memberInfo.charmLevel ?? 0;
    final bool isRealName = memberInfo.realNameAuth == 1;
    final bool isRealPerson = memberInfo.realPersonAuth == 1;

    List<Widget> tagList = [
      IconTag.genderAge(gender: gender, age: age),
    ];

    if (gender == 0) tagList.add(IconTag.charmLevel(charmLevel: charmLevel));
    if (isRealName) tagList.add(IconTag.realNameAuth());
    if (isRealPerson) tagList.add(IconTag.realPersonAuth());

    return Wrap(
      spacing: 4,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: tagList,
    );
  }
}
