
import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frechat/system/app_config/app_config.dart';
import 'package:frechat/models/ws_req/account/ws_account_get_rtm_token_req.dart';
import 'package:frechat/models/ws_res/account/ws_account_get_rtm_token_res.dart';
import 'package:frechat/system/authentication_manager.dart';
import 'package:frechat/system/base_view_model.dart';
import 'package:frechat/system/constant/enum.dart';
import 'package:frechat/system/global.dart';
import 'package:frechat/system/provider/user_info_provider.dart';
import 'package:frechat/system/providers.dart';
import 'package:frechat/system/repository/response_code.dart';
import 'package:frechat/system/util/audioplayer_util.dart';
import 'package:frechat/system/util/file_util.dart';
import 'package:frechat/system/util/timer.dart';
import 'package:frechat/system/websocket/websocket_handler.dart';
import 'package:frechat/system/websocket/websocket_status.dart';
import 'package:frechat/system/zego_call/interal/express/express_util.dart';
import 'package:frechat/system/zego_call/zego_provider.dart';
import 'package:frechat/widgets/shared/loading_animation.dart';
import 'package:frechat/widgets/shared/pip/pip.dart';
import 'package:frechat/widgets/theme/app_theme.dart';

class AppLifecycle {
  static Timer? _delayTimer;
  static const int maxDelayTime = 1;
  static Timer? _toastTimer;
  static AppLifecycleState currentState = AppLifecycleState.resumed;

  // static _initDelayDisposeSocket({
  //   required Function() onDisposeSocket
  // }) {
  //   if(_delayTimer != null) {
  //     return ;
  //   }
  //   _delayTimer = TimerUtil.periodic(
  //       timerType: TimerType.seconds,
  //       timerNum: 1,
  //       timerCallback: (time) {
  //         print('_initDelayDisposeSocket: ${time.tick}');
  //         if(maxDelayTime == time.tick) {
  //           onDisposeSocket();
  //         }
  //       }
  //   );
  // }
  //
  // static _disposeDelayDisposeSocket() {
  //   if(_delayTimer == null) {
  //     return ;
  //   }
  //   _delayTimer?.cancel();
  //   _delayTimer = null;
  // }

    static init(WidgetsBindingObserver observer) {
    WidgetsBinding.instance.addObserver(observer);
  }

  static dispose(WidgetsBindingObserver observer) {
    WidgetsBinding.instance.removeObserver(observer);
  }

  static _initToastTimer() {
    if(_toastTimer != null) {
      return ;
    }
    _toastTimer = TimerUtil.periodic(timerType: TimerType.seconds, timerNum: 5, timerCallback: (timer) {
      final BuildContext context = BaseViewModel.getGlobalContext();
      BaseViewModel.showToast(context, '亲～网速过慢重连中呦');
    });
  }

  static _disposeToastTimer() {
    if(_toastTimer == null) {
      return ;
    }
    _toastTimer?.cancel();
    _toastTimer = null;
  }

