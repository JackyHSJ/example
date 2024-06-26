

import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frechat/system/network_status/network_status_callback.dart';
import 'package:frechat/system/network_status/network_status_setting.dart';
import 'package:frechat/system/providers.dart';
import 'package:frechat/system/util/timer.dart';

class NetworkManager {
  NetworkManager({required this.ref});
  ProviderRef ref;
  Timer? _timer;

  Connectivity? _connectivity;
  StreamSubscription<ConnectivityResult>? subscription;

  init() {
    initTimer();
  }

  dispose() {
    disposeTimer();
  }

  /// Init timer
  void initTimer() {
    if(_timer != null) {
      return;
    }
    _timer = TimerUtil.periodic(
      timerType: NetworkStatusSetting.timerType,
      timerNum: NetworkStatusSetting.timerPeriodic,
      timerCallback: (time) => _req()
    );
  }

  void disposeTimer() {
    if(_timer == null) {
      return ;
    }
    _timer?.cancel();
    _timer = null;
  }

  _req() {
    final num currentPage = ref.read(userInfoProvider).currentPage ?? 0;
    final bool isInCallingPage = (currentPage == 2);
    // if(isInCallingPage){
      final NetworkStatusCallback callback = ref.read(networkCallbackProvider);
      ref.read(commApiProvider).checkAliveAndNetWorkSpeed(
        onConnectSuccess: callback.onConnectSuccess,
        onConnectFail: callback.onConnectFail,
        onNetworkTime: callback.onNetworkTime,
      );
    // }
  }

  Future<void> _initConnectivity() async {

    ConnectivityResult? result;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      result = await _connectivity?.checkConnectivity();
    } on PlatformException catch (e) {
      print('Could not check connectivity status error: $e');
      return;
    }

    // ref.read(networkCallbackProvider).updateConnectionStatus(result);
  }

  Future<void> initNetWorkStatusListener() async {
    if(subscription != null) {
      return;
    }
    _connectivity = Connectivity();
    _initConnectivity();
    final NetworkStatusCallback callback = ref.read(networkCallbackProvider);
    subscription = _connectivity?.onConnectivityChanged.listen(
      callback.updateConnectionStatus,
      onDone: callback.onDoneConnection,
      onError: callback.onErrorConnection,
    );
  }

  void disposeNetWorkStatusListener() {
    if(subscription == null) {
      return ;
    }
    subscription?.cancel();
    subscription = null;
  }
}