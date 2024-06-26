import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frechat/screens/cat/ai/ai_chat_room.dart';
import 'package:frechat/system/base_view_model.dart';
import 'package:frechat/system/constant/enum.dart';
import 'package:frechat/system/zego_call/interal/zim/zim_service_defines.dart';
import 'package:frechat/widgets/shared/pip/pip.dart';
import 'package:frechat/widgets/strike_up_list/components/strike_up_list_mate_components_view_model.dart';

class CatStrikeUpListMateComponents extends ConsumerStatefulWidget {
  const CatStrikeUpListMateComponents({super.key});

  @override
  ConsumerState<CatStrikeUpListMateComponents> createState() => _CatStrikeUpListMateComponentsState();
}

class _CatStrikeUpListMateComponentsState extends ConsumerState<CatStrikeUpListMateComponents> {

  late StrikeUpListMateComponentsViewModel viewModel;


  @override
  void initState() {
    super.initState();
    viewModel = StrikeUpListMateComponentsViewModel(ref: ref, setState: setState);
    viewModel.init();
  }

  @override
  void dispose() {
    viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 8.h, left: 16.w, right: 16.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          catImageButton('assets/cat/image_ai.png',CatSpeedDatingType.ai), // 視頻速配
          SizedBox(width: 13.5.w),
          catImageButton('assets/cat/image_video.png',CatSpeedDatingType.video), // 語音速配
          SizedBox(width: 13.5.w),
          catImageButton('assets/cat/image_voice.png',CatSpeedDatingType.voice)
        ],
      ),
    );
  }

  Widget catImageButton(String path,CatSpeedDatingType catSpeedDatingType){
    String title = '沟通师';
    if(catSpeedDatingType == CatSpeedDatingType.video){
      title = '视频速配';
    }else if(catSpeedDatingType == CatSpeedDatingType.voice){
      title = '语音速配';
    }
    return InkWell(
      child: Column(
        children: [
          Image(
            width: 100.w,
            height: 120.w,
            image:  AssetImage(path),
          ),
          Padding(padding: EdgeInsets.only(top: 8.h),
              child: Text(title,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 16.sp,
                    color: Color.fromRGBO(66, 44, 41,1),
                  )))
        ],
      ),
      onTap: (){
        if(catSpeedDatingType == CatSpeedDatingType.ai){
          BaseViewModel.pushPage(context, AiChatRoom());
        }else if(catSpeedDatingType == CatSpeedDatingType.video){
          final bool isPipMode = PipUtil.pipStatus == PipStatus.piping;
          if (isPipMode) {
            BaseViewModel.showToast(context, '您正在通话中，不可发起新通话');
          } else {
            viewModel.mateCheck(callType: ZegoCallType.video, checkCoinNum: 500);
          }
        }else{
          final bool isPipMode = PipUtil.pipStatus == PipStatus.piping;
          if (isPipMode) {
            BaseViewModel.showToast(context, '您正在通话中，不可发起新通话');
          } else {
            viewModel.mateCheck(callType: ZegoCallType.voice, checkCoinNum: 500);
          }
        }
      },
    );
  }

}