  static addListener(BuildContext context, {required WidgetRef ref, required AppLifecycleState state}) async {
    final bool isUserLoginState = ref.read(userUtilProvider.notifier).isUserLoginState;
    if(isUserLoginState == false) {
      return ;
    }
    switch (state) {
      case AppLifecycleState.resumed:

        /// 紀錄 App LifeCycle
        currentState = AppLifecycleState.resumed;

        await _reloadLoginAndConnectWS(context, ref: ref);
        /// 網路狀態檢查
        ref.read(networkManagerProvider).init();

        /// 同步通話狀態
        ref.read(callSyncManagerProvider).init();



        // _disposeDelayDisposeSocket();
        break;
      case AppLifecycleState.paused:

        /// 紀錄 App LifeCycle
        currentState = AppLifecycleState.paused;


        /// 當網路斷線時會開啟重練timer, 但滑至App背景就關閉socket重連timer
        WebSocketHandler.cancelReconnectTimer();

        /// 存進debug log
        _loadDebugLogs();

        final UserCallStatus userCallStatus = ref.read(userInfoProvider).userCallStatus ?? UserCallStatus.init;
        final AppPaymentStatus appPaymentStatus = ref.read(appPaymentManagerProvider).appPaymentStatus ?? AppPaymentStatus.init;

        /// 當通話中，前往支付狀態，退到背景時，則『不掛斷電話』與『Socket斷流』
        if(userCallStatus == UserCallStatus.calling && appPaymentStatus == AppPaymentStatus.paying){
          return;
        }

        /// 來電狀態的話直接掛斷電話
        if(userCallStatus == UserCallStatus.incomingRinging) {
          await ref.read(zegoCallBackProvider).rejectCall();
        }

        if(userCallStatus == UserCallStatus.outGoingRinging) {
          await ref.read(authenticationProvider).cancelCalling();
        }
        ///这注解先别打开，有可能造成传送图片失败
        // ref.read(zegoLoginProvider).dispose();

        /// socket dispose 延遲dispose
        // _initDelayDisposeSocket(onDisposeSocket: () => ref.read(webSocketUtilProvider).onWebSocketDispose());
        ref.read(webSocketUtilProvider).onWebSocketDispose();

        /// 網路狀態檢查
        ref.read(networkManagerProvider).dispose();

        /// 同步通話狀態
        ref.read(callSyncManagerProvider).dispose();

        _closeCallAndBgm(ref, userCallStatus: userCallStatus);
        AudioPlayerUtils.playerStop();
        break;
      case AppLifecycleState.detached:

        /// 紀錄 App LifeCycle
        currentState = AppLifecycleState.detached;

        /// 完全清除App 會進的CallBack
        /// iOS的部分要另外處理保證清除Cache暫存
        break;
      case AppLifecycleState.inactive:

        /// 紀錄 App LifeCycle
        currentState = AppLifecycleState.inactive;

        break;
      default:

        /// 紀錄 App LifeCycle
        currentState = AppLifecycleState.hidden;
        break;
    }

    print('currentState: $currentState');
  }

  static Future<void> _reloadLoginAndConnectWS(BuildContext context, {required WidgetRef ref}) async {
    if (WebSocketHandler.socketStatus == SocketStatus.SocketStatusConnected) {
      return ;
    }
    final AppTheme theme = ref.read(userInfoProvider).theme ?? AppTheme(themeType: AppThemeType.original);
    LoadingAnimation.showOverlayDotsLoading(context, appTheme: theme);
    _initToastTimer();
    await ref.read(authenticationProvider).loginAndConnectWs(
        onConnectSuccess: (succMsg) async {
          await _initZego(context, ref);
          LoadingAnimation.cancelOverlayLoading();
          _disposeToastTimer();
        },
        onConnectFail: (errMsg) async {
          final AuthenticationManager authentication = ref.read(authenticationProvider);
          await _checkClickTooShort(context, ref, errMsg: errMsg, authentication: authentication);
        }
    );
  }

  static Future<void> _checkClickTooShort(BuildContext context, WidgetRef ref, {
    required String errMsg,
    required AuthenticationManager authentication
  }) async {
    if(ResponseCode.CODE_CLICK_DURATION_TOO_SHORT == errMsg || ResponseCode.Network_Error == errMsg) {
      await authentication.keepRetryLoginAndConnectWs(
          onConnectSuccess: (succMsg) {
            _initZego(context, ref);
            LoadingAnimation.cancelOverlayLoading();
            _disposeToastTimer();
          },
          onConnectFail: (errMsg) {
            LoadingAnimation.cancelOverlayLoading();
            _disposeToastTimer();
          }
      );
    }
  }

  static _initZego(BuildContext context, WidgetRef ref) async {
    BaseViewModel.showToast(context, '亲～欢迎回来');
    await BaseViewModel.waitUntilToWebSocketConnect(isLoginState: true);
    final WsAccountGetRTMTokenRes rtcToken = await _getRtcToken(context, ref: ref);
    await ref.read(authenticationProvider).initZego(wsAccountGetRTMTokenRes: rtcToken);
  }

