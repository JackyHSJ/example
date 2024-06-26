import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frechat/screens/cat/ai/ai_chat_room.dart';
import 'package:frechat/system/base_view_model.dart';
import 'package:frechat/system/constant/enum.dart';
import 'package:frechat/system/zego_call/interal/zim/zim_service_defines.dart';
import 'package:frechat/widgets/shared/pip/pip.dart';
import 'package:frechat/widgets/strike_up_list/components/strike_up_list_mate_components_view_model.dart';

class DogStrikeUpListMateComponents extends ConsumerStatefulWidget {
  const DogStrikeUpListMateComponents({super.key});

  @override
  ConsumerState<DogStrikeUpListMateComponents> createState() => _DogStrikeUpListMateComponentsState();
}

class _DogStrikeUpListMateComponentsState extends ConsumerState<DogStrikeUpListMateComponents> {

  late StrikeUpListMateComponentsViewModel viewModel;


  @override
  void initState() {
    super.initState();
    viewModel = StrikeUpListMateComponentsViewModel(ref: ref, setState: setState);
    viewModel.init();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 8.h, left: 16.w, right: 16.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ImageButton('assets/dog/image_mate_ai_btn.png',CatSpeedDatingType.ai), // 視頻速配
          SizedBox(width: 13.5.w),
          ImageButton('assets/dog/image_mate_video_btn.png',CatSpeedDatingType.video), // 語音速配
          SizedBox(width: 13.5.w),
          ImageButton('assets/dog/image_mate_voice_btn.png',CatSpeedDatingType.voice)
        ],
      ),
    );
  }

  Widget ImageButton(String path,CatSpeedDatingType catSpeedDatingType){
    return InkWell(
      child: Image(
        width: 100.w,
        height: 146.h,
        image:  AssetImage(path),
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
            viewModel.mateCheck(callType: ZegoCallType.video, checkCoinNum: 500);
          }
        }
      },
    );
  }

}
