import 'package:frechat/system/zego_call/model/zego_user_model.dart';

import 'zim_service_defines.dart';

class ZegoCallStateManager {
  ZegoCallStateManager._internal();
  static final ZegoCallStateManager instance = ZegoCallStateManager._internal();
  ZegoCallStateManager({this.callData});

  ZegoCallData? callData;

  bool get busy => callData != null;

  void createCallData(String callID, ZegoUserInfo inviter, ZegoUserInfo invitee, ZegoCallUserState state, ZegoCallType callType) {
    callData = ZegoCallData(inviter: inviter, invitee: invitee, callType: callType, callID: callID, state: state);
  }

  void updateCall(String callID, ZegoCallUserState state) {
    if (callID.isNotEmpty && callID == callData?.callID) {
      callData?.state = state;
    } else {
      assert(false, 'callID is not match, curent:${callData?.callID ?? ''}, new:$callID');
    }
  }

  void clearCallData() => callData = null;
}

class ZegoCallData {
  ZegoCallData({
    required this.inviter,
    required this.invitee,
    required this.callType,
    required this.callID,
    this.state = ZegoCallUserState.inviting,
  });

  final ZegoUserInfo inviter;
  final ZegoUserInfo invitee;
  final ZegoCallType callType;
  final String callID;
  ZegoCallUserState state;
}
