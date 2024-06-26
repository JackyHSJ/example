import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frechat/system/base_view_model.dart';
import 'package:frechat/system/constant/enum.dart';
import 'package:frechat/system/zego_call/interal/zim/zim_service_defines.dart';
import 'package:frechat/widgets/shared/pip/pip.dart';
import 'package:frechat/widgets/strike_up_list/buttons/original/strike_up_list_mate_button.dart';
import 'package:frechat/widgets/strike_up_list/components/strike_up_list_mate_components_view_model.dart';

class YueYuanStrikeUpListMateComponents extends ConsumerStatefulWidget {
  const YueYuanStrikeUpListMateComponents({super.key});

  @override
  ConsumerState<YueYuanStrikeUpListMateComponents> createState() => _YueYuanStrikeUpListMateComponentsState();
}

class _YueYuanStrikeUpListMateComponentsState extends ConsumerState<YueYuanStrikeUpListMateComponents> {

  late StrikeUpListMateComponentsViewModel viewModel;


  @override
  void initState() {
    super.initState();
    viewModel =
        StrikeUpListMateComponentsViewModel(ref: ref, setState: setState);
    viewModel.init();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 8.h, left: 16.w, right: 16.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ImageButton('assets/yueyuan/image_mate_video_btn.png',ZegoCallType.video),
          SizedBox(width: 9.w),
          ImageButton('assets/yueyuan/image_mate_voice_btn.png',ZegoCallType.voice)
        ],
      ),
    );
  }

  Widget ImageButton(String path,ZegoCallType callType) {
    return InkWell(
      child: Image(
        width: 167.w,
        height: 88.h,
        image: AssetImage(path),
      ),
      onTap: () {
        final bool isPipMode = PipUtil.pipStatus == PipStatus.piping;
        if (isPipMode) {
          BaseViewModel.showToast(context, '您正在通话中，不可发起新通话');
        } else {
          viewModel.mateCheck(callType:callType , checkCoinNum: 200);
        }
      },
    );
  }
}
