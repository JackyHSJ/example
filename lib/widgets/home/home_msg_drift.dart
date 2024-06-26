import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frechat/system/constant/enum.dart';
import 'package:frechat/system/providers.dart';
import 'package:frechat/widgets/theme/app_theme.dart';
import 'package:frechat/widgets/theme/original/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class HomeMsgDrift extends ConsumerStatefulWidget {
  const HomeMsgDrift({super.key,
    required this.avatar,
    required this.nickName,
    required this.des,
    required this.replyText
  });
  final Widget avatar;
  final String nickName;
  final String des;
  final String replyText;

  @override
  ConsumerState<HomeMsgDrift> createState() => _HomeMsgDriftState();
}

class _HomeMsgDriftState extends ConsumerState<HomeMsgDrift> {
  final bool _isVisible = true;
  Widget get avatar => widget.avatar;
  String get nickName => widget.nickName;
  String get des => widget.des;
  String get replyText => widget.replyText;
  late AppTheme _theme;

  @override
  Widget build(BuildContext context) {
    if (!_isVisible) {
      return const SizedBox.shrink(); // 返回一个空的小部件，相当于移除该小部件
    }

    _theme = ref.watch(userInfoProvider).theme ?? AppTheme(themeType: AppThemeType.dogVersion);
    return Container(
      width: 343.w,
      height: 70.h,
      padding: EdgeInsets.symmetric(horizontal: 12.w,vertical: 12.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.white,
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.1),
            spreadRadius: 0,
            blurRadius: 10,
            offset: Offset(0, 5), // 设置阴影的偏移量
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _avatarWidget(),
          _contentWidget(),
          _replyButton(),
        ],
      ),
    );

  }

  Widget _avatarWidget(){
    return Container(
      width: 38.w,
      height: 38.w,
      child: avatar,
    );
  }

  Widget _contentWidget(){
    return Expanded(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 8.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              nickName,
              maxLines: 1,
              style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textBlack),
            ),
            Text(
              des,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 12.sp, color: AppColors.textBlack),
            ),
          ],
        ),
      ),
    );
  }

  Widget _replyButton(){
    return Container(
      alignment: Alignment.center,
      width: 67.w,
      height: 32.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(17),
        gradient: _theme.getAppLinearGradientTheme.buttonSecondaryColor,
      ),
      child: Text(
        replyText,
        style: _theme.getAppTextTheme.buttonSecondaryTextStyle,
      ),
    );
  }
}
