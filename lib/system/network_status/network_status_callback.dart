

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frechat/models/req/error_log_req.dart';
import 'package:frechat/screens/network_lock/network_lock.dart';
import 'package:frechat/system/base_view_model.dart';
import 'package:frechat/system/global.dart';
import 'package:frechat/system/network_status/network_status_setting.dart';
import 'package:frechat/system/providers.dart';
import 'package:frechat/widgets/shared/dialog/comm_dialog.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NetworkStatusCallback {
  NetworkStatusCallback({required this.ref});
  ProviderRef ref;

  // int _noneCount = 0;
  // int _noneMaxCount = 1;
  ConnectivityResult? _currentConnectivityType;
  bool isNetworkLockPage = false;

  /// 毫秒(ms)
  onNetworkTime(int delayTime) {
    final BuildContext currentContext = BaseViewModel.getGlobalContext();
    // BaseViewModel.showToast(currentContext, '網路延遲狀態: $delayTime ms');
    // if(delayTime > NetworkStatusSetting.statusSlowly && delayTime <= NetworkStatusSetting.statusVerySlow) {
    //   BaseViewModel.showToast(currentContext, '亲～网络延迟啰');
    // }

    final String userName = GlobalData.memberInfo?.userName ?? '';
    final ErrorLogReq headers = ErrorLogReq(
      userName: userName,
      delayTime: '${delayTime}ms',
    );
    ref.read(commApiProvider).sendErrorMsgLog(headers);

    if(delayTime > NetworkStatusSetting.statusVerySlow) {
      BaseViewModel.showToast(currentContext, '因网速较慢，通话可能不畅。\n 建议避开用量高峰或切换网络。');
      // CommDialog(currentContext).build(
      //     title: '提示',
      //     contentDes:
      //     '因网速较慢，通话可能不畅。\n 建议避开用量高峰或切换网络。',
      //     horizontalPadding: 32.w,
      //     rightBtnTitle: '确认',
      //     rightAction: () => BaseViewModel.popPage(currentContext),);
    }
  }

  onConnectSuccess(String errMsg) {
    /// 正常運行
  }

  onConnectFail(String errMsg) {
    /// 系統維護 跳轉系統維護頁面
  }

  void updateConnectionStatus(ConnectivityResult res) {
    _checkNetworkStatus(res);
    _currentConnectivityType = res;
  }

  void onDoneConnection() {
    print('123111 onDoneConnection');
  }

  void onErrorConnection(Object object, StackTrace stackTrace) {
    print('123111 onErrorConnection');
  }

  void _checkNetworkStatus(ConnectivityResult type) {
    final BuildContext context = BaseViewModel.getGlobalContext();
    switch (type) {
      case ConnectivityResult.none:
        if(isNetworkLockPage == true) {
          return ;
        }
        BaseViewModel.pushPage(context, const NetworkLock());
        isNetworkLockPage = true;
        break;
      default:
        if(_currentConnectivityType == ConnectivityResult.none) {
          BaseViewModel.popupDialog();
          BaseViewModel.popPage(context);
          isNetworkLockPage = false;
        }
        break;
    }
  }
}