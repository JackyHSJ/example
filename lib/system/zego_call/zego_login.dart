import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frechat/system/app_config/app_config.dart';
import 'package:frechat/system/zego_call/interal/express/express_callback.dart';
import 'package:frechat/system/zego_call/interal/express/zego_express_service.dart';
import 'package:frechat/system/zego_call/interal/zim/zim_service_defines.dart';
import 'package:frechat/system/zego_call/zego_provider.dart';
import 'package:zego_express_engine/zego_express_engine.dart';

class ZegoLogin {
  ZegoLogin({required this.ref});
  ProviderRef ref;

  List<StreamSubscription> subscriptions = [];

  Future<void> init({
      Function()? onConnection,
      required String userName,
      required String nickName,
      String? token
  }) async {
    final manager = ref.read(zegoSDKManagerProvider);
    final zimService = ref.read(zimServiceProvider);

    subscriptions.addAll([
      zimService.connectionStateStreamCtrl.stream
          .listen((ZIMServiceConnectionStateChangedEvent event) {
        debugPrint('connectionStateStreamCtrl: $event');
        if (event.state == ZIMConnectionState.connected) {
          onConnection?.call();
        }
      })
    ]);

    await manager.init(AppConfig.zegoAppID, kIsWeb ? null : AppConfig.zegoAppSign);
    final String zegoUserName = AppConfig.getZegoUserNameWithEnv(userName: userName);
    await manager.connectUser(zegoUserName, nickName, token: token);
  }

  Future<void> disconnectNotification() async {
    try {
      await ref.read(zimServiceProvider).disconnectUserAndZpns();
    } catch(e) {
      print('disconnectNotification: $e');
    }
  }

  void dispose() async {
    final manager = ref.read(zegoSDKManagerProvider);
    final zimService = ref.read(zimServiceProvider);
    for (var element in subscriptions) {
      await element.cancel();
    }
    await manager.disconnectUser();
    zimService.dispose();
  }

  Future<void> closePhone() async {
    final manager = ref.read(zegoSDKManagerProvider);
    // final zimService = ref.read(zimServiceProvider);
    for (var element in subscriptions) {
      await element.cancel();
    }
    await manager.disconnectUser();
  }

  /// 做全局接聽電話的監聽
  addReceiveCallListener() {
    final zegoCallback = ref.read(zegoCallBackProvider);
    final zimService = ref.read(zimServiceProvider);

    final ZegoCallSubscriptionNotifier subscriptionNotifier = ref.read(zegoCallSubscriptionProvider);
    subscriptionNotifier.addSubscription(zimService.incomingCallInvitationReceivedStreamCtrl.stream
        .listen(zegoCallback.onIncomingCallInvitationReceived));
    subscriptionNotifier.addSubscription(zimService.incomingCallInvitationCanceledStreamCtrl.stream
        .listen(zegoCallback.onIncomingCallInvitationCanceled));
    subscriptionNotifier.addSubscription(zimService.incomingCallInvitationTimeoutStreamCtrl.stream
        .listen(zegoCallback.onIncomingCallInvitationTimeout));
  }

  /// 做全局撥打電話的監聽
  addInviteCallListener() {
    final zegoCallback = ref.read(zegoCallBackProvider);
    final zimService = ref.read(zimServiceProvider);

    final ZegoCallSubscriptionNotifier subscriptionNotifier = ref.read(zegoCallSubscriptionProvider);
    subscriptionNotifier.addSubscription(zimService.outgoingCallInvitationRejectedStreamCtrl.stream
        .listen(zegoCallback.onOutgoingCallInvitationRejected));
    subscriptionNotifier.addSubscription(zimService.outgoingCallInvitationAcceptedStreamCtrl.stream
        .listen(zegoCallback.onOutgoingCallInvitationAccepted));
    subscriptionNotifier.addSubscription(zimService.outgoingCallInvitationTimeoutStreamCtrl.stream
        .listen(zegoCallback.onOutgoingCallInvitationTimeout));
  }

  callListenerDispose() {
    final ZegoCallSubscriptionNotifier subscriptionNotifier = ref.read(zegoCallSubscriptionProvider);
    subscriptionNotifier.disposeSubscription();
  }

  /// 播打通話or視訊用的監聽方法
  addCallingListUpdateListener() {
    final ExpressCallback expressCallback = ref.read(expressCallBackProvider);
    final ExpressService expressService = ref.read(expressServiceProvider);

    final ZegoCallingListUpdateSubscriptionNotifier subscriptionNotifier = ref.read(zegoCallingListUpdateSubscriptionProvider);

    subscriptionNotifier.addSubscription(expressService.streamListUpdateStreamCtrl.stream.listen(expressCallback.onStreamListUpdate));
    subscriptionNotifier.addSubscription(expressService.roomUserListUpdateStreamCtrl.stream.listen(expressCallback.onRoomUserListUpdate));
  }

  callingListUpdateListenerDispose() {
    final ZegoCallingListUpdateSubscriptionNotifier subscriptionNotifier = ref.read(zegoCallingListUpdateSubscriptionProvider);
    subscriptionNotifier.disposeSubscription();
  }

  /// Zego服務 網速監聽
  startNetworkSpeedInAudioOrVideo() {
    ref.read(expressServiceProvider).startNetworkSpeedTest();
    final ExpressCallback expressCallback = ref.read(expressCallBackProvider);
    ZegoExpressEngine.onNetworkSpeedTestQualityUpdate = expressCallback.onNetworkSpeedTestQualityUpdate;
    ZegoExpressEngine.onNetworkSpeedTestError = expressCallback.onNetworkSpeedTestError;
  }
}
