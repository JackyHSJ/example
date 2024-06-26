import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frechat/models/ws_res/notification/ws_notification_search_intimacy_level_info_res.dart';
import 'package:frechat/models/ws_res/setting/ws_setting_charm_achievement_res.dart';
import 'package:frechat/screens/profile/setting/iap/personal_setting_iap_view_model.dart';
import 'package:frechat/system/base_view_model.dart';
import 'package:frechat/system/constant/enum.dart';
import 'package:frechat/system/providers.dart';
import 'package:frechat/system/zego_call/interal/zim/zim_service_defines.dart';
import 'package:frechat/widgets/shared/pip/pip.dart';
import 'package:frechat/widgets/strike_up_list/buttons/original/strike_up_list_mate_button.dart';
import 'package:frechat/widgets/strike_up_list/components/strike_up_list_mate_components_view_model.dart';
import 'package:frechat/widgets/strike_up_list/frechat/frechat_strike_up_list_mate_button.dart';

class FrechatStrikeUpListMateComponents extends ConsumerStatefulWidget {
  const FrechatStrikeUpListMateComponents({super.key});

  @override
  ConsumerState<FrechatStrikeUpListMateComponents> createState() => _FrechatStrikeUpListMateComponentsState();
}

class _FrechatStrikeUpListMateComponentsState extends ConsumerState<FrechatStrikeUpListMateComponents> {

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
      padding: EdgeInsets.only(top: 13, left: 16, right: 16, bottom: 13),
      // color: Colors.cyan,
      child:Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _mateButton(ZegoCallType.video), // 視頻速配
          SizedBox(width: 11),
          _mateButton(ZegoCallType.voice), // 語音速配
        ],
      ) ,
    );
  }

  Widget _mateButton(ZegoCallType type) {
    return Expanded(child: InkWell(
      onTap: () => viewModel.pressMateBtn(context, type: type),
      child: FrechatStrikeUpListMateButton(callType: type),
    ));
  }
}
