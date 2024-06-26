
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

///不限对象组件
class PersonalFreeCallNoLimitCallCell extends ConsumerStatefulWidget {
  String des;
  String freeTime;
  String expirationDate;
  PersonalFreeCallNoLimitCallCell({super.key, required this.des, required this.freeTime, required this.expirationDate});

  @override
  ConsumerState<PersonalFreeCallNoLimitCallCell> createState() => _PersonalFreeCallNoLimitCallCellState();
}

class _PersonalFreeCallNoLimitCallCellState extends ConsumerState<PersonalFreeCallNoLimitCallCell> {

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
        borderRadius: BorderRadius.all(Radius.circular(8)),
        border:  Border.all(width: 1, color: Color.fromRGBO(234, 234, 234, 1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          tagAndTitle(),
          description(),
          expirationDateAndCallorVideoButton()
        ],
      ),
    );
  }

  Widget tagAndTitle(){
    return Padding(padding: EdgeInsets.only(top:8.h,left:12.w,right:12.w),
        child: Row(
          children: [
            Image(
              width: 44.w,
              height: 16.h,
              image: const AssetImage('assets/images/icon_free_tag.png'),
            ),
            Text('不限对象通话额度',
                style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                    color:  Color.fromRGBO(68, 70, 72, 1)
                ))
          ]));
  }

  Widget description(){
    return Padding(padding: EdgeInsets.only(top: 4.h,left: 16.w, right:12.w,bottom: 12.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            desContent(),
            Text('可于语音速配或视频速配及与他人语音或视频通话中使用',
                style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                    color:  Color.fromRGBO(176, 176, 176, 1)
                ))
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
          child: Text(' ${widget.freeTime} ', style: TextStyle(color: Colors.white, fontSize: 12.sp, fontStyle: FontStyle.italic, fontWeight: FontWeight.w700, height: 1)),
        ),
        Text('分钟', style: TextStyle(color: Color.fromRGBO(68, 70, 72, 1), fontSize: 12.sp, fontWeight: FontWeight.w500)),
      ],
    );
  }

  Widget expirationDateAndCallorVideoButton(){
    return Container(
      padding: EdgeInsets.only(left: 12.w),
      color: Color.fromRGBO(244, 244, 244, 1),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('使用期限至 ${widget.expirationDate}',
          style: TextStyle(
            fontSize: 12.sp,
            color: Color.fromRGBO(127, 127, 127, 1)
          )),
          callVideoButtonRow()
        ],
      ),
    );
  }

  Widget callVideoButtonRow(){
    return Padding(padding: EdgeInsets.only(top: 8.h, bottom: 8.h, right: 12.w),
        child: Row(
          children: [
            videoButton(),
            SizedBox(width: 4.w),
            callButton()
          ],
        ));
  }

  Widget videoButton(){
    return Container(
      padding: EdgeInsets.symmetric(vertical: 3.h,horizontal: 6.w),
      alignment: Alignment(0, 0),
      decoration:  BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(25.0)),
        gradient: LinearGradient(
          colors: [Color.fromRGBO(255, 230, 205, 1), Color.fromRGBO(255,175,147, 1)],
          begin: Alignment.centerLeft,
          end: Alignment.center,
        ),
      ),
        child: Row(
          children: [
            Image(
              width: 15.96.w,
              height: 10.95.w,
              image: const AssetImage('assets/images/icon_free_video.png'),
            ),
            Text('视频速配',style: TextStyle(
              fontSize: 10.sp,
              fontWeight: FontWeight.w500,
              color: Colors.white
            ))
          ],
        )
    );
  }

  Widget callButton(){
    return Container(
        padding: EdgeInsets.symmetric(vertical: 3.h,horizontal: 6.w),
        alignment: Alignment(0, 0),
        decoration:  BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(25.0)),
          gradient: LinearGradient(
            colors: [Color.fromRGBO(255, 230, 205, 1), Color.fromRGBO(255,175,147, 1)],
            begin: Alignment.centerLeft,
            end: Alignment.center,
          ),
        ),
        child: Row(
          children: [
            Image(
              width: 15.96.w,
              height: 10.95.w,
              image: const AssetImage('assets/images/icon_free_call.png'),
            ),
            Text('语音速配',style: TextStyle(
                fontSize: 10.sp,
                fontWeight: FontWeight.w500,
                color: Colors.white
            ))
          ],
        )
    );
  }

}