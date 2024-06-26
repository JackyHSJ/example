

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frechat/screens/call/calling_page_view_model.dart';
import 'package:frechat/screens/strike_up_list/mate/strike_up_list_mate_view_model.dart';
import 'package:frechat/system/constant/enum.dart';
import 'package:frechat/system/provider/user_info_provider.dart';
import 'package:frechat/system/providers.dart';
import 'package:frechat/system/zego_call/interal/zim/call_data_manager.dart';
import 'package:frechat/widgets/shared/pip/pip.dart';

class ExpressUtil {
  ExpressUtil({required this.ref});
  ProviderRef ref;

  closeMataDialog() {
    final bool isStrikeUpMateMode = ref.read(userInfoProvider).isStrikeUpMateMode ?? false;
    if(isStrikeUpMateMode) {
      StrikeUpListMateViewModel.stateController.sink.add(MateState.close);
    }
  }

  dispose() {
    if(CallingPageViewModel.callChargeTimer != null){
      CallingPageViewModel.callChargeTimer!.cancel();
      CallingPageViewModel.callChargeTimer = null;
    }

    if(CallingPageViewModel.callTimer != null){
      CallingPageViewModel.callTimer?.cancel();
      CallingPageViewModel.callTimer = null;
      CallingPageViewModel.currentCallTimer = 0;
      ref.read(userUtilProvider.notifier).setDataToPrefs(callTimer: 0);
    }

    ZegoCallStateManager.instance.clearCallData();
    _disposeListener();

    /// 初始化pip status
    PipUtil.pipStatus = PipStatus.init;
  }

  _disposeListener() {
    if(CallingPageViewModel.webSocketUtil == null) {
      return ;
    }
    CallingPageViewModel.webSocketUtil?.onWebSocketListenDispose();
    CallingPageViewModel.webSocketUtil = null;
  }
}