  static Future<WsAccountGetRTMTokenRes> _getRtcToken(BuildContext context, {required WidgetRef ref}) async {
    String? resultCodeCheck;
    final WsAccountGetRTMTokenReq reqBody = WsAccountGetRTMTokenReq.create();
    final WsAccountGetRTMTokenRes res = await ref.read(accountWsProvider).wsAccountGetRTMToken(reqBody,
        onConnectSuccess: (succMsg) => resultCodeCheck = succMsg,
        onConnectFail: (errMsg) {
          final currentContext = BaseViewModel.getGlobalContext();
          BaseViewModel.showToast(currentContext, ResponseCode.map[errMsg]!);
        }
    );
    if(resultCodeCheck == ResponseCode.CODE_SUCCESS) {
      ref.read(userUtilProvider.notifier).setDataToPrefs(rtcToken: res.rtcToken);
    }
    return res;
  }

  /// 強制退出App方法
  Future<void> requestAppExit() async {
    final AppExitResponse response = await ServicesBinding.instance.exitApplication(
      AppExitType.cancelable // 或者使用 AppExitType.required
    );
    if (response == AppExitResponse.exit) {
      print('強制退出');
    } else {
      print('退出取消');
    }
  }

  static Future<void> _closeCallAndBgm(WidgetRef ref, {required UserCallStatus userCallStatus}) async {
    final bool isStrikeUpMode = ref.read(userInfoProvider).isStrikeUpMateMode ?? false;
    if(userCallStatus == UserCallStatus.calling) {
      final BuildContext currentContext = BaseViewModel.getGlobalContext();
      ref.read(callAuthenticationManagerProvider).endCall(
          currentContext,
          callData: GlobalData.cacheCallData!,
          roomId: GlobalData.cacheRoomID!,
          channel: GlobalData.cacheChannel!,
          searchListInfo: GlobalData.cacheSearchListInfo!,
          onDispose: () {}
      );
      ref.read(expressUtilProvider).dispose();
      // await ref.read(authenticationProvider).cancelCalling();
      // _cancelCall(ref);
    }

    if(userCallStatus == UserCallStatus.outGoingRinging) {
      final currentContext = BaseViewModel.getGlobalContext();
      BaseViewModel.popPage(currentContext);
      if (isStrikeUpMode == true) {
        BaseViewModel.popPage(currentContext);
      }
    }

      /// 關閉BGM
    if(isStrikeUpMode == false) {
      AudioPlayerUtils.playerStop();
    }
  }

  static Future<void> _loadDebugLogs() async {
    final String env = await AppConfig.getEnvStr();
    if(env == 'PROD') {
      return ;
    }
    await FileUtil.writeText(GlobalData.cacheLogs, fileName: GlobalData.logFileName);
    GlobalData.cacheLogs = [];
  }

  // static _cancelCall(WidgetRef ref) {
  //   ref.read(zegoLoginProvider).closePhone();
  //   final BuildContext currentContext = BaseViewModel.getGlobalContext();
  //
  //   // 通話中把彈窗都 popup 掉
  //   BaseViewModel.popupDialog();
  //
  //   if(PipUtil.pipStatus == PipStatus.piping) {
  //     PipUtil.exitPiPMode();
  //   } else {
  //     // 把通話頁面 popup
  //     BaseViewModel.popPage(currentContext);
  //   }
  //
  //   /// 初始化pip status
  //   PipUtil.pipStatus = PipStatus.init;
  //
  //   /// 通話狀態
  //   ref.read(userUtilProvider.notifier).setDataToPrefs(userCallStatus: UserCallStatus.init);
  //
  //   /// 速配聊天大於七秒則會直接進入聊天室
  //   /// 速配模式下，聊天大於七秒則會寫入DB
  //   final bool isStrikeUpMateMode = ref.read(userInfoProvider).isStrikeUpMateMode ?? false;
  //
  //   if(isStrikeUpMateMode) {
  //     BaseViewModel.popPage(currentContext);
  //     BaseViewModel.popPage(currentContext);
  //     BaseViewModel.popPage(currentContext);
  //     return;
  //   }
  // }
}