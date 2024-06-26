// import 'dart:html';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frechat/screens/free_calling/free_calling_view_model.dart';
import 'package:frechat/widgets/shared/icon_tag.dart';
import 'package:frechat/widgets/shared/img_util.dart';
import 'package:frechat/widgets/shared/main_scaffold.dart';
import 'package:frechat/widgets/theme/original/app_colors.dart';
import 'package:flutter_screenutil/src/size_extension.dart';
import 'package:frechat/widgets/theme/uidefine.dart';

class FreeCallingDialog extends ConsumerStatefulWidget {
  const FreeCallingDialog({super.key});

  @override
  ConsumerState<FreeCallingDialog> createState() => _FreeCallingDialogState();
}

class _FreeCallingDialogState extends ConsumerState<FreeCallingDialog> {
  // late FreeCallingViewModel viewModel;
  final double paddingHeight = UIDefine.getAppBarHeight() + UIDefine.getStatusBarHeight();


  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // viewModel = FreeCallingViewModel(ref: ref, setState: setState, context: context);
    // viewModel.init();
  }

  @override
  Widget build(BuildContext context) {
    return freeCallingContent();
  }

  Widget freeCallingContent() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 22),
        _buildCallingItem(),
        SizedBox(height: 8),
        _buildCallingItem(),
        SizedBox(height: 8),
        _buildCallingItem(),
        SizedBox(height: 8),
        _buildCallingItem(),
        SizedBox(height: 12),
        _buildHint(),
        SizedBox(height: 32),
      ],
    );
  }

  Widget _buildCallingItem() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        border: Border.all(
          color: Color(0xffEAEAEA), // 设置边框颜色
          width: 1, // 设置边框宽度
        ),
        borderRadius: BorderRadius.circular(12.0),
        color: Color(0xffFFFFFF),
        // border: Border.
      ),
      child: Row(
        children: [
          Expanded(
              child: Row(
                children: [
                  IconTag.callingFree(),
                  SizedBox(width: 4),
                  Text(
                    '不限对象额度 可免费通话 12 分钟',
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 12),
                  ),
                ],
              )),
          ImgUtil.buildFromImgPath('assets/free_calling/icon_selected.png',
              width: 24, height: 24)
        ],
      ),
    );
  }

  Widget _buildHint() {
    return Text('• 不限对象:在速配视频、速配语音配对到的对象或达成亲密度标准的对象', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Color(0xffEC6193)),);
  }



}
