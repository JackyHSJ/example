import 'package:flutter/material.dart';
import 'package:frechat/system/repository/http_setting.dart';
import 'package:frechat/system/util/avatar_util.dart';
import 'package:flutter_screenutil/src/size_extension.dart';

class OfficialNotifyCircleAvatar extends StatelessWidget {
  const OfficialNotifyCircleAvatar({this.width = 64, this.height = 64, super.key});

  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {

    return SizedBox(
        width: width,
        height: height,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            AvatarUtil.localAvatar('assets/avatar/system_avatar.png', size: 64.w),
            Positioned(
                top: -4,
                right: -4,
                child: Image.asset('assets/strike_up_list/app_tag.png', scale: 2.5,)),
          ],
        ));
  }
}
