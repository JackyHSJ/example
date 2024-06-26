
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frechat/system/notification/zpns/zpns_callback.dart';
import 'package:frechat/system/notification/zpns/zpns_service.dart';
import 'package:frechat/system/zego_call/interal/express/express_callback.dart';
import 'package:frechat/system/zego_call/interal/express/express_util.dart';
import 'package:frechat/system/zego_call/interal/express/zego_express_service.dart';
import 'package:frechat/system/zego_call/interal/zim/zim_callback.dart';
import 'package:frechat/system/zego_call/interal/zim/zim_service.dart';
import 'package:frechat/system/zego_call/interal/zim/zim_util.dart';
import 'package:frechat/system/zego_call/zego_callback.dart';
import 'package:frechat/system/zego_call/zego_login.dart';
import 'package:frechat/system/zego_call/zego_sdk_manager.dart';
import 'package:zego_express_engine/zego_express_engine.dart';

final zegoCallSubscriptionProvider = ChangeNotifierProvider<ZegoCallSubscriptionNotifier>(
      (ref) => ZegoCallSubscriptionNotifier(),
);

class ZegoCallSubscriptionNotifier extends ChangeNotifier {
  List<StreamSubscription<dynamic>?> subscriptions = [];

  void addSubscription(StreamSubscription<dynamic>? subscription) {
    subscriptions.add(subscription);
    notifyListeners();
  }

  void disposeSubscription() {
    subscriptions.forEach((subscription) {
      subscription?.cancel();
    });
    subscriptions = [];
  }
}

final zegoCallingListUpdateSubscriptionProvider = ChangeNotifierProvider<ZegoCallingListUpdateSubscriptionNotifier>(
      (ref) => ZegoCallingListUpdateSubscriptionNotifier(),
);

class ZegoCallingListUpdateSubscriptionNotifier extends ChangeNotifier {
  List<StreamSubscription<dynamic>?> subscriptions = [];

  void addSubscription(StreamSubscription<dynamic>? subscription) {
    subscriptions.add(subscription);
    notifyListeners();
  }

  void disposeSubscription() {
    subscriptions.forEach((subscription) {
      subscription?.cancel();
    });
    subscriptions.clear();
  }
}

final zpnsCallBackProvider = Provider<ZPNsCallBack>((ref) => ZPNsCallBack(ref: ref));
final zimUtilProvider = Provider<ZIMUtil>((ref) => ZIMUtil(ref: ref));
final zimCallbackProvider = Provider<ZIMCallback>((ref) => ZIMCallback(ref: ref));
final zegoLoginProvider = Provider<ZegoLogin>((ref) => ZegoLogin(ref: ref));
final zimServiceProvider = Provider<ZIMService>((ref) => ZIMService(ref: ref));
final zegoSDKManagerProvider = Provider<ZEGOSDKManager>((ref) => ZEGOSDKManager(ref: ref));
final zegoCallBackProvider = Provider<ZegoCallBack>((ref) => ZegoCallBack(ref: ref));
final zpnsServiceProvider = Provider<ZPNsService>((ref) => ZPNsService(ref: ref));

/// Zego 通話 & 視訊
final expressCallBackProvider = Provider<ExpressCallback>((ref) => ExpressCallback(ref: ref));
final expressServiceProvider = Provider<ExpressService>((ref) => ExpressService(ref: ref));

final expressUtilProvider = Provider<ExpressUtil>((ref) => ExpressUtil(ref: ref));