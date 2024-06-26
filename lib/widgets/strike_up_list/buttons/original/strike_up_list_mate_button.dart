import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frechat/system/zego_call/interal/zim/zim_service_defines.dart';
import 'package:lottie/lottie.dart';

List<Color> getGradientColors(ZegoCallType callType) {
  return callType == ZegoCallType.video
      ? [
          const Color(0xFFFFEED9),
          const Color(0xFFFFAE92),
        ]
      : [
          const Color(0xFFFFD9CB),
          const Color(0xFFFF9292),
        ];
}

String getTitle(ZegoCallType callType) {
  return callType == ZegoCallType.video ? '视频速配' : '语音速配';
}

String getSubTitle(ZegoCallType callType) {
  return callType == ZegoCallType.video ? '实时视频聊天' : '实时语音聊天';
}

Color getTextColor(ZegoCallType callType) {
  return callType == ZegoCallType.video ? const Color(0xffFFB296) : const Color(0xffFF9696);
}

Widget getLottieFile(ZegoCallType callType) {
  return callType == ZegoCallType.video
      ? Lottie.asset('assets/json/strike_up_mate_btn_video.json')
      : Lottie.asset('assets/json/strike_up_mate_btn_voice.json');
}



class StrikeUpListMateButton extends ConsumerStatefulWidget {
  ZegoCallType callType;

  StrikeUpListMateButton({super.key, required this.callType});

  @override
  ConsumerState<StrikeUpListMateButton> createState() =>
      _StrikeUpListMateButtonState();
}

class _StrikeUpListMateButtonState extends ConsumerState<StrikeUpListMateButton> {

  ZegoCallType get callType => widget.callType;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.only(left: 4, right: 6, top: 6, bottom: 6),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            stops: [0.0556, 1.0347],
            colors: getGradientColors(callType),
            transform: const GradientRotation(264),
          ),
          boxShadow: const [
            BoxShadow(
              color: Color.fromRGBO(255, 176, 148, 0.30),
              offset: Offset(0, 0),
              blurRadius: 10,
              spreadRadius: 0,
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(child: getLottieFile(callType)),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  getTitle(callType),
                  style: TextStyle(
                    color: Color(0xFFFFFFFF),
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w700,
                    fontStyle: FontStyle.normal,
                    height: 1.4,
                  ),
                ),
                Text(
                  getSubTitle(callType),
                  style: TextStyle(
                    color: Color(0xFFFFFFFF),
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                    fontStyle: FontStyle.normal,
                    height: 1.333,
                  ),
                ),
                SizedBox(height: 4.h),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      color: Colors.white),
                  child: Text(
                    '快速配对',
                    style: TextStyle(
                      color: getTextColor(callType),
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w700,
                      fontStyle: FontStyle.normal,
                      height: 1.333,
                    ),
                  ),
                )
              ],
            )
          ],
        ));
  }
}
