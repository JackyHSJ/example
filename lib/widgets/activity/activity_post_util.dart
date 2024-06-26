


import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frechat/system/base_view_model.dart';
import 'package:frechat/widgets/shared/dialog/comm_dialog.dart';
import 'package:frechat/widgets/theme/app_theme.dart';
import 'package:intl/intl.dart';

class ActivityPostUtil {
  static Widget mainText(String content) {
    return Text(
      content,
      style: TextStyle(
          color: const Color(0xff2a2b36),
          fontWeight: FontWeight.bold,
          fontSize: 14.sp,
          height: 20.sp / 14.sp
      ),
    );
  }

  static Widget subText(String content, {Color color = const Color(0xff909090)}) {
    return Text(
      content,
      style: TextStyle(
          color: color,
          fontWeight: FontWeight.w400,
          fontSize: 12.sp,
          height: 16.sp / 12.sp
      ),
    );
  }

  static Widget contentText(String content, {Color color = const Color(0xff2b2b36)}) {
    return Text(
      content,
      style: TextStyle(
          color: color,
          fontWeight: FontWeight.w400,
          fontSize: 14.sp,
          height: 20.sp / 14.sp
      ),
    );
  }
  // 時間格式
  static String formatTimestampToDateTime(int timestamp) {
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
    DateFormat dateFormat = DateFormat('yyyy/MM/dd HH:mm');
    return dateFormat.format(dateTime);
  }

  // 舉報確認彈窗
  static void reportReplyConfirmDialog(AppTheme theme,BuildContext context) {
    CommDialog(context).build(
      theme: theme,
        title: '已收到举报',
        contentDes: '官方将在审核后于消息通知裁定结果，请耐心等候',
        rightBtnTitle: '确认',
        rightAction: () {
          BaseViewModel.popPage(context);
          BaseViewModel.popPage(context);
        }
    );
  }

  // Divider
  static Widget verticalDivider(
      int width,
      int height,
      {
        double leftPadding = 0,
        double rightPadding = 0
      }) {
    return Container(
      width: width.w,
      height: height.h,
      color: const Color(0xffEAEAEA),
      margin: EdgeInsets.only(left: leftPadding, right: rightPadding),
    );
  }
}