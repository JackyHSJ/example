import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frechat/models/ws_res/activity/ws_activity_search_info_res.dart';
import 'package:frechat/widgets/theme/original/app_colors.dart';

class ActivityPostCellRemind extends ConsumerStatefulWidget {
  const ActivityPostCellRemind({super.key, required this.postInfo});
  final ActivityPostInfo postInfo;


  @override
  ConsumerState<ActivityPostCellRemind> createState() => _ActivityPostCellRemindState();
}

class _ActivityPostCellRemindState extends ConsumerState<ActivityPostCellRemind> {
  ActivityPostInfo get postInfo => widget.postInfo;

  @override
  Widget build(BuildContext context) {
    return  Container(
      height: 32.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(8.h)),
        color: AppColors.mainPaleGrey,
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        child: Row(
          children: [
            _remindIcon(),
            SizedBox(width: 4.w),
            _remindText(),
          ],
        ),
      ),
    );
  }

  ///提醒icon
  Widget _remindIcon(){
    return Image(
        width: 16.h,
        height: 16.h,
        image: const AssetImage('assets/images/icon_exclamationmark.png'));
  }

  ///提醒訊息
  Widget _remindText() {
    return Text('温馨提示：您的动态将在审核后发布',
      style: TextStyle(
        fontSize: 10.sp,
        fontWeight: FontWeight.w500,
        color: const Color(0xFF979797),
      ),
    );
  }

}
