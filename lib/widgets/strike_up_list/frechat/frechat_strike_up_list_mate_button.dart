import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frechat/system/zego_call/interal/zim/zim_service_defines.dart';
import 'package:lottie/lottie.dart';

String getTitle(ZegoCallType callType) {
  return callType == ZegoCallType.video ? '视频匹配' : '语音匹配';
}

String getSubTitle(ZegoCallType callType) {
  return callType == ZegoCallType.video ? '真人视频' : '匹配好友';
}

String getImgIcon(ZegoCallType callType) {

  if (callType == ZegoCallType.video) {
    return 'assets/strike_up_list/frechat/icon_mate_video.png';
  }
  return 'assets/strike_up_list/frechat/icon_mate_voice.png';
}

LinearGradient getMateGradient(ZegoCallType callType) {

  if (callType == ZegoCallType.video) {
    return const LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Color(0xFFFF9396),
        Color(0xFFFF6AA0),
      ],
      stops: [0.0672, 1.009],
    );
  }

  return const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFC191FF),
      Color(0xFF8B93FF),
    ],
    stops: [0.0672, 1.009],
  );
}

class FrechatStrikeUpListMateButton extends ConsumerStatefulWidget {
  ZegoCallType callType;

  FrechatStrikeUpListMateButton({super.key, required this.callType});

  @override
  ConsumerState<FrechatStrikeUpListMateButton> createState() => _FrechatStrikeUpListMateButtonState();
}

class _FrechatStrikeUpListMateButtonState extends ConsumerState<FrechatStrikeUpListMateButton> {
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
    return _buildMateVideoBtn();
  }

  Widget _buildMateVideoBtn() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        gradient: getMateGradient(callType)
      ),
      height: 70,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                getTitle(callType),
                style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 18, color: Colors.white),
              ),
              Text(
                getSubTitle(callType),
                style: const TextStyle(fontSize: 14, color: Colors.white),
              ),
            ],
          ),
          Container(
            width: 65,
            height: 56,
            child: Image.asset(getImgIcon(callType), fit: BoxFit.cover),
          )
        ],
      ),
    );
  }
}
