
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frechat/models/ws_req/account/ws_account_end_call_req.dart';
import 'package:frechat/screens/chatroom/chatroom.dart';
import 'package:frechat/screens/chatroom/chatroom_viewmodel.dart';
import 'package:frechat/system/base_view_model.dart';
import 'package:frechat/system/constant/enum.dart';
import 'package:frechat/system/global.dart';
import 'package:frechat/system/global/shared_preferance.dart';
import 'package:frechat/system/provider/user_info_provider.dart';
import 'package:frechat/system/providers.dart';
import 'package:frechat/system/ws_comm/ws_account.dart';
import 'package:frechat/system/zego_call/interal/express/express_util.dart';
import 'package:frechat/system/zego_call/interal/express/zego_express_service.dart';
import 'package:frechat/system/zego_call/interal/express/zego_express_service_defines.dart';
import 'package:frechat/system/zego_call/interal/zim/zim_service.dart';
import 'package:frechat/system/zego_call/zego_provider.dart';
import 'package:frechat/system/zego_call/zego_sdk_manager.dart';
import 'package:frechat/widgets/shared/pip/pip.dart';
import 'package:zego_express_engine/zego_express_engine.dart';

class ExpressCallback {
  ExpressCallback({required this.ref}) {
    expressUtil = ExpressUtil(ref: ref);
    accountWs = ref.read(accountWsProvider);
  }
  ProviderRef ref;

  double publishCaptureFPS = 0.0;
  double publishEncodeFPS = 0.0;
  double publishSendFPS = 0.0;
  double publishVideoBitrate = 0.0;
  double publishAudioBitrate = 0.0;
  bool isHardwareEncode = false;
  String networkQuality = '';

  late ExpressUtil expressUtil;
  late AccountWs accountWs;

  void onPublisherQualityUpdate(String streamID, ZegoPublishStreamQuality quality) {
    publishCaptureFPS = quality.videoCaptureFPS;
    publishEncodeFPS = quality.videoEncodeFPS;
    publishSendFPS = quality.videoSendFPS;
    publishVideoBitrate = quality.videoKBPS;
    publishAudioBitrate = quality.audioKBPS;
    isHardwareEncode = quality.isHardwareEncode;

    switch (quality.level) {
      case ZegoStreamQualityLevel.Excellent:
        networkQuality = '☀️';
        break;
      case ZegoStreamQualityLevel.Good:
        networkQuality = '⛅️️';
        break;
      case ZegoStreamQualityLevel.Medium:
        networkQuality = '☁️';
        break;
      case ZegoStreamQualityLevel.Bad:
        networkQuality = '🌧';
        break;
      case ZegoStreamQualityLevel.Die:
        networkQuality = '❌';
        break;
      default:
        break;
    }
  }

  void onNetworkSpeedTestQualityUpdate(ZegoNetworkSpeedTestQuality quality, ZegoNetworkSpeedTestType type) {
    final BuildContext currentContext = BaseViewModel.getGlobalContext();
    /// 網路數據
    print("连接服务器耗时: ${quality.connectCost} ms");
    print("RTT: ${quality.rtt} ms");
    print("丢包率: ${quality.packetLostRate * 100}%");  // 轉換為百分比形式
    print("网络质量: ${describeQuality(quality.quality)}");

    /// 資料丢包率
    if (quality.packetLostRate > 0.1) {
      print("亲～您的网络质量不佳，可能会影响体验");
      BaseViewModel.showToast(currentContext, "亲～您的网络质量不佳，可能会影响体验");
    }

    /// 延迟ms : 200ms
    if (quality.rtt > 200) {
      print("亲～网络延迟较高，通信可能会有所延迟");
      BaseViewModel.showToast(currentContext, "亲～网络延迟较高，通信可能会有所延迟");
    }

    /// 網路等級
    if (quality.quality == ZegoStreamQualityLevel.Bad) {
      print("亲～您的网络质量很差，请考虑切换到更稳定的网络");
      BaseViewModel.showToast(currentContext, "亲～您的网络质量很差，请考虑切换到更稳定的网络");
    }
  }

  String describeQuality(ZegoStreamQualityLevel qualityLevel) {
    switch (qualityLevel) {
      case ZegoStreamQualityLevel.Excellent:
        return "优";
      case ZegoStreamQualityLevel.Good:
        return "良";
      case ZegoStreamQualityLevel.Medium:
        return "中";
      case ZegoStreamQualityLevel.Bad:
        return "差";
      case ZegoStreamQualityLevel.Die:
        return "中斷";
      default:
        return "未知狀態";
    }
  }

