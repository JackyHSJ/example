
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frechat/screens/profile/setting/block/personal_setting_block.dart';
import 'package:frechat/system/base_view_model.dart';
import 'package:frechat/system/constant/enum.dart';
import 'package:frechat/system/database/model/chat_user_model.dart';
import 'package:frechat/system/extension/chat_user_model.dart';
import 'package:frechat/system/provider/chat_user_model_provider.dart';
import 'package:frechat/system/repository/http_setting.dart';
import 'package:frechat/system/repository/response_code.dart';
import 'package:frechat/system/util/avatar_util.dart';
import 'package:frechat/system/util/cache_network_image_util.dart';
import 'package:frechat/widgets/shared/icon_tag.dart';
import 'package:frechat/widgets/shared/img_util.dart';
import 'package:frechat/widgets/shared/pip/pip.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../../models/ws_res/notification/ws_notification_block_group_res.dart';
import '../../../screens/profile/setting/block/personal_setting_block_view_model.dart';
import '../../constant_value.dart';
import '../../theme/original/app_colors.dart';
import 'package:flutter_screenutil/src/size_extension.dart';

///特定对象组件
class PersonalFreeCallLimitCallCell extends ConsumerStatefulWidget {
  String limitName;
  String des;
  String freeTime;
  String expirationDate;
  PersonalFreeCallLimitCallCell({super.key, required this.limitName, required this.des, required this.freeTime, required this.expirationDate});

  @override
  ConsumerState<PersonalFreeCallLimitCallCell> createState() => _PersonalFreeCallLimitCallCellState();
}

class _PersonalFreeCallLimitCallCellState extends ConsumerState<PersonalFreeCallLimitCallCell> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(16.h),
      // padding: EdgeInsets.only(top:8.h,left:12.w,right:12.w),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(8)),
        border:  Border.all(width: 1, color: const Color.fromRGBO(234, 234, 234, 1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              avatar(),
              Padding(padding: EdgeInsets.only(left: 12.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    tagAndTitle(),
                    description(),
                  ],
                ))
            ],
          ),
          expirationDateAndCallorVideoButton()
        ],
      ),
    );
  }

  Widget avatar(){
    return Padding(padding: EdgeInsets.only(top: 12.h,left: 12.w),
        child: AvatarUtil.defaultAvatar(0, size: 64.w, radius: 8));
  }

  Widget tagAndTitle(){
    return Padding(padding: EdgeInsets.only(top: 6.5.h),
        child: Row(
            children: [
              Image(
                width: 44.w,
                height: 16.h,
                image: const AssetImage('assets/images/icon_free_tag.png'),
              ),
              Text('与',
                  style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                      color:  const Color.fromRGBO(68, 70, 72, 1)
                  )),
              Text(widget.limitName,
                  style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                      color:  const Color.fromRGBO(68, 70, 72, 1)
                  )),
              Text('通话额度',
                  style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                      color:  const Color.fromRGBO(68, 70, 72, 1)
                  )),
            ]));
  }

  Widget description(){
    return Padding(padding: EdgeInsets.only(left: 4.w,top: 1.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            desContent(),
            Padding(padding: EdgeInsets.only(top: 1.h),child: Text('可于达成亲密度等级用户之聊天室中使用',
                style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                    color:  const Color.fromRGBO(176, 176, 176, 1)
                )))
          ],
        ));
  }

  Widget desContent(){
    return Row(
      children: [
        Text('剩馀免费', style: TextStyle(color: Color.fromRGBO(68, 70, 72, 1), fontSize: 12.sp, fontWeight: FontWeight.w500)),
        ShaderMask(
          shaderCallback: (Rect bounds) {
            return const LinearGradient(
              colors: [Color.fromRGBO(100, 125, 246, 1),Color.fromRGBO(89, 187, 224, 1)],
              stops: [0.111, 0.9222],
            ).createShader(bounds);
          },
          child: Text(widget.des, style: TextStyle(color: Colors.white, fontSize: 12.sp, fontWeight: FontWeight.w700, height: 1)),
        ),
        Text('通话', style: TextStyle(color: Color.fromRGBO(68, 70, 72, 1), fontSize: 12.sp, fontWeight: FontWeight.w500)),
        ShaderMask(
          shaderCallback: (Rect bounds) {
            return const LinearGradient(
              colors: [Color.fromRGBO(100, 125, 246, 1),Color.fromRGBO(89, 187, 224, 1)],
              stops: [0.111, 0.9222],
            ).createShader(bounds);
          },
          child: Text(' ${widget.freeTime} ', style: TextStyle(color: Colors.white, fontStyle: FontStyle.italic, fontSize: 12.sp, fontWeight: FontWeight.w700, height: 1)),
        ),
        Text('分钟', style: TextStyle(color: Color.fromRGBO(68, 70, 72, 1), fontSize: 12.sp, fontWeight: FontWeight.w500)),
      ],
    );
  }

  Widget expirationDateAndCallorVideoButton(){
    return Container(
      margin: EdgeInsets.only(top: 12.h),
      padding: EdgeInsets.only(left: 12.w),
      color: const Color.fromRGBO(244, 244, 244, 1),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('使用期限至 ${widget.expirationDate}',
          style: TextStyle(
            fontSize: 12.sp,
            color: const Color.fromRGBO(127, 127, 127, 1)
          )),
          callorVideoButton()
        ],
      ),
    );
  }

  Widget callorVideoButton(){
    return Padding(padding: EdgeInsets.only(top: 8.h, bottom: 8.h, right: 12.w),
        child: Container(
            padding: EdgeInsets.symmetric(vertical: 3.h,horizontal: 8.w),
            alignment: const Alignment(0, 0),
            decoration:  const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(25.0)),
              gradient: LinearGradient(
                colors: [Color.fromRGBO(255, 230, 205, 1), Color.fromRGBO(255,175,147, 1)],
                begin: Alignment.centerLeft,
                end: Alignment.center,
              ),
            ),
            child: Text('与TA通话',style: TextStyle(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w500,
                    color: Colors.white
                )
            )
        ));
  }

}