
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frechat/models/ws_res/member/ws_member_info_res.dart';
import 'package:frechat/models/ws_res/notification/ws_notification_search_list_res.dart';
import 'package:frechat/screens/call/waiting_page/voice_waiting_view.dart';
import 'package:frechat/screens/call/waiting_page_view_model.dart';
import 'package:frechat/system/constant/enum.dart';
import 'package:frechat/system/provider/user_info_provider.dart';
import 'package:frechat/system/util/audioplayer_util.dart';
import 'package:frechat/screens/call/waiting_page/video_waiting_view.dart';
import 'package:frechat/system/zego_call/interal/zim/call_data_manager.dart';
import 'package:frechat/system/zego_call/interal/zim/zim_service_defines.dart';

//通話視頻等待畫面
class WaitingPage extends ConsumerStatefulWidget {
  const WaitingPage(
      {
      super.key,
      required this.callData,
      required this.roomID,
      required this.memberInfoRes,
      required this.searchListInfo,
      this.token,
      this.channel,
      });

  final ZegoCallData callData;
  final String? token;
  final String? channel;
  final num roomID;
  final WsMemberInfoRes memberInfoRes;
  final SearchListInfo searchListInfo;



  @override
  ConsumerState<WaitingPage> createState() => _WaitingPageState();
}

class _WaitingPageState extends ConsumerState<WaitingPage> with TickerProviderStateMixin {
  late WaitingPageViewModel viewModel;
  bool get isEmptyCall => widget.token == '' && widget.channel == '';

  @override
  void initState() {
    super.initState();
    viewModel = WaitingPageViewModel(ref: ref);
    AudioPlayerUtils.playAssetAudio('aac/audio.aac',true);
    if (widget.callData.callType == ZegoCallType.video) {
      viewModel.initBeauty();
    }

    if(isEmptyCall) {
      ref.read(userUtilProvider.notifier).setDataToPrefs(userCallStatus: UserCallStatus.emptyCall);
      viewModel.initEmptyTimer(context);
    }

    viewModel.loadCache(
        callData: widget.callData,
        otherUserInfo: widget.callData.invitee,
        token: widget.token ?? '',
        channel: widget.channel ?? '',
        roomID: widget.roomID,
        memberInfoRes: widget.memberInfoRes,
        searchListInfo: widget.searchListInfo
    );
  }

  @override
  void dispose() {
    viewModel.disposeEmptyTimer();
    super.dispose();
  }

  @override
  void deactivate() {
    AudioPlayerUtils.playerStop();

    if(isEmptyCall) {
      viewModel.checkHaveOnHoldWithWaitingCall();
      ref.read(userUtilProvider.notifier).setDataToPrefs(userCallStatus: UserCallStatus.init);
    }
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        body: (widget.callData.callType == ZegoCallType.video)
            ? _videoWaitingView()
            : _voiceWaitingView(),
      ),
    );
  }

  Widget _videoWaitingView() {
    return VideoWaitingView(
      isAnswer: false,
      callData: widget.callData,
      memberInfoRes: widget.memberInfoRes,
      searchListInfo: widget.searchListInfo,
      channel: widget.channel,
      roomId: widget.roomID,
      isEnabledMicSwitch: false,
      isEnabledCamSwitch: false,
      isEnabledVolumn: false,
    );
  }

  Widget _voiceWaitingView() {
    return LayoutBuilder(builder: (context, containers) {
      return VoiceWaitingView(
        isAnswer: false,
        callData: widget.callData,
        channel: widget.channel,
        roomId: widget.roomID,
        memberInfoRes: widget.memberInfoRes,
        searchListInfo: widget.searchListInfo,
        isEnabledMicSwitch: false,
        isEnabledVolumn: false,
      );
    });
  }
}