  void onNetworkSpeedTestError(int errorCode, ZegoNetworkSpeedTestType type) {
    print('onNetworkSpeedTest Error Code: $errorCode');
  }

  Future<void> onStreamListUpdate(ZegoRoomStreamListUpdateEvent event) async {
    /// 結束通話API
    List<String> streamIDList = [];

    final ZEGOSDKManager manager = ref.read(zegoSDKManagerProvider);
    final ExpressService expressService = ref.read(expressServiceProvider);
    final ZIMService zimService = ref.read(zimServiceProvider);

    ref.read(callAuthenticationManagerProvider).currentStreamList = [];
    for (var stream in event.streamList) {
      /// 新增通話
      if (event.updateType == ZegoUpdateType.Add) {
        streamIDList.add(stream.streamID);
        expressService.startPlayingStream(stream.streamID);
      }

      /// 刪除通話
      if(event.updateType == ZegoUpdateType.Delete) {
        streamIDList.remove(stream.streamID);
        expressService.stopPlayingStream(stream.streamID);
        String callJson = jsonEncode({
          'channel': GlobalData.cacheChannel ?? '',
          'roomId': GlobalData.cacheRoomID ?? 0,
          'isCalling': false
        });
        await FcPrefs.setCallStatus(callJson);
        if(ChatRoomViewModel.animationController != null) {
          ChatRoomViewModel.animationController?.dispose();
          ChatRoomViewModel.animationController = null;
        }

        /// dispose
        for (String streamID in streamIDList) {
          expressService.stopPlayingStream(streamID);
        }

        /// 關閉美顏
        expressService.stopPreview();
        expressService.stopPublishingStream();
        expressService.logoutRoom(GlobalData.cacheChannel ?? '');
        manager.disposeZegoEffect();

        zimService.cancelInvitation(
          invitationID: GlobalData.cacheCallData?.callID ?? '',
          invitees: [
            GlobalData.cacheCallData?.invitee.userID ?? ''
          ],
        );
        final BuildContext currentContext = BaseViewModel.getGlobalContext();


        _endCallReq();

        // 通話中把彈窗都 popup 掉
        BaseViewModel.popupDialog();

        if(PipUtil.pipStatus == PipStatus.piping) {
          expressUtil.dispose();
          PipUtil.exitPiPMode();
        } else {
          // 把通話頁面 popup
          BaseViewModel.popPage(currentContext);
        }

        /// 初始化pip status
        PipUtil.pipStatus = PipStatus.init;

        /// 通話狀態
        ref.read(userUtilProvider.notifier).setDataToPrefs(userCallStatus: UserCallStatus.init);

        /// 速配聊天大於七秒則會直接進入聊天室
        /// 速配模式下，聊天大於七秒則會寫入DB
        final bool isStrikeUpMateMode = ref.read(userInfoProvider).isStrikeUpMateMode ?? false;

        if(isStrikeUpMateMode) {
          BaseViewModel.popPage(currentContext);
          BaseViewModel.popPage(currentContext);
          BaseViewModel.popPage(currentContext);
          BaseViewModel.pushPage(currentContext, _getChatRoom());
          return;
        }

        /// 速配彈窗
        expressUtil.closeMataDialog();

        /// 不是速配模式下，不管聊天時常多久都會寫入DB
        if(isStrikeUpMateMode == false) {
          // viewModel.insertDB(res: res, oppositeMemberInfoRes: widget.memberInfoRes, callData: widget.callData);
        }
      }

      /// other
    }
  }

  void onRoomUserListUpdate(ZegoRoomUserListUpdateEvent event) {
    for (var user in event.userList) {
      if (event.updateType == ZegoUpdateType.Delete) {
        if (user.userID == GlobalData.cacheOtherUserInfo?.userID) {
          // Navigator.pop(context);
        }
      }
    }
  }

  _endCallReq() {
    final String channel = GlobalData.cacheChannel ?? '';
    final num roomId = GlobalData.cacheRoomID ?? 0;
    final WsAccountEndCallReq endCallReq = WsAccountEndCallReq(roomId: roomId, channel: channel);
    accountWs.wsAccountEndCall(endCallReq,
        onConnectSuccess: (succMsg){},
        onConnectFail: (errMsg) {}
    );
  }

  static Widget _getChatRoom() {
    Widget chatRoom = ChatRoom(searchListInfo: GlobalData.cacheSearchListInfo);
    if(GlobalData.chatRoom != null) {
      chatRoom = (GlobalData.chatRoom as dynamic)
        ..searchListInfo =GlobalData.cacheSearchListInfo;
    }
    return chatRoom;
  }

}